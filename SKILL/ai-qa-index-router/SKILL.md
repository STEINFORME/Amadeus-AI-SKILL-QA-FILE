---
name: ai-qa-index-router
description: 通用 AI 知识库索引和任务路由 skill。Use when Codex needs to decide which local QA, md, docs, communications, skill outputs, archive, page navigation maps, or rule files to read before working; also use when maintaining an AI knowledge base index, routing tasks to source documents, or preventing stale duplicated rule sources.
---

# AI QA Index Router

## Purpose

Use this skill as the first routing layer for a repo-local AI knowledge base.

## Flow

1. Find the declared knowledge root from repo docs, `AGENTS.md`, `qa/`, index files, or user-provided paths.
2. Read the index before reading topic files.
3. Route by task type: source/path rules, frontend development, page entry/navigation map, validation, component/style map, repo function map, hotfix/deploy, style fixes, asset inventory, communication lessons, skill sync, and communication recording.
4. Read only the topic files needed for the task.
5. Return to real source, interfaces, screenshots, runtime behavior, or artifacts before making claims.
6. When maintaining the index, update route tables and source semantics together.

## Rules

- Keep the index as navigation, not the complete knowledge base.
- Do not duplicate full topic content into the index.
- When a source is demoted to a lightweight entry, clearly point to the complete source.
- When a task creates durable process knowledge, update the relevant topic file and then update the index if routing changes.
- If the index references project-specific modules, do not turn those modules into generic skills unless the rule is reusable across repositories.
- If the index references project page-entry maps, use them to choose evidence and validation paths, not as standalone generic skill material.

## Output

State which index was read, which topic files were selected, which concrete source facts were verified, and which files were updated.
