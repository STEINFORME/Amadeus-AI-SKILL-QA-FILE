# 会话记录：页面地图同步边界

## 时间

2026-06-01 13:03:20 +08:00

## 用户请求

根据 `communications` 优化 lessons，根据 `md` 更新通用开发 skill 和热修 skill，复制到仓库 `SKILL`，并直接提交 `main` 后推送。

## AI 判断

- `md\13-lqtedu-page-navigation-map.md` 是项目页面入口地图，不生成项目专用 skill。
- 可复用部分是通用前端流程：先确认入口链路、菜单/列表/父页面触发、权限/会话上下文，不能只凭直链判断页面有效。
- `md\09-hotfix-deploy-rules.md` 与 `git-hotfix-deploy` 当前核心规则未发现漂移，本轮不改热修 skill。

## 处理内容

- 将页面入口链路规则同步到通用 skill：`repo-frontend-dev-workflow`、`frontend-change-validation`、`repo-function-map-audit`、`ai-qa-index-router`、`task-rule-router`、`skill-sync-from-md`。
- 更新 `md\98-daily-skill-sync-rule.md`，把项目页面地图列为不生成通用 skill 的项目知识。
- 优化 `md\12-communication-lessons-and-knowledge.md` 既有条目，不新增正式条目数。

## 验证

- 已确认目标仓库分支为 `main`，远端为 `origin https://github.com/STEINFORME/Amadeus-AI-SKILL-QA-FILE.git`。
- 后续提交、推送、哈希一致性和最终提交号以本次 automation memory 与最终回复为准。

## 风险

- `md\13-lqtedu-page-navigation-map.md` 很大且包含项目专用页面路径，只能作为项目知识和通用规则来源，不能整体塞进 skill。
