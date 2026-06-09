# 会话记录：AI 工作流 skill 同步

## 时间

2026-06-09 16:52:00 +08:00

## 用户请求

根据 `communications` 优化唯一 lessons 文档；根据 `md` 更新多条通用 skill 和热修 skill；只保留通用 skill；复制到仓库 `SKILL`；直接提交 `main` 并推送。

## AI 判断

- `communications\2026-06-09-ai-workflow-knowledge-refactor-report.md` 包含新的长期规则事实，应提炼进 `md\12-communication-lessons-and-knowledge.md`。
- `md` 下新增的 00 系列工作流治理文档属于通用规则源，应接入索引和 skill 映射。
- `git-hotfix-deploy` 已覆盖 `09-hotfix-deploy-rules.md` 的关键热修门禁，本轮不为“热修”字样制造无漂移改动。
- `SKILL\ai-workflow-migration-restore` 原为 TODO 模板，本轮按正式 md 补全为通用迁移恢复 skill。

## 处理内容

- 优化 `md\12-communication-lessons-and-knowledge.md`，正式 lesson 从 7 条变为 9 条。
- 更新 `md\00-index.md` 和 `md\98-daily-skill-sync-rule.md`，接入 00 系列文档和新 skill 映射。
- 更新 `ai-knowledge-source-rules`、`ai-qa-index-router`、`task-rule-router`、`skill-sync-from-md`、`ai-communication-recorder`。
- 新增并补全 `ai-workflow-migration-restore`。
- 保留并纳入未跟踪的 00 系列 md、scripts、runtime example、`.gitignore` 和既有 2026-06-09 报告；`runtime\machine-profile.local.json` 继续被忽略。

## 验证

- `quick_validate.py` 已验证 `SKILL` 下 14 个 skill 均有效。
- lessons 正式条目数为 9，未超过 30 条。
- 已扫描 `SKILL`，未发现 TODO 模板残留。
- 已扫描变更通用 skill，未命中项目名、固定本机路径或单业务词。
- `sync-skills-to-codex.ps1` 已 dry-run：5 个 runtime skill 需更新，1 个新 skill 可创建，本轮未执行 `-Apply`。
- `check-ai-workflow-health.ps1` 已运行：C 盘剩余约 1.52GB 为 WARN；工作区 `.codex\skills` 存在为 WARN；其他关键路径 OK。
- `git diff --check` 无空白错误，仅提示 Git 将 LF 转 CRLF。

## 风险

- 本轮未同步到 `C:\Users\zuoti\.codex\skills`，只提交仓库 `SKILL` 产物。
- C 盘空间偏低和工作区 `.codex\skills` 双运行层风险仍存在。
- 提交和推送将在本记录写入后执行，最终结果写入自动化 memory 和最终回复。
