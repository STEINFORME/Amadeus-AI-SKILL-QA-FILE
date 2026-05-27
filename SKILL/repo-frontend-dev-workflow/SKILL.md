---
name: repo-frontend-dev-workflow
description: 通用前端页面和模块开发工作流。Use when Codex needs to build, fix, migrate, or review frontend pages, UI modules, forms, routes, state, styles, API field mapping, RP/design restoration, legacy JSP/jQuery/Avalon pages, Vue/React pages, mixed stacks, or ambiguous frontend defects that require repo guidance, source evidence, smallest-safe implementation, and targeted validation.
---

# Repo Frontend Dev Workflow

## First Move

1. Read repository guidance first: `AGENTS.md`, `qa/`, `docs/`, README, route/config files, related source, tests, and similar implementations.
2. Use `rg` to locate entries, fields, components, APIs, styles, and call chains.
3. Treat project docs as direction; confirm final facts from current source, real runtime behavior, and real API payloads.
4. Do not edit before identifying entry, data source, state owner, existing component/style patterns, impact scope, and validation route.

## Evidence Order

1. Real runtime behavior and Network payload.
2. Current source, templates, routes, config, tests, and built artifacts.
3. Repository QA, design/RP, screenshots, interface docs, and prior records.
4. Mock data, historical notes, and naming guesses.

Low-grade evidence can guide exploration, not define business logic.

## Development Flow

1. Clarify the requested outcome and exact scope.
2. Locate the real page/component entry and similar existing implementation.
3. Map data flow: request params, response fields, mapper, display, form echo, submit payload, errors, permissions, pagination, and navigation.
4. Choose the smallest necessary change; keep naming, file organization, API style, state management, error handling, and CSS style consistent with the repo.
5. Implement normal, loading, empty, failure, permission, invalid-field, repeat-submit, reset/close, and refresh behavior when the touched surface requires it.
6. Review the real diff for unrelated churn, global style leakage, dead code, hidden null risks, duplicate requests, and changed business meaning.
7. Validate with the narrowest reliable test or runtime check.

## Legacy Rules

- For JSP, jQuery, Avalon, CDN Vue, or nonstandard builds, preserve script order, global variables, server template paths, existing DOM/class structure, and request style.
- Do not introduce modern build tooling, new dependencies, module systems, or broad component splitting unless the repo already uses them and the task requires it.
- For third-party widgets, inspect the final browser DOM before styling hover, focus, upload, popover, or generated controls.

## Hard Stops

Stop and ask or report the missing fact when:

- Entry, route, key params, lifecycle, backend boundary, or data source is unknown.
- Status, permission, enum, submit, delete, upload, rich text, download, or navigation semantics are guessed.
- The fix touches shared components, global CSS, shared requests, permissions, menus, routes, includes, or production systems.
- The user asks for deletion, commit, push, reset, force overwrite, dependency upgrade, or other irreversible work without explicit authorization.

## Output

Report changed files, root cause, implementation, validation, unverified items, and remaining risk. Do not claim a page, submit flow, deploy, push, or verification happened unless it actually did.
