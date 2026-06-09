# AI 工作流运行手册

## 总原则

- md 是唯一正式长期知识源。
- communications 只记录发生过什么。
- SKILL 是从 md 生成的产物。
- runtime skills 是运行安装层。
- Hermes 是复盘和候选规则区。
- repo 是公司代码仓库，修改前必须有明确计划和用户确认。

## Codex 普通编码任务流程

1. 用户给 Codex 下任务，说明目标、限制和是否允许修改 repo。
2. Codex 读取工作区 AGENTS.md。
3. Codex 读取 `00-knowledge-source-policy.md` 和 `00-agent-entry-index.md`。
4. Codex 按任务类型只读取必要 md。
5. 如有匹配 skill，Codex 把 skill 当流程辅助，不把 skill 当主知识源。
6. Codex 搜索并读取 repo 相关代码、配置、调用链和测试。
7. Codex 输出计划，说明准备改哪些文件、怎么验证、风险是什么。
8. 用户确认后，Codex 修改 repo。
9. Codex 做针对性验证。
10. Codex 输出修改、依据、验证、风险。
11. Hermes 可读取 session 摘要或 communications 做复盘。
12. 有长期价值的候选规则经用户确认后写入 md。
13. md 变化后重新生成 SKILL 并同步 runtime skills。

## 用户需要确认的节点

- 修改 repo 前。
- 删除、移动、覆盖、commit、push、reset、生产访问等高风险操作前。
- 写入正式 md 前。
- Hermes 候选规则晋升正式规则前。
- 同步 runtime skills 前。
- 任何预计向 C 盘写入超过 100MB 的操作前。

## Hermes 复盘流程

```txt
Codex session / communications
↓
Hermes 只读分析
↓
写入 _ai/hermes/reviewed
↓
提取候选规则到 _ai/hermes/candidates
↓
等待用户确认
↓
由 Codex 或用户写入正式 md
```

Hermes 禁止：

- 修改 repo。
- 修改 Codex session 原始日志。
- 复制完整日志原文。
- 摘录 token、cookie、密钥、账号、公司敏感内容。
- 直接修改 SKILL 或 runtime skills。

## Skill 更新流程

```txt
正式 md
↓
生成 D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL
↓
同步到 C:\Users\zuoti\.codex\skills
↓
Codex runtime 使用
```

禁止：

- 从 runtime skills 反向覆盖 SKILL。
- 从 SKILL 反向覆盖 md。
- 手工长期维护 generated skill。

## communications 流程

communications 只记录：

- 用户请求。
- AI 判断。
- 执行内容。
- 验证结果。
- 风险和未完成项。

communications 中的经验若有长期价值，必须提炼并经确认后写入 md。

## 迁移恢复流程

1. 迁移 D 盘长期资产。
2. 重装 Codex、Hermes、Obsidian。
3. 重新登录账号和配置 API。
4. 设置 `OBSIDIAN_VAULT_PATH`。
5. 重建 Hermes Junction。
6. 重新 clone 公司 repo。
7. 同步 runtime skills。
8. 运行健康检查脚本。
