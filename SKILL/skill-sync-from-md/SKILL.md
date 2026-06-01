---
name: skill-sync-from-md
description: 通用从 md 知识源同步 skill 的流程。Use when Codex needs to generate, update, compare, copy, or install skills from markdown knowledge files, map each reusable source document to a skill, exclude feature-specific skills, keep skills concise, update agents metadata, verify copied skill folders, and record the sync result.
---

# Skill Sync From MD

## Source Mapping

1. Read the knowledge index.
2. Treat each reusable source markdown as a candidate skill.
3. Exclude markdown files that only document one specific feature, business module, private interface set, or one-off implementation.
4. Convert project-specific rules into generic workflows only when the behavior clearly transfers across repositories.
5. Keep skills as execution procedures; keep detailed project knowledge in md/reference docs.

## Sync Flow

1. Read relevant md files and any existing skill folders.
2. Compare rule drift before editing.
3. Update only skills whose source rules changed or are missing.
4. Keep frontmatter to `name` and `description`.
5. Update `agents/openai.yaml` so display name, short description, and default prompt match the skill.
6. Copy or write only valid skill folders that contain `SKILL.md` to the configured skill output directory.
7. If installing into an active Codex skills directory, check available space and replace only the selected valid skill folders.
8. Record the sync in communications, including commit, push, install, or skipped operation status.
9. If commit or push is explicitly authorized in the task, verify branch, remote target, and worktree status immediately before executing it.
10. Treat commit and push as separate operations; do not infer push authorization from commit authorization unless the task explicitly includes both.

## Exclusion Rules

- Do not create generic skills for single project features.
- Do not copy full md files into `SKILL.md`.
- Do not make one giant skill when source docs describe separate reusable tasks.
- Do not delete, overwrite, commit, push, or install skills unless the task explicitly includes that operation and required confirmation is satisfied.
- When commit or push is explicitly authorized, do not ask again; verify identity first and record the exact result.
- Do not keep empty directories or folders without `SKILL.md` as synchronized skills.
- When a raw communication marks an earlier sync as interrupted or superseded, use the later final record as the durable source.
- If source md and existing skills already match, do not churn every skill; update only changed lessons, metadata, or records and report unchanged mappings.

## Validation

- Check frontmatter names match folder names.
- Search for template placeholders.
- Search for unwanted project names, fixed private paths, feature modules, and private API names in generic skills.
- Count mapped source docs, generated skills, and excluded feature docs.
- Check every synchronized folder contains `SKILL.md` and expected metadata.
- Compare relative file lists and content hashes after copying or installing skill folders.

## Output

Report source-to-skill mapping, excluded docs and reasons, changed skill files, validation, commit or push status, and unverified items.
