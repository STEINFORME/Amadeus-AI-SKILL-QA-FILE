# 会话记录：skill 同步去冗余规则

## 时间

2026-06-03 10:14:52 +08:00

## 用户请求

根据 `communications` 优化唯一 lessons 文档，根据 `md` 更新通用开发 skill 和热修 skill，复制到仓库 `SKILL`，并直接提交 `main` 后推送。

## AI 判断

- 最新 `communications\2026-06-02\113328-skill-sync-no-churn.md` 的可复用点是：无漂移时不要重复改 skill，也不要为了满足提交授权制造改动。
- `md\12-communication-lessons-and-knowledge.md` 已有 7 条正式 lesson，本轮只优化现有 003、006、007 条，不新增正式条目。
- 相关规则只适合沉淀为通用同步、对话提炼和 Git 热修流程，不生成项目专用 skill。

## 处理内容

- 优化 `md\12-communication-lessons-and-knowledge.md`：删除 003 与 006 的重复 no-drift 表述，把安装、复制、哈希一致和不制造提交集中到 006、007。
- 更新 3 个通用 skill：`skill-sync-from-md`、`communication-lessons-extractor`、`git-hotfix-deploy`。
- 同步更新仓库 `SKILL` 与本机已安装 skill 中对应 3 个目录。

## 验证

- `md\12-communication-lessons-and-knowledge.md` 正式 lesson 数为 7，未超过 30。
- 3 个已改 skill 的 frontmatter 手工校验通过，仓库 `SKILL` 保持 13 个有效目录。
- 仓库 `SKILL` 与本机已安装 13 个通用 skill 相对文件集合和 SHA256 一致。
- 模板占位、固定项目路径、项目名和单业务功能词扫描无命中。
- `git diff --check` 无错误，仅有 Windows LF/CRLF 提示。
- 本机未安装 Python，`quick_validate.py` 无法运行，已用等价 frontmatter 校验补充。

## 风险

- 本轮没有新增项目专用 skill；仍需提交前核对分支、远端和工作区状态。
