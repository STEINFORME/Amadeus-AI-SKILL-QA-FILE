# 原 QA 资产清单

## 定位

原 `qa\tmp` 中有 base / ebase 截图和 tab 文本提取。它们不适合直接转成完整规则文本，但适合作为视觉证据索引。

原始文件已完整备份到：

`D:\software\Amadeus-AI-SKILL-QA-FILE\archive\lqtedu-qa-20260527-161512\tmp`

## 文本资产

| 文件 | 用途 |
| --- | --- |
| `base-tabs.txt` | `base.jsp` tab 文本提取，覆盖 A 按钮、超链提醒、控件、表格、布局等 |
| `ebase-tabs.txt` | `ebase.jsp` tab 文本提取，覆盖 E3 按钮、控件、表格等 |

## Base 截图资产

| 文件 | 用途 |
| --- | --- |
| `base-full.png` | base 页面全局视觉 |
| `base-layout.png` | base 布局、标题、步骤、分割线 |
| `base-color.png` | base 颜色 token 和色板 |
| `base-text.png` | base 字体、标题、文字样式 |
| `base-a-buttons.png` | A 按钮默认态 |
| `base-a-buttons-dropdown-open.png` | A 按钮下拉展开态 |
| `base-a-controls.png` | A 控件、输入框、下拉、日期、上传 |
| `base-a-links-alerts.png` | A 超链和提醒条 |
| `base-a-links-hover-open.png` | A hovercard 展开态 |
| `base-a-links-modal-open.png` | A 弹框展开态 |
| `base-a-tables.png` | A 表格、分页、冻结表 |

## EBase 截图资产

| 文件 | 用途 |
| --- | --- |
| `ebase-full.png` | ebase 页面全局视觉 |
| `ebase-e3-buttons.png` | E3 按钮、Link、标签、开关 |
| `ebase-e3-controls.png` | E3 控件默认态 |
| `ebase-e3-controls-select-open.png` | E3 下拉展开态 |
| `ebase-e3-controls-dialog-open.png` | E3 弹窗展开态 |
| `ebase-e3-controls-dialog-open-2.png` | E3 弹窗第二展开态 |
| `ebase-e3-tables.png` | E3 表格默认态 |
| `ebase-e3-tables-report.png` | E3 REPORT 视图 |

## 使用规则

- 需要判断样式时，先读 `05-base-ebase-component-map.md`，再按需查看 archive 中对应截图。
- 需要重新生成截图证据时，应把新截图资产登记到本文件。
- 原仓库 `qa` 简版文件只引用本清单，不再保存完整图片资产。
