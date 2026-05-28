# 会话记录：开发 skill 更新自动化

## 时间

2026-05-28 13:09:00 +08:00

## 用户请求

用户要求根据 `D:\software\Amadeus-AI-SKILL-QA-FILE\communications` 优化 `md\12-communication-lessons-and-knowledge.md`，保持最多 30 条并删除冗余条目；再根据 `md` 更新多条通用开发 skill 和热修 skill，不开发项目专用 skill；把修改后的 skill 整体复制到 `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL`，并直接提交到 `main`。

## AI 判断

- `communications\2026-05-27\164025-skill-generalization.md` 是中断前尝试，`communications\2026-05-27\170345-skill-rebuild-source-md.md` 才是源 md 重建通用 skill 的最终口径。
- `communications\2026-05-27\171010-install-skills-and-push.md` 新增了可复用规则：skill 安装或复制后必须只保留有效目录，并做文件集合与内容哈希校验。
- 本次只维护通用 skill：对话提炼、md 同步、对话记录、知识源边界、前端开发、前端验证、Git 热修部署；不生成单业务功能 skill。
- 用户已明确要求本仓库直接提交到 `main`，本次不再额外请求提交授权；未请求推送，本次不执行 `git push`。

## 处理内容

- 更新 `md\12-communication-lessons-and-knowledge.md`：合并旧 006/007 的同义规则，改为以最终记录为准和 skill 复制校验规则，条目数仍为 7。
- 更新 `md\98-daily-skill-sync-rule.md`：增加有效 skill 目录、安装/复制校验、中断记录取最终口径、提交/推送状态如实记录。
- 更新并同步 7 个通用 skill：
  - `communication-lessons-extractor`
  - `skill-sync-from-md`
  - `ai-communication-recorder`
  - `ai-knowledge-source-rules`
  - `repo-frontend-dev-workflow`
  - `frontend-change-validation`
  - `git-hotfix-deploy`
- 将上述 7 个本机 skill 目录复制/替换到 `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL` 对应目录。

## 验证

- 已检查 `12-communication-lessons-and-knowledge.md` 正式条目数为 7，未超过 30。
- 已静态校验 `SKILL` 下所有 skill 的 `SKILL.md`、`agents/openai.yaml`、frontmatter 起止、`name` 与目录名一致、`description` 存在。
- 已搜索 `SKILL`，未发现 `TODO`、`[TODO]`、`Structuring This Skill`、单业务功能词或固定项目路径残留。
- 已比较 7 个本机 skill 源目录与仓库 `SKILL` 目标目录的相对文件集合和 SHA256，结果一致。
- 已执行 `git diff --check`，无空白错误；仅出现 Git 在 Windows 下提示 LF 将被 CRLF 替换的换行符警告。
- `quick_validate.py` 未作为通过依据，原因是当前 Codex Python 环境缺少 `yaml` 包：`ModuleNotFoundError: No module named 'yaml'`。

## 风险

- 本次没有执行 `git push`，只按用户要求准备并提交本仓库 `main` 的本地提交。
- 换行符警告来自 Git/Windows 行尾设置，未发现内容校验失败。
