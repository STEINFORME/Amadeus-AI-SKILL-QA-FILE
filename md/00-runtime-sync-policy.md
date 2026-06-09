# Runtime Skill 同步策略

## 结论

Skill 必须跟随 md 修改。唯一允许的常规同步方向是：

```txt
D:\software\Amadeus-AI-SKILL-QA-FILE\md
↓
D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL
↓
C:\Users\zuoti\.codex\skills
```

禁止从 runtime skills 反向覆盖 SKILL，禁止从 SKILL 反向覆盖 md。

## 目录角色

| 路径 | 角色 | 是否主源 |
| --- | --- | --- |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\md` | 正式长期知识源 | 是 |
| `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL` | 从 md 生成的产物 | 否 |
| `C:\Users\zuoti\.codex\skills` | Codex runtime 安装层 | 否 |
| `D:\software\AI-Workspace\lqtedu-web-ai\.codex\skills` | 仓库镜像/临时运行层 | 否 |

## generated 文件标注建议

每个生成 skill 建议在 `SKILL.md` 中包含：

```txt
source md: <path>
generated time: <timestamp>
source hash: <hash>
do not edit directly; update md first
```

## 漂移检测

至少检查：

1. `D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL\<skill>\SKILL.md` 是否存在。
2. `%USERPROFILE%\.codex\skills\<skill>\SKILL.md` 是否存在。
3. 两者哈希是否一致。
4. 仓库 `.codex\skills` 是否存在同名 skill。
5. 如果同名 skill 内容不一致，报告漂移，不自动覆盖。

## 同步规则

- 默认 dry-run，先展示计划。
- `-Apply` 才执行复制。
- 默认不删除 runtime 中未知 skill。
- 如需 mirror 删除未知项，必须额外参数和人工确认。
- 只复制包含 `SKILL.md` 的有效 skill 目录。
- 不复制 communications、sessions、log 或大缓存。

## 仓库 `.codex\skills` 策略

默认主运行层使用：

```txt
C:\Users\zuoti\.codex\skills
```

仓库 `.codex\skills` 暂不作为长期维护层。若保留，只能作为项目镜像或历史兼容层；发现与 runtime 不一致时，应报告并等待确认。

## 新电脑恢复

1. 先迁移 md 和 SKILL 到 D 盘。
2. 安装并登录 Codex。
3. 运行同步脚本将 SKILL 复制到 `%USERPROFILE%\.codex\skills`。
4. 运行健康检查确认 runtime skills 存在。
