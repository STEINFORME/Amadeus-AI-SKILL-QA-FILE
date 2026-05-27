# RP 页面规则快速路由

## 读取策略

不要一上来通读所有文件。先按任务类型跳转，再读对应文件的快速入口，最后回源码、接口、截图、RP 或真实页面验证。

## 任务路由

| 任务 | 先看 | 目的 |
| --- | --- | --- |
| 新建或修改前端页面/模块 | `02-rp-page-development-rules.md` 和对应 skill | 判断证据、权限、技术栈、字段契约和影响面 |
| 写 RP 页面 / 改 UI | `02-rp-page-development-rules.md` | 判壳层、参考实现、交互边界 |
| 找组件/颜色/表格/控件写法 | `05-base-ebase-component-map.md` | 定位 `base.jsp` / `ebase.jsp` 示例和 CSS 来源 |
| 改完验收 / 写测试结论 | `04-rp-page-testing-rules.md` | 按入口、参数、显隐、交互、视觉输出结论 |
| 碰数字中枢 | `07-digitalhub-structure-notes.md` | 查管理页、静态大屏、接口链路和坑点 |
| 班主任手册 mock 转接口 | `08-class-teacher-handbook-interfaces.md` | 对齐假数据命名空间、真实接口和字段语义 |
| 热修、deploy、分支发布 | `09-hotfix-deploy-rules.md` | 控制 Git 流程、部署包和危险操作 |
| 前端 CS 样式类问题 | `10-frontend-cs-lessons.md` | 处理 Base 样式、间距、颜色、圆角、日期展示 |
| 更新长期规则或路径 | `01-path-and-source-rules.md` | 确认写入 Amadeus `md`，不是写回原仓库完整 QA |

## 默认顺序

1. 读本路由。
2. 读对应主题文件。
3. 搜源码验证关键事实。
4. 判断证据等级、停机条件、影响面和安全边界。
5. 能改才改代码；不能改就说明缺失证据和风险。
6. 回看对应文件的 checklist。

## 维护规则

- 新增“怎么判断、怎么选实现、怎么落结构”：更新 `02-rp-page-development-rules.md`。
- 新增“怎么验证、怎么写结论、异常数据、并发边缘、结论门禁”：更新 `04-rp-page-testing-rules.md`。
- 新增 `base/ebase` 组件、样式、截图证据：更新 `05-base-ebase-component-map.md`。
- 新增数字中枢入口、目录、接口、链路、坑点：更新 `07-digitalhub-structure-notes.md`。
- 新增班主任手册接口字段、mock 映射、对接顺序：更新 `08-class-teacher-handbook-interfaces.md`。
- 新增路径、对话记录、skill 输出规则：更新 `01-path-and-source-rules.md`、`98-daily-skill-sync-rule.md` 或 `99-ai-communications-recording-rule.md`。

## 对原仓库 qa 的要求

原仓库 `D:\software\lqtedu\lqtedu\qa` 的简版文件应只保留本路由的压缩版和完整文件链接，不再承载完整细节。
