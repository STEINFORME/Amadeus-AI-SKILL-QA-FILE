---
name: ai-knowledge-source-rules
description: 通用 AI 知识源、路径语义和写入边界 skill。Use when Codex needs to decide where long-term rules, conversation records, generated skills, archives, simplified repo entries, or automation outputs belong; also use when migrating QA knowledge, preventing dual-write drift, or checking old path wording.
---

# AI Knowledge Source Rules

## Source Md

Use the configured knowledge policy, folder purpose map, and path/source rules as the formal source. If a runtime skill, generated skill, old mirror, or historical communication conflicts with formal md, follow the formal md unless the current user explicitly overrides it.

## Directory Roles

Identify these roles from the current repo or user-provided paths:

- Formal knowledge source: durable rules, contracts, testing guidance, workflow governance, and source policy.
- Communications: raw conversation records, execution summaries, confirmations, and verification facts; not formal rules.
- Generated skill output: md-derived skill folders; rebuildable and not the source of truth.
- Runtime skill install: local Codex discovery layer; rebuildable and never a reverse-sync source.
- Simplified repo entry: lightweight index or automation trigger kept in a working repo.
- Scripts/runtime config: helper automation and non-secret local profiles; scripts are assets, not rule sources.
- Archive and mirrors: evidence or restore material; do not treat them as active rules unless restoring.

## Write Rules

1. Write durable reusable rules to the complete knowledge source.
2. Write raw conversation and execution facts to communications.
3. Write generated skills to the skill output directory.
4. Keep simplified repo entries short and link them to the complete source.
5. Do not write complete long-term rules back into a simplified entry.
6. Do not reverse-sync from runtime skills to generated skills, or from generated skills to md.
7. When path semantics change, update all routing docs that point at the old source.
8. Distinguish generated skill output from active skill installation; copy or replace only valid skill folders that contain `SKILL.md`, then verify file sets and hashes when both locations must match.

## Priority And Safety

1. Current user instruction wins unless it conflicts with safety boundaries.
2. Safety boundaries include destructive operations, secrets, production access, large C-drive writes, and repository changes without confirmation.
3. Formal md wins over skills, communications, mirrors, and local runtime habits.
4. Keep user-profile directories as runtime/config/cache layers, not long-term knowledge storage.
5. Never copy sessions, logs, credentials, cookies, tokens, or API keys into knowledge or migration assets.

## Checks

- Search for stale wording that says the simplified entry is the complete source.
- Check that communications and skill output directories exist before relying on them.
- Check that automation reads the complete source, not only the simplified entry.
- Keep archives as evidence, not active rule sources, unless the task is restoration.
- Check ignored local profiles before committing runtime templates.

## Output

Report the chosen source of truth, write target, skipped targets, conflict priority used, and any stale path wording found.
