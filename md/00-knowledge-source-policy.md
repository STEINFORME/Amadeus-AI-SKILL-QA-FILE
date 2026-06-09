# AI 工作流知识源治理规则

## 结论

`D:\software\Amadeus-AI-SKILL-QA-FILE\md` 是唯一正式长期知识源。只有这里承载“以后应该怎么做”。

其他目录只承担记录、生成、运行、复盘或候选职责，不能抢占 md 的主权。

## 分层职责

| 层级 | 路径 | 职责 | 是否正式规则源 |
| --- | --- | --- | --- |
| 正式长期知识源 | `D:\software\Amadeus-AI-SKILL-QA-FILE\md` | 长期规则、接口契约、测试规则、路径规则、AI 工作流治理 | 是 |
| 执行记录 | `D:\software\Amadeus-AI-SKILL-QA-FILE\communications` | 记录发生过什么、执行摘要、确认和验证事实 | 否 |
| Skill 生成输出 | `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL` | 从 md 生成的 skill 产物 | 否 |
| Codex runtime skills | `C:\Users\zuoti\.codex\skills` | Codex 实际运行安装层，可重建 | 否 |
| Hermes 复盘区 | `D:\software\AI-Workspace\lqtedu-web-ai\_ai\hermes` | 复盘、候选规则、交接模板、风险发现 | 否 |
| Obsidian 工作区 | `D:\software\AI-Workspace\lqtedu-web-ai` | AI 指挥台、Vault、任务协调 | 否 |
| 公司代码仓库 | `D:\software\AI-Workspace\lqtedu-web-ai\repo` | 业务代码分析和修改位置 | 否 |

## 冲突优先级

当多个来源冲突时，按以下顺序处理：

1. 当前用户本轮明确指令。
2. 安全边界：不乱改 repo、不泄露敏感信息、不执行危险命令、不占满 C 盘、修改前等待确认。
3. `D:\software\Amadeus-AI-SKILL-QA-FILE\md`。
4. 当前任务触发的 Skill。
5. `communications` 中的历史事实。
6. `_ai/hermes` 中的候选复盘。
7. Codex 默认习惯。

特殊规则：

- 用户指令和正式 md 冲突时，先询问用户。
- Skill 和 md 冲突时，以 md 为准。
- Hermes 候选规则和 md 冲突时，以 md 为准。
- communications 只证明“发生过什么”，不能覆盖 md。

## C 盘边界

C 盘用户目录只允许作为运行层、登录态、少量配置、runtime 入口存在，不允许作为长期知识源。

禁止：

- 把完整 md、communications、日志归档、skill 生成产物长期放到 C 盘。
- 复制 `C:\Users\zuoti\.codex\sessions` 到 D 盘；只允许读取和摘要。
- 破坏 `C:\Users\zuoti\.hermes` 与 `C:\Users\zuoti\AppData\Local\hermes` 的 Junction。
- 将 Hermes 迁回 C 盘。
- 在 C 盘创建预计超过 100MB 的新文件；如必须执行，先询问用户。

## 候选规则晋升流程

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

## 写入边界

- 长期规则只写 md。
- 事实流水只写 communications。
- Hermes 只写 `_ai/hermes`。
- SKILL 只作为生成产物，不能手工长期维护。
- runtime skills 只作为安装层，不能反向覆盖 SKILL 或 md。
- repo 业务代码只在用户确认编码计划后修改。

## 已知当前风险

- `_ai` 下存在 md 镜像，容易被误当正式规则源。
- `_ai/13-lqtedu-page-navigation-map.md` 与正式 md 的同名文件已出现漂移，需要单独人工确认。
- 仓库 `.codex/skills` 与用户级 runtime skills 同时存在，后续应避免长期维护两套版本。
