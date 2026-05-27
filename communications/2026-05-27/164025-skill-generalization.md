# 会话记录：根据 Amadeus md 生成通用 skill

> 本记录是中断前的第一次同步尝试，最终结果以 `communications\2026-05-27\170345-skill-rebuild-source-md.md` 为准。

## 时间

2026-05-27 16:40

## 用户请求

用户要求根据 `D:\software\Amadeus-AI-SKILL-QA-FILE\communications` 优化 `md\12-communication-lessons-and-knowledge.md`，该文件最多 30 条，每次修改要删除冗余条目；再根据 `md` 文件修改开发类 skill 和热修 skill，只开发通用 skill，不开发针对某个项目的 skill；最后把 `D:\software\Amadeus-AI-SKILL-QA-FILE` 的相关修改直接提交到 `main`。

## AI 判断

- `communications\2026-05-27\161500-qa-migration.md` 中已有的路径规则存在同义重复，应合并为知识源分层、对话提炼、skill 同步、危险操作和技术强制边界几类。
- 现有本机安装 skill 中存在具体项目名、固定项目路径和业务模块，不能直接作为本次通用 skill 输出。
- 通用 skill 应保留可跨仓库复用的流程：先读仓库事实、最小必要改动、前端状态与接口影响面、验证门禁、热修危险操作确认、deploy 包哈希校验。
- C 盘无剩余空间，无法把新 skill 安装到 `C:\Users\zuoti\.codex\skills`；本次只把通用 skill 输出到目标仓库 `SKILL` 目录。

## 处理内容

- 将 `12-communication-lessons-and-knowledge.md` 从 7 条优化为 6 条，补充最多 30 条和去冗余要求。
- 新增通用前端开发 skill：`SKILL\repo-frontend-dev-workflow`。
- 新增通用前端验证 skill：`SKILL\frontend-change-validation`。
- 新增通用 Git 热修部署 skill：`SKILL\git-hotfix-deploy`。
- 每个 skill 只保留通用流程，不写具体项目名、固定业务路径或私有接口。

## 验证

- `quick_validate.py` 未通过环境启动，原因是当前 Python 环境缺少 `yaml` 包。
- 已改用 PowerShell 静态检查 3 个 skill：frontmatter 起止、`name` 与目录名一致、存在 `description`。
- 已搜索 `SKILL` 输出，未发现具体项目名、固定项目仓库路径或业务模块词。
- 已搜索 `SKILL` 和 `12-communication-lessons-and-knowledge.md`，未发现模板占位残留。
- 已检查 `12-communication-lessons-and-knowledge.md` 的正式条目数为 6，未超过 30。

## 风险

- 因 C 盘空间为 0，通用 skill 未安装到本机 Codex skills 目录，只归档在目标仓库 `SKILL`。
- 本次生成的是通用流程 skill，不包含具体项目的接口、路径和业务模块细节；执行具体项目任务时仍需读取目标仓库自己的文档和源码。
