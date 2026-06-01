# 会话记录：skill 同步无漂移

## 时间

2026-06-01 08:02:12 +08:00

## 用户请求

根据 `communications` 优化唯一 lessons 文档，根据 `md` 更新通用开发 skill 和热修 skill，复制到仓库 `SKILL`，并直接提交 `main` 后推送。

## AI 判断

- 现有最新可复用规则仍是 `communications\2026-05-28\163320-skill-sync-push.md` 中的授权提交/推送核对规则。
- `md\12-communication-lessons-and-knowledge.md` 已覆盖最新提交/推送边界，本次只需要合并同义 skill 同步规则。
- 仓库 `SKILL` 下有 6 个通用 skill 与本机已安装对应 skill 存在规则漂移，漂移内容均来自通用 md 规则，不涉及项目专用 skill。

## 处理内容

- 优化 `md\12-communication-lessons-and-knowledge.md`：合并 003/006 同义规则，正式条目从 8 条压缩为 7 条。
- 同步 6 个通用 skill 到仓库 `SKILL`：`communication-lessons-extractor`、`skill-sync-from-md`、`frontend-change-validation`、`frontend-style-fix-rules`、`git-hotfix-deploy`、`repo-frontend-dev-workflow`。
- 新增本次自动化执行记录：`communications\2026-06-01\080212-skill-sync-no-drift.md`。

## 验证

- 已读取 `communications` 当前 6 条历史记录。
- 已确认 lessons 正式条目数为 7，未超过 30。
- 已比较 13 个通用 skill 的本机目录与仓库 `SKILL` 目录；发现并同步 6 个通用 skill 的规则漂移，剩余目录无差异。
- 已核对仓库分支为 `main`，远端为 `origin https://github.com/STEINFORME/Amadeus-AI-SKILL-QA-FILE.git`。
- 已阶段性提交运行记录：`36bb647 Record skill sync no drift`。
- 已阶段性推送到 `origin/main`：`9b9972a..36bb647 main -> main`。

## 风险

- 本次没有新增可复用规则，只压缩 lessons 冗余条目并同步已有通用 skill 漂移。
- 本记录补充提交会产生新的最终提交哈希，最终状态以本次自动化 memory 和最终回复为准。
