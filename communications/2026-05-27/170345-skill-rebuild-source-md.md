# 会话记录：按源 md 重建通用 skill

## 时间

2026-05-27 17:03

## 用户请求

用户中断前一轮后要求重新开始，并补充：除了开发和热修 skill，每次对话写入文档也要变成 skill；准确口径是源头 md 中每一条原则上都应该对应一个 skill，但要去除为单独功能开发的 skill，例如班主任手册。

## AI 判断

- `99-ai-communications-recording-rule.md` 必须对应一个通用 `ai-communication-recorder` skill。
- `00/01/02/03/04/05/06/09/10/11/12/98/99` 具备跨任务复用价值，应生成通用 skill。
- `07-digitalhub-structure-notes.md` 和 `08-class-teacher-handbook-interfaces.md` 只描述单业务功能链路或私有接口，不生成通用 skill。
- `06-project-function-map.md` 虽来自具体项目，但可抽象成“仓库功能地图和技术栈审计”通用 skill。

## 处理内容

- 重建 `SKILL` 目录下通用 skill 输出，共 13 个：
  - `ai-qa-index-router`
  - `ai-knowledge-source-rules`
  - `repo-frontend-dev-workflow`
  - `task-rule-router`
  - `frontend-change-validation`
  - `ui-component-reference-map`
  - `repo-function-map-audit`
  - `git-hotfix-deploy`
  - `frontend-style-fix-rules`
  - `qa-assets-inventory`
  - `communication-lessons-extractor`
  - `skill-sync-from-md`
  - `ai-communication-recorder`
- 更新 `md\98-daily-skill-sync-rule.md`，写入源 md 到通用 skill 的映射表和排除表。
- 更新 `md\12-communication-lessons-and-knowledge.md`，新增源 md 对应通用 skill 的自动化规则。
- 标记上一条 `164025-skill-generalization.md` 为中断前尝试，避免后续误读为最终结果。

## 验证

- `quick_validate.py` 未通过环境启动，原因是当前 Python 环境缺少 `yaml` 包。
- 已执行 frontmatter 静态校验：13 个 `SKILL.md` 的 `name` 均与目录名一致，且存在 `description`。
- 已检查 13 个 skill 目录均包含 `SKILL.md` 和 `agents/openai.yaml`。
- 已搜索模板占位残留：未发现 `TODO`、`[TODO]`、`Structuring This Skill` 等模板词。
- 已搜索通用 skill 中的单业务功能词和固定私有路径：未发现 `班主任`、`数字中枢`、`DataHub`、`/wbSheet`、固定项目仓库路径等。
- 已检查映射：13 个通用源 md 已对应 13 个 skill；`07`、`08` 已列入排除表。

## 风险

- C 盘空间为 0，不能安装到本机 Codex skills 目录；本次只维护目标仓库 `SKILL` 输出。
- 通用 skill 不承载具体项目接口和业务字段，具体任务仍必须读取目标仓库文档和源码。
