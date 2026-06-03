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

- 来源：`communications\2026-05-27\161500-qa-migration.md`、`communications\2026-06-01\080700-skill-sync-boundary.md`
- 类型：新规则
- 内容：从 `communications` 中提炼出的可复用教训和新知识只维护在本文件；本文件最多 30 条，每次修改必须压缩同义项和删除冗余条目；无新增事实时只优化已有条目，不伪造 lesson。
- 适用：复盘会话、每日自动化抽取教训、整理长期规则。

### 20260527-003 skill 同步必须读完整 md 并去项目化

- 来源：`communications\2026-05-27\161500-qa-migration.md`、`communications\2026-05-27\170345-skill-rebuild-source-md.md`、`communications\2026-06-01\130320-navigation-map-skill-sync.md`、`communications\2026-06-01\163600-skill-sync-no-drift.md`
- 类型：自动化规则
- 内容：生成或更新 skill 必须以 Amadeus `md` 为完整知识源；单业务文档和项目页面地图不生成项目专用 skill，只抽象可迁移规则；中断尝试让位于最终记录；通用 skill 不写项目名、固定路径、业务模块或私有接口。
- 适用：每日固定时间更新 skill、复制 skill 到 `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL`、清理被旧尝试污染的 lessons 条目。

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

### 20260527-006 skill 安装、复制和无漂移判断

- 来源：`communications\2026-05-27\171010-install-skills-and-push.md`、`communications\2026-06-01\163600-skill-sync-no-drift.md`、`communications\2026-06-02\113328-skill-sync-no-churn.md`
- 类型：自动化规则
- 内容：安装、复制或比对通用 skill 时，只处理包含 `SKILL.md` 的有效目录；先校验源目录、安装目录和归档目录的相对文件集合与 SHA256；一致时只记录验证结论，不重复复制、重写 skill 或制造提交，漂移时再同步并记录提交、推送或未执行项的真实结果。
- 适用：同步 skill 到 `C:\Users\zuoti\.codex\skills`、复制 skill 到 `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL`、提交或推送自动化结果。

### 20260528-007 提交推送按明确授权边界执行

- 来源：`communications\2026-05-28\130900-skill-sync-lessons-update.md`、`communications\2026-05-28\163320-skill-sync-push.md`、`communications\2026-06-02\113328-skill-sync-no-churn.md`
- 类型：自动化规则
- 内容：提交和推送分开处理；未明确要求推送时不推送，自动化任务明确授权提交或推送时可直接执行；执行前仍要核对当前分支、远端目标和工作区状态；无真实差异时不为满足授权制造改动，执行后记录提交哈希、推送结果和未执行项。
- 适用：自动化同步 skill、直接提交到 main、推送远端。
