---
name: frontend-change-validation
description: 通用前端变更验证和结论门禁。Use when Codex has modified, reviewed, or needs to verify frontend UI, routes, forms, API mappings, state logic, styles, responsive layout, legacy pages, component reuse, upload/download flows, permission/state visibility, or when a user asks whether a frontend fix is done, safe, visually correct, regression-free, or ready for handoff.
---

# Frontend Change Validation

## Validation Order

1. Entry: correct route, menu, include, parent page, caller, or local URL.
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

## Limited Verification

Mark limited instead of pretending when validation requires real deletion, save, submit, upload, publish, audit, production API calls, real user data, or irreversible actions without explicit confirmation.

## Report

Report conclusion label, evidence checked, verified behavior, unverified items, and remaining risk.
