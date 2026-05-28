# 每日自动化更新 skill 规则

## 目标

后续自动化每天固定时间读取 LQTedu 的简版入口和本目录完整知识源，更新对应 skill，并把更新后的 skill 复制到：

`D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL`

## 知识源顺序

1. 原仓库简版入口：`D:\software\lqtedu\lqtedu\qa`
2. 完整知识源：`D:\software\Amadeus-AI-SKILL-QA-FILE\md`
3. 当前已安装 skill：通常位于 `C:\Users\zuoti\.codex\skills`
4. 同步输出目录：`D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL`

原仓库 `qa` 是触发和快速索引，不是完整事实源；自动化必须读取 Amadeus `md` 才能更新完整 skill。

## 自动化步骤

1. 读取原仓库 `qa` 简版文件，确认任务入口和目标 skill。
2. 读取 `D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-index.md`。
3. 按索引读取相关主题文件。
4. 读取当前已安装 skill 的 `SKILL.md` 和 references。
5. 对比 md 规则与 skill 内容，只更新实际漂移的部分。
6. 保持 skill 为流程执行器，保持 md 为知识库和判断规则。
7. 若任务要求安装或替换当前 Codex skill，先确认磁盘空间和目标目录，再只处理包含 `SKILL.md` 的有效 skill 目录。
8. 更新后复制完整 skill 目录到 `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL`，无效空目录不作为同步结果保留。
9. 把本次自动化对话和执行摘要写入 `communications`，提交、推送或未执行项必须按真实结果记录。
10. 若任务已明确授权提交或推送，执行前核对当前分支、远端目标和工作区状态；执行后记录提交哈希和推送结果。

## 同步边界

- 不要把整个 md 目录原封不动塞进一个 `SKILL.md`。
- 不要把完整人员安排流程重复写入 md；完整编排留在对应 skill。
- 不要因为提到热修就改某个项目专用 hotfix skill；先比对是否实际漂移。
- 不要因为一个规则变化就重写所有 skill 文件。
- 不要删除、推送、提交或覆盖 skill，除非自动化任务明确包含并且已经得到确认。
- 明确授权提交或推送时，不再重复提问，但必须先做分支和远端核对。
- 生成通用 skill 时必须去项目化：不写具体项目名、固定项目仓库路径、业务模块名或私有接口；只沉淀跨仓库可复用的流程、门禁、验证和风险控制。
- 如果 `communications` 标明某次同步是中断前尝试，后续提炼和 skill 同步必须以最终记录为准，并清理由旧尝试产生的冗余条目。

## 源 md 到通用 skill 映射

除单业务功能文档外，源头 md 原则上一条对应一个通用 skill：

| 源 md | 通用 skill | 说明 |
| --- | --- | --- |
| `00-index.md` | `ai-qa-index-router` | 知识库索引和任务路由 |
| `01-path-and-source-rules.md` | `ai-knowledge-source-rules` | 知识源、路径语义和写入边界 |
| `02-rp-page-development-rules.md` | `repo-frontend-dev-workflow` | 前端页面和模块开发工作流 |
| `03-rp-page-common-router.md` | `task-rule-router` | 任务规则快速路由 |
| `04-rp-page-testing-rules.md` | `frontend-change-validation` | 前端变更验证和结论门禁 |
| `05-base-ebase-component-map.md` | `ui-component-reference-map` | UI 组件、样式参照和设计系统映射 |
| `06-project-function-map.md` | `repo-function-map-audit` | 仓库功能地图和技术栈审计 |
| `09-hotfix-deploy-rules.md` | `git-hotfix-deploy` | Git 热修分支和部署包流程 |
| `10-frontend-cs-lessons.md` | `frontend-style-fix-rules` | 样式修复、参考页复用和 mock 适配层 |
| `11-qa-assets-inventory.md` | `qa-assets-inventory` | QA 资产清单和视觉证据索引 |
| `12-communication-lessons-and-knowledge.md` | `communication-lessons-extractor` | 对话教训提炼 |
| `98-daily-skill-sync-rule.md` | `skill-sync-from-md` | 从 md 知识源同步 skill |
| `99-ai-communications-recording-rule.md` | `ai-communication-recorder` | AI 对话和执行记录写入文档 |

这些 skill 只能作为通用执行流程；具体项目路径、接口、业务字段和发布细节仍从目标仓库文档和源码读取。

不生成通用 skill 的单业务功能文档：

| 源 md | 原因 |
| --- | --- |
| `07-digitalhub-structure-notes.md` | 单业务功能链路，只作为项目知识保留 |
| `08-class-teacher-handbook-interfaces.md` | 单业务接口契约，只作为项目知识保留 |

## 输出要求

每次同步至少输出：

- 读取了哪些简版入口。
- 读取了哪些 Amadeus md 文件。
- 哪些 skill 文件发生变化。
- 是否复制到 `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL`。
- 验证方式和结果。
- 未验证项和风险。

## 验证

- 检查 skill 中是否包含新增规则。
- 检查 skill 中是否没有重复维护完整 md 原文。
- 检查 `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL` 中是否存在同步结果。
- 检查每个同步结果都是包含 `SKILL.md` 的有效 skill 目录。
- 如同步到当前 Codex skills 目录，比较源目录和目标目录的相对文件集合与内容哈希。
- 检查 `communications` 是否记录本次同步。
- 检查路径语义是否仍指向 Amadeus `md`。
