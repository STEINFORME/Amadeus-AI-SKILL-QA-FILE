# Amadeus AI Skill QA 知识库索引

## 定位

本目录是 LQTedu 项目 AI 开发规则、测试规则、项目认知、接口沉淀和自动化 skill 同步的完整知识源。

主源目录：`D:\software\Amadeus-AI-SKILL-QA-FILE\md`

原仓库 `D:\software\lqtedu\lqtedu\qa` 后续只保留简版索引和自动化读取入口，不再作为长期完整知识沉淀目录。

## 读取顺序

1. `01-path-and-source-rules.md`
2. 按任务类型读取对应主题文件
3. 回到源码、接口、截图、RP 或真实页面验证关键事实
4. 修改或维护 skill 时再读取 `98-daily-skill-sync-rule.md`
5. 需要记录对话时读取 `99-ai-communications-recording-rule.md`
6. 需要从对话提炼可复用教训时读取 `12-communication-lessons-and-knowledge.md`

## 任务路由

| 任务类型 | 优先读取 | 目的 |
| --- | --- | --- |
| 路径、记录、知识源、skill 输出规则 | `01-path-and-source-rules.md` | 统一所有 AI 的写入位置和维护边界 |
| 写 RP 页面、改 UI、判断前端实现 | `02-rp-page-development-rules.md` | 判断页面归属、证据等级、技术栈、字段和安全边界 |
| 快速选择该读哪份规则 | `03-rp-page-common-router.md` | 作为简易入口和自动化索引 |
| 改完验收、写测试结论 | `04-rp-page-testing-rules.md` | 按入口、参数、显隐、交互、视觉输出结论 |
| 找 base / ebase 组件和样式 | `05-base-ebase-component-map.md` | 快速定位旧 JSP/Avalon 和 Vue3/Element Plus 参考 |
| 理解整体项目模块 | `06-project-function-map.md` | 判断业务域、技术栈、复用边界和风险 |
| 查页面入口、点击链路、直链/部门上下文要求 | `13-lqtedu-page-navigation-map.md` | 给 AI 判断每个 JSP/HTML 页面怎么到达、是否要先切部门、是否只能从列表或流程进入 |
| 数字中枢 | `07-digitalhub-structure-notes.md` | 查管理入口、静态大屏、接口链路和常见坑 |
| 班主任手册接口 | `08-class-teacher-handbook-interfaces.md` | 对齐 mock、真实 `/wbSheet/*` 接口和动态字段 mapper |
| 热修、deploy、Git 发布流程 | `09-hotfix-deploy-rules.md` | 控制热修分支、部署包和危险操作确认 |
| 前端 CS、Base 样式、mock 适配层 | `10-frontend-cs-lessons.md` | 处理确定性样式和可复用页面结构经验 |
| 图片、txt 等迁移资产 | `11-qa-assets-inventory.md` | 查原 QA 临时图片和文本资产用途 |
| 对话提炼教训和新知识 | `12-communication-lessons-and-knowledge.md` | 从 communications 中沉淀可复用条目 |
| 每日自动化同步 skill | `98-daily-skill-sync-rule.md` | 规范从 md 更新 skill 并复制到 SKILL 目录 |
| AI 对话记录 | `99-ai-communications-recording-rule.md` | 规范对话记录落到 communications |

## 原始来源

本目录由 `D:\software\lqtedu\lqtedu\qa` 的 10 个顶层 Markdown 和 `tmp` 资产总结而来。

完整原样备份位于：

`D:\software\Amadeus-AI-SKILL-QA-FILE\archive\lqtedu-qa-20260527-161512`

## 维护原则

- 新规则、新经验、新接口契约、新测试规则写入 `D:\software\Amadeus-AI-SKILL-QA-FILE\md`。
- 原仓库 `qa` 只放简版索引，不放完整细节。
- AI 对话记录写入 `D:\software\Amadeus-AI-SKILL-QA-FILE\communications`。
- 对话中提炼出的可复用教训和新知识，只追加到 `12-communication-lessons-and-knowledge.md`。
- 自动化生成或同步后的 skill 复制到 `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL`。
- 文档里的旧路径语义必须定期检查，避免重新出现“长期沉淀到原仓库简版目录”的说法。
