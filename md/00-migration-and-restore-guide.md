# AI 工作流迁移与恢复指南

## 目标

迁移后保持：

```txt
D 盘 = 长期资产，可迁移，可备份
C 盘用户目录 = 运行环境，可重装，可重建
```

## 必须迁移的 D 盘目录

| 路径 | 迁移方式 | 说明 |
| --- | --- | --- |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\md` | 必须迁移 | 唯一正式长期知识源 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\communications` | 建议迁移 | 历史事实记录，可用于追溯 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL` | 建议迁移 | generated artifact，可由 md 重建 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\scripts` | 必须迁移 | 健康检查和同步脚本 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\runtime` | 迁移 example，local 视情况 | local 文件不能包含密钥 |
| `D:\software\AI-Workspace\lqtedu-web-ai` | 必须迁移 | Obsidian Vault 和 Hermes 工作区 |
| `D:\software\AI-Workspace\hermes-data` | 视 Hermes 配置迁移 | Hermes Junction 的 D 盘目标 |

## 不建议直接迁移的 C 盘目录

| 路径 | 处理方式 | 原因 |
| --- | --- | --- |
| `C:\Users\zuoti\.codex\sessions` | 不复制；只允许摘要 | 体积增长快，含敏感上下文 |
| `C:\Users\zuoti\.codex\log` | 不复制 | runtime 日志，可重建 |
| `C:\Users\zuoti\.codex\skills` | 不作为主迁移资产 | 从 `SKILL` 重新同步 |
| `C:\Users\zuoti\.hermes` | 不直接复制 Junction 本体 | 需要按新机器 D 盘目标重建 Junction |
| `C:\Users\zuoti\AppData\Local\hermes` | 不直接复制 Junction 本体 | 需要按新机器 D 盘目标重建 Junction |

## 新电脑安装顺序

1. 准备 D 盘目录结构，例如 `D:\software`。
2. 复制 `D:\software\Amadeus-AI-SKILL-QA-FILE`。
3. 复制 `D:\software\AI-Workspace\lqtedu-web-ai`。
4. 安装 Obsidian，并打开 Vault：`D:\software\AI-Workspace\lqtedu-web-ai`。
5. 设置环境变量 `OBSIDIAN_VAULT_PATH=D:\software\AI-Workspace\lqtedu-web-ai`。
6. 安装 Codex / Codex Desktop，并手动登录。
7. 从 `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL` 同步 skills 到 `%USERPROFILE%\.codex\skills`。
8. 安装 Hermes，手动配置 DS V4 API，不把 API Key 写入仓库。
9. 如需保持 C 盘低占用，创建 Hermes Junction 到 D 盘目标目录。
10. 重新 clone 公司 repo 到 `D:\software\AI-Workspace\lqtedu-web-ai\repo`，不要从旧机器复制 Git 凭证。
11. 运行健康检查脚本。

## Hermes Junction 注意事项

当前机器应保持：

```txt
C:\Users\zuoti\.hermes -> D:\software\AI-Workspace\hermes-data\.hermes
C:\Users\zuoti\AppData\Local\hermes -> D:\software\AI-Workspace\hermes-data\local-hermes
```

禁止删除 Junction 后让 Hermes 重新在 C 盘生成大量数据。新机器如需重建 Junction，应先确认目标 D 盘目录存在并备份旧数据。

## Codex runtime skills 恢复

运行：

```powershell
D:\software\Amadeus-AI-SKILL-QA-FILE\scripts\sync-skills-to-codex.ps1 -Apply
```

默认脚本应先 dry-run。同步方向只能是：

```txt
D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL -> %USERPROFILE%\.codex\skills
```

## 公司 repo 恢复

- 重新 clone 公司 repo。
- 不复制旧机器 Git 凭证。
- 如需本地 `repo\AGENTS.md`，必须加入 `repo\.git\info\exclude`。
- 不提交 AI 工作区文件、Hermes 输出、Obsidian 配置到公司仓库。

## 迁移后健康检查

运行：

```powershell
D:\software\Amadeus-AI-SKILL-QA-FILE\scripts\check-ai-workflow-health.ps1
```

必须确认：

- C 盘剩余空间足够。
- Hermes 路径是 Junction 且目标在 D 盘。
- md、communications、SKILL、scripts、runtime 存在。
- Obsidian Vault 存在。
- `_ai/hermes` 存在。
- repo 存在 `.git`。
- Codex runtime skills 存在。
- `OBSIDIAN_VAULT_PATH` 指向当前 Vault。
