---
name: ai-communication-recorder
description: 通用 AI 对话和执行记录写入文档 skill。Use when Codex needs to record AI conversations, execution summaries, automation runs, important validation conclusions, risky-operation confirmations, durable user requirements, or rule-changing decisions into a structured communications folder before extracting reusable lessons.
---

# AI Communication Recorder

## When To Record

Record when the turn includes:

- Automation or skill synchronization.
- QA/md migration or durable rule changes.
- Risky operations such as delete, clear, overwrite, commit, push, reset, release, or production access.
- Important validation conclusions.
- User requirements that should affect future development behavior.
- Interface contracts, testing rules, path rules, or source-of-truth changes.
- Follow-up results for operations that an earlier record left pending, such as commit, push, install, or cleanup status.

Skip simple Q&A, temporary explanations, and no-decision chatter.

## File Placement

1. Use the repo-configured communications directory.
2. If no directory is configured, create or propose a `communications/YYYY-MM-DD/HHmmss-title.md` structure in the current knowledge repository.
3. Do not mix raw conversation records into long-term rule docs.
4. If a conversation creates reusable knowledge, write the raw record first, then update the lessons or topic md.
5. If an earlier record says a result will be confirmed later, add a follow-up record or update the run summary after the operation actually completes.
6. For automation runs, include the current run time, changed paths, validation result, and whether commit, push, install, or destructive operations were actually performed or skipped.
7. For authorized commit or push runs, record the checked branch, remote target, commit hash, push result, and skipped items.

## Record Template

```md
# 会话记录：标题

## 时间

YYYY-MM-DD HH:mm:ss

## 用户请求

简要摘录用户目标。

## AI 判断

核心结论、边界、危险操作和是否需要确认。

## 处理内容

- 修改或生成的文件
- 执行的命令
- 关键路径

## 验证

- 已验证内容
- 验证结果
- 未验证项

## 风险

- 剩余风险
- 后续需要用户确认的事项
```

## Output

Report the record path, operation statuses recorded, and any follow-up lesson/topic files that were updated.
