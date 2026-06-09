---
name: ai-qa-index-router
description: 通用 AI 知识库索引和任务路由 skill。Use when Codex needs to decide which local QA, md, docs, communications, skill outputs, archive, page navigation maps, or rule files to read before working; also use when maintaining an AI knowledge base index, routing tasks to source documents, or preventing stale duplicated rule sources.
---

# AI QA Index Router

## Purpose

Use this skill as the first routing layer for an AI knowledge base. Read the entry/index first, then load only the topic md needed for the current task.

## Flow

1. Find the declared knowledge root from repo docs, `AGENTS.md`, `qa/`, index files, or user-provided paths.
2. Read the formal knowledge policy and entry index before topic files when they exist.
3. Route by task type: source/path rules, AI workflow governance, frontend development, page entry/navigation map, validation, component/style map, repo function map, hotfix/deploy, style fixes, asset inventory, communication lessons, migration/restore, skill sync, and communication recording.
4. Read only the topic files needed for the task; do not bulk-read md, communications, generated skills, runtime skills, sessions, or logs.
5. If a skill triggers, use it as workflow help; when skill and formal md conflict, prefer formal md.
6. Return to real source, interfaces, screenshots, runtime behavior, or artifacts before making claims.
7. When maintaining the index, update route tables and source semantics together.

## Common Routes

- Knowledge source, path, write boundary, or source conflict: knowledge policy, folder map, and path/source rules.
- AI workflow start, confirmation node, or minimal reading order: agent entry index and workflow runbook.
- Runtime skill sync or install drift: runtime sync policy and skill sync rules.
- Migration, new-machine restore, C-drive boundary, or health check: migration/restore guide and folder map.
- Page, UI, validation, component, function-map, hotfix, asset, communication, or lesson work: route to the matching topic md only.

## Rules

- Keep the index as navigation, not the complete knowledge base.
- Do not duplicate full topic content into the index.
- When a source is demoted to a lightweight entry, clearly point to the complete source.
- When a task creates durable process knowledge, update the relevant topic file and then update the index if routing changes.
- If the index references project-specific modules, do not turn those modules into generic skills unless the rule is reusable across repositories.
- If the index references project page-entry maps, use them to choose evidence and validation paths, not as standalone generic skill material.
- Do not treat communications as rules; use them as facts for later lesson extraction.

## Output

State which entry/index was read, which topic files were selected, which directories were intentionally skipped, which concrete source facts were verified, and which files were updated.
