---
name: frontend-change-validation
description: 通用前端变更验证和结论门禁。Use when Codex has modified, reviewed, or needs to verify frontend UI, routes, forms, API mappings, state logic, styles, responsive layout, legacy pages, component reuse, upload/download flows, permission/state visibility, or when a user asks whether a frontend fix is done, safe, visually correct, regression-free, or ready for handoff.
---

# Frontend Change Validation

## Validation Order

1. Entry: correct route, menu, click path, deep-link requirement, include, parent page, caller, workflow step, permission context, or local URL.
2. Parameters: URL, route/query params, props, hidden inputs, storage, and API payload.
3. Data states: normal, empty, loading, failure, permission denied, missing fields, wrong field types.
4. Visibility: permission, status, disabled/readonly/edit mode, row actions, operation placeholders.
5. Interactions: click, hover, focus, active, popconfirm/dialog, submit validation, cancel, reset, close, return, refresh.
6. Visuals: spacing, alignment, color, font size, border, shadow, focus outline, wrapping, responsive behavior.
7. Safety: XSS, URL concatenation, upload/download limits, duplicate submit, request race, pagination boundary, stale dialog data.

If entry or params fail, stop there; do not write a visual pass conclusion.

## Labels

- `通过`: critical paths were verified.
- `有问题`: a verified issue remains.
- `受限完成`: implementation is done but runtime verification is blocked.
- `非本次范围`: observed item is real but outside the requested scope.
- `未验证`: no direct validation was completed.

Do not use `通过` when critical runtime behavior is still unverified.

## Checks

- Use `rg` for old fields, params, enums, mock switches, placeholder markers, and duplicate logic.
- Inspect real diff for unrelated churn, global CSS leakage, empty guards hiding root cause, and changed business meaning.
- Run targeted tests first, then type check, build, lint, syntax checks, or browser checks as available.
- For forms, verify required rules, echo/backfill, reset, close cleanup, repeat submit, submit failure, and success refresh.
- For lists, verify empty state, total/list mismatch, pagination after delete, filters during request, and stale response overwrite.
- For interface changes, verify the full chain from response mapping to display, edit echo, submit payload, error handling, and every reused view touched by that field.
- For reference-style fixes, compare against the actual reference component or screenshot state used, not only against source selectors.
- For legacy or server-rendered pages, verify through the real menu, list, parent page, or workflow trigger when direct URLs depend on session or permissions.
- Use the repository's configured browser/E2E route and page navigation map when available; production-like targets, real submits, deletes, uploads, publishes, or formal environments still require explicit confirmation.

## Limited Verification

Mark limited instead of pretending when validation requires real deletion, save, submit, upload, publish, audit, production API calls, real user data, or irreversible actions without explicit confirmation.

If browser or runtime verification is blocked, do static checks that still reduce risk, but label the result `受限完成` or `未验证` instead of `通过`.

## Report

Report conclusion label, evidence checked, verified behavior, blocked runtime actions, unverified items, and remaining risk.
