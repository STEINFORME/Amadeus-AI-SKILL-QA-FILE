# 会话记录：skill 同步无重复改动

## 时间

2026-06-02 11:33:28 +08:00

## 用户请求

根据 `communications` 优化唯一 lessons 文档，根据 `md` 更新通用开发 skill 和热修 skill，复制到仓库 `SKILL`，并直接提交 `main` 后推送。

## AI 判断

- `communications\2026-06-01\163600-skill-sync-no-drift.md` 的可复用点是：无新增可迁移规则且 skill 文件集合和哈希一致时，不要重复修改或复制。
- 当前仓库 `SKILL` 与本机已安装的 13 个通用 skill 相对文件集合和 SHA256 一致，本轮不改 skill 文件。
- 提交和推送已被本次自动化明确授权，执行前仍核对分支、远端和工作区状态。

## 处理内容

- 优化 `md\12-communication-lessons-and-knowledge.md` 第 003、006 条，补充“无漂移只记录验证、不重复改 skill”和“哈希一致时不重复复制或改文件”。
- 清理重复生成的 `communications\2026-06-02\113311-skill-sync-no-new-drift.md`，只保留本记录。
- 未新增 lessons 正式条目，正式条目数保持 7 条。
- 未修改通用 skill 或热修 skill；仓库 `SKILL` 已是最新归档状态。

## 验证

- 已确认 `md\12-communication-lessons-and-knowledge.md` 正式条目数为 7，未超过 30。
- 已确认 `SKILL` 下 13 个目录均包含 `SKILL.md`。
- 已确认 `SKILL` 未命中模板占位、固定项目路径、项目名或单业务功能词。
- 已确认仓库 `SKILL` 与当前已安装 13 个通用 skill 相对文件集合和 SHA256 一致。
- 提交和推送结果以本次 automation memory 与最终回复为准。

## 风险

- 本轮无新增可迁移 skill 规则；强行改 skill 会造成无意义 churn。
