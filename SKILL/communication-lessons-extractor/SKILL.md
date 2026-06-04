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
6. If a communication says an earlier attempt was interrupted or superseded, prefer the final record and rewrite or remove lessons sourced only from the superseded attempt.
7. If there are no new durable facts, consolidate stale or duplicate entries, or merge new source provenance into an existing lesson, and report that no lesson was added; do not invent a synthetic lesson.

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
- Lessons whose only source is a superseded attempt when a later final communication contains the durable rule.
- Verification claims that were not completed in the raw record.
- Repeated no-drift run records whose reusable rule is already captured, unless they change the rule, source boundary, or provenance for an existing lesson.

## Validation

- Count formal lesson entries after editing and confirm the cap is not exceeded.
- Search the edited lessons for duplicate source/path rules and stale superseded wording.
- Keep raw communication paths as citations; do not replace them with memory-only provenance.

## Output

Report added, merged, source-only merged, deleted, unchanged, and intentionally skipped lesson entries, plus the final entry count.
