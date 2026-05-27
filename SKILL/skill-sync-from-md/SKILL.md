---
name: skill-sync-from-md
description: 通用从 md 知识源同步 skill 的流程。Use when Codex needs to generate, update, compare, or copy skills from markdown knowledge files, map each reusable source document to a skill, exclude feature-specific skills, keep skills concise, update agents metadata, and record the sync result.
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
6. Copy or write the complete skill folder to the configured skill output directory.
7. Record the sync in communications.

## Exclusion Rules

- Do not create generic skills for single project features.
- Do not copy full md files into `SKILL.md`.
- Do not make one giant skill when source docs describe separate reusable tasks.
- Do not delete, overwrite, commit, push, or install skills unless the task explicitly includes that operation and required confirmation is satisfied.

## Validation

- Check frontmatter names match folder names.
- Search for template placeholders.
- Search for unwanted project names, fixed private paths, feature modules, and private API names in generic skills.
- Count mapped source docs, generated skills, and excluded feature docs.

## Output

Report source-to-skill mapping, excluded docs and reasons, changed skill files, validation, and unverified items.
