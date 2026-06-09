---
name: ai-workflow-migration-restore
description: 通用 AI 工作流迁移、恢复和健康检查 skill。Use when Codex needs to migrate durable AI workflow assets, restore Codex/Hermes/Obsidian runtime setup on a new machine, validate C-drive versus durable-drive boundaries, run or review health checks, or plan runtime skill restoration without copying secrets, sessions, logs, or project-specific repositories.
---

# AI Workflow Migration Restore

## Overview

Use this skill to keep durable AI workflow assets separate from rebuildable runtime state during migration, restore, or health-check tasks.

## Roles

- Durable assets: formal md, communications, generated skills, scripts, runtime examples, user workspace, and reviewed AI workflow documents.
- Rebuildable runtime: Codex install, active skill installation, logs, caches, local app data, and authenticated sessions.
- Private local state: machine profiles, API keys, cookies, tokens, passwords, Git credentials, and full session logs.
- Company repositories: re-clone from remote; do not treat copied working directories as migration source.

## Migration Flow

1. Read the configured migration guide, folder purpose map, knowledge source policy, and runtime sync policy.
2. Identify durable assets, rebuildable runtime folders, ignored local files, and repositories that should be re-cloned.
3. Check local config templates for secrets before committing or copying.
4. Restore durable assets first, then install apps and log in manually.
5. Rebuild runtime skills only from generated skill output; do not reverse-sync runtime skills into generated output or md.
6. Recreate environment variables, junctions, or local runtime folders only after confirming the target paths.
7. Run the configured health-check script when available and report warnings separately from failures.

## Safety Rules

- Do not copy secrets, credentials, cookies, tokens, full sessions, logs, caches, or machine-local profiles.
- Do not write large new files into a user-profile runtime directory without explicit confirmation.
- Do not delete or recreate junctions, runtime folders, repositories, or generated skills without explicit authorization.
- Do not commit ignored local profiles; commit examples and scripts only after scanning for secrets.
- Do not assume a runtime warning means failure; classify each health-check warning and required next step.

## Validation

- Confirm durable folders and expected scripts exist.
- Confirm ignored local files remain ignored.
- Confirm generated skill output and runtime skills contain valid `SKILL.md` folders before sync.
- Compare file lists and hashes after any skill restore.
- Confirm environment variables and junction targets point to the intended durable location.
- Confirm no secrets were matched by a targeted scan.

## Output

Report migrated or restored asset classes, skipped runtime/private items, health-check result, warnings, and any operation that still needs explicit user confirmation.
