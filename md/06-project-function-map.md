# LQTedu 项目功能和技术栈总览摘要

## 一句话结论

LQTedu 是面向学校的老式 Java Web 单体系统：`Ant` 打 WAR，`JSP/Servlet` 服务端渲染，后端同时存在老反射 Ajax 框架和 Spring MVC Controller，前端混有老 `JSP + Avalon + jQuery`、`JSP 内 Vue3 + Element Plus`、微信端打包产物、静态数字大屏和大量一次性修复脚本。

项目更适合先合并底层能力，而不是硬合页面：组织/班级/学期范围、通知红点、附件上传、导出报表、评价记录、考勤状态、课程实例、队列任务生命周期。

## 技术栈要点

| 层级 | 技术 | 注意点 |
| --- | --- | --- |
| 构建 | Apache Ant | 非 Maven/Gradle，`build.xml` 是入口 |
| 运行 | Servlet 3.0 / Tomcat | JSP/Servlet Web 容器 |
| 后端新接口 | Spring MVC 4.x | `src/com/app/mvc`、`src/com/ajax/mvc` 等 |
| 后端老接口 | 自研 Ajax 反射框架 | 大量 JSP 仍走 `web/ajax/ajax.jsp` 和 `AbstractAjaxEvent` |
| ORM | Hibernate 5 + `.hbm.xml` | 实体和表结构来源 |
| 前端旧体系 | JSP + Avalon + jQuery + My97DatePicker | 对照 `web/base.jsp` |
| 前端新体系 | JSP 内 Vue3 + Element Plus | 对照 `web/ebase.jsp` |
| 微信新版 | Vue3 + Vue Router + Vant + Axios | 产物在 `web/weixin/wechat/v2` 等 |
| 大屏 | 静态 HTML + Vue3 + Axios + ECharts | 数字中枢不能裸开 HTML 下结论 |
| 文件上传 | Uploadify/E3Uploader/OSS 等多套 | 重复严重，需先确认业务入口 |
| 安全 | ESAPI、Kaptcha、登录/Token/切面 | 前端权限只做体验，后端必须兜底 |

## 主要业务域

| 业务域 | 前端入口 | 后端线索 | 合并判断 |
| --- | --- | --- | --- |
| 综合素质/评价 | `web/department/dyc/zh`、`web/teacher/zh`、`web/student/zh`、数字中枢 | `Zhpj*`、`Zh*`、`DyRate*`、`PjAjax` | 可抽评价核心，页面保留场景壳 |
| 考勤/请假 | `web/department/dyc/kq`、教师/学生/移动端 | `Kq*`、`KqService`、`KqJob` | 高价值高风险，先统一状态 |
| 通知/消息/红点 | OA、部门、微信、H5 | `Notice*`、`Notify*`、`RedPointJob` | 做统一消息中心 |
| 作业 | 空间、课程空间、学生端、H5 | `Homework*`、`HomeWorkAjax` | 统一作业核心和附件 |
| 课程/选修/课表 | 教务、课程空间、移动端 | `Selcourse*`、`Kb*`、`CourseUtils` | 统一课程主数据、名单和权限 |
| 班级/组织/人员权限 | school/org、department/org、selector | `Org*`、`Class*`、`DeptPowerService` | 统一 scope/selector |
| 数字中枢 | DataHub 管理页 + `web/digitalHub` | `DigitalHub*`、`ZhpjReportUtils` | 保持展示层独立，收口数据适配器 |
| 班主任手册 | `deploy/web/department/headmasterManual` 线索 | `/wbSheet/*` | 动态字段、模板、派发/检查可沉为通用工作单能力 |
| 导出/统计/报表 | `web/export/script`、统计目录 | `*Export*`、`StatisticService` | 统一导出任务、模板、权限、队列 |
| 文件/附件/相册 | upload、avatar、ueditor、空间图片 | `UploadController`、`WXH5UploadController`、`OssService` | 抽统一上传服务，保留兼容入口 |

## 重复建设点

- `web/fix/tools` 与 `web/export/script` 有同名但不同内容的导出/下载脚本。
- `deploy/web` 是补丁区，不等于主源码。
- 考勤有 PC、教师、学生、班级空间、课程空间、微信 H5 多入口。
- 评价、积分、荣誉、数字中枢报表命名和实现混杂。
- 通知、红点、微信推送、业务催办各自处理。
- 上传能力重复：普通上传、头像、相册、空间图片、H5 上传等。
- 队列服务生命周期重复：OSS、PDF、Notify、KQ、MQ、Statistic、ImgCompress。
- 微信多套产物并存：`v2`、`dist`、旧 JSP、`h5/app`。
- 组织、权限、选择器重复。

## 推荐落地顺序

1. 上传/附件公共层。
2. 通知/红点公共层。
3. 组织、班级、人员选择器。
4. 导出任务和报表模板。
5. 考勤状态枚举和请假联动。
6. 评价核心模型和报表适配器。
7. 作业核心和附件评论。
8. 班主任手册按真实 `/wbSheet/*` 接口复核后再纳入通用工作单模型。

## 开发默认规则

- 不要把页面硬合成一个页面，优先合服务、状态、权限、附件、通知、导出。
- 不要把 `deploy/web` 当主源码。
- 不要把老 JSP、Vue3/E3、微信 V2、静态大屏混成一种技术栈。
- 新页面先复用全局样式和 `vue_config.css`，少写局部覆盖。
- 高风险目录如 `web/fix` 应收口成受控后台，增加权限、审计、预览和日志。

## 风险

这份总览来自静态扫描和历史 QA，总览级结论只能作为路由和风险判断；落到具体修改时必须重新查当前分支源码、接口和真实页面。
