# AI 工作流知识源分层与可迁移化改造报告

## 10.1 本次修改总览

### 任务目标

本次任务目标是治理 AI 工作流知识源分层，解决：

- 知识源重复。
- 规则来源冲突。
- Hermes、Codex skill、正式 md、communications、runtime skills 边界不清。
- 后期迁移到新电脑困难。
- C 盘空间不足导致运行数据不能继续长期写入 C 盘。

### 实际执行阶段

- 阶段 1：只读审计，已完成。
- 阶段 2：执行计划，已输出并获得用户确认。
- 阶段 3：文件创建和修改，已完成。
- 阶段 4：自检和验收，已运行健康检查并记录结果。

### 是否修改文件

已修改/创建文件，均位于 D 盘；未修改公司业务代码。

### 跳过项

- 未删除旧文件。
- 未移动大目录。
- 未重装 Hermes。
- 未复制 `C:\Users\zuoti\.codex\sessions`。
- 未同步 skills 到 C 盘 runtime；仅创建同步脚本。
- 未处理 `_ai/13-lqtedu-page-navigation-map.md` 与正式 md 同名文件漂移，需人工确认。

### 风险摘要

- C 盘剩余空间低：复查时约 1.52 GiB，健康检查标记 WARN。
- 仓库 `.codex\skills` 仍存在，与用户 runtime skills 构成双运行层风险，健康检查标记 WARN。
- `repo` 原有 `CLAUDE.md` 修改仍存在，本次未触碰。

## 10.2 所有修改文件清单

| 文件路径 | 新建/修改/未改 | 修改目的 | 是否正式知识源 | 是否 generated artifact | 是否可迁移 | 是否影响 C 盘 |
| --- | --- | --- | --- | --- | --- | --- |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-knowledge-source-policy.md` | 新建 | 明确 md 唯一主权、冲突优先级、晋升链路 | 是 | 否 | 是 | 否 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-agent-entry-index.md` | 新建 | Codex 开工入口索引，避免全量读取 | 是 | 否 | 是 | 否 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-migration-and-restore-guide.md` | 新建 | 新电脑迁移恢复指南 | 是 | 否 | 是 | 否 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-runtime-sync-policy.md` | 新建 | md → SKILL → runtime skills 同步边界 | 是 | 否 | 是 | 否 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-ai-workflow-runbook.md` | 新建 | Codex/Hermes/skill/communications 运行手册 | 是 | 否 | 是 | 否 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-folder-purpose-map.md` | 新建 | 文件夹职责地图 | 是 | 否 | 是 | 否 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\runtime\machine-profile.example.json` | 新建 | 非敏感机器配置模板 | 否 | 否 | 是 | 否 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\runtime\machine-profile.local.json` | 新建 | 本机实际路径记录，private/local only | 否 | 否 | 视情况 | 否 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\.gitignore` | 新建 | 忽略 private local 配置 | 否 | 否 | 是 | 否 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\scripts\check-ai-workflow-health.ps1` | 新建 | 只读健康检查 | 否 | 否 | 是 | 否 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\scripts\sync-skills-to-codex.ps1` | 新建 | dry-run 优先同步 SKILL 到 Codex runtime | 否 | 否 | 是 | 仅用户以后 `-Apply` 时写 runtime skills |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\scripts\restore-on-new-machine.ps1` | 新建 | 新机器恢复辅助 | 否 | 否 | 是 | 以后运行时可能创建少量 runtime 目录 |
| `D:\software\AI-Workspace\lqtedu-web-ai\AGENTS.md` | 新建 | 工作区级 Codex 入口规则 | 否 | 否 | 是 | 否 |
| `D:\software\AI-Workspace\lqtedu-web-ai\repo\AGENTS.md` | 新建 | repo 本地 Codex 规则 | 否 | 否 | 是，本地规则 | 否 |
| `D:\software\AI-Workspace\lqtedu-web-ai\repo\.git\info\exclude` | 修改 | 加入 `AGENTS.md`，避免提交公司仓库 | 否 | 否 | 本机 Git 配置 | 否 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\communications\2026-06-09-ai-workflow-knowledge-refactor-report.md` | 新建 | 本次最终执行报告 | 否 | 否 | 是 | 否 |

## 10.3 当前文件夹职责说明

| 文件夹 | 当前职责 |
| --- | --- |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\md` | 唯一正式长期知识源，承载“以后应该怎么做” |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\communications` | 事实流水、执行记录、确认和验证结论，不承载长期规则 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL` | 从 md 生成的 skill 产物，可同步到 runtime，不是主知识源 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\scripts` | 健康检查、skill 同步、新机器恢复脚本 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\runtime` | 机器配置模板和本机非敏感路径配置 |
| `D:\software\AI-Workspace\lqtedu-web-ai` | Obsidian Vault / AI 指挥台 |
| `D:\software\AI-Workspace\lqtedu-web-ai\_ai` | 工作区 AI 辅助资料，不是正式规则源 |
| `D:\software\AI-Workspace\lqtedu-web-ai\_ai\hermes` | Hermes 复盘、候选规则、交接模板、风险发现 |
| `D:\software\AI-Workspace\lqtedu-web-ai\repo` | 公司代码仓库，业务代码只在用户确认计划后修改 |
| `C:\Users\zuoti\.codex\skills` | Codex runtime skills 安装层，可由 SKILL 重建 |
| `C:\Users\zuoti\.codex\sessions` | Codex 会话日志，只读摘要，不复制到 D 盘 |
| `C:\Users\zuoti\.codex\log` | Codex 运行日志，不作为迁移资产 |
| `C:\Users\zuoti\.hermes` | Hermes 用户配置入口，当前是 Junction 到 D 盘 |
| `C:\Users\zuoti\AppData\Local\hermes` | Hermes 本地数据入口，当前是 Junction 到 D 盘 |

## 10.4 以后 Codex 干活的确切运行流程

1. 用户给 Codex 下任务，说明目标、限制和是否允许修改 repo。
2. Codex 先读工作区 `AGENTS.md`。
3. Codex 读取 `D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-knowledge-source-policy.md`。
4. Codex 读取 `D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-agent-entry-index.md`。
5. Codex 按任务类型只读取必要 md，不全量读取 md。
6. Codex 根据任务类型判断是否使用 skill。
7. 如果使用 skill，skill 只作为流程辅助；skill 和 md 冲突时，以 md 为准。
8. Codex 搜索 repo 相关代码、配置、调用链、测试或页面证据。
9. Codex 输出计划，说明准备改哪些文件、为什么、怎么验证、风险是什么。
10. 用户确认后，Codex 修改 repo。
11. Codex 完成后输出修改、依据、验证、风险。
12. Hermes 读取 Codex session 摘要或 communications 复盘。
13. Hermes 将长期价值提取为候选规则。
14. 用户确认候选规则是否晋升 md。
15. md 更新后重新生成 SKILL。
16. SKILL 经确认后同步到 `C:\Users\zuoti\.codex\skills`。

## 10.5 以后 Hermes 的运行流程

Hermes 读取：

- Codex session 摘要。
- communications 中的执行事实。
- `_ai/hermes` 中已有复盘和候选规则。
- 必要时只读正式 md 用于对齐边界。

Hermes 不读取：

- 不默认读取完整 Codex sessions。
- 不复制完整日志原文。
- 不把 runtime skills 当正式规则。

Hermes 写入：

- `_ai/hermes/reviewed`：复盘结果。
- `_ai/hermes/candidates`：候选规则。
- `_ai/hermes` 下的交接模板和风险发现。

Hermes 不允许修改：

- repo 业务代码。
- Codex session 原始日志。
- `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL`。
- `C:\Users\zuoti\.codex\skills`。
- 正式 md，除非由用户明确要求并经 Codex/用户写入。

敏感内容规则：

- 如日志中出现 token、cookie、密钥、账号、公司敏感内容，只写“检测到敏感内容”，不摘录原文。

候选晋升链路：

```txt
Codex session / communications
↓
Hermes 复盘
↓
_ai/hermes/candidates
↓
人工确认
↓
写入 Amadeus md
↓
重新生成 SKILL
↓
同步到 C:\Users\zuoti\.codex\skills
```

## 10.6 以后迁移到新电脑的步骤

1. 复制 `D:\software\Amadeus-AI-SKILL-QA-FILE`。
2. 复制 `D:\software\AI-Workspace\lqtedu-web-ai`。
3. 视需要复制 `D:\software\AI-Workspace\hermes-data`。
4. 不复制 `C:\Users\zuoti\.codex\sessions`，只保留必要摘要。
5. 不复制 `C:\Users\zuoti\.codex\log`。
6. 不把 `C:\Users\zuoti\.codex\skills` 当主资产，后续从 SKILL 同步恢复。
7. 安装 Obsidian，打开 `D:\software\AI-Workspace\lqtedu-web-ai`。
8. 设置 `OBSIDIAN_VAULT_PATH=D:\software\AI-Workspace\lqtedu-web-ai`。
9. 安装 Codex / Codex Desktop，并手动登录。
10. 安装 Hermes，手动配置 DS V4 API，不把 API Key 写入文件。
11. 按新机器 D 盘目标重建 Hermes Junction，不把 Hermes 迁回 C 盘。
12. 从远端重新 clone 公司 repo 到 `D:\software\AI-Workspace\lqtedu-web-ai\repo`。
13. 运行 `D:\software\Amadeus-AI-SKILL-QA-FILE\scripts\sync-skills-to-codex.ps1` 先 dry-run，再确认 `-Apply`。
14. 运行 `D:\software\Amadeus-AI-SKILL-QA-FILE\scripts\check-ai-workflow-health.ps1`。

## 10.7 验收结果

### 9.1 知识源边界验收

| 指标 | 结果 | 说明 |
| --- | --- | --- |
| md 被明确标记为唯一正式长期知识源 | 通过 | 已写入 00-knowledge-source-policy、AGENTS |
| communications 被标记为历史事实记录 | 通过 | 已写入治理文档和运行手册 |
| SKILL 被标记为 generated artifact | 通过 | 已写入 runtime sync policy |
| runtime skills 被标记为运行安装层 | 通过 | 已写入治理文档和目录地图 |
| `_ai/hermes` 被标记为复盘/候选区 | 通过 | 已写入治理文档和 AGENTS |
| 冲突时以 md 为准 | 通过 | 已写入冲突优先级 |
| Hermes 候选规则不能直接成为正式规则 | 通过 | 已写入晋升链路 |
| Skill 不能覆盖 md | 通过 | 已写入 runtime sync policy |
| communications 不能覆盖 md | 通过 | 已写入治理文档 |

### 9.2 迁移验收

| 指标 | 结果 | 说明 |
| --- | --- | --- |
| 有迁移恢复指南 | 通过 | 已创建 00-migration-and-restore-guide.md |
| 有必须迁移的 D 盘目录清单 | 通过 | 已写入迁移指南 |
| 有不建议迁移的 C 盘目录清单 | 通过 | 已写入迁移指南 |
| 有新电脑恢复步骤 | 通过 | 已写入迁移指南和 restore 脚本 |
| 有 OBSIDIAN_VAULT_PATH 设置说明 | 通过 | 已写入迁移指南和 restore 脚本 |
| 有 Codex runtime skills 重新同步说明 | 通过 | 已写入 runtime sync policy 和 sync 脚本 |
| 有 Hermes Junction / D 盘映射注意事项 | 通过 | 已写入迁移指南 |
| 不依赖 C 盘缓存作为唯一知识源 | 通过 | md 主源在 D 盘 |

### 9.3 C 盘安全验收

| 指标 | 结果 | 说明 |
| --- | --- | --- |
| 没有把大量新文件写入 C 盘 | 通过 | 本次写入均在 D 盘 |
| 没有复制 Codex sessions 到 D 盘 | 通过 | 只读取大小和存在性 |
| 没有破坏 Hermes Junction | 通过 | Junction 仍指向 D 盘 |
| 没有重装 Hermes 到 C 盘 | 通过 | 未重装 |
| 报告写明 C 盘剩余空间 | 通过 | 复查约 1.52 GiB |
| 报告写明 Hermes 是否为 Junction | 通过 | 两个 Hermes 路径均为 Junction |

### 9.4 Codex 运行流程验收

| 指标 | 结果 | 说明 |
| --- | --- | --- |
| 有明确 Codex 普通任务流程 | 通过 | 已写入 runbook 和 AGENTS |
| 有明确 Codex 开工前读取路径 | 通过 | 已写入 agent entry index |
| 有明确用户确认节点 | 通过 | 已写入 runbook |
| 有明确 Codex 和 Hermes 分工 | 通过 | 已写入治理文档和 runbook |
| 有明确 Skill 和 md 关系 | 通过 | 已写入 runtime sync policy |
| 有明确 Hermes 复盘晋升 md 流程 | 通过 | 已写入治理文档和 runbook |

### 9.5 文件产物验收

| 文件 | 结果 |
| --- | --- |
| `md\00-knowledge-source-policy.md` | 通过 |
| `md\00-agent-entry-index.md` | 通过 |
| `md\00-migration-and-restore-guide.md` | 通过 |
| `md\00-runtime-sync-policy.md` | 通过 |
| `md\00-ai-workflow-runbook.md` | 通过 |
| `md\00-folder-purpose-map.md` | 通过 |
| `runtime\machine-profile.example.json` | 通过 |
| `scripts\check-ai-workflow-health.ps1` | 通过 |
| `scripts\sync-skills-to-codex.ps1` | 通过 |
| `scripts\restore-on-new-machine.ps1` | 通过 |
| `runtime\machine-profile.local.json` | 通过，额外创建并加入忽略 |
| `.gitignore` | 通过，额外创建用于忽略 local 配置 |

### 9.6 Git / repo 安全验收

| 指标 | 结果 | 说明 |
| --- | --- | --- |
| 不修改 repo 业务代码 | 通过 | 只新增 repo 本地 AGENTS.md 并改本地 exclude |
| repo\AGENTS.md 不被 Git 追踪 | 通过 | 已加入 `repo\.git\info\exclude`，status 对 AGENTS.md 为空 |
| 检查 repo git status | 通过 | 仍显示 `M CLAUDE.md`，为本次前已有状态 |
| 报告写明 repo 是否干净 | 通过 | repo 不干净，原因是 `CLAUDE.md` 已修改 |
| 不创建/修改仓库 `.codex\skills` | 通过 | 未修改该目录 |

## 10.8 风险和后续建议

### 当前仍有的冲突风险

1. `_ai/13-lqtedu-page-navigation-map.md` 与正式 md 同名文件漂移，需要人工确认哪一份为准。
2. 仓库 `.codex\skills` 仍存在，健康检查会提示双运行层风险。
3. C 盘剩余空间低，Codex sessions 已约 488MB，后续只能只读摘要，不能复制归档。
4. `repo` 原有 `CLAUDE.md` 修改未处理，需要用户确认是否保留、提交或回退；本次未动。

### 需要人工确认的文件

- `_ai/13-lqtedu-page-navigation-map.md`
- `D:\software\Amadeus-AI-SKILL-QA-FILE\md\13-lqtedu-page-navigation-map.md`
- `D:\software\AI-Workspace\lqtedu-web-ai\repo\CLAUDE.md`

### 需要备份的目录

- `D:\software\Amadeus-AI-SKILL-QA-FILE`
- `D:\software\AI-Workspace\lqtedu-web-ai`
- `D:\software\AI-Workspace\hermes-data`

### 尚未做的自动化

- md 到 SKILL 的自动生成器尚未实现，本次只明确策略和同步到 runtime 的脚本。
- Hermes 复盘目录下 `reviewed` / `candidates` 子目录尚未创建；如需要可后续创建。
- 未实现对 skill 的 source md/hash 自动标注；已在策略文档中规定。

### 不建议 AI 自动执行的操作

- 删除或移动历史知识源。
- 覆盖 `_ai` 与正式 md 的漂移文件。
- 清理 C 盘 sessions。
- 修改 Hermes Junction。
- Git commit / push / reset。
- 处理 API Key、token、cookie、Git 凭证。

## 10.9 收尾额外发现

最终 Git 状态检查时发现一个未计划目录：

```txt
D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL\ai-workflow-migration-restore\SKILL.md
```

只读检查结果：

- 创建时间：2026-06-09 16:45:17。
- 内容为 skill 模板占位，包含 TODO。
- 该目录不在本次执行计划内。
- 该目录位于 SKILL 生成产物层，不应作为正式知识源。
- 本次未删除它，因为删除文件/目录属于高风险操作，需要用户明确确认。

建议后续处理：

1. 如果这是误生成占位目录，用户确认后删除。
2. 如果确实需要该 skill，必须先把对应正式规则写入 md，再按 md → SKILL 流程重新生成，不应保留 TODO 模板作为有效 skill。
