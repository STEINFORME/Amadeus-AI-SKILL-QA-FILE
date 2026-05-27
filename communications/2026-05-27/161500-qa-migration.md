# 会话记录：LQTedu QA 迁移到 Amadeus md

## 时间

2026-05-27 16:15

## 用户请求

用户要求把 `D:\software\lqtedu\lqtedu\qa` 的完整内容总结成多个 md，迁移到 `D:\software\Amadeus-AI-SKILL-QA-FILE\md`；后续原仓库 `qa` 只保留简版入口；所有 AI 对话记录写入 `D:\software\Amadeus-AI-SKILL-QA-FILE\communications`；每日自动化从简版入口和 Amadeus md 更新 skill，并复制到 `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL`。

## AI 判断

- `D:\software\Amadeus-AI-SKILL-QA-FILE\md` 应作为完整知识源。
- 原仓库 `qa` 应作为简版索引和自动化触发入口。
- `communications` 保存对话和执行记录。
- `SKILL` 保存自动化更新后的 skill 结果。
- 清空原仓库 `qa` 属于危险操作，必须在执行前单独确认。

## 处理内容

- 创建目录：`md`、`communications`、`SKILL`、`archive`。
- 备份原始 `qa` 到 `D:\software\Amadeus-AI-SKILL-QA-FILE\archive\lqtedu-qa-20260527-161512`。
- 生成 14 个完整知识库 md 文件。
- 新增路径规则、每日 skill 同步规则、AI 对话记录规则。
- 迁移文档中把长期知识沉淀方向统一改为 `D:\software\Amadeus-AI-SKILL-QA-FILE\md`。
- 用户确认危险操作后，清空 `D:\software\lqtedu\lqtedu\qa` 内部内容。
- 回填原仓库 `qa` 简版入口 11 个 md 文件。

## 验证

- 已检查原 `qa` 包含 10 个 md、19 个 png、2 个 txt。
- 已检查备份文件类型数量与原 `qa` 对齐。
- 已检查原仓库 `qa` 回填后只剩 11 个 md 文件。
- 已检查简版入口均指向 `D:\software\Amadeus-AI-SKILL-QA-FILE\md`、`communications` 或 `SKILL`。

## 风险

- 自动化若只读取原仓库 `qa` 简版，会丢失完整细节；必须读取 Amadeus `md`。
- 单靠 md 规则不能技术强制所有 AI 记录对话，需要接入 AGENTS.md、skill 或自动化启动流程。
- 原始图片和长文细节不再保留在原仓库 `qa`，需要从 archive 或 Amadeus `md` 读取。
