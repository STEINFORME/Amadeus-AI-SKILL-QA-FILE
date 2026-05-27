# Base / EBase 组件认知地图摘要

## 适用范围

用于查 LQTedu 项目现成 UI 组件、颜色、按钮、表格、表单、布局，判断旧 JSP/Avalon 页面该参考 `base.jsp`，还是 Vue3/Element Plus 页面该参考 `ebase.jsp`。

## 第一判断

- 出现 `ms-*`、`btn-*`、`a_*`、`WdatePicker`、`glyphicons`：先看 `base.jsp`。
- 出现 `el-*`、`el-table`、`el-dialog`、`type="blue"`、`type="darkBlue"`：先看 `ebase.jsp`。
- 旧页面要 DOM/class：整块复制 `base.jsp` 示例，不要只抄单个类名。
- E3 页面要组件块：整块复制 `ebase.jsp` 示例，保留本地 wrapper、宽度类、link/button type。

## 快速索引

| 能力 | 索引 |
| --- | --- |
| 颜色 token | `base.tab0.color`、`web/Res/css/lqt_color.css` |
| 旧按钮 | `base.tab1.a_buttons` |
| 旧文字操作 | `base.tab2.text` |
| 旧超链、提醒条、Bootstrap modal、hovercard | `base.tab3.a_links_alerts` |
| 旧表单控件、上传、WdatePicker | `base.tab4.a_controls` |
| 旧表格、分页、冻结表 | `base.tab5.a_tables` |
| 旧标题、步骤条、分割线 | `base.tab6.layout` |
| E3 控件、上传、预览弹窗 | `ebase.tab7.e3_controls` |
| E3 搜索栏、列表、配置表、空态、分页 | `ebase.tab8.e3_tables` |
| E3 按钮、顶部文字操作、标签组 | `ebase.tab10.e3_buttons` |

## 关键规则

- `ebase.jsp` 顶部 `li id=t0..t10` 是循环序号，不是业务 tab 值。
- 业务值看 `tabdata[index].index` 和 `letsNavigate()`。
- tab `9` 只是跳转 `/ebase-Upload.jsp`，不是 `ebase.jsp` 内部内容。
- 复制表格时不要只抄 `el-table`，搜索栏、空态、分页、操作链接也要一起判断。
- 第三方组件和弹层要看展开态证据，不要只看默认截图。

## 源码入口

| 类型 | 路径 |
| --- | --- |
| old base 页面 | `web/base.jsp` |
| ebase 页面 | `web/ebase.jsp` |
| old common head | `web/inc/head.jsp` |
| old 颜色 token | `web/Res/css/lqt_color.css` |
| e3 主题 | `web/Res/css/vue_config.css` |
| old 样式 | `web/Res/css/style.css`、`web/Res/css/school-gaop.css`、`web/Res/css/Ava-a.css` |

## Base 内容分区

- 颜色：主色、辅助色、禁用色、文本色。
- A 按钮：标准按钮、弱按钮、扩展按钮、图标按钮、操作按钮、返回按钮、标签组。
- 字符：标题、小标题、强调文字等。
- A 超链和提醒条：`a_green`、`a_red`、`a_warning`、`a_blue`、提醒框、普通弹框和 hovercard。
- A 控件：多选、单选、必填项、输入框、下拉框、日期控件、上传、评星。
- A 表格：标准表格、双列表格、冻结表格、分页。
- 布局：中标题、小标题、步骤条、分割线、超大页面头部。

## EBase 内容分区

- E3 按钮：Link、标准按钮、弱按钮、开关、下拉按钮、图标按钮、操作按钮、标签组、文字搜索框。
- E3 控件：下拉框、80/120/140/180/240px 控件、年级班级下拉、上传图片、上传文件、超大弹框。
- E3 表格：搜索栏、配置表、请假类示例、推送目标、审核员、空态、分页、REPORT 视图。

## 资产说明

原 `qa\tmp` 中保存了 base / ebase 的截图和 tab 文本提取，已在 `11-qa-assets-inventory.md` 建清单；原始图片已进入 archive 备份。
