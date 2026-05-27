---
name: repo-function-map-audit
description: 通用仓库功能地图和技术栈审计 skill。Use when Codex needs to understand a large or legacy repository, classify modules, identify frontend/backend stacks, avoid confusing deploy artifacts with source, find repeated capabilities, judge module ownership, or choose a safe consolidation/refactor direction.
---

# Repo Function Map Audit

## Audit Flow

1. Locate build entry, runtime framework, frontend stacks, backend routing, ORM/schema clues, static assets, deploy/package directories, and generated artifacts.
2. Build a module map: business domain, frontend entry, backend/service clues, shared capabilities, and risk.
3. Separate source, deploy output, generated assets, temporary tools, and historical fixes.
4. Identify repeated capabilities before merging pages: upload, notification, selector, export, permissions, status enum, reports, queues, attachments, and routing.
5. Use the map for routing and risk, not as final proof for a specific code change.

## Rules

- Do not force old and new stacks into one implementation style.
- Prefer consolidating shared services, state, permissions, attachments, exports, and notifications before merging UI pages.
- Treat deploy/package directories as outputs unless repo evidence says they are active source.
- Mark feature-specific modules as project knowledge; do not create generic feature skills from them.

## Output

Provide a compact table: module/domain, entry, backend clue, reusable capability, risk, and next evidence needed.
