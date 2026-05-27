# AI 对话记录规则

## 强制记录位置

所有 AI 对话、执行摘要、自动化同步记录、重要验证结论，统一记录到：

`D:\software\Amadeus-AI-SKILL-QA-FILE\communications`

不要把对话记录混入规则知识库，也不要把长期对话摘要写回原仓库 `qa`。

## 建议目录结构

```text
D:\software\Amadeus-AI-SKILL-QA-FILE\communications\
  YYYY-MM-DD\
    HHmmss-session-summary.md
```

示例：

```text
D:\software\Amadeus-AI-SKILL-QA-FILE\communications\2026-05-27\161500-qa-migration.md
```

## 单条记录格式

每条记录建议包含：

```md
# 会话记录：标题

## 时间

YYYY-MM-DD HH:mm:ss

## 用户请求

简要摘录用户目标。

## AI 判断

核心结论、边界、危险操作和是否需要确认。

## 处理内容

- 修改或生成的文件
- 执行的命令
- 关键路径

## 验证

- 已验证内容
- 验证结果
- 未验证项

## 风险

- 剩余风险
- 后续需要用户确认的事项
```

## 记录范围

必须记录：

- 自动化更新 skill。
- QA / md 规则迁移。
- 清空、删除、覆盖、推送、提交等高风险操作的确认和结果。
- 影响长期开发规则的用户要求。
- 与接口契约、测试规则、路径规则有关的变更。

可不记录：

- 简单问答。
- 不涉及仓库或规则的临时解释。
- 无操作、无决策价值的短消息。

## 和 md 知识库的区别

- `communications` 保存“发生过什么”。
- `md` 保存“以后应该怎么做”。
- 一次对话产生了长期规则时，先写 `communications` 记录事实，再把可复用规则整理进 `md` 对应主题文件。
- 从对话中提炼出的教训和新知识，统一追加到 `12-communication-lessons-and-knowledge.md`，不要分散创建多份提炼文档。

## 对话提炼规则

- 原始会话记录仍写入 `D:\software\Amadeus-AI-SKILL-QA-FILE\communications`。
- 可复用教训、新知识、路径规则、自动化规则、风险提醒，追加到 `D:\software\Amadeus-AI-SKILL-QA-FILE\md\12-communication-lessons-and-knowledge.md`。
- 每条提炼保持独立编号，包含来源、类型、内容、适用场景。
- 不把流水账、临时情绪、无复用价值的过程写入提炼文件。

## 技术限制

单靠这份 md 规则不能从技术上强制所有 AI 自动写记录。要真正强制，需要把本规则接入 AGENTS.md、相关 skill、每日自动化或启动包装流程。
