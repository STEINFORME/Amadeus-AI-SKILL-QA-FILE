# Codex Agent 入口索引

## 结论

Codex 开工前应先读本文件，再按任务类型只读取必要 md。不要一次性读取整个 md，不要默认读取 communications、SKILL、runtime skills 或 `_ai/hermes`。

Skill 只作为流程辅助；当 Skill 和 md 冲突时，以 md 为准。

## 启动读取顺序

1. 当前用户任务和本轮明确限制。
2. `D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-knowledge-source-policy.md`。
3. 本文件。
4. 按任务类型读取下表中的必要 md。
5. 如果任务触发 skill，只把 skill 当执行流程辅助。
6. 回到仓库代码、配置、报错、页面或测试证据定位事实。

## 任务路由

| 任务类型 | 优先读取 md | 说明 |
| --- | --- | --- |
| 知识源、路径、写入边界、迁移、冲突治理 | `00-knowledge-source-policy.md`、`00-folder-purpose-map.md`、`00-runtime-sync-policy.md` | 明确主源和同步边界 |
| Codex 普通前端开发 | `02-rp-page-development-rules.md`、`03-rp-page-common-router.md`、必要时 `13-lqtedu-page-navigation-map.md` | 只读相关页面和模块 |
| 前端变更验证 | `04-rp-page-testing-rules.md` | 确认验证口径和输出要求 |
| UI / 样式 / 组件参考 | `05-base-ebase-component-map.md`、`10-frontend-cs-lessons.md` | 复用旧项目样式和组件 |
| 仓库功能地图 / 模块归属 | `06-project-function-map.md` | 判断业务域、技术栈和边界 |
| 数字中枢 | `07-digitalhub-structure-notes.md` | 仅相关任务读取 |
| 班主任手册接口 | `08-class-teacher-handbook-interfaces.md` | 仅相关任务读取 |
| 热修 / 部署 / Git 流程 | `09-hotfix-deploy-rules.md` | 高风险操作需确认 |
| QA 资产 / 截图证据 | `11-qa-assets-inventory.md` | 查找视觉证据和附件 |
| 对话教训提炼 | `12-communication-lessons-and-knowledge.md` | 从 communications 提炼后再晋升 |
| Skill 同步 | `98-daily-skill-sync-rule.md`、`00-runtime-sync-policy.md` | md → SKILL → runtime skills |
| AI 对话记录 | `99-ai-communications-recording-rule.md` | 记录事实，不写长期规则 |
| 迁移恢复 | `00-migration-and-restore-guide.md`、`00-folder-purpose-map.md` | 新机器恢复和健康检查 |

## 禁止默认读取

- 不默认读取整个 `D:\software\Amadeus-AI-SKILL-QA-FILE\md`。
- 不默认读取 `communications`。
- 不默认读取 `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL`。
- 不默认读取 `C:\Users\zuoti\.codex\sessions`。
- 不默认读取 `_ai/hermes`。

只有在任务明确涉及复盘、同步、迁移、日志摘要或指定文件时，才读取对应目录。

## Codex 普通任务最小流程

1. 明确用户目标和安全限制。
2. 读取本入口和对应 md。
3. 搜索并读取 repo 相关代码。
4. 找调用链和影响范围。
5. 输出计划，等待用户确认。
6. 确认后修改 repo。
7. 做针对性验证。
8. 输出修改、验证、风险。
9. 如有长期价值，由 Hermes 或用户发起候选规则沉淀，确认后写 md。
