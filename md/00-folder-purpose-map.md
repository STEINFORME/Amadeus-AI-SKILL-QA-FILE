# AI 工作流文件夹职责地图

| 文件夹路径 | 当前用途 | 是否长期资产 | 是否可迁移 | 是否可重建 | 是否能手改 | 是否正式规则源 | 谁负责写入 | 谁负责读取 | 迁移时怎么处理 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\md` | 正式长期知识源 | 是 | 是 | 否 | 可以，需确认 | 是 | 用户 / Codex 经确认 | Codex / Hermes / 用户 | 必须迁移和备份 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\communications` | 执行记录和事实流水 | 是 | 是 | 否 | 可以追加，不写长期规则 | 否 | Codex / Hermes / 自动化 | 用户 / Hermes / Codex 按需 | 建议迁移，避免当规则源 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL` | 从 md 生成的 skill 产物 | 是 | 是 | 可以由 md 重建 | 不建议手改 | 否 | 生成脚本 / Codex 经确认 | 同步脚本 / Codex | 可迁移，也可重建 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\scripts` | 健康检查、同步、恢复脚本 | 是 | 是 | 可从仓库恢复 | 可以，需确认 | 否 | 用户 / Codex | 用户 / Codex | 必须迁移 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\runtime` | 本机非敏感配置模板和本地配置 | 部分 | 是 | 可以 | local 可手改，禁止密钥 | 否 | 用户 / Codex | 脚本 / 用户 | example 迁移，local 视情况 |
| `D:\software\AI-Workspace\lqtedu-web-ai` | Obsidian Vault / AI 指挥台 | 是 | 是 | 否 | 可以 | 否 | 用户 / Codex / Hermes | 用户 / Codex / Hermes | 必须迁移 |
| `D:\software\AI-Workspace\lqtedu-web-ai\_ai` | 工作区 AI 辅助资料 | 是 | 是 | 部分可重建 | 可以，需分层 | 否 | 用户 / Hermes / Codex | 用户 / Codex / Hermes | 迁移，但不当正式规则源 |
| `D:\software\AI-Workspace\lqtedu-web-ai\_ai\hermes` | Hermes 复盘、候选规则、模板 | 是 | 是 | 部分可重建 | Hermes 可写 | 否 | Hermes | 用户 / Codex 按需 | 必须迁移 |
| `D:\software\AI-Workspace\lqtedu-web-ai\repo` | 公司代码仓库 | 否，源码以远端为准 | 不建议直接迁移 | 可重新 clone | Codex 经确认可改业务代码 | 否 | 开发者 / Codex 经确认 | Codex / 开发者 | 新机器重新 clone |
| `C:\Users\zuoti\.codex\skills` | Codex runtime skill 安装层 | 否 | 不作为主资产 | 可从 SKILL 同步 | 不建议手改 | 否 | 同步脚本 / Codex runtime | Codex | 新机器从 SKILL 重建 |
| `C:\Users\zuoti\.codex\sessions` | Codex 会话日志 | 否 | 不建议复制 | 不可完整重建 | 不手改 | 否 | Codex runtime | Hermes / Codex 只读摘要 | 不复制，只读摘要 |
| `C:\Users\zuoti\.codex\log` | Codex 运行日志 | 否 | 不建议复制 | 可重建 | 不手改 | 否 | Codex runtime | 用户 / Codex 排障 | 不迁移 |
| `C:\Users\zuoti\.hermes` | Hermes 用户配置入口，当前为 Junction | 否，入口可重建 | 不复制 Junction 本体 | 可重建 Junction | 不手改 Junction | 否 | Hermes runtime | Hermes | 新机器重建到 D 盘目标 |
| `C:\Users\zuoti\AppData\Local\hermes` | Hermes 本地数据入口，当前为 Junction | 否，入口可重建 | 不复制 Junction 本体 | 可重建 Junction | 不手改 Junction | 否 | Hermes runtime | Hermes | 新机器重建到 D 盘目标 |

## 当前已知冲突

- `_ai` 下存在正式 md 的镜像，后续必须避免把 `_ai` 当正式主源。
- `_ai/13-lqtedu-page-navigation-map.md` 与正式 md 的同名文件存在漂移，需要人工确认。
- 仓库 `.codex/skills` 与用户 runtime skills 同时存在，应避免双运行层长期分叉。
