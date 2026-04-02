/**
 * Protected Paths Extension
 * 
 * Blocks read access to sensitive files like .env, secrets, credentials.
 * Mirrors Claude Code's Read() deny patterns.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const DENIED_PATTERNS = [
  /^\.env$/,
  /^\.env\..*/,
  /\/\.env$/,
  /\/\.env\..*/,
  /\/secrets\//,
  /secret/i,
  /password/i,
  /credential/i,
  /\.aws\/credentials$/,
  /\.ssh\/id_/,
  /\.gnupg\//,
];

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, _ctx) => {
    if (event.toolName !== "read") return;
    
    const path = event.input.path as string;
    const isDenied = DENIED_PATTERNS.some(p => p.test(path));
    
    if (isDenied) {
      return { block: true, reason: `Blocked: ${path} matches protected file pattern` };
    }
  });
}
