---
name: ai-knowledge-source-rules
description: 通用 AI 知识源、路径语义和写入边界 skill。Use when Codex needs to decide where long-term rules, conversation records, generated skills, archives, simplified repo entries, or automation outputs belong; also use when migrating QA knowledge, preventing dual-write drift, or checking old path wording.
---

# AI Knowledge Source Rules

## Directory Roles

Identify these roles from the current repo or user-provided paths:

- Complete knowledge source: durable rules, contracts, testing guidance, and project cognition.
- Simplified entry: lightweight index or automation trigger kept in a working repo.
- Communications: raw conversation records, execution summaries, confirmations, and verification facts.
- Skill output: generated or synchronized skill folders.
- Active skill install: the local runtime directory where Codex discovers usable skills.
- Archive: original backups and assets.

## Write Rules

1. Write durable reusable rules to the complete knowledge source.
2. Write raw conversation and execution facts to communications.
3. Write generated skills to the skill output directory.
4. Keep simplified repo entries short and link them to the complete source.
5. Do not write complete long-term rules back into a simplified entry.
6. When path semantics change, update all routing docs that point at the old source.
7. Distinguish repository skill output from active skill installation; copy or replace only valid skill folders that contain `SKILL.md`, then verify file sets and hashes when both locations must match.

## Checks

- Search for stale wording that says the simplified entry is the complete source.
- Check that communications and skill output directories exist before relying on them.
- Check that automation reads the complete source, not only the simplified entry.
- Keep archives as evidence, not active rule sources, unless the task is restoration.

## Output

Report the chosen source of truth, write target, skipped targets, and any stale path wording found.
