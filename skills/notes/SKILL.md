---
name: Notes Manager
description: Tools for searching, reading, and adding to the user's personal notes (Obsidian vault).
---

# Notes Manager Skill

This skill allows the agent to interact with the user's Obsidian notes using the `obsidian` CLI tool.

## Obsidian CLI

All vault interactions should use the `obsidian` CLI. Key commands:

- **Search**: `obsidian search query="<text>"` or `obsidian search:context query="<text>"` for results with surrounding lines
- **Read file**: `obsidian read file="<name>"` or `obsidian read path="<path>"`
- **Read daily note**: `obsidian daily:read`
- **Append to file**: `obsidian append file="<name>" content="<text>"`
- **Append to daily note**: `obsidian daily:append content="<text>"`
- **Create file**: `obsidian create name="<name>" path="<folder/name.md>" content="<text>"`
- **List files**: `obsidian files folder="<path>"`
- **List tasks**: `obsidian tasks` (add `todo` or `done` flags to filter)
- **Get daily note path**: `obsidian daily:path`

Use `\n` for newlines in content values.

## Capabilities

### 1. Check/Search Notes
When the user asks to "check my notes" or search for something:
- Use `obsidian search:context query="<text>"` to find matches with context.
- Use `obsidian read` to retrieve full content of relevant files.
- Prioritize the `Daily/` and `Knowledge/` folders unless instructed otherwise.

### 2. Add to Notes
When the user asks to "add that to my notes" or "make a note of that":
- **Default Location**: Find a suitable location. If a new note/file is needed, create it in the Knowledge directory with `obsidian create`. If it's a small piece of information, search existing Knowledge files for a suitable one. If nowhere obvious, use `obsidian daily:append`.
- **Format**: Bullet point (`- `) followed by the content in Markdown.

### 3. Add to Tasks
When the user asks to "add that to my tasks":
- **Default Location**: Unless specified, append to the daily note with `obsidian daily:append`.
- **Format**: Task item (`- [ ] `) followed by the content in Markdown.

### 4. Commit and Push Changes
After making any updates to notes, commit and push:
- Run: `~/dotfiles/skills/notes/scripts/commit-and-push.sh "<description>"`
- The description should briefly describe what was added/changed.
- The script handles changing to the Notes directory and running jj commands.

## Constraints & Rules (from AGENTS.md)
1. **Preserve Structure**: Do not create new top-level directories.
2. **Privacy**: Be careful when reading from `Personal/` or `Work/` if the context implies sharing sensitive info.
3. **Formatting**: Respect existing Markdown links `[[Link]]` and tags `#tag`.

## Example Workflows

- **User**: "Check my notes for 'project alpha'."
  - **Action**: `obsidian search:context query="project alpha"`

- **User**: "Add this to my notes."
  - **Action**:
    1. `obsidian daily:append content="- <summary>"`
    2. Run commit-and-push script.

- **User**: "Add a task to review the PR."
  - **Action**:
    1. `obsidian daily:append content="- [ ] Review the PR"`
    2. Run commit-and-push script.
