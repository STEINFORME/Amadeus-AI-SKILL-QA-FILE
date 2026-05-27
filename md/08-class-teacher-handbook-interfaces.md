# 班主任手册接口和 mock 对接摘要

## 适用范围

用于班主任手册从 mock 到真实接口的对接、字段映射、动态字段 mapper、页面状态和风险判断。

## 当前真实接口结论

- 本轮真实接口共 31 个 `/wbSheet/*`。
- 全部按 `POST` 对接；文档写 `query` 时，前端仍按老项目习惯使用表单参数提交。
- 通用返回壳：`status:boolean`、`message:string`、`data:any`。
- Widdershins 导出存在参数说明截断、必填真假不可信、示例字段错位问题；对接以真实返回和后端口径复核。

## 对接顺序

1. 先接已开始落地的部门派发和模板管理。
2. 再接部门工作汇总和某班工作概览。
3. 再接自建工作单和检查页。
4. 最后接班主任个人端。

## 不能猜的内容

- 数据字典、学校结构、部门左栏属于后端配置和权限边界，没有接口时不要前端仿造。
- `editable`、权限、截止时间、是否能删除/编辑，优先以后端字段为准。
- JSON 结构参数按字符串传：`detailArrayStr`、`pic_array_str`、`pic_del_array_str`、`wbTimeObj`、`wbSendObj`、`selectList`。

## 真实接口目录

| 权限域 | 能力 | 接口 | 关键参数 |
| --- | --- | --- | --- |
| 班主任个人端 | 工作导览 | `/wbSheet/getTeacherWorkList` | `classId`、`termCode` |
| 班主任个人端 | 删除个人记录 | `/wbSheet/deleteTeacherOwnSheet` | `actId` |
| 班主任个人端 | 个人派送单列表 | `/wbSheet/getTeacherSendList` | `classId`、`termCode` |
| 班主任个人端 | 添加/编辑/查看初始化 | `/wbSheet/getTeacherOwnSheetInfo` | `indexId`、`actId`、`termCode`、`classId`、`wbDoType` |
| 班主任个人端 | 添加/修改提交 | `/wbSheet/updateTeacherOwnSheet` | `classId`、`actId`、`wbType`、`indexId`、`termCode`、`detailArrayStr`、图片字符串、`wbDoType` |
| 部门工作汇总 | 汇总列表 | `/wbSheet/getDeptTeacherWorkList` | `gradeType`、`termCode` |
| 部门工作汇总 | 教师修改权开关 | `/wbSheet/changeTeacherEditPower` | `powerId`、`powerOpen` |
| 部门工作汇总 | 某班工作概览 | `/wbSheet/getDeptTeacherRecord` | `gradeId`、`classId`、`termCode` |
| 部门工作汇总 | 工作记录查看 | `/wbSheet/getDeptTeacherRecordInfo` | `actId` |
| 自建工作单 | 教师自建工作单列表 | `/wbSheet/getDeptTeacherSheetList` | `termCode` |
| 自建工作单 | 添加/设置初始化 | `/wbSheet/getDeptTeacherSheetInfo` | `sheetId` |
| 自建工作单 | 添加/设置保存 | `/wbSheet/updateDeptTeacherSheet` | `sheetId`、`wbType`、`limitMin`、`limitMax` |
| 自建工作单 | 移除 | `/wbSheet/deleteDeptTeacherSheet` | `sheetId` |
| 自建工作单 | 沿用到本学期 | `/wbSheet/yanyongDeptTeacherSheet` | `sheetIds` |
| 检查页 | 自建/派发检查查询 | `/wbSheet/getWbCheck` | `termCode`、`wbDoType`、`wbType`、`wbId`、`indexId` |
| 检查页 | 自动保存开关 | `/wbSheet/changeAutoSavePower` | `powerId`、`powerOpen` |
| 检查页 | 检查提交/自动保存 | `/wbSheet/updateDeptWbSheet` | `actId`、`detailArrayStr`、图片字符串 |
| 部门派发 | 派发列表 | `/wbSheet/getDeptSendList` | `termCode` |
| 部门派发 | 新建页初始化 | `/wbSheet/getDeptSendAddInfo` | 无 |
| 部门派发 | 新建派发提交 | `/wbSheet/addDeptSendWbSend` | `wbType`、`wbTimeType`、`wbTimeObj`、`wbSendTime`、`wbSendGrade`、`wbSendObj`、`wbUserType`、`endTime` |
| 部门派发 | 详情查询 | `/wbSheet/getDeptSendDetail` | `wbId` |
| 部门派发 | 详情修改 | `/wbSheet/updateDeptSendDetail` | `wbId`、`wbUserType?`、`endTime?`、`cancelWb?` |
| 部门派发 | 列表删除单条 | `/wbSheet/deleteDeptSend` | `indexId` |
| 模板管理 | 模板列表 | `/wbSheet/getTempInfo` | 无 |
| 模板管理 | 项目详情 | `/wbSheet/getTempDetail` | `detailId` |
| 模板管理 | 新增自定义项目 | `/wbSheet/addTemp` | `name`、`textType`、`isRequired`、`baseCode`、长度、`tempId`、`typeId`、`selectList?` |
| 模板管理 | 删除项目 | `/wbSheet/delTemp` | `detailId` |
| 模板管理 | 修改自定义项目 | `/wbSheet/updateTemp` | `detailId`、字段定义、`selectList?` |
| 模板管理 | 上下移动项目 | `/wbSheet/swapDetail` | `preId`、`currentId` |
| 模板管理 | 修改快捷语库 | `/wbSheet/updateTempComment` | `detailId`、`comment` |
| 模板管理 | 启用快捷语库 | `/wbSheet/enableTempComment` | `detailId`、`status` |

## 枚举速记

| 字段 | 值 | 含义 |
| --- | --- | --- |
| `TEXT_TYPE` / `textType` | `S_LINE_SHORT` | 短单行文本框 |
| `TEXT_TYPE` / `textType` | `S_LINE` | 长单行文本框 |
| `TEXT_TYPE` / `textType` | `M_LINE` | 多行文本框 |
| `TEXT_TYPE` / `textType` | `SELECT` | 下拉框 |
| `TEXT_TYPE` / `textType` | `DATE_TEXT` | 日期框 |
| `COMMENT_ENABLE` / `status` | `0` / `1` | 快捷语库关闭 / 开启 |
| `WB_USER_TYPE` | `1` / `2` | 教师填写 / 部门填写 |
| `WB_TIME_TYPE` | `1` / `2` / `3` | 单次 / 按周 / 按月派发 |
| `wbDoType` | `1` / `2` | 自建工作单 / 派发工作单 |
| `SUCCESS_STATUS` | `-1` / `0` / `1` | 未完成 / 待完成 / 已完成 |

## 必备 mapper

- `normalizeTerm(row)`：统一 `CODE/TERM_ID`、`NAME/TERM_NAME`。
- `normalizeClass(row)`：统一班级、年级、教师字段。
- `normalizeDynamicField(detail)`：统一模板字段和填写字段。
- `buildDetailArrayStr(fields)`：回写动态字段值。
- `buildPicArrayStr(files)` / `buildPicDelArrayStr(files)`：图片新增和删除字符串。
- `normalizeDispatchBatch(row)`：统一周/月批次和详情显示。
- `normalizeBooleanStatus(res)`：统一 `status/message`，Vue3 失败走 `ElNotification`。

## 真实返回覆盖点

- `/getWbCheck` 自动保存开关在 `data.autoSaveMap.POWER_OPEN`，开关 id 在 `data.autoSaveMap.ID`。
- 已完成记录字段内容在 `successList[].updateList.details[]`，不是 `successList[].details[]`。
- 快捷语库在 `successList[].updateList.quick_comment_list[]`。
- 记录可编辑权限看 `successList[].can_edit`。

## Mock 对接清单

mock 命名空间：

| 命名空间 | 内容 |
| --- | --- |
| `overview` | 学期、学段、班级/班主任关系、汇总卡片、身份、开关 |
| `teacherTasks` | 自建工作单类型、自建记录、字段定义、历史学期汇总 |
| `dispatchTasks` | 派发任务、派发范围、回执/接收人状态、月度样例 |
| `templates` | 模板列表、模板字段预览 |
| `dictionary` | 数据字典分组、手册挂接项 |
| `schoolStructure` | 德育处/部门结构、学段、手册开关、教师修改权 |

占位接口到真实接口时，优先保字段语义，不死守 `CTH_*` 名称。

## 风险

- `/getTeacherOwnSheetInfo` 不要额外传 `wbType`；`wbType` 只出现在提交接口里。
- `/swapDetail` 的 `preId/currentId` 语义容易反，必须点真实接口确认。
- `selectList` 只在 `SELECT` 类型传，且是 JSON 字符串。
- 图片字段只看到字符串契约，真实上传链路要查项目已有上传组件。
- 部门“某班工作概览”的查看落点需要确认 RP 是弹层还是独立页。
