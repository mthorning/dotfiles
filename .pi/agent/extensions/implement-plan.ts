import type { ExtensionAPI, ExtensionCommandContext } from "@mariozechner/pi-coding-agent";
import { Key } from "@mariozechner/pi-tui";
import { access, readdir, readFile, stat } from "node:fs/promises";
import { join, relative } from "node:path";

interface PlanInfo {
  absolutePath: string;
  relativePath: string;
  label: string;
  title?: string;
  mtimeMs: number;
}

async function findRepoRoot(pi: ExtensionAPI, cwd: string): Promise<string> {
  const result = await pi.exec("git", ["rev-parse", "--show-toplevel"], { timeout: 5000 });
  if (result.code === 0) {
    const root = result.stdout.trim();
    if (root) return root;
  }
  return cwd;
}

async function collectMarkdownFiles(dir: string): Promise<string[]> {
  const entries = await readdir(dir, { withFileTypes: true });
  const files = await Promise.all(
    entries.map(async (entry) => {
      const fullPath = join(dir, entry.name);
      if (entry.isDirectory()) return collectMarkdownFiles(fullPath);
      if (entry.isFile() && entry.name.endsWith(".md")) return [fullPath];
      return [] as string[];
    }),
  );
  return files.flat();
}

function extractTitle(content: string): string | undefined {
  const lines = content
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean);

  const heading = lines.find((line) => line.startsWith("# "));
  if (heading) return heading.replace(/^#\s+/, "").trim();

  return lines[0]?.replace(/^[-*]\s+/, "").trim() || undefined;
}

async function loadPlans(pi: ExtensionAPI, cwd: string): Promise<PlanInfo[]> {
  const repoRoot = await findRepoRoot(pi, cwd);
  const plansDir = join(repoRoot, "matt-plans");

  await access(plansDir);

  const files = await collectMarkdownFiles(plansDir);
  const plans = await Promise.all(
    files.map(async (absolutePath) => {
      const [content, fileStat] = await Promise.all([readFile(absolutePath, "utf8"), stat(absolutePath)]);
      const title = extractTitle(content);
      const relativePath = relative(repoRoot, absolutePath);
      const label = title ? `${relativePath} — ${title}` : relativePath;
      return {
        absolutePath,
        relativePath,
        label,
        title,
        mtimeMs: fileStat.mtimeMs,
      } satisfies PlanInfo;
    }),
  );

  return plans.sort((a, b) => b.mtimeMs - a.mtimeMs);
}

async function selectPlan(ctx: ExtensionCommandContext, plans: PlanInfo[], args: string): Promise<PlanInfo | undefined> {
  const query = args.trim().toLowerCase();
  const filtered = query
    ? plans.filter((plan) =>
        [plan.relativePath, plan.title ?? "", plan.label].some((value) => value.toLowerCase().includes(query)),
      )
    : plans;

  if (filtered.length === 0) {
    ctx.ui.notify(`No plans matched: ${args.trim()}`, "warning");
    return undefined;
  }

  if (filtered.length === 1) return filtered[0];

  const selected = await ctx.ui.select(
    "Select a plan to implement",
    filtered.map((plan) => plan.label),
  );

  if (!selected) return undefined;
  return filtered.find((plan) => plan.label === selected);
}

function queueImplementation(pi: ExtensionAPI, ctx: ExtensionCommandContext, plan: PlanInfo): void {
  const message = [
    `Implement the plan in @${plan.absolutePath}.`,
    "Read the plan file first, then carry out the work.",
    "Use the plan as the source of truth and report progress against it.",
  ].join(" ");

  if (ctx.isIdle()) {
    pi.sendUserMessage(message);
    ctx.ui.notify(`Implementing ${plan.relativePath}`, "info");
    return;
  }

  pi.sendUserMessage(message, { deliverAs: "followUp" });
  ctx.ui.notify(`Queued implementation for ${plan.relativePath}`, "info");
}

export default function implementPlanExtension(pi: ExtensionAPI) {
  const run = async (args: string, ctx: ExtensionCommandContext) => {
    try {
      const plans = await loadPlans(pi, ctx.cwd);
      if (plans.length === 0) {
        ctx.ui.notify("No markdown plans found in matt-plans/", "warning");
        return;
      }

      const plan = await selectPlan(ctx, plans, args);
      if (!plan) return;

      queueImplementation(pi, ctx, plan);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      ctx.ui.notify(`Could not load plans: ${message}`, "error");
    }
  };

  pi.registerCommand("implement-plan", {
    description: "Pick a plan from matt-plans/ and ask Pi to implement it",
    handler: run,
  });

  pi.registerShortcut(Key.ctrlAlt("i"), {
    description: "Pick a plan to implement",
    handler: async (ctx) => run("", ctx),
  });
}
