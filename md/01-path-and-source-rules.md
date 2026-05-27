# 路径、知识源和写入规则

## 结论

LQTedu 的完整 AI QA 知识源统一迁移到：

`D:\software\Amadeus-AI-SKILL-QA-FILE\md`

原仓库：

`D:\software\lqtedu\lqtedu\qa`

后续只作为简版索引和自动化触发入口，不再承载完整长期知识。

## 目录职责

| 目录 | 职责 |
| --- | --- |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\md` | 完整规则、项目认知、接口契约、测试规则、路径规则 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\communications` | 所有 AI 对话和执行记录 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL` | 自动化更新、复制或归档后的 skill |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\archive` | 原始资料备份 |
| `D:\software\lqtedu\lqtedu\qa` | 简版索引、快速入口、自动化读取提示 |

## 路径语义替换

| 旧表达 | 新表达 |
| --- | --- |
| 旧式规则沉淀到原仓库目录 | 写入 `D:\software\Amadeus-AI-SKILL-QA-FILE\md` |
| 旧式对话或经验沉淀到原仓库目录 | 记录到 `D:\software\Amadeus-AI-SKILL-QA-FILE\md` |
| 旧式维护原仓库完整 QA 文档 | 更新 `D:\software\Amadeus-AI-SKILL-QA-FILE\md` 中对应主题文件 |
| 旧式把原仓库目录当完整事实源 | `D:\software\Amadeus-AI-SKILL-QA-FILE\md` 作为完整事实源 |
| qa 文件夹中的开发须知 | 原仓库 `qa` 简版入口 + Amadeus `md` 完整规则 |
| 自动化从 qa 生成 skill | 自动化以原仓库 `qa` 为触发入口，以 Amadeus `md` 为完整知识源生成 skill |

## AI 写入规则

- 需要沉淀规则、经验、接口契约、测试规则时，写入本目录对应主题文件。
- 需要新增一个跨主题规则时，先更新 `00-index.md` 和本文件。
- 需要保留每日对话和执行证据时，写入 `communications`，不混入规则文档。
- 需要更新 skill 时，先根据 `98-daily-skill-sync-rule.md` 读取本目录，再复制结果到 `SKILL`。
- 不要把完整规则重新写回原仓库 `qa`，避免旧源和新源双写漂移。

## 原仓库 qa 简版定位

原仓库 `qa` 的简版文件只做三件事：

1. 告诉 AI 完整规则在 `D:\software\Amadeus-AI-SKILL-QA-FILE\md`。
2. 给出最常用的任务路由和硬性禁区。
3. 作为每日自动化的触发入口或兼容老流程的读取入口。

原仓库 `qa` 不应再保存大段接口明细、截图资产清单、完整人员安排或长期规则原文。

## 检查口径

每次迁移、同步或自动化生成后，至少检查：

- `md` 中是否残留把长期知识沉淀回原仓库简版目录的旧方向表达。
- 原仓库 `qa` 是否只剩简版入口。
- `communications` 是否存在且可写。
- `SKILL` 是否存在且能接收同步结果。
- 自动化规则是否明确以 Amadeus `md` 为完整知识源。
