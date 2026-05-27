---
name: qa-assets-inventory
description: 通用 QA 资产清单和视觉证据索引 skill。Use when Codex needs to locate, register, verify, or summarize archived screenshots, extracted tab text, visual reference assets, design evidence, or migrated QA attachments before using them in UI development or validation.
---

# QA Assets Inventory

## Purpose

Use this skill to treat screenshots, text extracts, and archived attachments as evidence indexes, not as hidden rules.

## Flow

1. Locate the asset inventory file from the knowledge index.
2. Identify whether the task needs text extracts, full-page screenshots, component screenshots, open-state screenshots, or archived originals.
3. Open or view only the relevant assets.
4. Cross-check visual evidence with current source or runtime render before making implementation claims.
5. Register newly generated durable assets in the inventory with file name and purpose.

## Rules

- Do not store large images inside rule prose.
- Keep original assets in archive or asset folders; reference them from the inventory.
- Distinguish default, hover, focus, open, dialog, and report/table states.
- Do not treat old screenshots as current behavior without checking whether the source or UI changed.

## Output

Report the asset path, purpose, state represented, whether it was viewed, and how it affected the implementation or validation.
