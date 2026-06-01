---
name: frontend-style-fix-rules
description: 通用前端样式修复、参考页复用和 mock 适配层 skill。Use when Codex needs to make deterministic frontend visual fixes, match a reference page, reuse base styles, adjust spacing, colors, radius, date display, local mock adapters, or avoid changing business logic while fixing UI.
---

# Frontend Style Fix Rules

## Scope

Use this skill only for deterministic visual or display-layer work. If the change affects API fields, permissions, status, save flow, filtering, sorting, pagination, or button semantics, stop and switch to the broader development workflow.

## Reference First

1. Identify the canonical base/reference page or design system example.
2. Copy structure, classes, component type, button type, layout, and hints as a block when the user asks to match an existing style.
3. Adapt only business params and local data bindings.
4. Do not create a new local CSS system when existing tokens/classes solve it.

## Style Rules

- Prefer parent `display:flex/grid` with `gap` for grouped spacing.
- Use existing color tokens, classes, variables, and theme names before hardcoding values.
- Keep display format and submit/API format separate.
- Avoid global CSS unless the target is intentionally global and verified.
- Inspect final DOM for generated widgets before writing selectors.
- Use spacing, radius, color, and component choices from the actual reference or repo docs; if references conflict, stop and report the conflict instead of inventing a new local style.

## Mock Adapter Rules

- When real APIs are absent but the page must run, create a local adapter with an explicit mock switch.
- Preserve future API method names, param shapes, response shells, field names, array levels, status fields, and history structures as much as known.
- Replace adapter internals when real APIs arrive; do not scatter mock data through templates and event handlers.

## Output

Report the reference source, changed selectors/components, confirmation that business logic was not altered, validation result, and any blocked non-style decision.
