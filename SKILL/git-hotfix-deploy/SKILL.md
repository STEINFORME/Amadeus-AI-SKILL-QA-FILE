---
name: git-hotfix-deploy
description: 通用 Git 热修分支和部署包流程。Use when Codex needs to prepare, verify, create, merge, summarize, or hand off a hotfix branch, patch branch, release branch, deploy/package directory, branch diff export, remote push readiness, cleanup, or release reminder for a Git repository, especially when destructive operations, remote operations, or deploy artifacts require explicit confirmation and hash-based verification.
---

# Git Hotfix Deploy

## First Move

1. Read repository-specific release docs first: `qa/`, `docs/`, `AGENTS.md`, release notes, deploy scripts, CI config.
2. Identify base branch, source branch, hotfix branch, deploy/package directory, remote name, and artifact filters.
3. Start with read-only checks and report mismatches before changing branches, files, remotes, or artifacts.

## Required Facts

- Current branch and `git status --short --branch`.
- Remote tracking state for base and source branches.
- Whether local base equals remote base.
- Whether local source equals remote source.
- Merge-base when direct diff is unexpectedly large.
- Artifact inclusion rules: frontend, backend, config, deletes, generated files, mixed changes.
- Whether output is committed, ignored, uploaded, or only handed off.

## Dangerous Operations

Require explicit confirmation before clearing package directories, `git commit`, `git push`, remote delete, force push, `git reset --hard`, forced checkout, forced clean, forced overwrite, production upload, or real deployment.

If the current task already explicitly authorizes commit or push, that satisfies confirmation for that operation; still verify branch identity, remote target, and worktree status before executing it.

Commit and push are separate: explicit commit authorization does not imply push, and explicit push authorization does not remove the branch/remote/worktree verification gate.

Explicit authorization does not require creating filler changes. If verification shows no real diff, report the no-op result instead of committing.

Use:

```text
:warning: 检测到危险操作
操作类型：[具体操作]
影响范围：[详细说明]
风险评估：[潜在后果]

请明确回复“确认”后，我再继续执行。
```

## Standard Flow

1. Verify a clean or understood worktree.
2. Verify base and source branch remote alignment.
3. Build file list from the approved diff range, usually `base..source` or `merge-base..source`.
4. Rebuild package output only after confirmation when clearing or overwriting is involved.
5. Create the hotfix branch from the verified base unless repo docs say otherwise.
6. Merge or cherry-pick only approved source changes.
7. Push only after explicit confirmation or explicit task authorization.
8. Hand off with exact source branch, hotfix branch, push status, release action, cleanup target, and unperformed remote/destructive actions.
9. When a push is skipped because it was not requested, state that as an intentional skipped operation, not as an omission.

## Package Rules

- Keep output paths traceable to source paths.
- Do not hide backend, config, delete, database, or mixed changes inside a frontend package.
- Report deletes separately unless the deploy system has a known delete mechanism.
- Prefer Git-native extraction for exact branch content.
- Compare important files with Git blob hashes, not text output that may change encoding or newlines.

## Handoff Rules

- State whether the source branch, hotfix branch, package output, commit, push, upload, and cleanup actually happened.
- If release ownership stays outside Codex, word the reminder around the source branch that must be merged or cleaned up, not around assumptions about the hotfix branch lifecycle.
- If a requested direct commit or push is explicitly authorized, still verify branch identity and remote target immediately before executing it.
