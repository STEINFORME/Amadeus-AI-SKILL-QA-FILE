# LQTedu 项目功能、模块、技术栈总览

> 基于本地 `master` 分支静态扫描整理。当前本地 `master` 落后 `origin/master` 2 个提交，未执行 `git pull`；`qa/` 与 `deploy/` 在当前工作区是未跟踪目录，本文把它们作为本地规范/部署补丁线索，不直接等同于线上主干代码。

## 1. 一句话结论

这是一个面向学校的老式 Java Web 单体系统：`Ant` 打 WAR，`JSP/Servlet` 服务端渲染，后端同时存在老反射 Ajax 框架和较新的 Spring MVC Controller，前端混有老 `JSP + Avalon + jQuery`、新 `JSP 内 Vue3 + Element Plus`、微信端 `Vue/Vant` 打包产物、静态数字大屏和大量一次性修复脚本。

项目真正值得合并的不是页面本身，而是底层能力：组织/班级/学期范围、通知红点、附件上传、导出报表、评价记录、考勤状态、课程实例、队列任务生命周期。页面层直接大合并风险很高，尤其考勤、综评、微信 H5、数字中枢和班主任手册。

## 2. 扫描范围与规模

| 项目 | 结论 |
| --- | --- |
| 当前分支 | `master`，本地落后 `origin/master` 2 个提交 |
| 构建入口 | `build.xml` |
| 包管理 | 根 `package.json` 仅提供 e2e 脚本，不承担前端构建 |
| Web 页面规模 | `web` 下约 2543 个 `.jsp`、716 个 `.js`、296 个 `.css`、147 个 `.html` |
| Java 规模 | `src` 下约 1314 个 `.java`、177 个 `.xml`、8 个 `.properties` |
| 最大 PC 目录 | `web/department` 约 1057 个 JSP，其次 `web/space`、`web/fix`、`web/oa` |
| 最大 Java 包 | `src/com/ajax` 约 360 个 Java，`src/com/entity` 约 177 个 Java，`src/com/lineteam` 约 128 个 Java |
| 本地 QA 文档 | `qa/base-ebase组件认知地图.md`、`qa/数字中枢结构速记.md`、`qa/班主任手册-真实接口整合.md` 等 |

## 3. 技术栈表

| 层级 | 技术/组件 | 用途 | 证据路径 | 备注 |
| --- | --- | --- | --- | --- |
| 构建 | Apache Ant | 编译 Java 8、复制环境配置、打 `dist/lqtedu.war` | `build.xml` | 非 Maven/Gradle |
| 运行容器 | Servlet 3.0 / Tomcat | JSP/Servlet Web 容器 | `conf/*/web.xml` | welcome 是 `login.jsp` |
| 后端框架 | Spring MVC 4.x | 新接口、`@Controller`、`@RequestMapping` | `src/com/lqtedu/spring/conf/WebConfig.java`、`src/com/app/mvc`、`src/com/ajax/mvc` | 扫描 `com.app.mvc`、`com.ajax.mvc` 等 |
| 老接口框架 | 自研 Ajax 反射框架 | JSP 反射调用 `AbstractAjaxEvent` 子类 | `web/ajax/ajax.jsp`、`src/com/lineteam/ajax`、`src/com/ajax` | 大量老页面还靠它 |
| ORM | Hibernate 5 + `.hbm.xml` | 实体映射、SessionFactory | `conf/*/spring-hibernate.xml`、`src/com/entity` | `T*` 多为业务表，`D*` 多为字典/基础表 |
| 数据库 | MySQL + Druid | 主数据源、多数据源连接池 | `conf/*/config.properties`、`conf/*/druid/*.properties` | 文档只记录存在，不贴凭据 |
| 缓存/消息 | Redis/Jedis、Memcached/OCS、Redis MQ、阿里 ONS/RocketMQ | 缓存、红点、异步通知/队列 | `conf/*/redisPool.properties`、`src/com/service`、`web/WEB-INF/lib` | 多套并存，需先确认当前有效链路 |
| 定时任务 | Quartz | 后台 Job、统计、通知、考勤、综评任务 | `conf/*/quartz_jobs.xml`、`src/com/job` | Web.xml 中有 Quartz 初始化 |
| 文件上传 | Servlet Upload、Spring Multipart、Uploadify/E3Uploader、OSS | 普通文件、头像、相册、空间图片、H5 上传 | `conf/*/web.xml`、`src/com/upload`、`src/com/ajax/mvc/UploadController.java`、`src/com/app/mvc/WXH5UploadController.java` | 重复严重 |
| 前端旧体系 | JSP + Avalon + jQuery + My97DatePicker | 老 PC 后台、教师/学生端页面 | `web/base.jsp`、`web/Res/js`、大量 `ms-controller` 页面 | 不要和 Vue3 页面混写 |
| 前端新体系 | Vue3 + Element Plus | 新 PC 页面、Vue3 迁移页、EBase 示例 | `web/ebase.jsp`、`web/Res/js/vue.global.js`、`web/Res/css/vue_config.css` | 全局脚本本地托管，非 npm 构建 |
| 微信新版 | Vue3 + Vue Router + Vant + Axios | 微信 V2 主壳 | `web/weixin/wechat/v2`、`web/weixin/wechat/wechat/v2/js` | 产物已打包进仓库 |
| 微信旧版 | 老 Vue/Webpack、VUX/Vant2、JSP/SeaJS/jQuery/Zepto | 旧移动端主壳和早期 JSP 页面 | `web/weixin/wechat/dist`、`web/weixin/wechat/views`、`web/weixin/service` | 入口和产物归属混乱 |
| 老 App H5 | JSP + token + SeaJS | App 内嵌通知/作业/成绩 | `web/h5/app` | 功能面较窄 |
| 大屏 | 静态 HTML + Vue3 + Axios + ECharts | 数字中枢展示 | `web/digitalHub` | 不能裸开静态页下业务结论，需从 DataHub 管理入口带加密参数进入 |
| 报表/导出 | POI、JasperReports、iText、PDF/Excel 脚本 | 考试、综评、选修、考勤、作业等导出 | `web/export/script`、`src/com/ajax/mvc/*Export*`、`web/WEB-INF/lib` | 每个业务各搞一套，合并价值高 |
| 安全 | ESAPI、Kaptcha、登录/Token/切面 | 输入过滤、验证码、登录态、Token 校验 | `conf/*/ESAPI*`、`conf/*/web.xml`、`src/com/ajax/mvc/config` | 前端权限只做体验拦截，后端必须兜底 |

## 4. 后端模块表

| 模块/层 | 路径 | 核心职责 | 合并/简化判断 |
| --- | --- | --- | --- |
| 平台基础层 | `src/com/lineteam/**` | 初始化、参数读取、过滤器、Ajax 基类、Hibernate DAO、QueryUtil、DruidPool、安全/日志 | 底座类，别乱动；新能力应明确复用边界 |
| ORM 实体 | `src/com/entity/**`、`src/com/lqtedu/weixin/entity/**` | HBM 实体和数据库表映射 | 作为数据结构来源；可建立实体索引，不建议批量改名 |
| 老 Ajax 业务 | `src/com/ajax/**`、`src/com/bussiness/**`、`web/ajax/ajax.jsp` | 老 JSP 业务入口、反射调用、部分 SQL/页面逻辑 | 新代码不要继续横向复制 `Ajax.java`；可逐步把业务沉到服务层 |
| Spring MVC 后台接口 | `src/com/ajax/mvc/**`、`src/com/ajax/mvc/util/**` | PC/后台 API：考试、考勤、空间、教务、OA、资产、选课、综评等 | 保留 URL，抽公共 service，避免 Controller 继续套老 Ajax |
| H5/移动端接口 | `src/com/app/mvc/**`、`src/com/app/mvc/util/**`、`src/com/app/ajax/**` | `/app/*`、`/wechat/*` 移动端接口和菜单/用户工具 | 可作为移动端收口点，但权限和菜单要以后端为准 |
| 登录与权限 | `src/com/ajax/login/**`、`src/com/ajax/mvc/config/**`、`src/com/lineteam/security/**` | 登录、Token、切面、真实姓名替换、安全工具 | 登录跳转应配置化，别继续散落 JSP 判断 |
| 教务/班级/课程 | `src/com/ajax/department/jiaow/**`、`src/com/bussiness/department/jiaow/**`、`src/com/ajax/mvc/*Course*/*Kb*/*Sel*` | 学生/教师/班级/课表/课程/选修/教务设置 | 高合并价值：课程主数据、开课实例、学生名单、教师权限应统一 |
| 考试/成绩/统计 | `src/com/ajax/department/exam/**`、`src/com/ajax/mvc/Exam*`、`src/com/service/statistic/**` | 考试设置、录入、分析、成绩统计、报表导出 | 报表/导出可先收口，考试业务本身谨慎动 |
| 综评/德育/荣誉 | `src/com/ajax/department/dyc/**`、`src/com/ajax/mvc/Zhpj*`、`src/com/app/mvc/ZhController.java` | 综合评价、积分、荣誉、德育报表、学生画像 | 可抽评价核心模型；页面按角色保留不同外壳 |
| 考勤/请假 | `src/com/ajax/department/xxc/kq/**`、`src/com/ajax/mvc/Kq*`、`src/com/app/mvc/Kq*`、`src/com/service/kq/**`、`src/com/job/kq/**` | 学生/教师/班级/选修考勤，请假审批、通知队列、定时提醒 | 高价值但高风险；先统一状态枚举、请假联动和通知钩子 |
| OA/通知/报修/收集 | `src/com/ajax/oa/**`、`src/com/bussiness/oa/**`、`src/com/ajax/mvc/OaController.java`、`src/com/service/notify/**` | 通知、投票、报修、资料收集、文件流转、消息推送 | 通知/红点/接收范围应做统一消息中心 |
| 空间/作业/成长记录 | `src/com/ajax/space/**`、`src/com/ajax/classesspace/**`、`src/com/ajax/mvc/Space*`、`src/com/app/mvc/Ts*`、`src/com/app/mvc/homeWorkH5Controller.java` | 班级空间、课程空间、专题空间、作业、成长/特殊关注、评论附件 | 作业核心和评论/附件/通知可收口，入口保留差异 |
| 文件/媒体/上传 | `src/com/upload/**`、`src/com/album/upload/**`、`src/com/ajax/mvc/UploadController.java`、`src/com/service/oss/**`、`src/com/img/**`、`src/com/sp/**` | 普通上传、头像、相册、空间图片、OSS 同步、图片/视频压缩 | 先抽统一 UploadService 和 WorkerService 生命周期 |
| 第三方集成 | `src/com/ajax/openAPI/**`、`src/com/lqtedu/mvc/**`、`src/com/lqtedu/service/**`、`src/com/aliyuncs/**`、`src/com/ons/**` | 数字中枢/openAPI、微信 OAuth/消息、阿里云、外部 REST | 可按适配器模式收口，但需保留历史接口兼容 |
| 定时/常驻服务 | `src/com/job/**`、`src/com/service/**` | Quartz Job、通知/PDF/OSS/MQ/统计/考勤后台线程 | 生命周期重复明显，适合抽公共模板 |

## 5. PC Web / JSP 模块表

| 模块 | 路径 | 功能 | 主要技术栈 | 合并/简化判断 |
| --- | --- | --- | --- | --- |
| 旧基础页 | `web/base.jsp` | 老组件、样式、布局、旧页面参照 | JSP + Avalon + jQuery + My97DatePicker | 不和 `ebase.jsp` 合并；作为老页面标准参照 |
| 新基础页 | `web/ebase.jsp` | Vue3/E3/Element Plus 示例和样式基准 | JSP 内 Vue3 + Element Plus | 不和老基准混用；可统一 token/组件用法 |
| 部门后台 | `web/department` | 最大后台区：教务、德育、总务、组织、办公、数字中枢等 | 老 JSP 为主，夹 Vue3 页面 | 只能按子模块局部瘦身，不能整体硬合 |
| 教务后台 | `web/department/jiaow` | 考试、成绩分析、选课、课表、课程体系、学生/教师管理、课堂评价 | 老 JSP/Avalon 为主，少量 Vue3 | 教务主数据和导出统计可先统一 |
| 德育后台 | `web/department/dyc` | 综评、考勤、导师/成长、报表、任务、模板 | 老 JSP + 部分 Vue3 | 评价/考勤/导师制要分层收口 |
| 总务后台 | `web/department/zongw` | 资产、车辆、场馆、宿管等 | 老 JSP/Avalon | 可与报修/资产/场馆 H5 建共享模型 |
| 组织/人员 | `web/department/org`、`web/school/org`、`web/sys/org`、`web/common/selector` | 组织、部门、人员选择、权限范围 | 老 JSP + JS 选择器 | scope/selector 是全项目公共能力，优先统一 |
| 学校后台 | `web/school` | 学校、年级班级、组织、基础设置 | 老 JSP 为主，少量 Vue3 | 可统一导入/弹窗/选择器，别整体迁移 |
| 教师端 | `web/teacher` | 教师考勤、课堂评价、考试/成绩、资产、打印、文件等 | 老 JSP + Vue3 并存 | 适合按同名 Vue3 页逐步替换 |
| 学生端 | `web/student` | 学生文件、选课、请假、课程、课堂评价、考勤、成绩/综评 | 老 JSP + 部分 Vue3 | 逐步 Vue3 化，保留角色差异 |
| 家长端 | `web/parent` | 家长查看、考勤/孩子相关功能 | 老 JSP | 可与微信家长端共享数据接口 |
| OA | `web/oa` | 问卷/测验、投票、办公、报修、通知、日程、资料收集 | 老 JSP | 通知、报修、收集、问卷可与移动端统一接口 |
| 空间 | `web/space`、`web/coursespace`、`web/classesspace` | 教学空间、班级空间、课程空间、专题空间、作业/资料/讨论 | 老 JSP | 作业、评论、附件、通知公共层可复用 |
| 考勤入口 | `web/kq`、`web/teacher/kq`、`web/student/kq`、`web/department/dyc/kq` | 多角色考勤、请假、补卡、统计 | 老 JSP + Vue3 迁移页 | 高重复，先统一状态和服务，页面后迁 |
| 统计报表 | `web/statistics`、`web/export/script` | 统计、Excel/PDF/Jasper 导出 | JSP 脚本 + 后端导出类 | 建议统一导出任务和模板 |
| 修复工具 | `web/fix`、`web/fix/tools`、`web/fix/test` | 一次性修数、重跑任务、导出备份、服务启动、队列排查 | 裸 JSP 工具页 | 风险最大，应收成受控后台：权限、审计、预览、日志 |
| 数字中枢管理 | `web/department/office/campus/DataHub` | 大屏配置、加密 `school_id` 启动静态大屏 | JSP 内 Vue3 + Element Plus | 可抽启动参数 helper，不能和静态大屏混成一页 |
| 数字中枢大屏 | `web/digitalHub` | 首页、学生综评、班级综评、日榜、图片配置等静态展示 | HTML + Vue3 + Axios + ECharts | 保持展示层独立；数据适配器可收口 |
| 静态资源 | `web/Res` | CSS、JS、字体、图标、Avalon/jQuery/Element Plus 等 | 静态库 | 新页面先复用全局样式和 `vue_config.css`，少写局部覆盖 |

## 6. 移动端 / 微信 / H5 模块表

| 模块 | 路径 | 定位 | 技术形态 | 简化判断 |
| --- | --- | --- | --- | --- |
| 微信登录授权 | `web/weixin/authLogin.jsp`、`web/weixin/toLogin.jsp`、`web/weixin/common/checkLogin.jsp` | OAuth、token 登录、角色分流 | JSP + Session + 后端登录工具 | 先收入口路由表，别继续散落跳转判断 |
| 微信新版 V2 | `web/weixin/wechat/v2`、`web/weixin/wechat/wechat/v2` | 新移动端主壳 | Vue3 + Vue Router + Vant + Axios | 新功能优先进 V2 |
| 微信旧版 dist | `web/weixin/wechat/dist`、`web/weixin/wechat/wechat/dist` | 旧移动端主壳 | 老 Vue/Webpack 包，混 VUX/Vant2 | 标记为遗留，先确认真实入口再迁移 |
| 微信旧 JSP 页面 | `web/weixin/wechat/views`、`web/weixin/wechat/public` | 早期微信页面 | JSP/HTML + SeaJS + jQuery/Zepto | 通知/问卷/报修/消息可优先迁到 V2 |
| 微信 JSP 服务接口 | `web/weixin/service/ajax`、`web/weixin/service/post`、`web/weixin/service/pay` | 旧页面数据接口、支付、报修、评论 | JSP 接口 | 逐步迁 Spring Controller，保留兼容入口 |
| 老 App H5 | `web/h5/app` | App 内嵌通知、作业、成绩 | JSP + token + SeaJS | 可降级为兼容层，后续导到统一移动端壳 |
| 新移动端后端 | `src/com/app/mvc`、`src/com/app/mvc/util` | `/app/*`、`/wechat/*` API、菜单、个人信息 | Spring MVC | 权限以菜单接口/后端判断为准，前端 `meta.roles` 只做体验 |

## 7. 主要业务功能域表

| 业务域 | 主要功能 | 前端入口 | 后端线索 | 重叠/合并可能 |
| --- | --- | --- | --- | --- |
| 综合素质/评价 | 综评配置、评价记录、积分、荣誉、学生画像、班级/教师评价、报表 | `web/department/dyc/zh`、`web/teacher/zh`、`web/student/zh`、`web/department/jiaow/shzp`、`web/teacher/ktpj` | `ZhScoreController`、`ZhpjReportController`、`ZhpjEvalController`、`ZhHonorController`、`ZhController`、`DyRateController`、`CoursePJController`、`ZhAjax`、`PjAjax` | 高。抽“评价核心：项目、记录、积分、荣誉、报表”，前端保留场景壳 |
| 考勤/请假 | 考勤规则、日/周/月视图、补卡/补签、请假审批、班级/选修/教师考勤、通知催报 | `web/department/dyc/kq`、`web/teacher/kq`、`web/student/kq`、`web/space/classspace/kq`、`web/coursespace/checkon`、移动端 V2 | `KqController`、`KqH5Controller`、`KqDkController`、`KqAjax`、`KqLeaveAjax`、`TCheckonAjax`、`KqService`、`KqJob` | 高但高风险。先统一状态枚举、请假联动、通知钩子 |
| 通知/消息/红点 | 通知发布、阅读统计、评论、催阅、微信/APP 消息、红点 | `web/oa/notice`、`web/department/notice`、`web/weixin`、`web/h5/app/views/notice.jsp` | `NoticeController`、`NoticeAjax`、`AppNoticeUtils`、`NoticeUtils`、`NotifyService`、`NotifyMgr`、`RedPointJob` | 高。做统一消息中心：接收范围、已读统计、红点、微信推送 |
| 作业 | 发布、题型、提交、批改、评语、优秀作业、催交、附件上传 | `web/space/teachspace/homework`、`web/coursespace/homework`、`web/student/files/homework.jsp`、`web/h5/app/views/homework.jsp` | `HomeworkController`、`homeWorkH5Controller`、`SchHomeworkController`、`HomeWorkAjax`、`HomeworkService` | 中高。统一作业核心，保留课程空间/教学空间入口差异 |
| 课程/选修/课表 | 课程体系、选修发布、报名/退选、课程空间、课表、公开课、课程评价 | `web/department/jiaow/courseSystem`、`web/department/jiaow/selcourse`、`web/department/jiaow/xuanx`、`web/coursespace`、移动端选课 | `SelcourseController`、`SelCourseWebController`、`selCourseH5Controller`、`KbController`、`KbAjax`、`SelcourseUtils`、`CourseUtils` | 高。统一课程主数据、开课实例、名单、教师权限 |
| 班级/组织/人员权限 | 班级管理、年级班级、学生/教师导入、组织部门、空间权限、选择器 | `web/school/grade`、`web/department/jiaow/classSystem`、`web/space/classspace`、`web/department/org`、`web/common/selector` | `TclassAjax`、`ClassFenBanAjax`、`OrgAjax`、`SchoolClassAjax`、`OrgTeacherAjax`、`ClassUtils`、`OrgUtils`、`SpaceAuthAjax`、`DeptPowerService` | 很高。统一 scope/selector，否则每个模块继续各查各的 |
| 数字中枢 | 大屏配置、首页数据、综评大屏、班级综评、图片轮播、加密 `school_id` 启动 | `web/department/office/campus/DataHub`、`web/digitalHub` | `DigitalHubController`、`DigitalHubService`、`ZhpjReportController`、`ZhpjReportUtils` | 中。做“大屏展示层 + 数据适配器”，不并成普通页面 |
| 班主任手册 | 工作导览、自建工作单、派发工作单、部门汇总、模板、检查页、动态字段 | 当前源码 `web` 下不明显；部署线索在 `deploy/web/department/headmasterManual` | QA 记录 31 个 `/wbSheet/*`，如 `/wbSheet/getTeacherWorkList`、`/wbSheet/getWbCheck`、`/wbSheet/getTempInfo` | 中高。动态字段 mapper、模板、派发/检查可沉为通用工作单能力；需真实接口复核 |
| 导出/统计/报表 | Excel/PDF/Jasper 导出、考试统计、综评报表、选修导出、考勤导出、作业统计 | `web/export/script`、`web/statistics`、`web/department/jiaow/exam/count`、`web/department/jiaow/sydx` | `ExamExportController`、`XuanXuExportController`、`JyExportController`、`StatisticService`、`JasperPrintServlet` | 高。统一导出任务、模板、权限、文件生成队列 |
| 报修/维修工单 | 用户报修、部门受理、转派、完成、评价、微信端报修 | `web/oa/repairs`、`web/weixin/wechat/views/profile/repair_*`、`web/weixin/service/post/repair` | `RepairsAjax`、`RepairsUtils`、`RepairJob`、`RepairMsg`、`GadRepairMsg` | 中。可共享流转、附件、通知能力，但业务对象不要硬合 |
| 问卷/测评/投票 | 问卷、投票、测评、发布和统计 | `web/oa/examen`、`web/oa/vote`、移动端旧页面/V2 | `WXExamenController`、`ExamenAjax`、`Vote*` 线索 | 中。调查类模型可抽，但和考试/成绩不要混 |
| 文件/附件/相册 | 普通文件、头像、相册、富文本图片、空间图片、OSS 同步 | `web/common/upload`、`web/user/upload`、`web/department/avatar`、`web/ueditor`、`web/Res/js/uploadify*` | `src/com/upload`、`src/com/album/upload`、`UploadController`、`WXH5UploadController`、`OssService` | 高。统一扩展名、大小、OSS、附件表写入和权限校验 |
| 即时通讯/消息 | IM UI、WebSocket、消息历史 | `web/im`、`src/com/im` | `NwsListener`、`ImAjax`、`TIm*` 实体 | 中。先和通知/红点明确边界 |
| 运维/修复工具 | 一次性修数、补任务、重跑 job、导出备份、下载文件、队列排查 | `web/fix`、`web/fix/tools`、`web/fix/test` | `KqJob`、`ZhJob`、`ZhHonorJob`、`RateJob`、`RepairJob`、`NotifyService` 等 | 高。不是合业务，是收口成受控后台，裸 JSP 很危险 |

## 8. 已发现的重复建设点

| 重复点 | 现象 | 建议 |
| --- | --- | --- |
| fix/export 同名脚本 | `web/fix/tools` 与 `web/export/script` 有同名但不同内容的导出/下载脚本 | 先清单化归属：正式导出进 `web/export/script`，修复脚本进受控后台或标记废弃 |
| `deploy/web` 补丁区 | `deploy/web` 有不少文件在 `web` 下没有对应或内容不同 | 先做补丁对账，确认是否并回主源码；不要把 deploy 当主源码 |
| 考勤多套入口 | PC 后台、教师、学生、班级空间、课程空间、微信 H5 都有考勤/请假 | 先统一服务和状态，不先合页面 |
| 评价/积分/荣誉多套实现 | 德育综评、课堂评价、荣誉、数字中枢报表命名混杂 | 抽评价核心模型和报表适配器 |
| 通知/红点多套实现 | OA、App、微信、红点、各业务催办各自处理 | 统一消息中心和接收范围模型 |
| 上传能力重复 | CommonUpload、AvatarUpload、albumUpload、spaceUpload、dataUpload、UploadController、WXH5UploadController 并存 | 抽 UploadService，保留兼容入口 |
| 队列服务生命周期重复 | OSS/PDF/Notify/KQ/MQ/Statistic/ImgCompress 都有类似线程/handler/service 模式 | 抽 WorkerService/Lifecycle 模板 |
| 微信产物多套 | `v2`、`dist`、旧 JSP、`h5/app`、PDF viewer 多套产物并存 | 先确认真实部署映射，再定唯一来源 |
| 组织/权限/选择器重复 | school/org、sys/org、department/org、common selector 多份 | 统一 scope/selector API 和组件 |
| 配置重复 | `conf/cloud*` 多环境 web/spring/hibernate 配置散落 | 公共配置模板化，环境差异放 properties |

## 9. 可简化合并的业务清单

> 这里的“合并”不是把页面揉成一个页面。这个项目页面入口太多，直接合页面容易炸。优先合并的是业务模型、接口服务、状态枚举、权限范围、通知/附件/导出这些底层能力；页面只保留角色和场景差异。

| 优先级 | 可合并业务/能力 | 建议合并成 | 现在分散在哪里 | 为什么能更简单 | 合并边界 |
| --- | --- | --- | --- | --- | --- |
| P0 | 通知、消息、红点、催办、微信/APP 推送 | 统一消息中心 | `web/oa/notice`、`web/department/notice`、`web/weixin`、`web/h5/app/views/notice.jsp`、作业催交、考勤催办、报修提醒、问卷/投票提醒 | 本质都是“谁发给谁、什么内容、是否已读、是否提醒、是否推送” | 合接收范围、已读统计、红点、推送；不同业务只传业务类型和跳转地址 |
| P0 | 上传、附件、头像、相册、富文本图片、空间图片、H5 上传、OSS 同步 | 统一附件/上传服务 | `web/common/upload`、`web/user/upload`、`web/department/avatar`、`web/ueditor`、`web/Res/js/uploadify*`、`src/com/upload`、`src/com/album/upload`、`UploadController`、`WXH5UploadController`、`OssService` | 都是在校验文件、落临时/正式目录、写附件记录、同步 OSS、返回访问地址 | 保留旧 URL 兼容，内部统一扩展名、大小、权限、OSS、附件表写入 |
| P0 | 导出、统计报表、PDF/Excel 生成、下载脚本 | 统一导出任务平台 | `web/export/script`、`web/fix/tools`、考试导出、综评报表、选修导出、考勤导出、作业统计 | 本质都是“按权限取数据 -> 套模板/字段 -> 生成文件 -> 下载/缓存/清理” | 先合任务、权限、文件生成、模板管理；各业务保留自己的查询参数 |
| P0 | 组织、班级、学期、教师、学生、部门、人员选择器、权限范围 | 统一 scope/selector 服务 | `web/school/org`、`web/sys/org`、`web/department/org`、`web/common/selector`、各业务自己的班级/学生/教师查询 | 几乎每个业务都重复查同一批范围数据，重复又容易权限错 | 合范围计算和选择器 API；业务只声明需要的范围类型 |
| P1 | 考勤、请假、补卡/补签、教师考勤、学生考勤、班级考勤、选修课考勤 | 统一考勤域 | `web/department/dyc/kq`、`web/teacher/kq`、`web/student/kq`、`web/space/classspace/kq`、`web/coursespace/checkon`、`KqController`、`KqH5Controller`、`KqAjax`、`KqService` | 都围绕“人员、日期、班级/课程、考勤状态、异常、请假抵扣、通知” | 先合状态枚举、请假联动、统计口径；页面和角色入口不要先合 |
| P1 | 综评、课堂评价、德育积分、荣誉、学生画像、学期报告、数字中枢综评数据 | 统一评价核心 | `web/department/dyc/zh`、`web/teacher/zh`、`web/student/zh`、`web/department/jiaow/shzp`、`web/teacher/ktpj`、`Zhpj*`、`Zh*`、`DyRate*` | 本质都是“评价项目/指标、评价对象、评价记录、积分/等级、荣誉、报表展示” | 合评价记录、指标、积分、荣誉、报表适配；课堂评价/德育/综评保留场景名 |
| P1 | 课程、选修、课表、课程空间、课程考勤、课程评价、课程名单 | 统一课程实例模型 | `web/department/jiaow/courseSystem`、`web/department/jiaow/selcourse`、`web/department/jiaow/xuanx`、`web/coursespace`、`selCourseH5Controller`、`KbController` | 都依赖课程、开课、教师、学生名单、时间地点、报名/退选、评价/考勤 | 合课程主数据、开课实例、名单、教师权限；课程空间页面可以继续独立 |
| P1 | 作业、资料收集、任务填报、问卷式提交、班主任手册工作单动态字段 | 统一“任务/表单提交”能力 | `web/space/teachspace/homework`、`web/coursespace/homework`、`web/oa/collect`、`TaskController`、`deploy/web/department/headmasterManual`、`/wbSheet/*` | 都是“发起任务 -> 指定对象 -> 动态字段/附件 -> 提交 -> 查看/检查/统计” | 合动态字段 mapper、附件、提交状态、对象范围；作业和工作单的业务语义不要硬合 |
| P1 | 报修、班主任手册工作单、OA 流程、待办任务 | 统一工单/流转底座 | `web/oa/repairs`、`web/department/dyc/ts`、`deploy/web/department/headmasterManual`、`TaskController`、`RepairsAjax` | 都有发起、指派、处理、完成、评价/检查、通知、附件 | 只合流转、通知、附件、状态机；维修、成长记录、手册工作单仍是不同业务 |
| P2 | 问卷、投票、测评、调查类表单 | 统一调查/投票引擎 | `web/oa/examen`、`web/oa/vote`、`WXExamenController`、微信旧页面 | 都是题目、选项、对象范围、提交、统计 | 可以合题型、发布对象、统计；不要和正式考试成绩分析硬合 |
| P2 | 数字中枢、统计报表、综评报表、大屏图片配置 | 统一数据适配层 | `web/department/office/campus/DataHub`、`web/digitalHub`、`/digitalHub/*`、`/zhpj/report/*` | 大屏只是展示层，数据来自综评、班级、课程、图片配置 | 只合数据适配和启动参数；大屏页面保持独立 |
| P2 | 修复脚本、补数据脚本、重跑 job、导出备份 | 受控运维任务后台 | `web/fix/tools`、`web/fix/test`、`src/com/job`、`src/com/service` | 裸 JSP 修数风险太大，很多脚本只是参数不同 | 合权限、参数校验、预览、执行日志、回滚说明；不要直接删历史脚本 |
| P2 | 微信登录、App H5 登录、角色分流、菜单权限 | 统一移动端入口/菜单服务 | `web/weixin/authLogin.jsp`、`web/weixin/toLogin.jsp`、`web/weixin/wechat/v2`、`web/weixin/wechat/dist`、`web/h5/app`、`ProfileUtils` | 都在做身份识别、角色判断、跳转菜单 | 合登录成功后的路由表和菜单接口；旧 dist/H5 先兼容再迁移 |

### 最应该先合的 5 个

| 排名 | 合并项 | 原因 |
| --- | --- | --- |
| 1 | 通知/消息/红点 | 横跨所有业务，模型清楚，收益最大 |
| 2 | 上传/附件/OSS | 重复入口最多，安全和权限风险明显 |
| 3 | 导出/报表任务 | `fix` 和 `export` 已经出现同名分叉，最容易改错 |
| 4 | 组织/班级/学期/人员范围 | 所有业务都依赖，不统一就会一直复制 |
| 5 | 考勤/请假状态 | 重复度高，但风险也高，适合先合状态和服务，不先合页面 |

### 暂时不要硬合的

| 业务 | 原因 | 正确做法 |
| --- | --- | --- |
| `base.jsp` 和 `ebase.jsp` | 老 Avalon 体系和 Vue3/Element Plus 体系不同，硬合会污染两边 | 保持双基准，只统一颜色、间距、组件使用规则 |
| 数字中枢页面和普通后台页 | 大屏是展示层，启动参数和展示比例都特殊 | 合数据适配，不合页面形态 |
| 班主任手册和报修/任务 | 可以共享工单底座，但业务字段、权限、检查逻辑不同 | 合流程/附件/通知/动态字段，不合业务名义 |
| 微信旧 `dist`、新版 `v2`、老 `h5/app` | 真实部署映射没确认前，删错就是线上事故 | 先确认入口，再把新功能只放 V2，旧入口逐步降级 |
| 考试成绩分析和问卷测评 | 名字都像“测评”，但成绩分析有严肃统计和权限边界 | 只复用题型/导出能力，不合核心业务 |

## 10. 合并简化方案

### 方案 A：保守清点型，P0-P1

不动业务逻辑，先定入口归属、减少改错地方。

| 动作 | 涉及路径 | 收益 | 风险 |
| --- | --- | --- | --- |
| fix/export 同名脚本清单化 | `web/fix/tools`、`web/export/script` | 快速减少“修了 A 漏了 B” | 不减少代码量 |
| deploy 补丁对账 | `deploy/web`、`web` | 找出未并回主干的页面/资源 | 需要人工确认哪些是线上真实补丁 |
| 微信产物归属标记 | `web/weixin/wechat/v2`、`web/weixin/wechat/dist`、`web/weixin/wechat/wechat/*` | 避免误删线上入口 | 需要部署映射确认 |
| 基础入口索引 | `web/base.jsp`、`web/ebase.jsp`、各大业务目录 | 给后续开发明确“该看哪里” | 没有立刻业务收益 |

适合场景：近期仍在频繁修 bug，不能承受大范围回归。推荐先做，最稳。

### 方案 B：中等收口型，P1-P2

保留现有 JSP/Controller URL，抽公共服务内核，让旧入口调用同一套能力。

| 动作 | 涉及路径 | 收益 | 风险 |
| --- | --- | --- | --- |
| 上传附件公共层 | `src/com/upload`、`src/com/album/upload`、`UploadController`、`WXH5UploadController`、`OssService` | 统一文件大小、类型、OSS、附件表写入 | 需覆盖头像、相册、富文本、H5 等边界 |
| 通知消息中心 | `NoticeController`、`NoticeAjax`、`NotifyService`、`RedPoint*` | 统一接收范围、已读统计、红点、微信推送 | 会影响多业务催办 |
| 考勤服务拆分 | `KqService`、`KqH5Service`、`KqController`、`KqAjax` | 统一请假、打卡、统计、通知联动 | 现有类巨大，必须分功能灰度 |
| 综评核心模型 | `ZhScoreUtils`、`ZhpjReportUtils`、`ZhHonorService`、`ZhAjax` | 统一评价项目、记录、积分、荣誉、报表 | 学校配置和历史字段复杂 |
| 队列生命周期模板 | `src/com/service/*`、`src/com/job/*` | 减少 OSS/PDF/通知/考勤等后台线程复制代码 | 需要启动/停止/异常重试验证 |

适合场景：要降低后续需求成本，但暂时不重做页面。推荐作为主路线。

### 方案 C：激进迁移型，P2-P3

统一技术路线，逐步淘汰旧 JSP 临时入口和多套 H5 产物。

| 动作 | 涉及路径 | 收益 | 风险 |
| --- | --- | --- | --- |
| 移动端统一到 V2 壳 | `web/weixin`、`web/h5/app`、`src/com/app/mvc` | 移动端入口清晰，新功能不再分叉 | 需要微信环境、角色权限、真实菜单回归 |
| 老 JSP 迁 Vue3 | `web/teacher`、`web/student`、`web/department/dyc/zh`、`web/department/jiaow` | 长期减少页面维护成本 | 老页面有学校特例，必须逐页迁 |
| 修复脚本后台化 | `web/fix/tools`、`src/com/job`、`src/com/service` | 降低裸 JSP 修数风险，有审计/预览/权限 | 需要运维流程配合 |
| 导出任务平台化 | `web/export`、`src/com/ajax/mvc/*Export*`、`src/com/service/statistic` | 模板、权限、异步文件生成统一 | 文件格式兼容要逐项验 |
| 数据访问规范化 | `QueryUtil`、Hibernate DAO、Druid 多数据源 | 新代码路径清楚 | 老 SQL 迁移风险高，只能新旧共存过渡 |

适合场景：有较长窗口、能做灰度、能拿到真实数据和完整回归资源。不能一口吃，项目会噎死。

## 11. 推荐落地顺序

1. 先做 `deploy/web` 对账，确认未合并补丁和真实线上入口。
2. 再收 `web/fix/tools` 与 `web/export/script`，先管住修复/导出这类高风险高重复区域。
3. 然后统一上传/附件和通知/红点，这两块横跨业务多，但公共模型相对清楚。
4. 接着做组织/班级/学期 scope 和 selector 统一，不然每个功能都会继续复制查询。
5. 考勤、综评最后动，先拆服务和状态，别直接迁页面。
6. 微信 H5 先确认部署映射和真实入口，再决定旧 `dist`、旧 JSP、`h5/app` 的降级或迁移。
7. 数字中枢保持展示层独立，只收数据适配器和启动参数。
8. 班主任手册按 QA 与真实 `/wbSheet/*` 接口复核后再纳入通用工作单模型。

## 12. 后续开发默认规则

| 场景 | 默认动作 |
| --- | --- |
| 新 PC 页面 | 先看 `web/ebase.jsp` 和同模块 Vue3 页面；没有覆盖再局部写样式 |
| 老 JSP/Avalon 页面 | 先看 `web/base.jsp` 和同类老页面，不往里硬塞 Vue3 写法 |
| 样式判断 | `base.jsp/ebase.jsp` -> 同模块/同类型页面 -> `web/Res/css/lqt_color.css`、`web/Res/css/vue_config.css` -> 局部 override |
| 接口字段 | 真实 Network/源码行为优先，导出文档/RP/mock 不能盲信 |
| 权限/状态 | 后端字段优先，不按日期、行号、当前学期在前端硬猜 |
| 保存/删除/上传/提交 | 默认停在提交前，除非用户明确确认真实执行 |
| 修一个 bug | 顺手扫同接口、同状态、同跳转链，别在同一个坑里摔第二次 |

## 13. 未验证与风险

| 项目 | 状态 |
| --- | --- |
| 构建 | 未执行 `ant`，本文是静态结构梳理 |
| 运行 | 未启动 Tomcat，未浏览器访问 |
| 接口 | 未调用本地/测试/生产接口 |
| 数据库 | 未连接数据库，未验证表结构和真实数据 |
| 线上映射 | 未验证 Nginx/Tomcat 真实部署映射，尤其微信产物与 `deploy/web` |
| 远端 master | 本地 `master` 落后 `origin/master` 2 个提交，未拉取远端最新内容 |

## 14. 关键证据路径

| 类型 | 路径 |
| --- | --- |
| 构建 | `build.xml`、`package.json` |
| 环境配置 | `conf/test`、`conf/cloud1`、`conf/cloud2`、`conf/cloud3`、`conf/cloud4` |
| Web 初始化 | `conf/*/web.xml`、`src/com/lqtedu/spring/conf/WebInitializer.java`、`src/com/lqtedu/spring/conf/WebConfig.java` |
| Spring/Hibernate | `conf/*/spring.xml`、`conf/*/spring-hibernate.xml`、`src/com/entity` |
| PC 基准 | `web/base.jsp`、`web/ebase.jsp`、`web/Res` |
| 部门后台 | `web/department/jiaow`、`web/department/dyc`、`web/department/office`、`web/department/org` |
| 角色端 | `web/teacher`、`web/student`、`web/parent`、`web/school`、`web/user` |
| 移动端 | `web/weixin`、`web/h5/app`、`src/com/app/mvc` |
| 数字中枢 | `web/department/office/campus/DataHub`、`web/digitalHub`、`qa/数字中枢结构速记.md` |
| 班主任手册 | `deploy/web/department/headmasterManual`、`qa/班主任手册-真实接口整合.md` |
| 导出/修复 | `web/export/script`、`web/fix/tools` |
| 后端业务 | `src/com/ajax`、`src/com/ajax/mvc`、`src/com/app/mvc`、`src/com/service`、`src/com/job` |
