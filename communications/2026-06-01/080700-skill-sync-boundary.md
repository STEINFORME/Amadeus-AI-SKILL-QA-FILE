# 会话记录：skill 同步边界优化

## 时间

2026-06-01 08:06:56 +08:00

## 用户请求

根据 `communications` 优化 `md\12-communication-lessons-and-knowledge.md`，根据 `md` 更新多条通用开发 skill 和热修 skill，复制到仓库 `SKILL`，并直接提交 `main` 后推送。

## AI 判断

- 当前没有 2026-05-28 16:33 后的新原始记录；本次不伪造新 lesson，只压缩已有重复口径并同步对应通用 skill。
- 继续只维护通用 skill，不从单业务功能文档生成项目专用 skill。
- 提交和推送已被本次自动化明确授权，执行前仍核对分支、远端和工作区状态。

## 处理内容

- `md\12-communication-lessons-and-knowledge.md` 保持 30 条内，并补充“无新增事实时不伪造 lesson”的提炼边界。
- 更新并复制 6 个通用 skill 到 `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL`：
  - `communication-lessons-extractor`
  - `skill-sync-from-md`
  - `repo-frontend-dev-workflow`
  - `frontend-change-validation`
  - `frontend-style-fix-rules`
  - `git-hotfix-deploy`

## 验证

- lessons 正式条目数为 7，未超过 30。
- `SKILL` 下所有 skill 均包含 `SKILL.md`，frontmatter `name` 与目录名一致，且存在 `description`。
- 6 个已同步 skill 的本机源目录和仓库目标目录文件集合一致，SHA256 一致。
- `SKILL` 未命中 `TODO`、模板占位、固定项目路径、项目名或单业务功能词。
- `git diff --check` 未发现空白错误；仅有 Windows 行尾替换提示。

## 风险

- 本记录写入时提交哈希尚未生成；提交和推送结果在本次最终回复与 automation memory 中确认。
