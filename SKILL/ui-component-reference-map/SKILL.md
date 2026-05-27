---
name: ui-component-reference-map
description: 通用 UI 组件、样式参照和设计系统映射 skill。Use when Codex needs to find existing buttons, colors, form controls, tables, dialogs, layout classes, old/new UI reference pages, screenshots, style tokens, or component examples before implementing or fixing frontend UI.
---

# UI Component Reference Map

## First Move

1. Identify the target stack: legacy template, jQuery/Avalon, CDN Vue, React/Vue app, design system, or mixed stack.
2. Locate the repo's canonical reference pages, component demos, style tokens, theme files, screenshots, and existing similar pages.
3. Prefer copying proven structure and classes over inventing local CSS.

## Reuse Rules

- For old pages, reuse DOM/class blocks as a unit; do not copy only a color or one class name.
- For component libraries, reuse complete component examples with wrappers, width classes, button/link types, empty states, pagination, and dialog structure.
- If a reference page has tabs or demos, distinguish demo indices from real business values.
- For table changes, inspect search bar, empty state, pagination, operations, column width, and row click behavior together.
- For third-party widgets, inspect expanded/open DOM before styling.

## Visual Evidence

- Use screenshots and extracted tab text as evidence indexes.
- Register newly generated or important screenshots in the asset inventory.
- Do not claim design fidelity from source HTML alone when screenshots or runtime render are required.

## Output

Report the reference source, copied pattern, local adaptation, and any style or component risks.
