---
name: communication-lessons-extractor
description: 通用对话教训提炼 skill。Use when Codex needs to extract reusable lessons, new rules, path rules, automation rules, risk reminders, or durable knowledge from raw communication records while keeping the lessons file concise, deduplicated, and capped.
---

# Communication Lessons Extractor

## Rules

1. Read raw communications first; do not invent lessons from memory alone.
2. Keep raw facts in communications and reusable rules in the lessons file.
3. Before adding a lesson, merge equivalent existing entries and delete or rewrite redundant ones.
4. Keep the lessons file capped by the repository rule; if no rule exists, keep it short and high-signal.
5. Each lesson must include source, type, content, and applicable trigger.

## Keep

- New durable workflow rules.
- Path/source changes.
- Automation behavior.
- Risk gates and confirmation rules.
- Repeated mistakes that should alter future behavior.

## Drop

- Process chatter.
- One-off implementation details with no reuse.
- Emotional commentary.
- Duplicated path statements already covered by a broader rule.
- Feature-specific details that belong in a feature document, not a generic lesson.

## Output

Report added, merged, deleted, and unchanged lesson entries, plus the final entry count.
