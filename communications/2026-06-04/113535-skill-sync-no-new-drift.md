# 会话记录：skill 同步复核并收紧 no-drift 规则

## 时间

2026-06-04 11:38:09 +08:00

## 用户请求

根据 `communications` 优化唯一 lessons 文档，根据 `md` 更新通用开发 skill 和热修 skill，复制到仓库 `SKILL`，并直接提交 `main` 后推送。

## AI 判断

- 上次自动化后新增记录 `communications\2026-06-03\130416-skill-sync-current-no-drift.md` 和 `communications\2026-06-03\163505-skill-sync-no-new-drift.md` 都只确认无新 durable lesson 或 skill 漂移。
- `md\12-communication-lessons-and-knowledge.md` 仍为 7 条正式 lesson，未超过 30 条；本轮不新增正式条目，只把 6 月 3 日 no-drift 复核来源合并到已有第 006 条。
- 可复用变化适合沉淀到 `communication-lessons-extractor` 和 `skill-sync-from-md`；`md\09-hotfix-deploy-rules.md` 与 `git-hotfix-deploy` 现有规则一致，本轮不为“热修”字样制造热修 skill 改动。

## 处理内容

- 优化 `md\12-communication-lessons-and-knowledge.md` 第 006 条：合并 `communications\2026-06-03\163505-skill-sync-no-new-drift.md` 来源，并明确重复 no-drift 记录只合并来源或记录验证结论，不重复复制、重写 skill 或制造提交。
- 更新本机已安装 `communication-lessons-extractor`：允许无新增 durable fact 时只合并来源 provenance，并在输出中区分 source-only merged。
- 更新本机已安装 `skill-sync-from-md`：明确 repeated no-drift/no-churn 只更新 lesson provenance 或运行记录，不重写 unchanged skills。
- 未修改 `git-hotfix-deploy`；当前热修规则已覆盖明确授权、提交推送分离和无真实 diff 不制造提交。
- 将上述 2 个有效 skill 目录同步到仓库 `SKILL`，并新增本轮自动化复核记录。

## 验证

- 已确认 `main` 跟踪 `origin/main`，执行前工作区干净。
- 已确认 lessons 正式条目数为 7。
- 已确认 `SKILL` 下 13 个目录均包含 `SKILL.md` 和 `agents/openai.yaml`。
- 已确认 2 个已同步 skill 的本机安装目录与仓库 `SKILL` 目录相对文件集合和 SHA256 一致。
- 已确认 13 个仓库 skill 的 frontmatter name 与目录名一致，且存在 description。
- `git diff --check` 无错误，仅有 Windows LF/CRLF 提示。

## 风险

- 未运行 `quick_validate.py`；本轮使用 frontmatter、metadata、正式条目数、hash 同步和 `git diff --check` 补充验证。热修 skill 无内容变更。
