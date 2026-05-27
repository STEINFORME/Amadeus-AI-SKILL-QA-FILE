---
name: task-rule-router
description: 通用任务规则快速路由 skill。Use when Codex needs to quickly choose which rule document or skill to read for a development, UI, validation, component/style, function-map, hotfix, asset, communication, or skill-sync task without loading the entire knowledge base.
---

# Task Rule Router

## Routing Flow

1. Read the user request and identify the task class.
2. Read the index or route file.
3. Select the smallest relevant rule set.
4. Read topic files only after the route is clear.
5. Verify task-critical facts in source code, runtime behavior, artifacts, or repository config.
6. Update the route file when a new durable task class appears.

## Common Routes

- Page or UI development: frontend development workflow.
- Post-change acceptance: frontend validation workflow.
- Component, color, style, or reference page lookup: component reference map.
- Repo architecture or module ownership: function-map audit.
- Hotfix, deploy, branch, or package work: Git hotfix deploy.
- Visual CS/style constants or mock adapter rules: style fix workflow.
- Archived screenshots or text assets: asset inventory.
- Conversation record: communication recorder.
- Extracted lessons: communication lessons extractor.
- Skill generation or sync: skill sync workflow.

## Guardrails

- Do not read every document by default.
- Do not treat routing docs as final facts.
- Do not create a project-specific skill from a route that only applies to one feature.
- If two routes conflict, use the current source and runtime evidence to decide.

## Output

List selected route files, skipped irrelevant files, and the concrete evidence still needed.
