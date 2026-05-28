# 会话记录：skill 同步推送规则

## 时间

2026-05-28 16:33:20 +08:00

## 用户请求

根据 `communications` 优化 `md\12-communication-lessons-and-knowledge.md`，根据 `md` 更新多条通用开发 skill 和热修 skill，复制到仓库 `SKILL`，并直接提交 `main` 后推送。

## AI 判断

- `communications` 是原始事实源，`md\12-communication-lessons-and-knowledge.md` 是去重 lessons 入口。
- 本次新增规则只处理通用自动化边界：用户明确授权提交或推送时可执行，但执行前仍要核对分支、远端和工作区。
- 本次不新增项目专用 skill，只同步通用 `skill-sync-from-md`、`ai-communication-recorder`、`git-hotfix-deploy`。

## 处理内容

- 更新 `md\12-communication-lessons-and-knowledge.md`：新增 20260528-008，条目数为 8，未超过 30。
- 更新 `md\98-daily-skill-sync-rule.md`：补充已授权提交/推送时的核对和记录规则。
- 更新 `md\09-hotfix-deploy-rules.md`：补充已授权提交/推送的执行边界。
- 更新并复制 3 个通用 skill 到 `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL`：
  - `skill-sync-from-md`
  - `ai-communication-recorder`
  - `git-hotfix-deploy`

## 验证

- lessons 正式条目数：8。
- `SKILL` 下所有 skill 均包含 `SKILL.md`，frontmatter `name` 与目录名一致，且存在 `description`。
- `SKILL` 未命中 `TODO`、模板占位、固定项目路径、项目名或单业务功能词。
- 3 个已同步 skill 的源目录和仓库目标目录文件集合一致，SHA256 一致。
- `git diff --check` 未发现空白错误；仅有 Windows 行尾替换提示。
- 已核对当前仓库分支为 `main`，远端为 `origin https://github.com/STEINFORME/Amadeus-AI-SKILL-QA-FILE.git`。

## 风险

- 本记录写入时提交哈希尚未生成；提交和推送结果在本次最终回复与 automation memory 中确认。
- PowerShell profile 中缺失 `openclaw.ps1` 会在命令输出中产生噪声，但未影响本次 Git 和文件校验命令。
