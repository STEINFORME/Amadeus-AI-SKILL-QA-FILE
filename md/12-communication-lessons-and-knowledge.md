# 对话提炼教训和新知识

## 定位

本文件是 `D:\software\Amadeus-AI-SKILL-QA-FILE\communications` 中对话记录的唯一提炼入口，最多保留 30 条。

`communications` 保存原始会话和执行事实；本文件只保存可复用的教训、新规则、新知识和后续自动化应记住的判断。

## 记录格式

每次修改都先合并同义项、删除冗余项，再新增必要条目。每条记录使用独立编号，保持短句、可执行、可检索。

```md
### YYYYMMDD-NNN 标题

- 来源：`communications\YYYY-MM-DD\文件名.md`
- 类型：教训 / 新规则 / 路径规则 / 自动化规则 / 风险提醒
- 内容：一条可复用结论。
- 适用：触发场景或适用任务。
```

## 条目

### 20260527-001 知识源分层固定

- 来源：`communications\2026-05-27\161500-qa-migration.md`
- 类型：路径规则
- 内容：原仓库 `qa` 只保留简版索引和自动化触发入口，完整长期知识写入 `D:\software\Amadeus-AI-SKILL-QA-FILE\md`，AI 对话和执行事实写入 `communications`，同步后的 skill 写入 `SKILL`。
- 适用：读取 QA、更新规则、记录对话、同步 skill。

### 20260527-002 对话提炼只写一个入口

- 来源：`communications\2026-05-27\161500-qa-migration.md`
- 类型：新规则
- 内容：从 `communications` 中提炼出的可复用教训和新知识只维护在本文件；本文件最多 30 条，每次修改必须压缩同义项和删除冗余条目。
- 适用：复盘会话、每日自动化抽取教训、整理长期规则。

### 20260527-003 自动化更新 skill 必须读完整 md

- 来源：`communications\2026-05-27\161500-qa-migration.md`
- 类型：自动化规则
- 内容：每日自动化可以从原仓库 `qa` 简版入口触发，但生成或更新 skill 时必须读取 Amadeus `md` 作为完整知识源，skill 只保留流程执行规则，不原文搬运整套 md。
- 适用：每日固定时间更新 skill、复制 skill 到 `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL`。

### 20260527-004 清空目录前必须先备份并确认

- 来源：`communications\2026-05-27\161500-qa-migration.md`
- 类型：风险提醒
- 内容：涉及清空、删除、覆盖目录时，必须先做完整备份，再按危险操作格式等待用户明确确认。
- 适用：清空 `qa`、重建 `deploy`、覆盖 skill、删除分支或文件。

### 20260527-005 md 规则不能等同于技术强制

- 来源：`communications\2026-05-27\161500-qa-migration.md`
- 类型：风险提醒
- 内容：单靠 md 规则不能技术强制所有 AI 自动记录对话；若要强制，需要接入 AGENTS.md、skill、每日自动化或启动包装流程。
- 适用：设计对话自动保存、自动化执行、skill 创建。

### 20260527-006 从项目经验生成 skill 时要通用化

- 来源：`communications\2026-05-27\164025-skill-generalization.md`
- 类型：新规则
- 内容：从具体项目 md 提炼 skill 时，只保留可跨仓库复用的流程、门禁、验证和风险控制，不把项目名、固定路径、业务模块或私有接口写进通用 skill。
- 适用：根据 Amadeus `md` 更新开发 skill、验证 skill、热修 skill。

### 20260527-007 源 md 原则上一条对应一个通用 skill

- 来源：`communications\2026-05-27\170345-skill-rebuild-source-md.md`
- 类型：自动化规则
- 内容：除单业务功能文档外，源头 md 原则上一条对应一个通用 skill；`AI 对话记录规则` 也必须生成对话写入文档 skill；像班主任手册、数字中枢这类单业务功能文档只保留为项目知识，不开发通用 skill。
- 适用：从 `md` 生成或同步 `SKILL` 目录。
