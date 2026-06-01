# LQTedu 页面入口和导航方式地图（AI 用）

## 结论

这份文档给 AI 使用，用来判断 LQTedu 页面应该怎么到达：哪些可以登录后直链，哪些必须先进顶部栏目或左侧菜单，哪些必须先进“我的部门”设置当前部门，哪些只能从列表、记录、流程上一步或按钮进入。

解析基准：local master 5d06517d，本地分支已切到 `master`，但本地 `master` 当前落后 `origin/master` 34 个提交；未执行 `git pull`。

静态范围：`D:\software\lqtedu\lqtedu\web` 下 2713 个 JSP/HTML/HTM 页面候选。

运行时证据：使用 Chrome 登录 `https://gz.lqtedu.com` 的教师账号 `swbj`，抽取当前账号可见顶部/左侧菜单；运行时菜单只代表该账号权限，不代表所有学校和所有角色。

## 使用口径

- 先看“全局入口规则”，再看“目录级规则”，最后查“全量页面索引”。
- 文档中的“直链可尝试”不是承诺无权限；老系统很多页面靠 Session、当前学期、当前部门、当前孩子、当前空间 ID 或查询参数工作。
- 页面如果进入 `inc/error/nonFunc.jsp`，优先按菜单链重新进入，不要直接判定页面失效。
- `department/*` 页面不等于都要手点“我的部门”，但凡页面带 `top-active=dept`、依赖 `curDept`、或走 `t_school_funcs/t_dept_funcs` 权限，就先走部门链路。
- `fix/*`、`export/*`、`ajax/*`、`inc/*`、`common/*` 默认不是普通页面入口，必须先找触发它们的业务页。

## 全局入口规则

| 入口/动作 | URL/代码入口 | AI 点击方式 |
| --- | --- | --- |
| 登录入口 | /login.jsp | 打开后输入账号；成功后通常跳 `/toPage.jsp` 或角色首页。 |
| 统一首页跳转 | /toPage.jsp | 按角色跳转：教师 `/teacher/tea-index.jsp`，学生 `/student/stu-index.jsp`，家长 `/parent/par-index.jsp`，管理员 `/cloud/index.jsp`。 |
| 教师首页 | /teacher/tea-index.jsp | 顶部“首页”；首页卡片可进入班级空间、教学空间、专项空间、日程、通知、事务。 |
| 学生首页 | /student/stu-index.jsp | 学生登录后由 `/toPage.jsp` 跳转；顶部“首页”。 |
| 家长首页 | /parent/par-index.jsp | 家长登录后由 `/toPage.jsp` 跳转；依赖当前孩子上下文。 |
| 我的班级 | /school/grade/classView.jsp | 顶部“我的班级”；左侧再点班级空间、班级信息、学生综合评价、考勤、档案等。 |
| 社团选修 | /department/mycourse/myselcourse/list.jsp | 顶部“社团选修”；左侧含社团选修空间、课程、名单、创新实践课题等，部分入口动态计算课程空间 ID。 |
| 我的教学 | /teacher/teach-go.jsp | 顶部“我的教学”；左侧含教学空间、课表、成绩管理、课堂评价。 |
| 我的应用 | /user/headupload.jsp | 顶部“我的应用”；左侧含日程、便笺、报修、预约、打印、工资、请假、考勤、个人设置等，依权限显示。 |
| 我的事务 | /oa/notice/myListNotice.jsp | 顶部“我的事务”；左侧含通知、事务、公文、问卷、投票。 |
| 我的部门 | /inc/page/toMyDept.jsp?DEPT=<encoded dept 或 MY_TRANS> | 必须设置当前部门会话后进 `/department/index.jsp`；部门页签/左侧菜单由数据库权限渲染。 |
| 部门切换 | /inc/page/toIndex.jsp?DEPT=<encoded>&DEPT_NAME=<name> | 点击部门条 `neck.jsp` 的部门名，写入 `curDeptCode/curDeptName` 后跳 `/department/index.jsp`。 |
| 集团入口 | /inc/page/toOrgDeptIndex.jsp | 有 `orgId` 时顶部“集团”；进入集团用户模式，再按 `org_neck.jsp` 切部门或切换用户/管理身份。 |

## 部门链路规则

- 顶部“我的部门”在 `web/inc/page/head.jsp` 中生成，教师有部门权限时链接到 `/inc/page/toMyDept.jsp?DEPT=<encoded dept>`。
- `/inc/page/toMyDept.jsp` 校验 `DEPT` 是否在 `SessionParam.getDeptArray()` 内，合法则跳 `/department/index.jsp`，否则跳 `/inc/error/nonFunc.jsp`。
- `/inc/page/toIndex.jsp` 是部门切换器，接收 `DEPT`、`DEPT_NAME`，写入 `curDeptCode/curDeptName` 后跳 `/department/index.jsp`。
- `/department/index.jsp` 包含 `head.jsp`、`neck.jsp`、`body-left.jsp`；`neck.jsp` 上方部门条负责切换当前部门，右侧“通知/日程/公文/问卷/投票/资料/收集/权限”按当前部门 OA 权限显示。
- 部门左侧业务菜单不是硬编码完整清单，来自 `src/com/tree/LeftFuncUtils.java` 查询 `t_dept_funcs`、`t_school_funcs`、`t_teacher_grant_funcs` 后渲染 `left.getLeftMenu()`。没有数据库权限时，源码只能给出“这页属于哪个部门/哪个 active id”，不能证明某账号必定可见。

## 当前账号运行时可见菜单样本

| 采集页 | 区域 | li id | 可见文本 | 目标路径 |
| --- | --- | --- | --- | --- |
| 教师首页 | page |  | 2024年8月23日更新公告 | /cloud/school/showNotice.jsp |
| 教师首页 | page |  | 我 | /user/headupload.jsp |
| 教师首页 | page |  | 退出 | /logout.jsp |
| 教师首页 | top | index | 首页 | /toPage.jsp |
| 教师首页 | top | class | 我的班级 | /school/grade/classView.jsp |
| 教师首页 | top | course | 社团选修 | /department/mycourse/myselcourse/list.jsp |
| 教师首页 | top | teach | 我的教学 | /teacher/teach-go.jsp |
| 教师首页 | top | dept | 我的部门 | /inc/page/toMyDept.jsp?DEPT=MY_TRANS |
| 教师首页 | top | apply | 我的应用 | /user/headupload.jsp |
| 教师首页 | top | affair | 我的事务 | /oa/notice/myListNotice.jsp |
| 教师首页 | page |  | 我的信息 | /user/headupload.jsp |
| 教师首页 | left |  | 初二1班 | /space/classspace/index.jsp?classId=A13688 |
| 教师首页 | left |  | 初二3班 | /space/classspace/index.jsp?classId=A13690 |
| 教师首页 | left |  | 初三1班 | /space/classspace/index.jsp?classId=A13692 |
| 教师首页 | left |  | ．．． | /school/grade/classView.jsp |
| 教师首页 | left |  | 我的社团选修 | /department/mycourse/myselcourse/list.jsp |
| 教师首页 | left |  | 初二语文啊啊？？ | /space/teachspace/index.jsp?spaceId=A12247 |
| 教师首页 | left |  | 专项空间 | /space/specialspace/manager/specialEnter.jsp |
| 教师首页 | left |  | 校园风采`2 | /space/specialspace/index.jsp?OBJECT_ID=A10332 |
| 教师首页 | left |  | 失物招领晒米在 | /space/specialspace/index.jsp?OBJECT_ID=A10334 |
| 教师首页 | left |  | chrisceshi | /space/specialspace/index.jsp?OBJECT_ID=A10699 |
| 教师首页 | left |  | ．．． | /space/specialspace/manager/specialEnter.jsp |
| 教师首页 | page |  | 我的日程 | /oa/calendar/cal.jsp |
| 教师首页 | page |  | 通知 | /oa/notice/myListNotice.jsp |
| 教师首页 | page |  | 测试图是否模糊 | /oa/notice/myViewNotice.jsp?fromtype=1&noticeId=A14715 |
| 教师首页 | page |  | test | /oa/notice/myViewNotice.jsp?fromtype=1&noticeId=A14706 |
| 教师首页 | page |  | 热乎乎 | /oa/notice/myViewNotice.jsp?fromtype=1&noticeId=A14698 |
| 教师首页 | page |  | 飞飞飞 | /oa/notice/myViewNotice.jsp?fromtype=1&noticeId=A14697 |
| 教师首页 | page |  | 事务提醒 | /department/dyc/task/myTaskList.jsp |
| 教师首页 | page |  | 1x公开课 | /space/teachspace/PreLession/openCourseAudit.jsp?type=un&adultId=A10386 |
| 教师首页 | page |  | 2公开课 | /space/teachspace/PreLession/openCourseAudit.jsp?type=un&adultId=A10385 |
| 教师首页 | page |  | xx公开课 | /space/teachspace/PreLession/openCourseAudit.jsp?type=un&adultId=A10384 |
| 教师首页 | page |  | 3公开课 | /space/teachspace/PreLession/openCourseAudit.jsp?type=un&adultId=A10383 |
| 我的班级 | page |  | 2024年8月23日更新公告 | /cloud/school/showNotice.jsp |
| 我的班级 | page |  | 我 | /user/headupload.jsp |
| 我的班级 | page |  | 退出 | /logout.jsp |
| 我的班级 | top | index | 首页 | /toPage.jsp |
| 我的班级 | top | class | 我的班级 | /school/grade/classView.jsp |
| 我的班级 | top | course | 社团选修 | /department/mycourse/myselcourse/list.jsp |
| 我的班级 | top | teach | 我的教学 | /teacher/teach-go.jsp |
| 我的班级 | top | dept | 我的部门 | /inc/page/toMyDept.jsp?DEPT=MY_TRANS |
| 我的班级 | top | apply | 我的应用 | /user/headupload.jsp |
| 我的班级 | top | affair | 我的事务 | /oa/notice/myListNotice.jsp |
| 我的班级 | left | class-space | 班级空间 | /space/classspace/classlist/myClassList.jsp |
| 我的班级 | left | class-view | 班级信息 | /school/grade/classView.jsp |
| 我的班级 | left | class-headmaster-manual | 班主任手册 | /department/headmasterManual/headmaster/guide.jsp |
| 我的班级 | left | class-sel-stu | 班级社团选修 | /department/mycourse/clsQuery/clsQueryList.jsp |
| 我的班级 | left | teach-class-dy | 星级班级评比 | /department/dyc/report/dyClsReport.jsp |
| 我的班级 | left | teach-class-sg | 本班宿舍 | /department/zongw/sg/tea/teaSgInfo.jsp |
| 我的班级 | left | teacher-examen | 问卷管理 | /oa/examen/listTeaPExamen.jsp |
| 我的班级 | left | teacher-cls-ktpj | 课堂评价报表 | /teacher/ktpj/cls/cls_tea_week_report.jsp |
| 我的班级 | left | class-cmaudit | 学生学期报告 | /department/jiaow/sydx/cls/auditClsStus_vue3.jsp |
| 我的班级 | left | class-files | 学生档案 | /teacher/files/stuFiles.jsp |
| 我的班级 | left | ts_studio | 导师工作室 | /teacher/ts/ts_studio.jsp |
| 我的班级 | page |  | 三abc1班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/index.jsp?classId=A13704 |
| 我的班级 | page |  | 三abc2班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/index.jsp?classId=A13705 |
| 我的班级 | page |  | 三abc3班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/index.jsp?classId=A13706 |
| 我的班级 | page |  | 三abc4班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/index.jsp?classId=A13707 |
| 我的班级 | page |  | 三abc5班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/index.jsp?classId=A13708 |
| 我的班级 | page |  | 三abc6班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/index.jsp?classId=A13709 |
| 我的班级 | page |  | 四1班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/classSpaceManger.jsp?classId=A13711 |
| 我的班级 | page |  | 四4班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/classSpaceManger.jsp?classId=A13713 |
| 我的班级 | page |  | 四5班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/index.jsp?classId=A13714 |
| 我的班级 | page |  | 四7班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/classSpaceManger.jsp?classId=A13716 |
| 我的班级 | page |  | 五2班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/index.jsp?classId=A13722 |
| 我的班级 | page |  | 六8班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/index.jsp?classId=A13733 |
| 我的班级 | page |  | 初二1班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/index.jsp?classId=A13688 |
| 我的班级 | page |  | 初二3班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/classSpaceManger.jsp?classId=A13690 |
| 我的班级 | page |  | 初三1班 | /school/grade/classView.jsp |
| 我的班级 | page |  | 空间 | /space/classspace/index.jsp?classId=A13692 |
| 社团选修 | page |  | 2024年8月23日更新公告 | /cloud/school/showNotice.jsp |
| 社团选修 | page |  | 我 | /user/headupload.jsp |
| 社团选修 | page |  | 退出 | /logout.jsp |
| 社团选修 | top | index | 首页 | /toPage.jsp |
| 社团选修 | top | class | 我的班级 | /school/grade/classView.jsp |
| 社团选修 | top | course | 社团选修 | /department/mycourse/myselcourse/list.jsp |
| 社团选修 | top | teach | 我的教学 | /teacher/teach-go.jsp |
| 社团选修 | top | dept | 我的部门 | /inc/page/toMyDept.jsp?DEPT=MY_TRANS |
| 社团选修 | top | apply | 我的应用 | /user/headupload.jsp |
| 社团选修 | top | affair | 我的事务 | /oa/notice/myListNotice.jsp |
| 社团选修 | left | teacher-xuanx | 社团选修课程 | /department/mycourse/myselcourse/list.jsp |
| 社团选修 | left | teacher-xuanx-user | 选修课程名单 | /department/mycourse/myselcourse/userList.jsp |
| 社团选修 | left | tea-issue-temp | 创新实践课题 | /teacher/issue/tea_my_issue.jsp |
| 社团选修 | page | tab_mySelcourse | 我的课程 | /department/mycourse/myselcourse/list.jsp |
| 社团选修 | page | tab_selcourseLib | 课程模板 | /department/mycourse/sellib/list.jsp |
| 社团选修 | page | tab_applyContent | 申报说明 | /department/mycourse/comment/info.jsp |
| 我的教学 | page |  | 2024年8月23日更新公告 | /cloud/school/showNotice.jsp |
| 我的教学 | page |  | 我 | /user/headupload.jsp |
| 我的教学 | page |  | 退出 | /logout.jsp |
| 我的教学 | top | index | 首页 | /toPage.jsp |
| 我的教学 | top | class | 我的班级 | /school/grade/classView.jsp |
| 我的教学 | top | course | 社团选修 | /department/mycourse/myselcourse/list.jsp |
| 我的教学 | top | teach | 我的教学 | /teacher/teach-go.jsp |
| 我的教学 | top | dept | 我的部门 | /inc/page/toMyDept.jsp?DEPT=MY_TRANS |
| 我的教学 | top | apply | 我的应用 | /user/headupload.jsp |
| 我的教学 | top | affair | 我的事务 | /oa/notice/myListNotice.jsp |
| 我的教学 | left | user-trans | 教学空间 | /space/teachspace/myTeachSpaces.jsp |
| 我的教学 | left | course-kb | 我的课表 | /department/jiaow/kb/teaKbView.jsp |
| 我的教学 | left | teach-exam-entry | 考试录入 | /teacher/exam/entry-list.jsp |
| 我的教学 | left | teach-small-entry | 小分录入 | /teacher/exam/small-list.jsp |
| 我的教学 | left | teach-exam-analyse | 考试分析 | /teacher/exam/count-list.jsp |
| 我的教学 | left | teach-test | 测验成绩 | /teacher/test/list.jsp |
| 我的应用 | page |  | 2024年8月23日更新公告 | /cloud/school/showNotice.jsp |
| 我的应用 | page |  | 我 | /user/headupload.jsp |
| 我的应用 | page |  | 退出 | /logout.jsp |
| 我的应用 | top | index | 首页 | /toPage.jsp |
| 我的应用 | top | class | 我的班级 | /school/grade/classView.jsp |
| 我的应用 | top | course | 社团选修 | /department/mycourse/myselcourse/list.jsp |
| 我的应用 | top | teach | 我的教学 | /teacher/teach-go.jsp |
| 我的应用 | top | dept | 我的部门 | /inc/page/toMyDept.jsp?DEPT=MY_TRANS |
| 我的应用 | top | apply | 我的应用 | /user/headupload.jsp |
| 我的应用 | top | affair | 我的事务 | /oa/notice/myListNotice.jsp |
| 我的应用 | left |  | 我的日程 | /oa/calendar/cal.jsp |
| 我的应用 | left |  | 我的便笺 | /user/note/myNote.jsp |
| 我的应用 | left | user-repairs | 我的报修 | /oa/repairs/myListRepairs.jsp |
| 我的应用 | left | user-venue | 我的预约 | /department/venue/myApplyVenue.jsp |
| 我的应用 | left | myapp-assets | 物资申领 | /teacher/assets/myApply.jsp |
| 我的应用 | left | myapp-print | 打印申请 | /teacher/print/myPrint.jsp |
| 我的应用 | left | myapp-salary | 我的工资 | /user/wage/myWageList.jsp |
| 我的应用 | left | myapp-leave | 我的请假 | /teacher/kq/leave/my_leave.jsp |
| 我的应用 | left | myapp-kq | 我的考勤 | /teacher/kq/leave/my_kq.jsp |
| 我的应用 | left | specialSpace | 专项空间 | /space/specialspace/manager/specialEnter.jsp |
| 我的应用 | left | usercfg-userinfo | 身份信息 | /user/userinfo.jsp |
| 我的应用 | left | usercfg-password | 修改密码 | /user/password.jsp |
| 我的应用 | left | usercfg-headpic | 设置头像 | /user/headupload.jsp |
| 我的应用 | left | usercfg-menuset | 个人偏好 | /user/cfg/userMenuSet.jsp |
| 我的事务 | page |  | 2024年8月23日更新公告 | /cloud/school/showNotice.jsp |
| 我的事务 | page |  | 我 | /user/headupload.jsp |
| 我的事务 | page |  | 退出 | /logout.jsp |
| 我的事务 | top | index | 首页 | /toPage.jsp |
| 我的事务 | top | class | 我的班级 | /school/grade/classView.jsp |
| 我的事务 | top | course | 社团选修 | /department/mycourse/myselcourse/list.jsp |
| 我的事务 | top | teach | 我的教学 | /teacher/teach-go.jsp |
| 我的事务 | top | dept | 我的部门 | /inc/page/toMyDept.jsp?DEPT=MY_TRANS |
| 我的事务 | top | apply | 我的应用 | /user/headupload.jsp |
| 我的事务 | top | affair | 我的事务 | /oa/notice/myListNotice.jsp |
| 我的事务 | left | user-notice | 通知 151 | /oa/notice/myListNotice.jsp |
| 我的事务 | left | user-trans | 事务 1847 | /department/dyc/task/myTaskList.jsp |
| 我的事务 | left | user-oa | 公文 46 | /oa/office/listOfficePerDo.jsp |
| 我的事务 | left | user-examen | 问卷 1 | /oa/examen/myListPExamen.jsp |
| 我的事务 | left | user-vote | 投票 | /oa/vote/myListPVote.jsp |
| 我的事务 | page |  | 测试图片压缩模糊 | /oa/notice/myViewNotice.jsp?noticeId=A14717 |
| 我的事务 | page |  | 啊啊啊 | /oa/notice/myViewNotice.jsp?noticeId=A14716 |
| 我的事务 | page |  | 测试图是否模糊 | /oa/notice/myViewNotice.jsp?noticeId=A14715 |
| 我的事务 | page |  | 待查看 | /oa/notice/myViewNotice.jsp?noticeId=A14715 |
| 我的事务 | page |  | 图片压缩了 | /oa/notice/myViewNotice.jsp?noticeId=A14714 |

## 静态页面统计

### 按业务域

| 业务域 | 页面数 |
| --- | --- |
| 部门-教务 | 592 |
| 空间 | 273 |
| 部门-德育 | 253 |
| 修复工具 | 235 |
| 我的事务/OA | 223 |
| 微信端 | 116 |
| 教师端 | 115 |
| 课程空间 | 82 |
| Res | 80 |
| html | 62 |
| 学生端 | 61 |
| 部门-办公室 | 58 |
| 集团/组织部门 | 48 |
| 部门-总务 | 48 |
| 公共框架/片段 | 46 |
| 学校/班级基础数据 | 45 |
| 公共组件/片段 | 42 |
| user | 42 |
| 部门功能 | 37 |
| H5 | 36 |
| cloud | 33 |
| 社团选修 | 20 |
| 导出脚本 | 19 |
| 家长端 | 17 |
| 预约/场地 | 14 |
| 数字中枢 | 10 |
| about | 9 |
| im | 9 |
| ajax | 8 |
| baseOAtab | 8 |
| ck | 7 |
| kq | 7 |
| 系统入口 | 6 |
| sys | 6 |
| builder | 4 |
| outsite | 4 |
| statistics | 4 |
| model | 3 |
| testParam | 3 |
| 基础模板 | 2 |
| applets | 1 |
| avalonTest.jsp | 1 |
| base-HugePageHeadCss.jsp | 1 |
| base-uploadPic.jsp | 1 |
| cache | 1 |
| del_queue_sql.jsp | 1 |
| digitalBaseAuth.jsp | 1 |
| ebase-Upload.jsp | 1 |
| fixZhEval.jsp | 1 |
| glyphion.jsp | 1 |
| gridstack | 1 |
| help | 1 |
| kq.jsp | 1 |
| lostpwd-app.jsp | 1 |
| luna | 1 |
| old.jsp | 1 |
| queue.jsp | 1 |
| table.jsp | 1 |
| tableAjax.jsp | 1 |
| test.jsp | 1 |
| testDir.jsp | 1 |
| toMobileSetup.jsp | 1 |
| total.jsp | 1 |
| ueditor | 1 |
| updateStuPower.jsp | 1 |
| updateYCB.jsp | 1 |

### 按访问类型

| 访问类型 | 页面数 |
| --- | --- |
| 部门上下文页 | 837 |
| 内部片段/API | 475 |
| 带参数页面 | 314 |
| 直链可尝试 | 275 |
| 修复/测试工具 | 235 |
| 参数/详情页 | 223 |
| 移动端/H5 | 127 |
| 菜单直达 | 102 |
| 流程步骤页 | 86 |
| 导出脚本 | 19 |
| 数字中枢 | 10 |
| 系统入口/重定向 | 6 |
| 部门/集团入口 | 4 |

## 目录级导航规则

- `teacher/*`：教师角色页面。顶层入口通常是 `/teacher/tea-index.jsp`、`/teacher/teach-go.jsp`，左侧菜单来自 `body-left.jsp` 的 `top-active=class/course/teach/apply/affair` 分支。
- `student/*`：学生角色页面。先 `/toPage.jsp` 进入 `/student/stu-index.jsp`，再按“我的班级/社团选修/我的学习/我的应用/我的事务”进入。
- `parent/*`：家长角色页面。依赖当前孩子上下文；孩子班级、孩子学习、孩子请假等实际复用学生端页面。
- `department/mycourse/*`：社团选修教师/学生/家长公共入口，多数可以顶部“社团选修”直达，课程空间页要从课程卡片点击拿 `curCourseId`。
- `department/jiaow/*`、`department/dyc/*`、`department/bgs/*`、`department/zongw/*`：部门功能页。优先走“我的部门”设置当前部门，再点左侧数据库菜单；详情/设置/导入/统计页多半要从上级列表进入。
- `department/org/*`：集团/组织部门页。先顶部“集团”或 `/inc/page/toOrgDeptIndex.jsp`，再按 `org_neck.jsp` 切“用户/管理”模式和组织部门。
- `oa/*`：我的事务/OA。个人侧可从顶部“我的事务”进入；部门侧通知/日程/公文/问卷/投票/资料/收集必须先处于当前部门。
- `school/*`：学校和班级基础数据。班级信息可从“我的班级”直达；管理类页面受学校/部门权限控制。
- `space/*`、`coursespace/*`：空间类页面通常依赖 `classId`、`spaceId`、`curCourseId`、`OBJECT_ID`，必须从首页卡片、班级/课程列表或空间列表点击进入。
- `digitalHub/*`：数字中枢静态大屏壳可直链，但真实数据需要来源管理页和参数，例如 `school_id`；不要只裸开 HTML 就判断业务正确。
- `weixin/*`、`h5/*`：移动端/微信入口，通常通过微信授权、token 或 H5 登录页进入，PC 顶部菜单不是主入口。
- `fix/*`：历史修复、测试、运维工具，危险性高；只有明确任务和环境确认时才直链。
- `inc/*`、`common/*`、`base-page/*`、`ebase-page/*`：页面片段、模板或公共组件，不作为业务页面单独点击。

## 全量页面索引

字段说明：`页面` 是相对 Web 根路径；`访问类型` 是 AI 的首选进入策略；`点击/到达方式` 是优先链路；`导航参数` 来自 JSP 的 `top-active/dept-left/dept-right/dept-id`；`疑似参数` 是源码读取的请求参数，只代表静态线索。

### 系统入口（6）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /authLogin.jsp |  | 系统入口/重定向 | 先打开上级列表/查询页，再点击记录进入；参数：schoolId |  | schoolId |  |
| /index.jsp | My JSP 'index.jsp' starting page | 系统入口/重定向 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /login.jsp | 绿蜻蜓云校园 | 系统入口/重定向 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 返回 @ /about/fu.html； 返回 @ /about/he.html； 返回 @ /about/index.html |
| /logout.jsp |  | 系统入口/重定向 | 源码菜单 /inc/page/head.jsp -> 退出 |  |  | 退出 @ /teacher/tea-index.jsp； 退出 @ /school/grade/classView.jsp； 退出 @ /department/mycourse/myselcourse/list.jsp |
| /toLogin.jsp |  | 系统入口/重定向 | 先打开上级列表/查询页，再点击记录进入；参数：token, userId, status |  | token, userId, status |  |
| /toPage.jsp |  | 系统入口/重定向 | 运行时 教师首页 top -> 首页 |  |  | 首页 @ /teacher/tea-index.jsp； 首页 @ /school/grade/classView.jsp； 首页 @ /department/mycourse/myselcourse/list.jsp |

### 教师端（115）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /teacher/assets/applyRecord.jsp | 申领记录 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 myapp-assets | top-active=apply; dept-left=myapp-assets |  | 申领记录 @ /teacher/assets/applyRecord.jsp； 申领记录 @ /teacher/assets/giveBackRecord.jsp； 申领记录 @ /teacher/assets/myApply.jsp |
| /teacher/assets/giveBackRecord.jsp | 归还记录 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 myapp-assets | top-active=apply; dept-left=myapp-assets |  | 归还记录 @ /teacher/assets/applyRecord.jsp； 归还记录 @ /teacher/assets/giveBackRecord.jsp； 归还记录 @ /teacher/assets/myApply.jsp |
| /teacher/assets/myApply.jsp | 我要申领 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的应用 left -> 物资申领 | top-active=apply; dept-left=myapp-assets |  | 物资申领 @ /user/headupload.jsp； 物资申领 @ /inc/page/body-left.jsp； 我要申领 @ /teacher/assets/applyRecord.jsp |
| /teacher/assets/myAssets.jsp | 我的物资 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 myapp-assets | top-active=apply; dept-left=myapp-assets |  | 我的物资 @ /teacher/assets/applyRecord.jsp； 我的物资 @ /teacher/assets/giveBackRecord.jsp； 我的物资 @ /teacher/assets/myApply.jsp |
| /teacher/exam/count-list-AQR.jsp | 学业质量报表 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 teach -> 左侧 teach-exam-analyse | top-active=teach; dept-left=teach-exam-analyse |  |  |
| /teacher/exam/count-list.jsp | 我的考试 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的教学 left -> 考试分析 | top-active=teach; dept-left=teach-exam-analyse | termId | 考试分析 @ /teacher/exam/entry-list.jsp； 成绩分析 @ /fix/test_body_left.jsp； 考试分析 @ /inc/page/body-left.jsp |
| /teacher/exam/entry-list.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的教学 left -> 考试录入 | top-active=teach; dept-left=teach-exam-entry |  | 考试录入 @ /teacher/exam/entry-list.jsp； 成绩录入 @ /fix/test_body_left.jsp； 考试录入 @ /inc/page/body-left.jsp |
| /teacher/exam/small-list.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的教学 left -> 小分录入 | top-active=teach; dept-left=teach-small-entry |  | 小分录入 @ /teacher/exam/entry-list.jsp； 小分录入 @ /fix/test_body_left.jsp； 小分录入 @ /inc/page/body-left.jsp |
| /teacher/exam/stuInfo.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 教师端页面/我的教学相关入口 |  |  |  |
| /teacher/exam/termInfo.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 teach -> 左侧 teach-exam-analyse | top-active=teach; dept-left=teach-exam-analyse |  | 学期总评快捷汇总 @ /teacher/exam/count-list.jsp |
| /teacher/exam/usually.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 平时成绩 | top-active=teach; dept-left=teach-test |  | 平时成绩 @ /fix/test_body_left.jsp； 平时成绩 @ /inc/page/body-left.jsp |
| /teacher/exam/viewByClass.jsp | 按班级查看 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 teach-exam-analyse | top-active=teach; dept-left=teach-exam-analyse | type |  |
| /teacher/exam/viewBySubject.jsp | 按科目查看 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 teach-exam-analyse | top-active=teach; dept-left=teach-exam-analyse | type |  |
| /teacher/files/editStuComment.jsp | 写寄语 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 class-files | top-active=class; dept-left=class-files | class_id, teacher_type, class_name, type_name |  |
| /teacher/files/importStuComment.jsp | 导入寄语 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 class-files | top-active=class; dept-left=class-files |  |  |
| /teacher/files/myCommentLib.jsp | 我的个人寄语库 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 class-files | top-active=class; dept-left=class-files | id, type, teacherType, LIMIT, from_page, classId, teaList |  |
| /teacher/files/stuComment.jsp | 学生寄语 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 class-files | top-active=class; dept-left=class-files |  |  |
| /teacher/files/stuFiles.jsp | 学生档案 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的班级 left -> 学生档案 | top-active=class; dept-left=class-files |  | 学生档案 @ /school/grade/classView.jsp； 学生档案 @ /fix/test_body_left.jsp； 学生档案 @ /inc/page/body-left.jsp |
| /teacher/issue/body-right-top.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：li |  | li |  |
| /teacher/issue/remarkList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 tea-issue-temp | top-active=course; dept-left=tea-issue-temp | ISSUE_ID |  |
| /teacher/issue/remarkMultFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 course -> 左侧 tea-issue-temp | top-active=course; dept-left=tea-issue-temp | REPORT_ID, CLASS_ID, STU_IDS, ISSUE_ID |  |
| /teacher/issue/remarkSingleFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 course -> 左侧 tea-issue-temp | top-active=course; dept-left=tea-issue-temp | STU_ID, ISSUE_ID |  |
| /teacher/issue/tea_issue_apply.jsp | 创新实践课题 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 tea-issue-temp | top-active=course; dept-left=tea-issue-temp | ID, TEMP_ID |  |
| /teacher/issue/tea_issue_approve.jsp | 创新实践课题 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 course -> 左侧 stu-issue-temp | top-active=course; dept-left=stu-issue-temp |  |  |
| /teacher/issue/tea_issue_auto_set.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 教师端页面/我的教学相关入口 |  |  | 自动选题 @ /department/jiaow/issue/jwc_issue_test_view.jsp； 自动选题 @ /student/issue/stu_issue_test_view.jsp； 自动选题 @ /teacher/issue/tea_issue_auto_set.jsp |
| /teacher/issue/tea_issue_detail.jsp | 创新实践课题 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 course -> 左侧 tea-issue-temp | top-active=course; dept-left=tea-issue-temp | ID |  |
| /teacher/issue/tea_issue_manual_set.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 教师端页面/我的教学相关入口 |  |  | 手动选题 @ /teacher/issue/tea_issue_auto_set.jsp； 手动选题 @ /teacher/issue/tea_issue_manual_set.jsp |
| /teacher/issue/tea_issue_temp.jsp | 创新实践课题 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 tea-issue-temp | top-active=course; dept-left=tea-issue-temp | SEA_NAME | 课题模板 @ /teacher/issue/body-right-top.jsp |
| /teacher/issue/tea_issue_test_view.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 教师端页面/我的教学相关入口 |  |  |  |
| /teacher/issue/tea_my_issue.jsp | 创新实践课题 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 社团选修 left -> 创新实践课题 | top-active=course; dept-left=tea-issue-temp | SEA_TERM_CODE | 创新实践课题 @ /department/mycourse/myselcourse/list.jsp； 创新实践课题 @ /fix/test_body_left.jsp； 创新实践课题 @ /inc/page/body-left.jsp |
| /teacher/issue/tea_remarkView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 course -> 左侧 tea-issue-temp | top-active=course; dept-left=tea-issue-temp | STU_ID, ISSUE_ID |  |
| /teacher/kq/day_view_vue3.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 一卡通考勤 | top-active=class; dept-left=kq-dayview |  | 一卡通考勤 @ /inc/page/body-left.jsp |
| /teacher/kq/day_view.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 源码菜单 /inc/page/body-left.jsp -> 考勤确认 | top-active=class; dept-left=kq-dayview_old |  | 考勤确认 @ /fix/test_body_left.jsp； 考勤确认 @ /inc/page/body-left.jsp |
| /teacher/kq/leave/add_leave_vue3.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 myapp-leave | top-active=apply; dept-left=myapp-leave |  |  |
| /teacher/kq/leave/add_leave.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 myapp-leave | top-active=apply; dept-left=myapp-leave |  |  |
| /teacher/kq/leave/my_kq.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的应用 left -> 我的考勤 | top-active=apply; dept-left=myapp-kq |  | 我的考勤 @ /user/headupload.jsp； 我的考勤 @ /fix/test_body_left.jsp； 我的考勤 @ /inc/page/body-left.jsp |
| /teacher/kq/leave/my_leave_view_vue3.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 myapp-leave | top-active=apply; dept-left=myapp-leave | leave_id |  |
| /teacher/kq/leave/my_leave_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 apply -> 左侧 myapp-leave | top-active=apply; dept-left=myapp-leave | leave_id |  |
| /teacher/kq/leave/my_leave.jsp | 我的请假 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的应用 left -> 我的请假 | top-active=apply; dept-left=myapp-leave |  | 我的请假 @ /user/headupload.jsp； 我的请假 @ /fix/test_body_left.jsp； 我的请假 @ /inc/page/body-left.jsp |
| /teacher/kq/leave/tea_approve_leave_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 affair -> 左侧 user-trans | top-active=affair; dept-left=user-trans | leave_id |  |
| /teacher/kq/leave/tea_approve_leave.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-trans | top-active=affair; dept-left=user-trans | leave_id |  |
| /teacher/kq/stu_view_vue3.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 考勤汇总 | top-active=class; dept-left=kq-stuview | class_id | 考勤汇总 @ /inc/page/body-left.jsp |
| /teacher/kq/stu_view.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 源码菜单 /inc/page/body-left.jsp -> 学生视图 | top-active=class; dept-left=kq-stuview_old |  | 学生视图 @ /fix/test_body_left.jsp； 学生视图 @ /inc/page/body-left.jsp； 学生视图 @ /teacher/kq/week_view.jsp |
| /teacher/kq/studentLeave/body-right-top.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：li, tag |  | li, tag |  |
| /teacher/kq/studentLeave/handle_leave.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 jiaow-jx_gradelist | top-active=class; dept-left=jiaow-jx_gradelist |  |  |
| /teacher/kq/studentLeave/leave_pending.jsp | 学生请假 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 学生请假 | top-active=class; dept-left=kq-stu-leave |  | 学生请假 @ /inc/page/body-left.jsp |
| /teacher/kq/studentLeave/leave_solved.jsp | 学生请假 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 kq-stu-leave | top-active=class; dept-left=kq-stu-leave |  |  |
| /teacher/kq/studentLeave/view_leave.jsp | 学生请假 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 ${param.active} -> 左侧 ${param.deptLeft} | top-active=${param.active}; dept-left=${param.deptLeft} | active, deptLeft, page_type, ID, user_type |  |
| /teacher/kq/studentLeave/wait_submit.jsp | 学生请假 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 kq-stu-leave | top-active=class; dept-left=kq-stu-leave |  |  |
| /teacher/kq/view_info_vue3.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 kq-stuview | top-active=class; dept-left=kq-stuview | pick_date, class_id |  |
| /teacher/kq/view_info.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 kq-weekview | top-active=class; dept-left=kq-weekview | weekNo, pickDate |  |
| /teacher/kq/week_view_vue3.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 kq-stuview | top-active=class; dept-left=kq-stuview | class_id |  |
| /teacher/kq/week_view.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 源码菜单 /inc/page/body-left.jsp -> 时间视图 | top-active=class; dept-left=kq-stuview_old |  | 时间视图 @ /fix/test_body_left.jsp； 时间视图 @ /inc/page/body-left.jsp； 时间视图 @ /teacher/kq/stu_view.jsp |
| /teacher/ktpj/cls/cls_tea_other_report.jsp | 其他报表 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 teacher-cls-ktpj | top-active=class; dept-left=teacher-cls-ktpj |  | 其他报表 @ /teacher/ktpj/cls/cls_tea_other_report.jsp； 其他报表 @ /teacher/ktpj/cls/cls_tea_week_report.jsp |
| /teacher/ktpj/cls/cls_tea_week_report.jsp | 周报表 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的班级 left -> 课堂评价报表 | top-active=class; dept-left=teacher-cls-ktpj |  | 课堂评价报表 @ /school/grade/classView.jsp； 课堂评价报表 @ /fix/test_body_left.jsp； 课堂评价报表 @ /inc/page/body-left.jsp |
| /teacher/ktpj/cls/stu_group.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 teach-pj-mgr | top-active=teach; dept-left=teach-pj-mgr | classId |  |
| /teacher/ktpj/clstea_report_sum_view.jsp | 报表分析 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：STAT_ID, STAT_TYPE, WEEK_IDX, TERM_CODE, USER_TYPE, START_DATE, END_DATE, CLASS_ID, GRADE_CODE, COURSE_CODE |  | STAT_ID, STAT_TYPE, WEEK_IDX, TERM_CODE, USER_TYPE, START_DATE, END_DATE, CLASS_ID, GRADE_CODE, COURSE_CODE |  |
| /teacher/ktpj/clstea_report_view.jsp | 报表分析 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：STAT_ID, STAT_TYPE, WEEK_IDX, TERM_CODE, USER_TYPE, START_DATE, END_DATE, CLASS_ID |  | STAT_ID, STAT_TYPE, WEEK_IDX, TERM_CODE, USER_TYPE, START_DATE, END_DATE, CLASS_ID |  |
| /teacher/ktpj/exportSumView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：MAXRECORDS, STAT_ID, PJ_TYPE, CLASS_ID |  | MAXRECORDS, STAT_ID, PJ_TYPE, CLASS_ID |  |
| /teacher/ktpj/ktpj.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：CLASS_ID, GRADE_CODE, COURSE_CODE |  | CLASS_ID, GRADE_CODE, COURSE_CODE | {{el.CLASS_NAME}}{{el.COURSE_NAME}} @ /teacher/ktpj/pjMgr.jsp |
| /teacher/ktpj/pjMgr.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 评价录入 | top-active=teach; dept-left=teach-pj-mgr |  | 评价录入 @ /fix/test_body_left.jsp； 评价录入 @ /inc/page/body-left.jsp； 评价录入 @ /teacher/ktpj/cls/stu_group.jsp |
| /teacher/ktpj/pjsz.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 teach -> 左侧 teach-pj-mgr | top-active=teach; dept-left=teach-pj-mgr |  |  |
| /teacher/ktpj/tea_item.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 teach -> 左侧 teach-pj-mgr | top-active=teach; dept-left=teach-pj-mgr |  |  |
| /teacher/ktpj/tea_op_rec.jsp | 操作记录 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 评价记录 | top-active=teach; dept-left=teach-pj-rec |  | 评价记录 @ /fix/test_body_left.jsp； 评价记录 @ /inc/page/body-left.jsp； 操作记录 @ /teacher/ktpj/tea_op_rec.jsp |
| /teacher/ktpj/tea_other_repeat.jsp | 其他报表 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 teach -> 左侧 teach-pj-stat | top-active=teach; dept-left=teach-pj-stat |  | 其他报表 @ /teacher/ktpj/tea_other_repeat.jsp； 其他报表 @ /teacher/ktpj/tea_week_repeat.jsp |
| /teacher/ktpj/tea_report_sum_view.jsp | 报表分析 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：STAT_ID, STAT_TYPE, WEEK_IDX, TERM_CODE, USER_TYPE, START_DATE, END_DATE, CLASS_ID, GRADE_COURSE |  | STAT_ID, STAT_TYPE, WEEK_IDX, TERM_CODE, USER_TYPE, START_DATE, END_DATE, CLASS_ID, GRADE_COURSE |  |
| /teacher/ktpj/tea_report_view.jsp | 报表分析 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：STAT_ID, STAT_TYPE, WEEK_IDX, TERM_CODE, USER_TYPE, START_DATE, END_DATE |  | STAT_ID, STAT_TYPE, WEEK_IDX, TERM_CODE, USER_TYPE, START_DATE, END_DATE |  |
| /teacher/ktpj/tea_stu_rec.jsp | 学生记录 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 teach -> 左侧 teach-pj-rec | top-active=teach; dept-left=teach-pj-rec |  | 学生记录 @ /teacher/ktpj/tea_op_rec.jsp； 学生记录 @ /teacher/ktpj/tea_stu_rec.jsp |
| /teacher/ktpj/tea_stu_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：STU_ID, WEEK_IDX, TERM_CODE, GRADE_COURSE, GRADE_CODE, COURSE_CODE, CLASS_ID, STAT_ID, PJ_TYPE |  | STU_ID, WEEK_IDX, TERM_CODE, GRADE_COURSE, GRADE_CODE, COURSE_CODE, CLASS_ID, STAT_ID, PJ_TYPE |  |
| /teacher/ktpj/tea_week_repeat.jsp | 周报表 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 报表查看 | top-active=teach; dept-left=teach-pj-stat |  | 报表查看 @ /fix/test_body_left.jsp； 报表查看 @ /inc/page/body-left.jsp； 周报表 @ /teacher/ktpj/tea_other_repeat.jsp |
| /teacher/print/addPrint.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：source |  | source |  |
| /teacher/print/applyPrint.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 myapp-print | top-active=apply; dept-left=myapp-print |  |  |
| /teacher/print/myPrint.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 运行时 我的应用 left -> 打印申请 | top-active=apply; dept-left=myapp-print |  | 打印申请 @ /user/headupload.jsp； 打印申请 @ /inc/page/body-left.jsp |
| /teacher/tea-index.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 index -> 左侧 对应菜单 | top-active=index |  | @ /teacher/tea-note.jsp |
| /teacher/tea-note.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /teacher/tea-index.jsp -> /teacher/tea-note.jsp | top-active=index |  | @ /teacher/tea-index.jsp |
| /teacher/teach-go.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 教师首页 top -> 我的教学 |  |  | 我的教学 @ /teacher/tea-index.jsp； 我的教学 @ /teacher/tea-index.jsp； 我的教学 @ /school/grade/classView.jsp |
| /teacher/test/classlist.jsp | 按班级查看 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 teach -> 左侧 teach-test | top-active=teach; dept-left=teach-test |  |  |
| /teacher/test/count.jsp | 核定及统计 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：testId, objNo, testName |  | testId, objNo, testName | 核定及统计 @ /teacher/test/input.jsp |
| /teacher/test/courselist.jsp | 按科目查看 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 teach -> 左侧 teach-test | top-active=teach; dept-left=teach-test |  |  |
| /teacher/test/fsd_view.jsp | 测验分析 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：type, gradeCode, classNo, sf, classId, gradeId, testId |  | type, gradeCode, classNo, sf, classId, gradeId, testId | @ /department/jiaow/test/detail.jsp；  @ /department/jiaow/test/list.jsp；  @ /teacher/test/courselist.jsp |
| /teacher/test/import.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：testId, testName, levelModel, levelNum, scoretype, fullScore, coursename, courseid, objno |  | testId, testName, levelModel, levelNum, scoretype, fullScore, coursename, courseid, objno | 成绩导入 @ /teacher/test/input.jsp； 成绩导入 @ /teacher/test/input.jsp |
| /teacher/test/input.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：testId, testName, objNo, inputLength |  | testId, testName, objNo, inputLength | 成绩录入 @ /teacher/test/count.jsp； 成绩录入 @ /teacher/test/import.jsp； 返回 @ /teacher/test/updateStu.jsp |
| /teacher/test/list_add.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：termId, termName |  | termId, termName |  |
| /teacher/test/list.jsp | 我的测验 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的教学 left -> 测验成绩 | top-active=teach; dept-left=teach-test | termId | 测验成绩 @ /teacher/exam/entry-list.jsp； 测验成绩 @ /fix/test_body_left.jsp； 测验成绩 @ /inc/page/body-left.jsp |
| /teacher/test/otherlist.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 teach -> 左侧 teach-test | top-active=teach; dept-left=teach-test |  |  |
| /teacher/test/searchStudent.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：testId, searchKey |  | testId, searchKey |  |
| /teacher/test/stu_table.jsp | 测验分析 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：type, gradeCode, classNo, sf, classId, gradeId, testId |  | type, gradeCode, classNo, sf, classId, gradeId, testId |  |
| /teacher/test/stu_view.jsp | 测验分析 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：type, gradeCode, classNo, sf, classId, gradeId, testId |  | type, gradeCode, classNo, sf, classId, gradeId, testId | 学生分析 @ /teacher/test/stu_table.jsp； 学生分析 @ /teacher/test/stu_view.jsp； 学生分析 @ /teacher/test/ycb_view.jsp |
| /teacher/test/updateStu.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 教师端页面/我的教学相关入口 |  |  | 学生名单更新 @ /teacher/test/input.jsp |
| /teacher/test/ycb_view.jsp | 测验分析 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：type, gradeCode, classNo, sf, classId, gradeId, testId |  | type, gradeCode, classNo, sf, classId, gradeId, testId | 英才榜 @ /teacher/test/stu_table.jsp； 英才榜 @ /teacher/test/stu_view.jsp； 英才榜 @ /teacher/test/ycb_view.jsp |
| /teacher/test/youliang_view.jsp | 测验分析 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：type, gradeCode, classNo, sf, classId, gradeId, testId |  | type, gradeCode, classNo, sf, classId, gradeId, testId | 优良差率 @ /teacher/test/stu_table.jsp； 优良差率 @ /teacher/test/stu_view.jsp； 优良差率 @ /teacher/test/ycb_view.jsp |
| /teacher/ts/inc_ts_studio_tab.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：tab |  | tab |  |
| /teacher/ts/secret_tab.jsp | 秘密标注 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：student_id, term_code, search_type |  | student_id, term_code, search_type |  |
| /teacher/ts/ts_act_op.jsp | 导师制档案 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：student_id, term_code, search_type, act_type, from_page |  | student_id, term_code, search_type, act_type, from_page |  |
| /teacher/ts/ts_act_rec_mult.jsp | 导师制档案 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 教师端页面/我的教学相关入口 |  |  |  |
| /teacher/ts/ts_act_rec.jsp | 导师制档案 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：id, type_id, student_id, term_code, from_page |  | id, type_id, student_id, term_code, from_page |  |
| /teacher/ts/ts_discuss.jsp | 家校留言 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：student_id, term_code |  | student_id, term_code |  |
| /teacher/ts/ts_lib_detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：lib_id |  | lib_id |  |
| /teacher/ts/ts_stu_info.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 ${param.Left} | top-active=class; dept-left=${param.Left} | classId, Left, Identity, type |  |
| /teacher/ts/ts_students.jsp | 一生一档 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 ts_studio | top-active=class; dept-left=ts_studio | teacherId, termCode |  |
| /teacher/ts/ts_studio.jsp | 导师-我的学生 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的班级 left -> 导师工作室 | top-active=class; dept-left=ts_studio |  | 导师工作室 @ /school/grade/classView.jsp； 导师工作室 @ /fix/test_body_left.jsp； 导师工作室 @ /inc/page/body-left.jsp |
| /teacher/ts/ts_sub_act_op.jsp | 导师制档案 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：student_id, term_code, act_id, sub_ids |  | student_id, term_code, act_id, sub_ids |  |
| /teacher/ts/ts_tea_mystat.jsp | 记录统计 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 ts_studio | top-active=class; dept-left=ts_studio | term_code |  |
| /teacher/ts/ts_tea_pdf.jsp | 一师一册 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 ts_studio | top-active=class; dept-left=ts_studio | termCode |  |
| /teacher/ts/ts_tea_record.jsp | 导师-操作记录 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 class -> 左侧 ts_studio | top-active=class; dept-left=ts_studio | term_code |  |
| /teacher/ts/ts_tea_space.jsp | 导师-互动空间 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 ts_studio | top-active=class; dept-left=ts_studio |  |  |
| /teacher/ts/ts_tea_stulist.jsp | 班主任-本班学生 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 ts_studio | top-active=class; dept-left=ts_studio |  |  |
| /teacher/ts/workOverView.jsp | 工作导览 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 源码菜单 /inc/page/body-left.jsp -> 导师工作室 | top-active=class; dept-left=ts_studio |  | 导师工作室 @ /inc/page/body-left.jsp； 工作导览 @ /teacher/ts/workOverView.jsp |
| /teacher/zh/list.jsp | 其他报表 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 zhpj-list | top-active=class; dept-left=zhpj-list |  | 其他报表 @ /teacher/zh/list.jsp； 其他报表 @ /teacher/zh/zh_week_list.jsp |
| /teacher/zh/step1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 源码菜单 /inc/page/body-left.jsp -> 报表汇总 | top-active=class; dept-left=zhpj-hz |  | 报表汇总 @ /fix/test_body_left.jsp； 报表汇总 @ /inc/page/body-left.jsp |
| /teacher/zh/step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 class -> 左侧 zhpj-hz | top-active=class; dept-left=zhpj-hz |  |  |
| /teacher/zh/zh_class_statistics.jsp | 学生记录 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 zhpj-op-list | top-active=class; dept-left=zhpj-op-list |  | 班级统计 @ /teacher/zh/zh_class_statistics.jsp； 班级统计 @ /teacher/zh/zh_op_rec.jsp； 班级统计 @ /teacher/zh/zh_stu_rec.jsp |
| /teacher/zh/zh_op_rec.jsp | 操作记录 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 操作记录 | top-active=class; dept-left=zhpj-op-list |  | 操作记录 @ /fix/test_body_left.jsp； 操作记录 @ /inc/page/body-left.jsp； 我的记录 @ /teacher/zh/zh_class_statistics.jsp |
| /teacher/zh/zh_stu_rec.jsp | 学生记录 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 zhpj-op-list | top-active=class; dept-left=zhpj-op-list |  |  |
| /teacher/zh/zh_week_list.jsp | 周报表 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 报表查看 | top-active=class; dept-left=zhpj-list |  | 报表查看 @ /fix/test_body_left.jsp； 报表查看 @ /inc/page/body-left.jsp； 周报表 @ /teacher/zh/list.jsp |

### 学生端（61）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /student/addParentDialog.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：studentId, parentId, sex, name, phone, unit, post, rest, title |  | studentId, parentId, sex, name, phone, unit, post, rest, title |  |
| /student/course/xuanx/applicationRecord.jsp | 申请记录 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 course -> 左侧 course-xuanx | top-active=course; dept-left=course-xuanx |  | 申请记录 @ /student/course/xuanx/info.jsp； 申请记录 @ /student/course/xuanx/my-xuanx.jsp； 申请记录 @ /student/course/xuanx/select.jsp |
| /student/course/xuanx/detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 course -> 左侧 course-xuanx | top-active=course; dept-left=course-xuanx | ID |  |
| /student/course/xuanx/info.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 course -> 左侧 course-xuanx | top-active=course; dept-left=course-xuanx |  | 选课说明 @ /student/course/xuanx/applicationRecord.jsp； 选课说明 @ /student/course/xuanx/detail.jsp； 选课说明 @ /student/course/xuanx/my-xuanx-vue3.jsp |
| /student/course/xuanx/my-xuanx-vue3.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 course-xuanx | top-active=course; dept-left=course-xuanx | selectTerm |  |
| /student/course/xuanx/my-xuanx.jsp | 选修课程 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/head.jsp -> 社团选修 | top-active=course; dept-left=course-xuanx | selectTerm | 社团选修 @ /inc/page/head.jsp； ．．． @ /parent/par-index.jsp； ．．． @ /parent/par-note.jsp |
| /student/course/xuanx/quick-select.jsp | 社团选修课程 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 学生端页面/我的学习相关入口 |  |  |  |
| /student/course/xuanx/select.jsp | 社团选修课程 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 选修课程 | top-active=course; dept-left= |  | 选修课程 @ /fix/test_body_left.jsp； 网上选课 @ /fix/test_body_left.jsp； 选修课程 @ /inc/page/body-left_bak.jsp |
| /student/exam/count-list.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 成绩分析 | top-active=teach; dept-left=teach-exam-analyse | termId | 成绩分析 @ /fix/test_body_left.jsp； 成绩分析 @ /fix/test_body_left.jsp； 成绩分析 @ /inc/page/body-left.jsp |
| /student/exam/small-list.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 小分录入 | top-active=teach; dept-left=teach-small-entry |  | 小分录入 @ /fix/test_body_left.jsp； 小分录入 @ /inc/page/body-left.jsp |
| /student/files/dy.jsp | 德育记录 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, SEA_STU_ID |  | SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, SEA_STU_ID |  |
| /student/files/exam.jsp | 学业发展 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 我的档案 |  | SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, FILE_CLASS_ID, SEA_STU_ID | 我的档案 @ /fix/test_body_left.jsp； 孩子档案 @ /fix/test_body_left.jsp； 我的档案 @ /inc/page/body-left.jsp |
| /student/files/fazhan.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SEA_TERM_CODE, SEA_VIEW_TYPE, SEA_STU_ID |  | SEA_TERM_CODE, SEA_VIEW_TYPE, SEA_STU_ID |  |
| /student/files/file_head.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 学生端页面/我的学习相关入口 |  |  |  |
| /student/files/homework.jsp | 作业 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, FILE_CLASS_ID, SEA_STU_ID |  | SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, FILE_CLASS_ID, SEA_STU_ID |  |
| /student/files/jy_detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：seaViewType, stuId, seaTermCode, title, courseId, courseName, fileClassId |  | seaViewType, stuId, seaTermCode, title, courseId, courseName, fileClassId |  |
| /student/files/jy.jsp | 学期寄语 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, FILE_CLASS_ID, SEA_STU_ID |  | SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, FILE_CLASS_ID, SEA_STU_ID |  |
| /student/files/selcourse.jsp | 社团选修 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, SEA_STU_ID |  | SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, SEA_STU_ID |  |
| /student/files/termReport.jsp | 学期报告 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SEA_STU_ID, SEA_VIEW_TYPE, FILE_USER_TYPE, FILE_CLASS_ID, SEA_TERM_CODE |  | SEA_STU_ID, SEA_VIEW_TYPE, FILE_USER_TYPE, FILE_CLASS_ID, SEA_TERM_CODE |  |
| /student/files/test.jsp | 测验 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, FILE_CLASS_ID, SEA_STU_ID |  | SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, FILE_CLASS_ID, SEA_STU_ID |  |
| /student/files/ts_discuss.jsp | 家校留言 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：student_id, term_code |  | student_id, term_code |  |
| /student/files/ts.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, SEA_STU_ID |  | SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, SEA_STU_ID |  |
| /student/files/zh_dev.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, SEA_STU_ID, SEA_YEAR |  | SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, SEA_STU_ID, SEA_YEAR |  |
| /student/files/zh_honor.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, SEA_STU_ID, SEA_YEAR |  | SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, SEA_STU_ID, SEA_YEAR |  |
| /student/files/zh.jsp | 学生综评 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, SEA_STU_ID, SEA_YEAR, SEA_EVAL_ID, ZH_PAGE_INDEX |  | SEA_TERM_CODE, SEA_VIEW_TYPE, FILE_USER_TYPE, SEA_STU_ID, SEA_YEAR, SEA_EVAL_ID, ZH_PAGE_INDEX |  |
| /student/issue/body-right-top.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：li |  | li |  |
| /student/issue/issue_temp_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：TEMP_ID |  | TEMP_ID |  |
| /student/issue/issueRemark.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 stu-issue-temp | top-active=course; dept-left=stu-issue-temp | ISSUE_ID |  |
| /student/issue/stu_issue_apply.jsp | 创新实践课题 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 stu-issue-temp | top-active=course; dept-left=stu-issue-temp | ID, TEMP_ID |  |
| /student/issue/stu_issue_detail.jsp | 创新实践课题 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 course -> 左侧 stu-issue-temp | top-active=course; dept-left=stu-issue-temp | ID |  |
| /student/issue/stu_issue_retry.jsp | 创新实践课题 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 stu-issue-temp | top-active=course; dept-left=stu-issue-temp | ID, TEMP_ID |  |
| /student/issue/stu_issue_temp_view.jsp | 课程信息 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 jiaow-issue-temp | top-active=dept; dept-id=jiaow; dept-left=jiaow-issue-temp | TEMP_ID |  |
| /student/issue/stu_issue_temp.jsp | 创新实践课题 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 stu-issue-temp | top-active=course; dept-left=stu-issue-temp | SEA_NAME | 课题模板 @ /student/issue/body-right-top.jsp |
| /student/issue/stu_issue_test_view.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 学生端页面/我的学习相关入口 |  |  |  |
| /student/issue/stu_issue_test.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 course -> 左侧 stu-issue-temp | top-active=course; dept-left=stu-issue-temp |  |  |
| /student/issue/stu_my_issue.jsp | 创新实践课题 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 创新实践课题 | top-active=course; dept-left=stu-issue-temp | SEA_TERM_CODE | 创新实践课题 @ /fix/test_body_left.jsp； 创新实践课题 @ /inc/page/body-left.jsp； 我的课题 @ /student/issue/body-right-top.jsp |
| /student/issue/stu_remarkView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 course -> 左侧 stu-issue-temp | top-active=course; dept-left=stu-issue-temp | ISSUE_ID |  |
| /student/kq/frm_stu_kq_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：check_date, student_id |  | check_date, student_id |  |
| /student/kq/my_week_view_vue3.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 我的考勤 | top-active=class; dept-left=kq-stu-info |  | 我的考勤 @ /inc/page/body-left.jsp； 孩子考勤 @ /inc/page/body-left.jsp |
| /student/kq/my_week_view.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 kq-stu-info_old | top-active=class; dept-left=kq-stu-info_old |  |  |
| /student/kq/week_view.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 kq-stu-info | top-active=class; dept-left=kq-stu-info |  | 我的考勤 @ /fix/test_body_left.jsp； 孩子考勤 @ /fix/test_body_left.jsp |
| /student/ktpj/stu_other_report.jsp | 其他报表 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 teach -> 左侧 stu-ktpj | top-active=teach; dept-left=stu-ktpj |  | 其他报表 @ /student/ktpj/stu_other_report.jsp； 其他报表 @ /student/ktpj/stu_rec.jsp； 其他报表 @ /student/ktpj/stu_week_report.jsp |
| /student/ktpj/stu_rec.jsp | 评价记录 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 课堂评价 | top-active=teach; dept-left=stu-ktpj |  | 课堂评价 @ /fix/test_body_left.jsp； 课堂评价 @ /fix/test_body_left.jsp； 课堂评价 @ /inc/page/body-left.jsp |
| /student/ktpj/stu_report_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：WEEK_IDX, STU_ID, TERM_CODE, COURSE_CODE, CLASS_ID, STAT_ID, STAT_TYPE, CLASS_STU, START_DATE, END_DATE, PJ_TYPE |  | WEEK_IDX, STU_ID, TERM_CODE, COURSE_CODE, CLASS_ID, STAT_ID, STAT_TYPE, CLASS_STU, START_DATE, END_DATE, PJ_TYPE |  |
| /student/ktpj/stu_week_report.jsp | 周报表 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 teach -> 左侧 stu-ktpj | top-active=teach; dept-left=stu-ktpj |  | 周报表 @ /student/ktpj/stu_other_report.jsp； 周报表 @ /student/ktpj/stu_rec.jsp； 周报表 @ /student/ktpj/stu_week_report.jsp |
| /student/leave/add_leave.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 kq-stu-leave | top-active=class; dept-left=kq-stu-leave | ID |  |
| /student/leave/my_leave.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 我的请假 | top-active=class; dept-left=kq-stu-leave |  | 我的请假 @ /inc/page/body-left.jsp； 孩子请假 @ /inc/page/body-left.jsp |
| /student/leave/view_leave.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 kq-stu-leave | top-active=class; dept-left=kq-stu-leave | ID |  |
| /student/stu-index.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部  -> 左侧 | top-active=; dept-id=; dept-right=; dept-left=; dept-middle= |  | @ /student/stu-note.jsp |
| /student/stu-info.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 我的资料 | top-active=apply; dept-left=apply-stu-info |  | 我的资料 @ /fix/test_body_left.jsp； 我的资料 @ /inc/page/body-left.jsp； 孩子资料 @ /inc/page/body-left.jsp |
| /student/stu-note.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /student/stu-index.jsp -> /student/stu-note.jsp | top-active=index |  | @ /student/stu-index.jsp |
| /student/teach-go.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/head.jsp -> 我的学习 |  |  | 我的学习 @ /inc/page/head.jsp； 孩子学习 @ /inc/page/head.jsp； 孩子学习 @ /parent/par-index.jsp |
| /student/test/list.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 测验分析 | top-active=teach; dept-left=teach-test-analyse |  | 测验分析 @ /fix/test_body_left.jsp； 测验分析 @ /fix/test_body_left.jsp； 测验分析 @ /inc/page/body-left.jsp |
| /student/test/my_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 teach-test-analyse | top-active=teach; dept-left=teach-test-analyse | testId, testName, stuId | {{el.TEST_NAME}} @ /student/test/list.jsp；  @ /student/test/list.jsp |
| /student/test/stu_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 teach-test | top-active=teach; dept-left=teach-test | testId, testName, stuId, stuName | {{list.name}} @ /teacher/test/stu_table.jsp |
| /student/ts/quick-select.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 学生端页面/我的学习相关入口 |  |  |  |
| /student/ts/ts_lib_detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：lib_id |  | lib_id |  |
| /student/userinfo.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 账号信息 | top-active=apply; dept-left=usercfg-userinfo |  | 账号信息 @ /fix/test_body_left.jsp； 账号信息 @ /inc/page/body-left.jsp |
| /student/zh_pic_stu.jsp | 班级视图 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：term_id, eval_id, stu_id, p_id, userType |  | term_id, eval_id, stu_id, p_id, userType |  |
| /student/zh/zh_view.jsp | 学生综合评价 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 源码菜单 /inc/page/body-left.jsp -> 学生综合评价 | top-active=class; dept-left=stu-class-zh |  | 学生综合评价 @ /fix/test_body_left.jsp； 学生综合评价 @ /fix/test_body_left.jsp； 学生综合评价 @ /inc/page/body-left.jsp |
| /student/zh/zh_ycb.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 学生端页面/我的学习相关入口 |  |  |  |

### 家长端（17）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /parent/course/xuanx/my-xuanx.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 选修课程 | top-active=course; dept-left=course-xuanx | selectTerm | 选修课程 @ /fix/test_body_left.jsp； 选修课程 @ /inc/page/body-left.jsp； 社团选修 @ /inc/page/head.jsp |
| /parent/html/user.html | 绿蜻蜓用户协议 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 《绿蜻蜓用户协议》 @ /parent/regStep2.jsp； 《绿蜻蜓用户协议》 @ /parent/regStep21.jsp |
| /parent/kq/stu_leave.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 kq-stu-leave | top-active=class; dept-left=kq-stu-leave |  | 孩子请假 @ /fix/test_body_left.jsp |
| /parent/par-index.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部  -> 左侧 | top-active=; dept-id=; dept-right=; dept-left=; dept-middle= |  | @ /parent/par-note.jsp |
| /parent/par-info.jsp | 家长资料 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 家长资料 | top-active=apply; dept-left=apply-par-info |  | 家长资料 @ /fix/test_body_left.jsp； 家长资料 @ /inc/page/body-left.jsp |
| /parent/par-myProfile.jsp | 家长资料 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 我的资料 | top-active=apply; dept-left=apply-par-info |  | 我的资料 @ /fix/test_body_left.jsp； 我的资料 @ /inc/page/body-left.jsp |
| /parent/par-note.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /parent/par-index.jsp -> /parent/par-note.jsp | top-active=index |  | @ /parent/par-index.jsp |
| /parent/par-stu-info.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 孩子资料 | top-active=apply; dept-left=apply-stu-info |  | 孩子资料 @ /fix/test_body_left.jsp； 孩子资料 @ /inc/page/body-left.jsp |
| /parent/regStep1.jsp | 绿蜻蜓云校园 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：utype, appid |  | utype, appid |  |
| /parent/regStep12.jsp | 绿蜻蜓云校园 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：appid |  | appid |  |
| /parent/regStep2.jsp | 绿蜻蜓云校园 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /parent/regStep21.jsp | 绿蜻蜓云校园 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /parent/regStep25.jsp | 绿蜻蜓云校园 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 下一步 @ /parent/regStep21.jsp |
| /parent/selParStu.jsp | 绿蜻蜓云校园 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /parent/toLogin.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /parent/toParIndex.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：TOKEN, STU_ID |  | TOKEN, STU_ID |  |
| /parent/userinfo.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 账号信息 | top-active=apply; dept-left=usercfg-userinfo |  | 账号信息 @ /fix/test_body_left.jsp； 账号信息 @ /inc/page/body-left.jsp |

### 学校/班级基础数据（45）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /school/base/adminRight.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> super-right | top-active=dept; dept-left=super-right |  |  |
| /school/base/ajax/school-info-set-Ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：code, schoolId, schoolType |  | code, schoolId, schoolType |  |
| /school/base/ajax/school-info-set-select.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：code |  | code |  |
| /school/base/ajax/school-term-setting-add-Ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /school/base/ajax/school-term-setting-Ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /school/base/ajax/school-term-settting-add.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 首页 -> 我的班级/学校基础数据入口 |  |  |  |
| /school/base/ajax/school-term-settting-edit.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：tid |  | tid |  |
| /school/base/cfgTerm.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> office-sch-xueq | top-active=dept; dept-id=office; dept-left=office-sch-xueq |  |  |
| /school/base/school-info.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> office-sch-info | top-active=dept; dept-id=office; dept-left=office-sch-info |  | 学校基础信息 @ /inc/page/body-left_bak.jsp |
| /school/base/school-term-setting.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> office-sch-xueq | top-active=dept; dept-id=office; dept-left=office-sch-xueq |  | 学期设置 @ /department/dyc/kq/tea/holiday_cloud_view.jsp； 学期设置 @ /department/dyc/kq/tea/holiday_school.jsp； 学期设置 @ /inc/page/body-left_bak.jsp |
| /school/base/schoolSystemSetting.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> office-sch-xzsz | top-active=dept; dept-id=office; dept-left=office-sch-xzsz |  | 学制设置 @ /inc/page/body-left_bak.jsp |
| /school/base/schoolSystemSettingMain.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：schoolId |  | schoolId |  |
| /school/base/temp/step1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 首页 -> 我的班级/学校基础数据入口 |  |  |  |
| /school/base/temp/step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 首页 -> 我的班级/学校基础数据入口 |  |  |  |
| /school/base/temp/step3.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 首页 -> 我的班级/学校基础数据入口 |  |  |  |
| /school/func/getOrgtreeAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：SID |  | SID |  |
| /school/func/getOrgtreeC.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SCHOOL_ID, CODE |  | SCHOOL_ID, CODE |  |
| /school/func/getTreeTable.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SID |  | SID |  |
| /school/func/list.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/teacher/body-left.jsp -> 学校结构 | top-active=dept; dept-right=power |  | 学校结构 @ /inc/page/teacher/body-left.jsp |
| /school/grade/ajax/ClassList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：tid, termId, schoolId |  | tid, termId, schoolId |  |
| /school/grade/classesManager.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-class | top-active=dept; dept-id=jiaow; dept-left=jiaow-class |  | 班级管理 @ /inc/page/body-left_bak.jsp |
| /school/grade/classesSetting.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-grad | top-active=dept; dept-id=jiaow; dept-left=jiaow-grad |  | 班年级设置 @ /inc/page/body-left_bak.jsp |
| /school/grade/classInfo.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/head.jsp -> 我的班级 | top-active=class; dept-left=class-view | id, type | 我的班级 @ /inc/page/head.jsp； 孩子班级 @ /inc/page/head.jsp； 孩子班级 @ /parent/par-index.jsp |
| /school/grade/classInfo/ClassesHeader.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：id |  | id |  |
| /school/grade/classInfo/ClassesHeaderEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：id |  | id |  |
| /school/grade/classInfo/classStudentInfo.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：id, isTeacher |  | id, isTeacher |  |
| /school/grade/classInfo/CourseHeader.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：id, type |  | id, type |  |
| /school/grade/classInfo/CourseHeaderEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：id |  | id |  |
| /school/grade/classInfo/stu_code_jxb.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 class-view | top-active=class; dept-left=class-view | type, classId, className | 学号设置 @ /school/grade/classInfo.jsp |
| /school/grade/classInfo/stu_code.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 class-view | top-active=class; dept-left=class-view | className, type | 学号设置 @ /school/grade/classInfo.jsp |
| /school/grade/classInfoDept.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-class | top-active=dept; dept-id=jiaow; dept-left=jiaow-class | id |  |
| /school/grade/classInfoEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 class -> 左侧 class-view | top-active=class; dept-left=class-view | id | 职务设置 @ /school/grade/classInfo.jsp |
| /school/grade/classView.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 运行时 教师首页 top -> 我的班级 | top-active=class; dept-left=class-view |  | 我的班级 @ /teacher/tea-index.jsp； 我的班级 @ /teacher/tea-index.jsp； ．．． @ /teacher/tea-index.jsp |
| /school/grade/classView/ClassList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：termId |  | termId |  |
| /school/grade/importHeadTea.jsp | 导入班主任 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-grad | top-active=dept; dept-id=jiaow; dept-left=jiaow-grad |  | 导入班主任 @ /school/grade/classesSetting.jsp |
| /school/grade/setStuRight.jsp | 功能授权 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 class-view | top-active=class; dept-left=class-view | type, classId | 功能授权 @ /school/grade/classInfo.jsp |
| /school/grade/stu_avatar.jsp | 照片导入 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 class-view | top-active=class; dept-left=class-view | type, classId | &type=&classId=" class="btn btn-green btn-sm" > 照片导入 @ /school/grade/classInfo.jsp |
| /school/grade/stu_group.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 class-view | top-active=class; dept-left=class-view | classId, type | 分组管理 @ /school/grade/classInfo.jsp |
| /school/grade/stu-info.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 class-view | top-active=class; dept-left=class-view | classId | &classId="> @ /school/grade/classInfo/classStudentInfo.jsp |
| /school/org/addDept.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：NODE_DID, NODE_CODE |  | NODE_DID, NODE_CODE |  |
| /school/org/addDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：NODE_DID, NODE_CODE |  | NODE_DID, NODE_CODE |  |
| /school/org/ajaxDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：DID, DCODE |  | DID, DCODE |  |
| /school/org/manDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：MID, DID, MCODE |  | MID, DID, MCODE |  |
| /school/org/mgr.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> office-sch-struct | top-active=dept; dept-id=office; dept-left=office-sch-struct |  | 学校结构 @ /inc/page/body-left_bak.jsp |
| /school/space.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> teacher -> 部门页签 -> office-sch-info | top-active=dept; dept-id=teacher; dept-left=office-sch-info |  |  |

### 社团选修（20）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /department/mycourse/add/adminAdd2.jsp | 新建课程 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 course -> 左侧 teacher-xuanx | top-active=course; dept-left=teacher-xuanx |  |  |
| /department/mycourse/apply/list.jsp | 待审核课程 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部  -> 左侧 | top-active=; dept-id=; dept-right=; dept-left=; dept-middle= |  |  |
| /department/mycourse/clsQuery/clsEvalList.jsp | 选修评价 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 class-sel-stu | top-active=class; dept-left=class-sel-stu |  |  |
| /department/mycourse/clsQuery/clsKqDetail.jsp | 选修课程 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：stu_id |  | stu_id |  |
| /department/mycourse/clsQuery/clsKqList.jsp | 选修课程 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 class-sel-stu | top-active=class; dept-left=class-sel-stu |  |  |
| /department/mycourse/clsQuery/clsQueryList.jsp | 选修课程 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的班级 left -> 班级社团选修 | top-active=class; dept-left=class-sel-stu |  | 班级社团选修 @ /school/grade/classView.jsp； 班级选修名单 @ /fix/test_body_left.jsp； 班级社团选修 @ /inc/page/body-left.jsp |
| /department/mycourse/comment/info.jsp | 选修课程 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/teacher/body-right-top.jsp -> 申报说明 | top-active=course; dept-left=teacher-xuanx |  | 申报说明 @ /department/mycourse/myselcourse/list.jsp； 申报说明 @ /inc/page/body-left_bak.jsp； 申报说明 @ /inc/page/teacher/body-right-top.jsp |
| /department/mycourse/inaduit/inAjax.jsp | 管理员新建课程 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 顶部 course -> 左侧 teacher-xuanx-my | top-active=course; dept-left=teacher-xuanx-my |  |  |
| /department/mycourse/inaduit/inAjaxWs.jsp | 新建课程 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 course -> 左侧 teacher-xuanx | top-active=course; dept-left=teacher-xuanx |  | @ /department/mycourse/myselcourse/listAjax.jsp |
| /department/mycourse/inc/teacherArea.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/mycourse/myselcourse/applicationRecord.jsp | 申请记录 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 course -> 左侧 teacher-xuanx-user | top-active=course; dept-left=teacher-xuanx-user |  | 申请记录 @ /department/mycourse/myselcourse/body-right-top.jsp |
| /department/mycourse/myselcourse/applyRecord.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/mycourse/myselcourse/body-right-top.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：li |  | li |  |
| /department/mycourse/myselcourse/list.jsp | 社团选修课程 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 教师首页 top -> 社团选修 | top-active=course; dept-left=teacher-xuanx | selCouseForm_op, SEA_TERM_CODE, SEA_TERM_STATUS | 社团选修 @ /teacher/tea-index.jsp； 我的社团选修 @ /teacher/tea-index.jsp； 社团选修 @ /school/grade/classView.jsp |
| /department/mycourse/myselcourse/listAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /department/mycourse/myselcourse/myCommentLibSet.jsp | 个人评语库设置 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/mycourse/myselcourse/userList.jsp | 社团选修名单 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 社团选修 left -> 选修课程名单 | top-active=course; dept-left=teacher-xuanx-user |  | 选修课程名单 @ /department/mycourse/myselcourse/list.jsp； 课程名单 @ /department/mycourse/myselcourse/body-right-top.jsp； 选修课程名单 @ /fix/test_body_left.jsp |
| /department/mycourse/sellib/list.jsp | 选修课程 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/teacher/body-right-top.jsp -> 课程模板 | top-active=course; dept-left=teacher-xuanx | SEA_COURSE_TYPE, SEA_CATEGORY, SEA_NAME, SEA_STATUS | 课程模板 @ /department/mycourse/myselcourse/list.jsp； 选修课程库 @ /inc/page/body-left_bak.jsp； 课程模板 @ /inc/page/teacher/body-right-top.jsp |
| /department/mycourse/sellib/listAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, COURSE_TYPE, seaCategory, seaStatus, seaName |  | pageSize, curPage, COURSE_TYPE, seaCategory, seaStatus, seaName |  |
| /department/mycourse/success/selDetails.jsp | 我的选修课程 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 teacher-xuanx-my | top-active=course; dept-left=teacher-xuanx-my | ID | @ /department/mycourse/myselcourse/listAjax.jsp |

### 我的事务/OA（223）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /oa/calendar/cal.jsp | 我的日程 - | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的应用 left -> 我的日程 |  |  | 我的日程 @ /teacher/tea-index.jsp； 我的日程 @ /user/headupload.jsp； 我的日程 @ /fix/test_body_left.jsp |
| /oa/calendar/datafeed.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/calendar/dept/add_cal.jsp | 日程 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> calendar -> 左侧菜单 | top-active=dept; dept-right=calendar |  | 发布日程 @ /oa/calendar/dept/add_cal.jsp； 发布日程 @ /oa/calendar/dept/cal_check.jsp； 发布日程 @ /oa/calendar/dept/edit_cal.jsp |
| /oa/calendar/dept/cal_check.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> calendar -> 左侧菜单 | top-active=dept; dept-right=calendar | id |  |
| /oa/calendar/dept/check_cal.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> calendar -> 左侧菜单 | top-active=dept; dept-right=calendar |  |  |
| /oa/calendar/dept/edit_cal.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> calendar -> 左侧菜单 | top-active=dept; dept-right=calendar |  | 修改 @ /oa/calendar/dept/view_cal.jsp |
| /oa/calendar/dept/list_cal.jsp | 已发日程 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/neck.jsp -> 日程 | top-active=dept; dept-right=calendar |  | 日程 @ /inc/page/neck.jsp； 已发日程 @ /oa/calendar/dept/add_cal.jsp； 已发日程 @ /oa/calendar/dept/cal_check.jsp |
| /oa/calendar/dept/load_cal.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/calendar/dept/view_cal.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> calendar -> 左侧菜单 | top-active=dept; dept-right=calendar |  | 返回 @ /oa/calendar/dept/check_cal.jsp； 返回 @ /oa/calendar/dept/edit_cal.jsp； 取消 @ /oa/calendar/dept/edit_cal.jsp |
| /oa/calendar/easy_cal.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/calendar/events.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/calendar/venue.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  | 查看预约详情 @ /department/venue/applyVenue.jsp； {{el.NAME}} @ /department/venue/myApplyVenue.jsp； {{el.NAME}} @ /department/venue/myVenue.jsp |
| /oa/collect/addCollect.jsp | 资料收集 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> collect -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=collect |  | 资料收集 @ /oa/collect/common/body-right-top.jsp |
| /oa/collect/ajax/dirAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：ids |  | ids |  |
| /oa/collect/ajax/listPCollectAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /oa/collect/collectHander.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-trans | top-active=affair; dept-left=user-trans | type |  |
| /oa/collect/common/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li, returnUrl |  | li, returnUrl |  |
| /oa/collect/listPCollect.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/neck.jsp -> 收集 | top-active=dept; dept-id=jiaow; dept-right=collect |  | 收集 @ /inc/page/neck.jsp； 已发布收集 @ /oa/collect/common/body-right-top.jsp |
| /oa/collect/preViewNpCollect.jsp | 资料收集详情 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> collect -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=collect | collectId, type | {{el.TITLE}} @ /oa/collect/listPCollect.jsp |
| /oa/collect/SavePosition.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/collect/viewCountCollect.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> collect -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=collect | collectId | 已交：{{el.VIEWCOUNT}}/{{el.ALLCOUNT}}-- @ /oa/collect/listPCollect.jsp； / @ /oa/collect/preViewNpCollect.jsp |
| /oa/com/batch_add_stu.jsp | My JSP 'batch_add_stu.jsp' starting page | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/data/_dataManager.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> file -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=file |  |  |
| /oa/data/ajax/dirAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：ids |  | ids |  |
| /oa/data/ajax/downloadAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：ID |  | ID | " title="" target="_blank"> @ /space/classspace/index.jsp； " title="" target="_blank"> @ /space/specialspace/index.jsp |
| /oa/data/ajax/fileListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pFile, pageIndex, pageCount, orderCode, orderType, searchText |  | pFile, pageIndex, pageCount, orderCode, orderType, searchText |  |
| /oa/data/ajax/searchFileListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：searchText |  | searchText |  |
| /oa/data/dataManager.jsp | 资料 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/neck.jsp -> 资料 | top-active=dept; dept-id=jiaow; dept-right=file |  | 资料 @ /inc/page/neck.jsp |
| /oa/examen/add_loop_examen.jsp | 循环问卷 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> ts_lib | top-active=dept; dept-id=dsz; dept-left=ts_lib |  |  |
| /oa/examen/addExamen.jsp | 问卷 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | modelId | 新建问卷 @ /oa/examen/common/body-right-top.jsp |
| /oa/examen/addExamenModel.jsp | 问卷 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question |  |  |
| /oa/examen/ajax/ansUserListExamenAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, examenId, searchKey |  | pageSize, curPage, examenId, searchKey |  |
| /oa/examen/ajax/expTotal.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId |  | examenId | 导出表格 @ /oa/examen/totalAllCount.jsp |
| /oa/examen/ajax/expTotalQuestion.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId, questionId, type |  | examenId, questionId, type | 导出表格 @ /oa/examen/teaTotalQuestionCount.jsp； 导出表格 @ /oa/examen/totalQuestionCount.jsp； 导出表格 @ /oa/examen/totalQuestionCount.jsp |
| /oa/examen/ajax/listAnsTotalAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：questionId, examId, pageSize, curPage |  | questionId, examId, pageSize, curPage |  |
| /oa/examen/ajax/listAnsTotalAjax2.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：questionNo, courseId, pageSize, curPage |  | questionNo, courseId, pageSize, curPage |  |
| /oa/examen/ajax/listNpExamenAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, searchText, curPage |  | pageSize, searchText, curPage |  |
| /oa/examen/ajax/listPExamenAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, searchText, curPage |  | pageSize, searchText, curPage |  |
| /oa/examen/ajax/listTeaAnsTotalAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：questionId, examId, pageSize, curPage |  | questionId, examId, pageSize, curPage |  |
| /oa/examen/ajax/listTeaPExamenAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, searchText, curPage |  | pageSize, searchText, curPage |  |
| /oa/examen/ajax/myListPExamenAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, searchText, curPage |  | pageSize, searchText, curPage |  |
| /oa/examen/ajax/optionAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId |  | examenId |  |
| /oa/examen/ajax/teaAnsUserListExamenAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, examenId, searchKey |  | pageSize, curPage, examenId, searchKey |  |
| /oa/examen/ansUserListExamen.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId |  |
| /oa/examen/common/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li, so, returnUrl |  | li, so, returnUrl |  |
| /oa/examen/common/body-right-top2.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li, so, returnUrl |  | li, so, returnUrl |  |
| /oa/examen/common/examen_model_pic.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：workId, mainId, quesId, imgId |  | workId, mainId, quesId, imgId | @ /oa/examen/preViewNpExamenModel_1.jsp；  @ /oa/examen/preViewNpExamenModel_1.jsp；  @ /oa/examen/preViewNpExamenModel_1.jsp |
| /oa/examen/common/examen_pic.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：workId, mainId, quesId, imgId |  | workId, mainId, quesId, imgId | @ /department/jiaow/xuanx/examen/preViewNpExamen_1.jsp；  @ /department/jiaow/xuanx/examen/preViewNpExamen_1.jsp；  @ /department/jiaow/xuanx/examen/preViewNpExamen_1.jsp |
| /oa/examen/common/in_examen_model_pic.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：workId, mainId, quesId, imgId, pictype, classId, objid, objname |  | workId, mainId, quesId, imgId, pictype, classId, objid, objname |  |
| /oa/examen/common/in_examen_pic.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：workId, mainId, quesId, imgId, pictype, classId, objid, objname |  | workId, mainId, quesId, imgId, pictype, classId, objid, objname |  |
| /oa/examen/common/nav.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId, navType |  | examenId, navType |  |
| /oa/examen/common/nav2.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId, navType |  | examenId, navType |  |
| /oa/examen/common/viewAnsTotalList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId, navType |  | examenId, navType |  |
| /oa/examen/common/viewBarTotalList_1.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId, fromType |  | examenId, fromType |  |
| /oa/examen/common/viewBarTotalList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId, fromType, userId, studentId |  | examenId, fromType, userId, studentId |  |
| /oa/examen/common/viewList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId, pageType, fromType |  | examenId, pageType, fromType |  |
| /oa/examen/common/viewListByQuestion.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId, questionId |  | examenId, questionId |  |
| /oa/examen/common/viewListByQuestionOption.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId, questionId |  | examenId, questionId |  |
| /oa/examen/common/viewListHasRepley.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId, userId, studentId |  | examenId, userId, studentId |  |
| /oa/examen/common/viewNpList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId, fromType |  | examenId, fromType |  |
| /oa/examen/common/viewOptionTotalList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId |  | examenId |  |
| /oa/examen/common/viewTeaAnsTotalList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId, navType |  | examenId, navType |  |
| /oa/examen/common/viewTotalList_1.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId |  | examenId |  |
| /oa/examen/common/viewTotalList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId |  | examenId |  |
| /oa/examen/common/viewTotalList2_1.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId |  | examenId |  |
| /oa/examen/common/viewTotalList2.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examenId |  | examenId |  |
| /oa/examen/editExamen.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId | 设置 @ /department/jiaow/xuanx/examen/viewNpExamen.jsp； 设置 @ /oa/examen/viewNpExamen.jsp |
| /oa/examen/editExamenModel.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId |  |
| /oa/examen/examen_export.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examen_id |  |
| /oa/examen/examenManage.jsp | 模板管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question |  | 模板管理 @ /oa/examen/common/body-right-top.jsp |
| /oa/examen/exportExamen.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, from | 引用本问卷发布 @ /oa/examen/preViewNpExamen.jsp |
| /oa/examen/frm_loop_examen_detail_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：loop_id |  | loop_id |  |
| /oa/examen/frm_merge_options.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：list |  | list |  |
| /oa/examen/frm_set_jump_model.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：examen_id, question_id |  | examen_id, question_id |  |
| /oa/examen/frm_set_jump.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：examen_id, question_id |  | examen_id, question_id |  |
| /oa/examen/listPExamen.jsp | 已发布问卷 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/neck.jsp -> 问卷 | top-active=dept; dept-id=jiaow; dept-right=question |  | 问卷 @ /inc/page/neck.jsp； 已发布问卷 @ /oa/examen/common/body-right-top.jsp |
| /oa/examen/listTeaPExamen.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的班级 left -> 问卷管理 | top-active=class; dept-left=teacher-examen |  | 问卷管理 @ /school/grade/classView.jsp； 问卷管理 @ /fix/test_body_left.jsp； 问卷管理 @ /inc/page/body-left.jsp |
| /oa/examen/listUpExamen.jsp | 未发布问卷 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question |  | 暂存 @ /department/jiaow/xuanx/examen/viewNpExamen.jsp； 未发布问卷 @ /oa/examen/common/body-right-top.jsp； 返回 @ /oa/examen/editExamen.jsp |
| /oa/examen/loop_examen_list.jsp | 循环问卷 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question |  | 循环问卷 @ /oa/examen/common/body-right-top.jsp |
| /oa/examen/multAdd.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, type, questionId | 单选题 @ /department/jiaow/xuanx/examen/viewNpExamen.jsp； 多选题 @ /department/jiaow/xuanx/examen/viewNpExamen.jsp； 单选题 @ /oa/examen/viewNpExamen.jsp |
| /oa/examen/multAddModel.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, type, questionId |  |
| /oa/examen/multEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId |  |
| /oa/examen/myListPExamen.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的事务 left -> 问卷 1 | top-active=affair; dept-left=user-examen; dept-right=question |  | 问卷 1 @ /oa/notice/myListNotice.jsp； 问卷 1 @ /inc/error/nonFunc.jsp； 问卷 @ /fix/test_body_left.jsp |
| /oa/examen/myViewCountExamen.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-examen | top-active=affair; dept-left=user-examen; dept-right=question | examenId | {{el.VIEWCOUNT}}/{{el.ALLCOUNT}}-- @ /oa/examen/myListPExamen.jsp |
| /oa/examen/myViewTotalBarExamen.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-examen | top-active=affair; dept-left=user-examen; dept-right=question | examenId | @ /oa/examen/myViewTotalBarExamen.jsp；  @ /oa/examen/myViewTotalExamen.jsp |
| /oa/examen/myViewTotalExamen.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-examen | top-active=affair; dept-left=user-examen; dept-right=question | examenId | @ /oa/examen/myListPExamen.jsp；  @ /oa/examen/myViewTotalBarExamen.jsp；  @ /oa/examen/myViewTotalExamen.jsp |
| /oa/examen/preViewNpExamen_1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, type |  |
| /oa/examen/preViewNpExamen.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, type | 预览 @ /department/jiaow/xuanx/examen/viewNpExamen.jsp； {{el.TITLE}} @ /oa/examen/listUpExamen.jsp； 预览 @ /oa/examen/viewNpExamen.jsp |
| /oa/examen/preViewNpExamenModel_1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, type |  |
| /oa/examen/qrAdd.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId | 问答题 @ /department/jiaow/xuanx/examen/viewNpExamen.jsp； 问答题 @ /oa/examen/viewNpExamen.jsp |
| /oa/examen/qrAddModel.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId |  |
| /oa/examen/qrEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId |  |
| /oa/examen/scrAdd.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId, type | 打分题 @ /department/jiaow/xuanx/examen/viewNpExamen.jsp； 打分题 @ /oa/examen/viewNpExamen.jsp |
| /oa/examen/scrAddModel.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId, type |  |
| /oa/examen/scrEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId |  |
| /oa/examen/sigEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId |  |
| /oa/examen/sortExamen.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId | 题目排序 @ /department/jiaow/xuanx/examen/viewNpExamen.jsp； 题目排序 @ /oa/examen/viewNpExamen.jsp |
| /oa/examen/sortExamenModel.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId |  |
| /oa/examen/teaAnsUserListExamen.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 teacher-examen | top-active=class; dept-left=teacher-examen | examenId |  |
| /oa/examen/teaTotalQuestionCount.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 teacher-examen | top-active=class; dept-left=teacher-examen | examenId, questionId, thisIndex | 查看详情 @ /oa/examen/common/viewTotalList2.jsp； 查看详情 @ /oa/examen/common/viewTotalList2.jsp； 查看详情 @ /oa/examen/common/viewTotalList2.jsp |
| /oa/examen/totalAllCount.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId | 查看 @ /oa/examen/totalSetting.jsp； 点击此处查看答卷情况。 @ /oa/examen/totalSetting.jsp |
| /oa/examen/totalQuestionCount.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId, thisIndex | 查看统计详情 @ /oa/examen/common/viewBarTotalList.jsp； 查看统计详情 @ /oa/examen/common/viewBarTotalList.jsp； 查看统计详情 @ /oa/examen/common/viewBarTotalList.jsp |
| /oa/examen/totalQuestionUser.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：role, examenId, questionId, classId, gradeId, typeId, ans |  | role, examenId, questionId, classId, gradeId, typeId, ans | &examenId=&questionId=&classId={{el.E_CLASS_ID}}">{{el.Q}} @ /oa/examen/teaTotalQuestionCount.jsp； &examenId=&questionId=&gradeId={{el.GRADE_CODE}}&typeId=ALL">{{el.Q}} @ /oa/examen/teaTotalQuestionCount.jsp； &examenId=&questionId=&typeId=ALL">{{el.Q}} @ /oa/examen/teaTotalQuestionCount.jsp |
| /oa/examen/totalSetting.jsp | 设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId | @ /oa/examen/common/nav.jsp |
| /oa/examen/totalTempAdd.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question |  | 新增模板 @ /oa/examen/totalTempList.jsp |
| /oa/examen/totalTempEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; dept-right=question | id | @ /oa/examen/totalTempList.jsp |
| /oa/examen/totalTempList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question |  | 统计模板 @ /oa/examen/common/body-right-top.jsp |
| /oa/examen/tptAdd.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examen_id, id | 图片题 @ /department/jiaow/xuanx/examen/viewNpExamen.jsp； 图片题 @ /oa/examen/viewNpExamen.jsp |
| /oa/examen/tptAddModel.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examen_id, id |  |
| /oa/examen/twsmAdd.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId | 图文说明 @ /department/jiaow/xuanx/examen/viewNpExamen.jsp； 图文说明 @ /oa/examen/viewNpExamen.jsp |
| /oa/examen/twsmAddModel.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId |  |
| /oa/examen/viewCountExamen.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> question -> 左侧菜单 | top-active=dept; dept-right=question | examenId | {{el.VIEWCOUNT}}/{{el.ALLCOUNT}}-- @ /oa/examen/listPExamen.jsp |
| /oa/examen/viewExamen.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-examen | top-active=affair; dept-left=user-examen | examenId | {{el.TITLE}} @ /oa/examen/myListPExamen.jsp； 待完成 @ /oa/examen/myListPExamen.jsp |
| /oa/examen/viewExamenHasRepley_1.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-examen | top-active=affair; dept-left=user-examen | examenId |  |
| /oa/examen/viewExamenHasRepley.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-examen | top-active=affair; dept-left=user-examen | examenId | {{el.TITLE}} @ /oa/examen/myListPExamen.jsp |
| /oa/examen/viewExamenModel.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, type, flag |  |
| /oa/examen/viewNpExamen_1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId |  |
| /oa/examen/viewNpExamen.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId | {{el.TITLE}} @ /oa/examen/listUpExamen.jsp； 取消 @ /oa/examen/multAdd.jsp； 取消 @ /oa/examen/multEdit.jsp |
| /oa/examen/viewNpExamenModel_1.jsp | 模板管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId | 返回 @ /oa/examen/editExamenModel.jsp； 取消 @ /oa/examen/multAddModel.jsp； 取消 @ /oa/examen/qrAddModel.jsp |
| /oa/examen/viewRepley.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, userId | @ /oa/examen/ansUserListExamen.jsp |
| /oa/examen/viewTeaCountExamen.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 teacher-examen | top-active=class; dept-left=teacher-examen | examenId | {{el.VIEWCOUNT}}/{{el.ALLCOUNT}}-- @ /oa/examen/listTeaPExamen.jsp |
| /oa/examen/viewTeaRepley.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 teacher-examen | top-active=class; dept-left=teacher-examen | examenId, userId | @ /oa/examen/teaAnsUserListExamen.jsp |
| /oa/examen/viewTeaTotalAnsExamen.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 teacher-examen | top-active=class; dept-left=teacher-examen | examenId | @ /oa/examen/common/nav2.jsp； 返回列表 @ /oa/examen/viewTeaTotalAnsExamenDetail_type6.jsp； 返回列表 @ /oa/examen/viewTeaTotalAnsExamenDetail.jsp |
| /oa/examen/viewTeaTotalAnsExamen6.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 teacher-examen | top-active=class; dept-left=teacher-examen | examenId | @ /oa/examen/common/nav2.jsp |
| /oa/examen/viewTeaTotalAnsExamenDetail_type6.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 teacher-examen | top-active=class; dept-left=teacher-examen | examenId, questionId | @ /oa/examen/common/viewTeaAnsTotalList.jsp； 上一题 @ /oa/examen/viewTeaTotalAnsExamenDetail_type6.jsp； 下一题 @ /oa/examen/viewTeaTotalAnsExamenDetail_type6.jsp |
| /oa/examen/viewTeaTotalAnsExamenDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 class -> 左侧 teacher-examen | top-active=class; dept-left=teacher-examen | examenId, questionId | @ /oa/examen/common/viewTeaAnsTotalList.jsp； 上一题 @ /oa/examen/viewTeaTotalAnsExamenDetail.jsp； 下一题 @ /oa/examen/viewTeaTotalAnsExamenDetail.jsp |
| /oa/examen/viewTeaTotalExamen.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 teacher-examen | top-active=class; dept-left=teacher-examen | examenId | @ /oa/examen/common/nav2.jsp |
| /oa/examen/viewTotalAnsExamen.jsp | 问答 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId | @ /oa/examen/common/nav.jsp； 返回列表 @ /oa/examen/viewTotalAnsExamenDetail_type6.jsp； 返回列表 @ /oa/examen/viewTotalAnsExamenDetail.jsp |
| /oa/examen/viewTotalAnsExamen6.jsp | 图片题 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId | @ /oa/examen/common/nav.jsp |
| /oa/examen/viewTotalAnsExamenDetail_type6.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId | @ /oa/examen/common/viewAnsTotalList.jsp； 上一题 @ /oa/examen/viewTotalAnsExamenDetail_type6.jsp； 下一题 @ /oa/examen/viewTotalAnsExamenDetail_type6.jsp |
| /oa/examen/viewTotalAnsExamenDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId | @ /oa/examen/common/viewAnsTotalList.jsp； 上一题 @ /oa/examen/viewTotalAnsExamenDetail.jsp； 下一题 @ /oa/examen/viewTotalAnsExamenDetail.jsp |
| /oa/examen/viewTotalBarExamen.jsp | 柱状图 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId | @ /oa/examen/common/nav.jsp；  @ /oa/vote/viewTotalAnsExamen.jsp |
| /oa/examen/viewTotalExamen.jsp | 饼图 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId | @ /oa/examen/common/nav.jsp；  @ /oa/vote/viewTotalAnsExamen.jsp |
| /oa/examen/viewTotalOptionExamen.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId |  |
| /oa/notice/addNotice.jsp | 发新通知 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> notice -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=notice | off_id, title, content, fileattment, dept_code | 发新通知 @ /oa/notice/common/body-right-top.jsp |
| /oa/notice/ajax/listNoticeAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, searchText, searchLb, searchLabel |  | pageSize, curPage, searchText, searchLb, searchLabel |  |
| /oa/notice/ajax/myListNoticeAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, searchText, searchLb, curPage |  | pageSize, searchText, searchLb, curPage |  |
| /oa/notice/common/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li, so, returnUrl |  | li, so, returnUrl |  |
| /oa/notice/editNotice.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> notice -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=notice | noticeId | 修改 @ /department/org/notice/viewNotice.jsp； 修改 @ /oa/notice/viewNotice.jsp |
| /oa/notice/editNotice0.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> notice -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=notice | noticeId | 只改内容不重发 @ /oa/notice/viewNotice.jsp |
| /oa/notice/editNotice1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> notice -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=notice | noticeId | 修改并重发 @ /oa/notice/viewNotice.jsp |
| /oa/notice/listNotice.jsp | 已发通知 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/neck.jsp -> 通知 | top-active=dept; dept-id=jiaow; dept-right=notice |  | 活动报道 @ /department/org/index.jsp； 通知 @ /inc/page/neck.jsp； 已发通知 @ /oa/notice/common/body-right-top.jsp |
| /oa/notice/myListNotice.jsp | 通知查阅 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 教师首页 top -> 我的事务 | top-active=affair; dept-left=user-notice | SEA_LABEL | 我的事务 @ /teacher/tea-index.jsp； 通知 @ /teacher/tea-index.jsp； 我的事务 @ /school/grade/classView.jsp |
| /oa/notice/myViewCountNotice.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-notice | top-active=affair; dept-left=user-notice | noticeId, fromtype | 阅读：{{el.VIEWCOUNT}}/{{el.ALLCOUNT}}-- @ /oa/notice/myListNotice.jsp； / -- @ /oa/notice/myViewNotice.jsp |
| /oa/notice/myViewNotice.jsp | 通知详情 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /parent/par-index.jsp -> " style="color:#666666 "> ! | top-active=affair; dept-left=user-notice | fromtype | 测试图是否模糊 @ /teacher/tea-index.jsp； test @ /teacher/tea-index.jsp； 热乎乎 @ /teacher/tea-index.jsp |
| /oa/notice/noViewClass.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：noticeId, viewType |  | noticeId, viewType | 查看未阅学生 @ /oa/notice/viewCountNotice.jsp； 查看未阅家长 @ /oa/notice/viewCountNotice.jsp |
| /oa/notice/viewCountNotice.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> notice -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=notice | noticeId, fromtype | 阅读：{{el.VIEWCOUNT}}/{{el.ALLCOUNT}}-- @ /oa/notice/listNotice.jsp； / -- @ /oa/notice/viewNotice.jsp |
| /oa/notice/viewNotice.jsp | 通知详情 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> notice -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=notice |  | {{el.TITLE \| html}} @ /oa/notice/listNotice.jsp |
| /oa/office/addOffice.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> gw -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=gw |  | 发起公文 @ /oa/office/common/body-right-top.jsp |
| /oa/office/ajax/listOfficeAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, searchText |  | pageSize, curPage, searchText |  |
| /oa/office/ajax/listOfficeDoAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, searchText, curPage |  | pageSize, searchText, curPage |  |
| /oa/office/ajax/listOfficeHadDoAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, searchText, curPage |  | pageSize, searchText, curPage |  |
| /oa/office/common/body-right-top-per.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li, returnUrl, searchText |  | li, returnUrl, searchText |  |
| /oa/office/common/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li, returnUrl, searchText |  | li, returnUrl, searchText |  |
| /oa/office/common/choiseDptAllDataFile.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/office/common/choiseDptDataFile.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：fileIds |  | fileIds |  |
| /oa/office/docView.jsp | OFFICE在线编辑 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：fileId |  | fileId |  |
| /oa/office/docViewTest.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/office/listOffice.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/neck.jsp -> 公文 | top-active=dept; dept-id=jiaow; dept-right=gw |  | 公文 @ /inc/page/neck.jsp； 已发公文 @ /oa/office/common/body-right-top.jsp |
| /oa/office/listOfficePerDo.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的事务 left -> 公文 46 | top-active=affair; dept-left=user-oa |  | 公文 46 @ /oa/notice/myListNotice.jsp； 公文 46 @ /inc/error/nonFunc.jsp； 公文 @ /fix/test_body_left.jsp |
| /oa/office/listOfficePerHadDo.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 affair -> 左侧 user-oa | top-active=affair; dept-left=user-oa |  | 已处理 @ /oa/office/common/body-right-top-per.jsp |
| /oa/office/personListOffice.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> notice -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=notice |  |  |
| /oa/office/quickWord.jsp | 快捷语库 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 affair -> 左侧 user-oa | top-active=affair; dept-left=user-oa |  | 快捷语库 @ /oa/office/common/body-right-top-per.jsp |
| /oa/office/savefile.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：fileId |  | fileId |  |
| /oa/office/upload.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/office/viewOfficeDept.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> gw -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=gw | id | {{el.TITLE}} @ /oa/office/listOffice.jsp； {{el.TITLE}} @ /oa/office/personListOffice.jsp |
| /oa/office/viewOfficeHis.jsp | 公文详情 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-oa | top-active=affair; dept-left=user-oa | id | {{el.TITLE}} @ /oa/office/listOfficePerHadDo.jsp |
| /oa/office/viewOfficePass.jsp | 公文详情 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-office | top-active=affair; dept-left=user-office | id | '"> {{el.TITLE}} @ /oa/office/listOfficePerDo.jsp； '"> 待处理 待查阅 @ /oa/office/listOfficePerDo.jsp |
| /oa/office/viewOfficePerson.jsp | 公文详情 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-oa | top-active=affair; dept-left=user-oa | id | '"> {{el.TITLE}} @ /oa/office/listOfficePerDo.jsp； '"> 待处理 待查阅 @ /oa/office/listOfficePerDo.jsp |
| /oa/repairs/addRepairs.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 user-repairs | top-active=apply; dept-left=user-repairs |  | 提交报修 @ /oa/repairs/common/body-right-top.jsp |
| /oa/repairs/ajax/hadListRepairsAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /oa/repairs/ajax/handerListRepairsAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /oa/repairs/ajax/myListRepairsAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /oa/repairs/ajax/notListRepairsAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /oa/repairs/common/body-right-top-main.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li, xq |  | li, xq |  |
| /oa/repairs/common/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li |  | li |  |
| /oa/repairs/hadListRepairs.jsp | 报修处理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> repairs -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=repairs |  | 已完毕报修 @ /oa/repairs/common/body-right-top-main.jsp |
| /oa/repairs/handerListRepairs.jsp | 报修处理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> repairs -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=repairs |  | 未完毕报修 @ /oa/repairs/common/body-right-top-main.jsp |
| /oa/repairs/myListRepairs.jsp | 我的报修 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的应用 left -> 我的报修 | top-active=apply; dept-left=user-repairs |  | 我的报修 @ /user/headupload.jsp； 我的报修 @ /fix/test_body_left.jsp； 我的报修 @ /inc/page/body-left.jsp |
| /oa/repairs/myViewRepairs.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 user-repairs | top-active=apply; dept-left=user-repairs | fromtype | {{formattedText(el.TITLE)}} @ /oa/repairs/myListRepairs.jsp； 待确认 @ /oa/repairs/myListRepairs.jsp |
| /oa/repairs/notListRepairs.jsp | 报修处理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> repairs -> repairs | top-active=dept; dept-left=repairs; dept-right=repairs |  | 待处理报修 @ /oa/repairs/common/body-right-top-main.jsp |
| /oa/repairs/repairJob.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/repairs/setting.jsp | 报修处理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> repairs -> repairs | top-active=dept; dept-left=repairs; dept-right=repairs |  | 提醒设置 @ /oa/repairs/common/body-right-top-main.jsp |
| /oa/repairs/viewRepairs.jsp | 报修详情 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> 左侧菜单 | top-active=dept; dept-id=jiaow | uName, className | {{formattedText(el.TITLE)}} @ /oa/repairs/hadListRepairs.jsp；  @ /oa/repairs/handerListRepairs.jsp； 待完工 @ /oa/repairs/handerListRepairs.jsp |
| /oa/vote/addVote.jsp | 投票 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> vote -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=vote | voteId, from | 新建投票 @ /oa/vote/common/body-right-top.jsp |
| /oa/vote/ajax/ansUserListVoteAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /oa/vote/ajax/listAnsTotalAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：questionId, examId, pageSize, curPage |  | questionId, examId, pageSize, curPage |  |
| /oa/vote/ajax/listNpVoteAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, searchText, curPage |  | pageSize, searchText, curPage |  |
| /oa/vote/ajax/listPVoteAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, searchText, curPage |  | pageSize, searchText, curPage |  |
| /oa/vote/ajax/myListPVoteAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, searchText, curPage |  | pageSize, searchText, curPage |  |
| /oa/vote/ajax/myListUser.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：SUBJECT, ANSWER |  | SUBJECT, ANSWER |  |
| /oa/vote/ansUserListVote.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> vote -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=vote |  |  |
| /oa/vote/common/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li, so, returnUrl |  | li, so, returnUrl |  |
| /oa/vote/common/openAudio.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：id |  | id |  |
| /oa/vote/common/openVideo.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：id |  | id |  |
| /oa/vote/common/upload.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/vote/common/viewAnsTotalList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/vote/common/viewBarTotalList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/vote/common/viewList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/vote/common/viewListHasRepley.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 首页 -> 我的事务 -> 对应左侧菜单 |  |  |  |
| /oa/vote/common/viewNpList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：voteId |  | voteId |  |
| /oa/vote/common/viewTotalList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：voteId, isShow |  | voteId, isShow |  |
| /oa/vote/Copy of multEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; dept-right=vote | subId |  |
| /oa/vote/editVote.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> vote -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=vote |  | 设置 @ /oa/vote/viewNpVote.jsp |
| /oa/vote/listPVote.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/neck.jsp -> 投票 | top-active=dept; dept-id=jiaow; dept-right=vote |  | 投票 @ /inc/page/neck.jsp； 已发布投票 @ /oa/vote/common/body-right-top.jsp |
| /oa/vote/listUpVote.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> vote -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=vote |  | 未发布投票 @ /oa/vote/common/body-right-top.jsp； 返回 @ /oa/vote/editVote.jsp； 暂存 @ /oa/vote/viewNpVote.jsp |
| /oa/vote/multAdd.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> vote -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=vote |  | 增加投票大题 @ /oa/vote/viewNpVote.jsp |
| /oa/vote/multEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; dept-right=vote | subId |  |
| /oa/vote/myListPVote.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的事务 left -> 投票 | top-active=affair; dept-left=user-vote; dept-right=vote |  | 投票 @ /oa/notice/myListNotice.jsp； 投票 @ /inc/error/nonFunc.jsp； 投票 @ /fix/test_body_left.jsp |
| /oa/vote/myViewCountVote.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-vote | top-active=affair; dept-left=user-vote; dept-right=question | voteId | {{el.VIEWCOUNT}}/{{el.ALL_COUNT}}-- @ /oa/vote/myListPVote.jsp |
| /oa/vote/myViewTotalBarVote.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-vote | top-active=affair; dept-left=user-vote; dept-right=question | voteId | @ /oa/vote/myListPVote.jsp；  @ /oa/vote/myViewTotalBarVote.jsp；  @ /oa/vote/myViewTotalVote.jsp |
| /oa/vote/myViewTotalVote.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-vote | top-active=affair; dept-left=user-vote; dept-right=vote | voteId | @ /oa/vote/myViewTotalBarVote.jsp；  @ /oa/vote/myViewTotalVote.jsp |
| /oa/vote/preViewNpVote.jsp | 已发布投票 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> vote -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=vote | voteId, notOwn, type | {{el.TITLE}} @ /oa/vote/listPVote.jsp； {{el.TITLE}} @ /oa/vote/listUpVote.jsp； 预览 @ /oa/vote/viewNpVote.jsp |
| /oa/vote/sortVote.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> vote -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=vote | voteId | 题目排序 @ /oa/vote/viewNpVote.jsp |
| /oa/vote/viewCountVote.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> vote -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=vote | voteId | {{el.VIEWCOUNT}}/{{el.ALLCOUNT}}-- @ /oa/vote/listPVote.jsp |
| /oa/vote/viewNpVote.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> vote -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=vote |  | {{el.TITLE}} @ /oa/vote/listUpVote.jsp； 取消 @ /oa/vote/multAdd.jsp； 取消 @ /oa/vote/multEdit.jsp |
| /oa/vote/viewRepley.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> vote -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=vote | voteId, userId | @ /oa/vote/ansUserListVote.jsp |
| /oa/vote/viewTotalAnsExamen.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> vote -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=vote | examenId |  |
| /oa/vote/viewTotalBarVote.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> vote -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=vote | voteId | @ /oa/vote/viewTotalBarVote.jsp；  @ /oa/vote/viewTotalVote.jsp |
| /oa/vote/viewTotalVote.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> vote -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=vote | voteId | @ /oa/vote/viewTotalBarVote.jsp；  @ /oa/vote/viewTotalVote.jsp |
| /oa/vote/viewVote.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-vote | top-active=affair; dept-left=user-vote | voteId | {{el.TITLE}} @ /oa/vote/myListPVote.jsp； 待完成 @ /oa/vote/myListPVote.jsp |
| /oa/vote/viewVoteHasRepley.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 affair -> 左侧 user-vote | top-active=affair; dept-left=user-vote | voteId | {{el.TITLE}} @ /oa/vote/myListPVote.jsp |
| /oa/vote/vote_set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> vote -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=vote | vote_id |  |

### 部门-教务（592）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /department/jiaow/admission-prediction/analyse.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/admission-prediction/create.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-admission | top-active=dept; dept-id=jiaow; dept-left=exam-admission |  |  |
| /department/jiaow/admission-prediction/detail.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-admission | top-active=dept; dept-id=jiaow; dept-left=exam-admission |  |  |
| /department/jiaow/admission-prediction/index.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-admission | top-active=dept; dept-id=jiaow; dept-left=exam-admission |  |  |
| /department/jiaow/ch/addCh.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/ch/classHour.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-kskb-kbgl | top-active=dept; dept-id=jiaow; dept-left=jiaow-kskb-kbgl |  | 课时管理 @ /department/jiaow/ch/timeSetting.jsp |
| /department/jiaow/ch/setHour.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/ch/setSelCourseTime.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/ch/timeSetting.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-kskb-kbgl | top-active=dept; dept-id=jiaow; dept-left=jiaow-kskb-kbgl |  | @ /department/jiaow/ch/classHour.jsp |
| /department/jiaow/classSystem/classSet.jsp | 教学班设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> jiaow-jx_gradelist | top-active=dept; dept-id=dsz; dept-left=jiaow-jx_gradelist | grade_id, grade_name, class_id, term_id |  |
| /department/jiaow/classSystem/editRelateJXClass.jsp | 教学班系统 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> jiaow-jx_gradelist | top-active=dept; dept-id=dsz; dept-left=jiaow-jx_gradelist | gradeName, courseName, choose_term_id, choose_pre_term_id, grade_code, jx_grade_id |  |
| /department/jiaow/classSystem/gradeDetail.jsp | 教学班列表 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 jiaow-jx_gradelist | top-active=dept; dept-id=dsz; dept-left=jiaow-jx_gradelist | grade_id, term_id | {{grade_name}} @ /department/jiaow/classSystem/classSet.jsp |
| /department/jiaow/classSystem/gradeList.jsp | 教学班列表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> jiaow-jx_gradelist | top-active=dept; dept-id=dsz; dept-left=jiaow-jx_gradelist |  | 教学班列表 @ /department/jiaow/classSystem/classSet.jsp； 教学班列表 @ /department/jiaow/classSystem/gradeDetail.jsp |
| /department/jiaow/classSystem/importStu.jsp | 导入学生 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> jiaow-jx_gradelist | top-active=dept; dept-id=dsz; dept-left=jiaow-jx_gradelist |  |  |
| /department/jiaow/classSystem/importTea.jsp | 导入任教 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> jiaow-jx_gradelist | top-active=dept; dept-id=dsz; dept-left=jiaow-jx_gradelist |  |  |
| /department/jiaow/classSystem/relateJXClass.jsp | 教学班系统 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> jiaow-jx_gradelist | top-active=dept; dept-id=dsz; dept-left=jiaow-jx_gradelist | choose_term_id, choose_pre_term_id |  |
| /department/jiaow/classSystem/stuList.jsp | 学生名单 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> jiaow-jx_gradelist | top-active=dept; dept-id=dsz; dept-left=jiaow-jx_gradelist |  |  |
| /department/jiaow/courseSystem/addTuozhan.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 ->  ->  -> | top-active=; dept-id=; dept-right=; dept-left=; dept-middle= |  |  |
| /department/jiaow/courseSystem/ajax/adminAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：SEL_GRADE |  | SEL_GRADE |  |
| /department/jiaow/courseSystem/basic/detail.jsp | 基础型课程设置 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 jiaow-kec-jic | top-active=dept; dept-id=jiaow; dept-left=jiaow-kec-jic | id, seaType |  |
| /department/jiaow/courseSystem/basic/list.jsp | 基础型课程 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-kec-jic | top-active=dept; dept-id=jiaow; dept-left=jiaow-kec-jic | seaType | 基础型课程 @ /inc/page/body-left_bak.jsp |
| /department/jiaow/courseSystem/basic/listAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, COURSE_TYPE, seaType |  | pageSize, curPage, COURSE_TYPE, seaType |  |
| /department/jiaow/courseSystem/composite/detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 jiaow-kec-zongh | top-active=dept; dept-id=jiaow; dept-left=jiaow-kec-zongh | ID |  |
| /department/jiaow/courseSystem/composite/list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-kec-zongh | top-active=dept; dept-id=jiaow; dept-left=jiaow-kec-zongh |  | 综合型课程 @ /inc/page/body-left_bak.jsp |
| /department/jiaow/courseSystem/composite/listAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, COURSE_TYPE |  | pageSize, curPage, COURSE_TYPE |  |
| /department/jiaow/courseSystem/expend/detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 jiaow-kec-tuoz | top-active=dept; dept-id=jiaow; dept-left=jiaow-kec-tuoz | ID |  |
| /department/jiaow/courseSystem/expend/list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-kec-tuoz | top-active=dept; dept-id=jiaow; dept-left=jiaow-kec-tuoz |  | 拓展型课程 @ /inc/page/body-left_bak.jsp |
| /department/jiaow/courseSystem/expend/listAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, COURSE_TYPE |  | pageSize, curPage, COURSE_TYPE |  |
| /department/jiaow/courseSystem/inc/courseTypeDetail.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/courseSystem/inc/courseTypeView.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：courseDetailId, isView |  | courseDetailId, isView |  |
| /department/jiaow/courseSystem/inc/formArea.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/courseSystem/inc/uploadFile.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：choise1 |  | choise1 |  |
| /department/jiaow/courseSystem/inc/uploadImgFile.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：choise1 |  | choise1 |  |
| /department/jiaow/courseSystem/MainCourse.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 ->  ->  -> | top-active=; dept-id=; dept-right=; dept-left=; dept-middle= |  | 基础性课程 @ /inc/left.jsp |
| /department/jiaow/courseSystem/research/detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 jiaow-kec-yanj | top-active=dept; dept-id=jiaow; dept-left=jiaow-kec-yanj | ID |  |
| /department/jiaow/courseSystem/research/list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-kec-yanj | top-active=dept; dept-id=jiaow; dept-left=jiaow-kec-yanj |  | 研究型课程 @ /inc/page/body-left_bak.jsp |
| /department/jiaow/courseSystem/research/listAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, COURSE_TYPE |  | pageSize, curPage, COURSE_TYPE |  |
| /department/jiaow/courseSystem/Tuozhan.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 ->  ->  -> | top-active=; dept-id=; dept-right=; dept-left=; dept-middle= |  |  |
| /department/jiaow/courseSystem/YanJiu.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 ->  ->  -> | top-active=; dept-id=; dept-right=; dept-left=; dept-middle= |  |  |
| /department/jiaow/courseSystem/ZongHe.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 ->  ->  -> | top-active=; dept-id=; dept-right=; dept-left=; dept-middle= |  |  |
| /department/jiaow/exam/add.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list | t, g | 新建历史考试 @ /department/jiaow/exam/history/step1.jsp； 新建历史考试 @ /department/jiaow/exam/history/step1.jsp； 新建历史考试 @ /department/jiaow/exam/history/step1.jsp |
| /department/jiaow/exam/analyse/adjust-info.jsp | 原分调整 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list | bigId, courseId, courseName, gradeName | 调整 @ /department/jiaow/exam/analyse/adjust.jsp |
| /department/jiaow/exam/analyse/adjust.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  | 成绩调整 @ /department/jiaow/exam/analyse/adjust-info.jsp； 原分调整 @ /department/jiaow/exam/analyse/adjust.jsp； 原分调整 @ /department/jiaow/exam/analyse/bkScore.jsp |
| /department/jiaow/exam/analyse/ajax/searchStudent.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId, searchKey |  | examId, searchKey |  |
| /department/jiaow/exam/analyse/audit-set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  |  |
| /department/jiaow/exam/analyse/bkScore.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list | examId | 补考成绩 @ /department/jiaow/exam/analyse/adjust.jsp； 补考成绩 @ /department/jiaow/exam/analyse/bkScore.jsp |
| /department/jiaow/exam/analyse/extraRef/extraRef.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  |  |
| /department/jiaow/exam/analyse/extraRef/upsertRef.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list | examId, infoId, setId, add |  |
| /department/jiaow/exam/analyse/fenduan.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  |  |
| /department/jiaow/exam/analyse/go-analyse.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  | 成绩统计 @ /department/jiaow/exam/analyse/adjust-info.jsp； 成绩统计 @ /department/jiaow/exam/analyse/adjust.jsp； 成绩统计 @ /department/jiaow/exam/analyse/audit-set.jsp |
| /department/jiaow/exam/analyse/importMakeUp.jsp | 补考成绩导入 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list | examId |  |
| /department/jiaow/exam/analyse/morecourse-error-set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  | 特殊统计规则 @ /department/jiaow/exam/analyse/morecourse-error-set.jsp； 特殊统计规则 @ /department/jiaow/exam/analyse/morecourse-set.jsp； 特殊统计规则 @ /department/jiaow/exam/analyse/morecourse.jsp |
| /department/jiaow/exam/analyse/morecourse-set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  | 总分项对比设置 @ /department/jiaow/exam/analyse/morecourse-error-set.jsp； 总分项对比设置 @ /department/jiaow/exam/analyse/morecourse-set.jsp； 总分项对比设置 @ /department/jiaow/exam/analyse/morecourse.jsp |
| /department/jiaow/exam/analyse/morecourse.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  | 总分项基础设置 @ /department/jiaow/exam/analyse/morecourse-error-set.jsp； 总分项基础设置 @ /department/jiaow/exam/analyse/morecourse-set.jsp； 总分项基础设置 @ /department/jiaow/exam/analyse/morecourse.jsp |
| /department/jiaow/exam/analyse/school-power.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  | 配置默认权限 @ /department/jiaow/exam/analyse/stu-power.jsp |
| /department/jiaow/exam/analyse/score-line.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  |  |
| /department/jiaow/exam/analyse/score-lineBak.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  |  |
| /department/jiaow/exam/analyse/set-temp-level.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  |  |
| /department/jiaow/exam/analyse/stu-power.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  | 返回 @ /department/jiaow/exam/analyse/school-power.jsp； 学生及家长成绩查看权限 @ /department/jiaow/exam/analyse/school-power.jsp |
| /department/jiaow/exam/analyse/student.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/analyse/tea-power-def.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  | 配置默认权限 @ /department/jiaow/exam/analyse/tea-power.jsp |
| /department/jiaow/exam/analyse/tea-power.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  | 返回 @ /department/jiaow/exam/analyse/tea-power-def.jsp |
| /department/jiaow/exam/analyse/zero-score.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  | 成绩不完整临时统计 @ /department/jiaow/exam/entry/entry.jsp |
| /department/jiaow/exam/count/class/examinfo_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId, classId |  | examId, classId |  |
| /department/jiaow/exam/count/class/examinfo.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/count/class/examinfo2.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/count/class/fazhan_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId |  | examId |  |
| /department/jiaow/exam/count/class/fazhan_ajax1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | examId |  |
| /department/jiaow/exam/count/class/fazhan_exam_set.jsp | 班级视图 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/count/class/fazhan_view.jsp | 【班级分析-发展趋势】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gids, ccs, cids, o |  | m, f, sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/class/fazhan.jsp |
| /department/jiaow/exam/count/class/fazhan.jsp | 【班级分析-发展趋势】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/class/fazhan_view.jsp |
| /department/jiaow/exam/count/class/fsd_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId, identity, gradeIds, chooseClass, courseIds, objNo |  | examId, identity, gradeIds, chooseClass, courseIds, objNo |  |
| /department/jiaow/exam/count/class/fsd_view.jsp | 【班级分析-分段分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gids, ccs, cids, o |  | m, f, sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/class/fsd.jsp |
| /department/jiaow/exam/count/class/fsd.jsp | 【班级分析-分段分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/class/fsd_view.jsp |
| /department/jiaow/exam/count/class/lisan_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId |  | examId |  |
| /department/jiaow/exam/count/class/lisan_view.jsp | 【班级分析-离散分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gids, ccs, cids, o |  | m, f, sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/class/lisan.jsp |
| /department/jiaow/exam/count/class/lisan.jsp | 【班级分析-离散分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/class/lisan_view.jsp |
| /department/jiaow/exam/count/class/stu_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId |  | examId |  |
| /department/jiaow/exam/count/class/stu_view.jsp | 【班级分析-学生分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gids, ccs, cids, o |  | m, f, sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/class/stu.jsp |
| /department/jiaow/exam/count/class/stu.jsp | 【班级分析-学生分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/class/stu_view.jsp |
| /department/jiaow/exam/count/class/youliang_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId |  | examId |  |
| /department/jiaow/exam/count/class/youliang_view.jsp | 【班级分析-优良差率】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gids, ccs, cids, o |  | m, f, sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/class/youliang.jsp |
| /department/jiaow/exam/count/class/youliang.jsp | 【班级分析-优良差率】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/class/youliang_view.jsp |
| /department/jiaow/exam/count/class/zlfx_edit.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 修改 @ /department/jiaow/exam/count/class/zlfx_infoview.jsp； "+t.teaName+"（已完成） @ /department/jiaow/exam/count/class/zlfx_look.jsp； "+t.teaName+"（待完成） @ /department/jiaow/exam/count/class/zlfx_look.jsp |
| /department/jiaow/exam/count/class/zlfx_infoview.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | "+inputName+" @ /department/jiaow/exam/count/class/zlfx_look.jsp； "+t.teaName+" @ /department/jiaow/exam/count/class/zlfx_look.jsp |
| /department/jiaow/exam/count/class/zlfx_look.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f | 班年级质量分析报告 @ /department/jiaow/exam/count/class/zlfx.jsp |
| /department/jiaow/exam/count/class/zlfx_print.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f |  | m, f | 打印表格 @ /department/jiaow/exam/count/class/zlfx.jsp |
| /department/jiaow/exam/count/class/zlfx_printall.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f | 打印报告 @ /department/jiaow/exam/count/class/zlfx.jsp |
| /department/jiaow/exam/count/class/zlfx.jsp | 【班级分析-质量分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o |  |
| /department/jiaow/exam/count/class/zong_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId, classId |  | examId, classId |  |
| /department/jiaow/exam/count/class/zong_view.jsp | 【班级分析-综合分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gids, ccs, cids, o |  | m, f, sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/class/zong.jsp |
| /department/jiaow/exam/count/class/zong.jsp | 【班级分析-综合分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/class/zong_view.jsp |
| /department/jiaow/exam/count/course/examinfo_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId |  | examId |  |
| /department/jiaow/exam/count/course/examinfo.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/count/course/fazhan_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId, identity, gradeIds, chooseClass, courseIds, objNo |  | examId, identity, gradeIds, chooseClass, courseIds, objNo |  |
| /department/jiaow/exam/count/course/fazhan_ajax1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | examId, identity, gradeIds, chooseClass, courseIds, objNo |  |
| /department/jiaow/exam/count/course/fazhan_exam_set.jsp | 班级视图 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/count/course/fazhan_view.jsp | 【科目分析-发展趋势】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gids, ccs, cids, o |  | m, f, sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/course/fazhan.jsp |
| /department/jiaow/exam/count/course/fazhan.jsp | 【科目分析-发展趋势】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/course/fazhan_view.jsp |
| /department/jiaow/exam/count/course/fsd_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId, identity, gradeIds, chooseClass, courseIds, objNo, scoreLine |  | examId, identity, gradeIds, chooseClass, courseIds, objNo, scoreLine |  |
| /department/jiaow/exam/count/course/fsd_view.jsp | 【科目分析-分段分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gids, ccs, cids, o |  | m, f, sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/course/fsd.jsp |
| /department/jiaow/exam/count/course/fsd.jsp | 【科目分析-分段分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/course/fsd_view.jsp |
| /department/jiaow/exam/count/course/lisan_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId, identity, gradeIds, chooseClass, courseIds, objNo |  | examId, identity, gradeIds, chooseClass, courseIds, objNo |  |
| /department/jiaow/exam/count/course/lisan_view.jsp | 【科目分析-离散分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gids, ccs, cids, o |  | m, f, sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/course/lisan.jsp |
| /department/jiaow/exam/count/course/lisan.jsp | 【科目分析-离散分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/course/lisan_view.jsp |
| /department/jiaow/exam/count/course/stu_view.jsp | 【科目分析-学生分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gids, ccs, cids, o |  | m, f, sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/course/stu.jsp |
| /department/jiaow/exam/count/course/stu.jsp | 【科目分析-学生分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/course/stu_view.jsp |
| /department/jiaow/exam/count/course/youliang_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId, from, identity, gradeIds, chooseClass, courseIds, objNo |  | examId, from, identity, gradeIds, chooseClass, courseIds, objNo |  |
| /department/jiaow/exam/count/course/youliang_view.jsp | 【科目分析-优良差率】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gids, ccs, cids, o |  | m, f, sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/course/youliang.jsp |
| /department/jiaow/exam/count/course/youliang.jsp | 【科目分析-优良差率】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/course/youliang_view.jsp |
| /department/jiaow/exam/count/course/zlfx_edit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f |  | m, f | 修改 @ /department/jiaow/exam/count/course/zlfx_infoview.jsp； "+t.teaName+"（待完成） @ /department/jiaow/exam/count/course/zlfx_look.jsp； "+t.teaName+"（待完成） @ /department/jiaow/exam/count/course/zlfx_look.jsp |
| /department/jiaow/exam/count/course/zlfx_infoview.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | "+t.teaName+"（已完成） @ /department/jiaow/exam/count/course/zlfx_look.jsp； "+t.teaName+" @ /department/jiaow/exam/count/course/zlfx_look.jsp； "+t.teaName+"（已完成） @ /department/jiaow/exam/count/course/zlfx_look.jsp |
| /department/jiaow/exam/count/course/zlfx_look.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f | 科目质量分析报告 @ /department/jiaow/exam/count/course/zlfx.jsp |
| /department/jiaow/exam/count/course/zlfx_print.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gids, ccs, cids, o |  | m, f, sf, gids, ccs, cids, o | 打印表格 @ /department/jiaow/exam/count/course/zlfx.jsp |
| /department/jiaow/exam/count/course/zlfx_printall.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o | 打印报告 @ /department/jiaow/exam/count/course/zlfx.jsp |
| /department/jiaow/exam/count/course/zlfx.jsp | 【科目分析-质量分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o |  |
| /department/jiaow/exam/count/course/zong_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId, identity, gradeIds, chooseClass, courseIds, objNo |  | examId, identity, gradeIds, chooseClass, courseIds, objNo |  |
| /department/jiaow/exam/count/course/zong_view.jsp | 【科目分析-综合分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gids, ccs, cids, o |  | m, f, sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/course/zong.jsp |
| /department/jiaow/exam/count/course/zong.jsp | 【科目分析-综合分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/course/zong_view.jsp |
| /department/jiaow/exam/count/list-AcademicQualityReport.jsp | 学业质量报表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-count | top-active=dept; dept-id=jiaow; dept-left=exam-count |  |  |
| /department/jiaow/exam/count/list-AQR-Add.jsp | 学业质量报表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-count | top-active=dept; dept-id=jiaow; dept-left=exam-count |  |  |
| /department/jiaow/exam/count/list-AQR-Check.jsp | 学业质量报表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-count | top-active=dept; dept-id=jiaow; dept-left=exam-count |  |  |
| /department/jiaow/exam/count/list-AQR-Option.jsp | 学业质量报表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-count | top-active=dept; dept-id=jiaow; dept-left=exam-count |  |  |
| /department/jiaow/exam/count/list.jsp | 考试分析 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-count | top-active=dept; dept-id=jiaow; dept-left=exam-count | termId, courseCode | 本场考试统计完成，您可点击这里，直接进入到成绩分析页面。 @ /department/jiaow/exam/analyse/go-analyse.jsp； 绿蜻蜓已为你生成“{{tExam.title}}”成绩 @ /department/jiaow/exam/term/info.jsp； 总评汇总及统计任务已添加至系统队列，请耐心等待完成。 @ /department/jiaow/exam/term/termInfo.jsp |
| /department/jiaow/exam/count/school/avalon/user_number.html |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/count/school/avalon/user_number2.html |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/count/school/avalon/user_number3.html |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/count/school/avalon/zong.html |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/count/school/fsd_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId, identity, gradeIds, chooseClass, courseIds, objNo, scoreLine |  | examId, identity, gradeIds, chooseClass, courseIds, objNo, scoreLine |  |
| /department/jiaow/exam/count/school/fsd_view.jsp | 【全校分析-总分段分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：sf, gids, ccs, cids, o |  | sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/school/fsd.jsp |
| /department/jiaow/exam/count/school/fsd.jsp | 【全校分析-总分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/school/fsd_view.jsp |
| /department/jiaow/exam/count/school/stu.jsp | 【全校分析-科目总表】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | sf, gids, ccs, cids, o |  |
| /department/jiaow/exam/count/school/zong_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId, identity, gradeIds, chooseClass, courseIds, objNo |  | examId, identity, gradeIds, chooseClass, courseIds, objNo |  |
| /department/jiaow/exam/count/school/zong_view.jsp | 【全校分析-综合分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：sf, gids, ccs, cids, o |  | sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/school/zong.jsp |
| /department/jiaow/exam/count/school/zong.jsp | 【全校分析-综合分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/school/zong_view.jsp |
| /department/jiaow/exam/count/small_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId |  | examId |  |
| /department/jiaow/exam/count/small_classajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId |  | examId |  |
| /department/jiaow/exam/count/small_stuajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId |  | examId |  |
| /department/jiaow/exam/count/small_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m |  | m |  |
| /department/jiaow/exam/count/small-classview.jsp | 【班级分析-小分分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gids, ccs, cids, o |  | m, f, sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/small.jsp |
| /department/jiaow/exam/count/small-stuview.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m |  | m | 查看图表 @ /department/jiaow/exam/count/small.jsp |
| /department/jiaow/exam/count/small-view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m |  | m |  |
| /department/jiaow/exam/count/small.jsp | 【班级分析-小分分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/small_view.jsp； 查看表格 @ /department/jiaow/exam/count/small-classview.jsp； 查看表格 @ /department/jiaow/exam/count/small-stuview.jsp |
| /department/jiaow/exam/count/student/fazan_view.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/count/student/stu_trend_analysis_view.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 查看图表 @ /department/jiaow/exam/count/student/stu_trend_analysis.jsp |
| /department/jiaow/exam/count/student/stu_trend_analysis.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m | 查看表格 @ /department/jiaow/exam/count/student/stu_trend_analysis_view.jsp； 查看表格 @ /department/jiaow/exam/count/student/stu_trend_analysis_view.jsp |
| /department/jiaow/exam/count/student/zong_view.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | {{list.name}} @ /department/jiaow/exam/count/class/stu.jsp； "+stuInfo["STUDENT_NAME"]+" @ /department/jiaow/exam/count/course/examinfo.jsp； {{tr.name}} @ /department/jiaow/exam/count/course/stu.jsp |
| /department/jiaow/exam/count/student/zong.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m | 查看表格 @ /department/jiaow/exam/count/student/zong_view.jsp； 查看表格 @ /department/jiaow/exam/count/student/zong_view.jsp |
| /department/jiaow/exam/count/teach/small-view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f |  | m, f | 小分分析 @ /department/jiaow/exam/count/teach/small-view.jsp； 小分分析 @ /department/jiaow/exam/count/teach/stu_view.jsp； 小分分析 @ /department/jiaow/exam/count/teach/stu_view1.jsp |
| /department/jiaow/exam/count/teach/stu_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f |  | m, f | 学生分析 @ /department/jiaow/exam/count/teach/small-view.jsp； 学生分析 @ /department/jiaow/exam/count/teach/stu_view.jsp； 学生分析 @ /department/jiaow/exam/count/teach/stu_view1.jsp |
| /department/jiaow/exam/count/teach/stu_view1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f |  |
| /department/jiaow/exam/count/teach/youliang_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f |  | m, f | 优良差率 @ /department/jiaow/exam/count/teach/small-view.jsp； 优良差率 @ /department/jiaow/exam/count/teach/stu_view.jsp； 优良差率 @ /department/jiaow/exam/count/teach/stu_view1.jsp |
| /department/jiaow/exam/count/teach/zlfx.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f | 质量分析 @ /department/jiaow/exam/count/teach/small-view.jsp； 质量分析 @ /department/jiaow/exam/count/teach/stu_view.jsp； 质量分析 @ /department/jiaow/exam/count/teach/stu_view1.jsp |
| /department/jiaow/exam/count/toolbar.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | examName, modual, from, identity, gradeIds, chooseClass, courseIds, objNo, active, scoreName |  |
| /department/jiaow/exam/count/ycb_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：stuStatus, type |  | stuStatus, type |  |
| /department/jiaow/exam/count/ycb-view.jsp | 【全校分析-英才榜】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：sf, gids, ccs, cids, o |  | sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/exam/count/ycb.jsp |
| /department/jiaow/exam/count/ycb.jsp | 【全校分析-英才榜】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/exam/count/ycb-view.jsp |
| /department/jiaow/exam/entry/ajax/historyInfo.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：historyId |  | historyId |  |
| /department/jiaow/exam/entry/ajax/importHistory.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/exam/entry/ajax/searchStudent.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId, classId, courseId, newexam, searchKey, objNo |  | examId, classId, courseId, newexam, searchKey, objNo |  |
| /department/jiaow/exam/entry/class_course.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | gradeId, classId, courseId, openURL, entryType, close, objNo, inputType, inputLength | 成绩录入 @ /department/jiaow/exam/entry/import.jsp； 返回 @ /department/jiaow/exam/entry/updateStu.jsp |
| /department/jiaow/exam/entry/class-level.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | objNo |  |
| /department/jiaow/exam/entry/class.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | gradeId, classId, courseId, openURL, entryType, objNo, inputType, inputLength | 等级录入 @ /department/jiaow/exam/entry/class_course.jsp； 等级录入 @ /department/jiaow/exam/entry/class.jsp； 成绩录入 @ /department/jiaow/exam/entry/import.jsp |
| /department/jiaow/exam/entry/entry-power.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  | 录入授权 @ /department/jiaow/exam/entry/entry.jsp |
| /department/jiaow/exam/entry/entry.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  | 成绩录入 @ /department/jiaow/exam/entry/entry-power.jsp |
| /department/jiaow/exam/entry/export.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | gradeId, classId, courseId, entryType, objNo, examId | 成绩导出 @ /department/jiaow/exam/entry/class_course.jsp； 成绩导出 @ /department/jiaow/exam/entry/class-level.jsp； 成绩导出 @ /department/jiaow/exam/entry/class.jsp |
| /department/jiaow/exam/entry/grade-count.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 单独统计 @ /department/jiaow/exam/entry/entry.jsp |
| /department/jiaow/exam/entry/import.jsp | 成绩导入 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | gradeId, objNo, openURL |  |
| /department/jiaow/exam/entry/scoreImport.jsp | 绿蜻蜓云校园 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 成绩导入 @ /department/jiaow/exam/entry/class_course.jsp； 成绩导入 @ /department/jiaow/exam/entry/class-level.jsp； 成绩导入 @ /department/jiaow/exam/entry/class.jsp |
| /department/jiaow/exam/entry/stu-audit.jsp | 异常分核定 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：objNo |  | objNo |  |
| /department/jiaow/exam/entry/updateStu.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | openURL, entryType, objNo | 学生名单更新 @ /department/jiaow/exam/entry/class_course.jsp； 学生名单更新 @ /department/jiaow/exam/entry/class-level.jsp； 学生名单更新 @ /department/jiaow/exam/entry/class.jsp |
| /department/jiaow/exam/exam-info.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list | examId, t, g |  |
| /department/jiaow/exam/exp1/exp_info.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | {{i.EXAM_NAME}} @ /department/jiaow/exam/exp1/list.jsp |
| /department/jiaow/exam/exp1/list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-exp1 | top-active=dept; dept-id=jiaow; dept-left=exam-exp1 | termId |  |
| /department/jiaow/exam/exp1/step1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 exam-exp1 | top-active=dept; dept-id=jiaow; dept-left=exam-exp1 |  | 新建分析 @ /department/jiaow/exam/exp1/list.jsp |
| /department/jiaow/exam/exp1/step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 exam-exp1 | top-active=dept; dept-id=jiaow; dept-left=exam-exp1 |  | {{i.EXAM_NAME}} @ /department/jiaow/exam/exp1/list.jsp |
| /department/jiaow/exam/exp1/step3_1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 exam-exp1 | top-active=dept; dept-id=jiaow; dept-left=exam-exp1 |  |  |
| /department/jiaow/exam/exp1/step3_2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 exam-exp1 | top-active=dept; dept-id=jiaow; dept-left=exam-exp1 |  |  |
| /department/jiaow/exam/exp1/step3_3.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 exam-exp1 | top-active=dept; dept-id=jiaow; dept-left=exam-exp1 |  |  |
| /department/jiaow/exam/exp1/student_set.jsp | 人工调整 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/fenduan/fenduanadd.jsp | 新建分段模板 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> fenduan-list | top-active=dept; dept-id=jiaow; dept-left=fenduan-list |  | 新建分段模板 @ /department/jiaow/exam/fenduan/fenduanlist.jsp；  @ /department/jiaow/exam/fenduan/fenduanlist.jsp；  @ /department/jiaow/exam/fenduan/fenduanlist.jsp |
| /department/jiaow/exam/fenduan/fenduanlist.jsp | 分段模板 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> fenduan-list | top-active=dept; dept-id=jiaow; dept-left=fenduan-list |  | 分段模板 @ /department/jiaow/exam/fenduan/fenduanadd.jsp； 分段模板 @ /department/jiaow/exam/rate/ratelistLevelshow.jsp； 分段模板 @ /department/jiaow/exam/rate/ratelistshow.jsp |
| /department/jiaow/exam/go.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 确定 @ /department/jiaow/exam/analyse/school-power.jsp； 确定 @ /department/jiaow/exam/analyse/stu-power.jsp；  @ /department/jiaow/exam/small/list.jsp |
| /department/jiaow/exam/history/nav.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | gradeYear, gradeTerm, gradeStatus, stepShow |  |
| /department/jiaow/exam/history/step1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 exam-history | top-active=dept; dept-id=jiaow; dept-left=exam-history |  |  |
| /department/jiaow/exam/history/step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 exam-history | top-active=dept; dept-id=jiaow; dept-left=exam-history |  |  |
| /department/jiaow/exam/history/step3.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 exam-history | top-active=dept; dept-id=jiaow; dept-left=exam-history |  | 下一步 @ /department/jiaow/exam/history/step2.jsp |
| /department/jiaow/exam/history/step4.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 exam-history | top-active=dept; dept-id=jiaow; dept-left=exam-history |  | 信息有误，重新导入 @ /department/jiaow/exam/history/step3.jsp； 无匹配学期，另外导入 @ /department/jiaow/exam/history/step3.jsp |
| /department/jiaow/exam/level/addLevel.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/level/level-edit.jsp | 新建等第模板 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 exam-level | top-active=dept; dept-id=jiaow; dept-left=exam-level | levelId | 新建等第模板 @ /department/jiaow/exam/level/levels.jsp；  @ /department/jiaow/exam/level/levels.jsp |
| /department/jiaow/exam/level/level-Lv2Score.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-level | top-active=dept; dept-id=jiaow; dept-left=exam-level | levelId | @ /department/jiaow/exam/level/levels.jsp |
| /department/jiaow/exam/level/level-Score2Lv.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-level | top-active=dept; dept-id=jiaow; dept-left=exam-level |  | @ /department/jiaow/exam/level/levels.jsp |
| /department/jiaow/exam/level/levels.jsp | 等第模板 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-level | top-active=dept; dept-id=jiaow; dept-left=exam-level |  | 等第模板 @ /department/jiaow/exam/level/level-edit.jsp； 等第系统 @ /department/jiaow/exam/level/level-Lv2Score.jsp； 等第系统 @ /department/jiaow/exam/level/level-Score2Lv.jsp |
| /department/jiaow/exam/level/lvInfoAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：LEVEL_ID |  | LEVEL_ID |  |
| /department/jiaow/exam/level/temps/mode1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/level/temps/mode2.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/level/temps/mode3.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/level/temps/mode4.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/list.jsp | 考试列表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list | termId, courseCode | 考试列表 @ /department/jiaow/exam/term/info.jsp； 考试列表 @ /department/jiaow/exam/term/step1.jsp； 考试列表 @ /department/jiaow/exam/term/step2.jsp |
| /department/jiaow/exam/nav.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | examId, examName, examStatus, step, examType |  |
| /department/jiaow/exam/paper/add.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> exam-manager | top-active=affair; dept-left=exam-manager |  | 新增试卷 @ /department/jiaow/exam/paper/list.jsp |
| /department/jiaow/exam/paper/list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> exam-manager | top-active=affair; dept-left=exam-manager | termId, subjectCode | 试卷管理 @ /department/jiaow/exam/paper/add.jsp |
| /department/jiaow/exam/rate/rateadd.jsp | 新建分率模板 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> rate-list | top-active=dept; dept-id=jiaow; dept-left=rate-list |  | 新建分率模板 @ /department/jiaow/exam/rate/ratelist.jsp；  @ /department/jiaow/exam/rate/ratelist.jsp |
| /department/jiaow/exam/rate/ratedefault.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> rate-list | top-active=dept; dept-id=jiaow; dept-left=rate-list |  | 默认配置表 @ /department/jiaow/exam/rate/ratelist.jsp |
| /department/jiaow/exam/rate/ratedetail.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/rate/rateLeveldetail.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/rate/ratelist.jsp | 分率模板 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> rate-list | top-active=dept; dept-id=jiaow; dept-left=rate-list |  | 分率模板 @ /department/jiaow/exam/rate/rateadd.jsp； 分率模板 @ /department/jiaow/exam/rate/ratelistLevelshow.jsp； 分率模板 @ /department/jiaow/exam/rate/ratelistshow.jsp |
| /department/jiaow/exam/rate/ratelistLevelshow.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-level | top-active=dept; dept-id=jiaow; dept-left=exam-level; dept-left=rate-list; dept-left=fenduan-list | type |  |
| /department/jiaow/exam/rate/ratelistshow.jsp | 分段默认配置表 分率默认配置表 等第默认配置表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-level | top-active=dept; dept-id=jiaow; dept-left=exam-level; dept-left=rate-list; dept-left=fenduan-list | type | 分段默认配置表 @ /department/jiaow/exam/fenduan/fenduanlist.jsp； 等第默认配置表 @ /department/jiaow/exam/level/levels.jsp； 分率默认配置表 @ /department/jiaow/exam/rate/ratelist.jsp |
| /department/jiaow/exam/set-info.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  |  |
| /department/jiaow/exam/set.jsp | 标准考试 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  |  |
| /department/jiaow/exam/small/course-set-detail.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/small/course-set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-small | top-active=dept; dept-id=jiaow; dept-left=exam-small |  | @ /department/jiaow/exam/small/info.jsp |
| /department/jiaow/exam/small/download.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | openURL, objNo | 小分导出 @ /department/jiaow/exam/small/entry-one-list.jsp； 小分导出 @ /department/jiaow/exam/small/entry.jsp |
| /department/jiaow/exam/small/entry-one-detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：courseName, openURL, pageTitle, objNo, inputType, inputLength |  | courseName, openURL, pageTitle, objNo, inputType, inputLength |  |
| /department/jiaow/exam/small/entry-one-list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | courseName, openURL, pageTitle, objNo, inputType, inputLength |  |
| /department/jiaow/exam/small/entry.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | courseName, openURL, pageTitle, objNo, inputType, inputLength | 小分录入 @ /department/jiaow/exam/small/import.jsp |
| /department/jiaow/exam/small/import.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | courseName, openURL, pageTitle, objNo | 小分导入 @ /department/jiaow/exam/small/entry-one-list.jsp； 小分导入 @ /department/jiaow/exam/small/entry.jsp |
| /department/jiaow/exam/small/info.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-small | top-active=dept; dept-id=jiaow; dept-left=exam-small |  | @ /department/jiaow/exam/small/course-set.jsp； 返回 @ /department/jiaow/exam/small/course-set.jsp；  @ /department/jiaow/exam/small/list.jsp |
| /department/jiaow/exam/small/list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-small | top-active=dept; dept-id=jiaow; dept-left=exam-small | termId | 小分试题 @ /department/jiaow/exam/small/course-set.jsp； 小分试题 @ /department/jiaow/exam/small/info.jsp； 返回 @ /department/jiaow/exam/small/info.jsp |
| /department/jiaow/exam/small/power.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-small | top-active=dept; dept-id=jiaow; dept-left=exam-small |  | 小分录入授权 @ /department/jiaow/exam/small/info.jsp |
| /department/jiaow/exam/small/table.jsp | Table | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | termId |  |
| /department/jiaow/exam/small/table/t.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/small/table/test.jsp | Sticky Table Headers Revisited \| Demo 3 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/term/handleUnusual.jsp | 无成绩处理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list | exam_id, grade_code, grade_name, title, termId, eType |  |
| /department/jiaow/exam/term/info.jsp | 学年总评 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  | 学年总评 @ /department/jiaow/exam/list.jsp； 学年总评 @ /department/list.jsp； 学期总评 @ /department/list.jsp |
| /department/jiaow/exam/term/step1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  | @ /department/jiaow/exam/term/info.jsp； 取消 @ /department/jiaow/exam/term/step2.jsp |
| /department/jiaow/exam/term/step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  |  |
| /department/jiaow/exam/term/termInfo.jsp | 学期总评 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list |  | 学期总评 @ /department/jiaow/exam/list.jsp |
| /department/jiaow/exam/term/termPower.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/exam/term/termStep1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/exam/term/termStep2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/exam/test/level.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-test-power | top-active=dept; dept-id=jiaow; dept-left=exam-test-power |  | 测验等第设置 @ /department/jiaow/exam/test/level.jsp； 测验等第设置 @ /department/jiaow/exam/test/power.jsp； 测验等级设置 @ /department/jiaow/exam/test/rate.jsp |
| /department/jiaow/exam/test/power.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-test-power | top-active=dept; dept-id=jiaow; dept-left=exam-test-power |  | 测验成绩权限 @ /department/jiaow/exam/test/level.jsp； 测验成绩权限 @ /department/jiaow/exam/test/power.jsp； 测验成绩权限 @ /department/jiaow/exam/test/rate.jsp |
| /department/jiaow/exam/test/rate.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-test-power | top-active=dept; dept-id=jiaow; dept-left=exam-test-power |  | 测验分率设置 @ /department/jiaow/exam/test/level.jsp； 测验分率设置 @ /department/jiaow/exam/test/power.jsp； 测验分率设置 @ /department/jiaow/exam/test/rate.jsp |
| /department/jiaow/exam/usually-all.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list | examId, termId |  |
| /department/jiaow/exam/usually.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list | termId | 平时成绩 @ /department/jiaow/exam/list.jsp； {{examinfo.examName}} @ /department/jiaow/exam/usually-all.jsp； 返回 @ /department/jiaow/exam/usually-all.jsp |
| /department/jiaow/func/deptMember.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/func/list.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/neck.jsp -> 权限 | top-active=dept; dept-id=; dept-right=power |  | 部门功能 @ /department/jiaow/func/list.jsp； 部门功能 @ /department/jiaow/func/set_funcs.jsp； 权限 @ /inc/page/neck.jsp |
| /department/jiaow/func/listAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/func/set_funcs.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> power -> 左侧菜单 | top-active=dept; dept-right=power |  | 通用功能 @ /department/jiaow/func/list.jsp； 通用功能 @ /department/jiaow/func/set_funcs.jsp |
| /department/jiaow/issue/applyIssue.jsp | 课程信息 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-issue-temp | top-active=dept; dept-id=jiaow; dept-left=jiaow-issue-temp | ID, TEMP_ID |  |
| /department/jiaow/issue/issueBankList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-issue-temp | top-active=dept; dept-id=jiaow; dept-left=jiaow-issue-temp |  |  |
| /department/jiaow/issue/issueForm.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/issue/issueFormJs.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/issue/issueFormView.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/issue/issueRemark.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> tea-issue-temp | top-active=course; dept-left=tea-issue-temp | CATE |  |
| /department/jiaow/issue/issueRule.jsp | 选修课程 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-temp | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-temp | SEA_COURSE_TYPE, SEA_CATEGORY, SEA_STATUS, SEA_NAME |  |
| /department/jiaow/issue/issueTemp.jsp | 选修课程 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-issue-temp | top-active=dept; dept-id=jiaow; dept-left=jiaow-issue-temp | SEA_NAME | 返回 @ /department/jiaow/issue/issueBankList.jsp |
| /department/jiaow/issue/issueTotal.jsp | 创新实践课题 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-issue-total | top-active=dept; dept-id=jiaow; dept-left=jiaow-issue-total | TERM_CODE, SEA_NAME |  |
| /department/jiaow/issue/jwc_edit_issue.jsp | 课程信息 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-issue-temp | top-active=dept; dept-id=jiaow; dept-left=jiaow-issue-temp | ISSUE_ID |  |
| /department/jiaow/issue/jwc_issue_detail.jsp | 创新实践课题 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 jiaow-issue-total | top-active=dept; dept-id=jiaow; dept-left=jiaow-issue-total | ID |  |
| /department/jiaow/issue/jwc_issue_test_view.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/issue/multAdd.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-issue-temp | top-active=dept; dept-id=jiaow; dept-left=jiaow-issue-temp |  |  |
| /department/jiaow/issue/remark_inc.html |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/issue/remarkView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 jiaow-issue-total | top-active=dept; dept-id=jiaow; dept-left=jiaow-issue-total | STU_ID, ISSUE_ID |  |
| /department/jiaow/issue/temp/addTemp.jsp | 新建课程 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-issue-temp | top-active=dept; dept-id=jiaow; dept-left=jiaow-issue-temp | ID |  |
| /department/jiaow/jw.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> 左侧菜单 | top-active=dept; dept-id=jiaow |  | 我的应用 @ /inc/page/cloud/head.jsp； 教务处 @ /inc/page/Copy of neck.jsp； 我的应用 @ /inc/page/stu/head.jsp |
| /department/jiaow/kb/addKbDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：CLSID, DETAIL_ID, WEEK_NO, CH_CODE |  | CLSID, DETAIL_ID, WEEK_NO, CH_CODE |  |
| /department/jiaow/kb/Am-Kbexchange-Application.jsp | 调课申请 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> user-trans | top-active=affair; dept-left=user-trans |  |  |
| /department/jiaow/kb/Am-KBExchangeAffairsDetails.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> course-trans | top-active=dept; dept-left=course-trans |  |  |
| /department/jiaow/kb/Am-KbExchangeReplace-Build.jsp | 发起调代课 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> course-trans | top-active=dept; dept-left=course-trans |  |  |
| /department/jiaow/kb/Am-kbExchangeReplace-Class.jsp | 调代课安排-班内调换 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/kb/Am-KbExchangeReplace-Deal.jsp | 调课代管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> course-trans | top-active=dept; dept-left=course-trans |  |  |
| /department/jiaow/kb/Am-KbExchangeReplace-Freedom.jsp | 调代课安排-自由调换 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/kb/Am-KbExchangeReplace-Remind.jsp | 调课代管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> course-trans | top-active=dept; dept-left=course-trans |  |  |
| /department/jiaow/kb/Am-KbExchangeReplace-statistics.jsp | 代课统计 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> substitute-stat | top-active=dept; dept-left=substitute-stat |  |  |
| /department/jiaow/kb/Am-KbExchangeReplace-WaitForDeal.jsp | 调课代管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> course-trans | top-active=dept; dept-left=course-trans |  |  |
| /department/jiaow/kb/Am-Replace-Statistic.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> course-trans | top-active=dept; dept-left=course-trans |  |  |
| /department/jiaow/kb/Am-Self-Negotiation-Class.jsp | 调代课安排-班级视图 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/kb/Am-self-Negotiation-Teacher.jsp | 调代课安排-教师视图 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/kb/Am-teaKbApply.jsp | 调代课申请 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> course-kb | top-active=teach; dept-left=course-kb |  | 调代课申请 @ /department/jiaow/kb/teaKbApplyRecord.jsp |
| /department/jiaow/kb/holidayKbOption.jsp | 课表设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> jiaow-kbgl | top-active=dept; dept-left=jiaow-kbgl |  |  |
| /department/jiaow/kb/impKb.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/kb/inc_Kbexchange_tab.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | li |  |
| /department/jiaow/kb/kbMgr.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> jiaow-kbgl | top-active=dept; dept-left=jiaow-kbgl | GRADE_CODE, CLS_ID |  |
| /department/jiaow/kb/KbView.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/kb/kbWeekMgr.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> jiaow-kbgl | top-active=dept; dept-left=jiaow-kbgl | GRADE_CODE, CLS_ID |  |
| /department/jiaow/kb/stuKbView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 源码菜单 /inc/page/body-left.jsp -> 我的课表 | top-active=teach; dept-left=course-kb | KB_TYPE | 我的课表 @ /fix/test_body_left.jsp； 孩子课表 @ /fix/test_body_left.jsp； 我的课表 @ /inc/page/body-left.jsp |
| /department/jiaow/kb/teaKbApplyOtherRecord.jsp | 向我调代 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> course-kb | top-active=teach; dept-left=course-kb |  | 向我调代 @ /department/jiaow/kb/teaKbApplyOtherRecord.jsp； 向我调代 @ /department/jiaow/kb/teaKbApplyRecord.jsp； 向我调代 @ /department/jiaow/kb/teaKbClsView.jsp |
| /department/jiaow/kb/teaKbApplyRecord.jsp | 我要调代 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> course-kb | top-active=teach; dept-left=course-kb |  | 返回 @ /department/jiaow/kb/Am-teaKbApply.jsp； 我要调代 @ /department/jiaow/kb/teaKbApplyOtherRecord.jsp； 我要调代 @ /department/jiaow/kb/teaKbApplyRecord.jsp |
| /department/jiaow/kb/teaKbClsView.jsp | 班级课表 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 course-kb | top-active=teach; dept-left=course-kb | CLSID | 班级课表 @ /department/jiaow/kb/teaKbApplyOtherRecord.jsp； 班级课表 @ /department/jiaow/kb/teaKbApplyRecord.jsp； 班级课表 @ /department/jiaow/kb/teaKbClsView.jsp |
| /department/jiaow/kb/teaKbView.jsp | 个人课表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 运行时 我的教学 left -> 我的课表 | top-active=teach; dept-left=course-kb |  | 我的课表 @ /teacher/exam/entry-list.jsp； 个人课表 @ /department/jiaow/kb/teaKbApplyOtherRecord.jsp； 个人课表 @ /department/jiaow/kb/teaKbApplyRecord.jsp |
| /department/jiaow/ktpj/addStat.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/ktpj/globalSet.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/ktpj/jwc_item.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> KT_SZ | top-active=dept; dept-left=KT_SZ | OBJ_NAME, OBJ_ID, COURSE_CODE, GRADE_CODE |  |
| /department/jiaow/ktpj/jwc_other_report.jsp | 其他报表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> PJ_TJ | top-active=dept; dept-left=PJ_TJ |  | 其他报表 @ /department/jiaow/ktpj/jwc_other_report.jsp； 其他报表 @ /department/jiaow/ktpj/jwc_week_report.jsp |
| /department/jiaow/ktpj/jwc_pjsz.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> PJ_SZ | top-active=dept; dept-left=PJ_SZ |  |  |
| /department/jiaow/ktpj/jwc_temp.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> KT_SZ | top-active=dept; dept-left=KT_SZ |  |  |
| /department/jiaow/ktpj/jwc_week_report.jsp | 周报表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> PJ_TJ | top-active=dept; dept-left=PJ_TJ |  | 周报表 @ /department/jiaow/ktpj/jwc_other_report.jsp； 周报表 @ /department/jiaow/ktpj/jwc_week_report.jsp |
| /department/jiaow/ktpj/useSet.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/ktpj/viewCourseItem.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/ktpj/week_statList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/newexam/add.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= | t, g, typeCode | 新建考试 @ /department/jiaow/newexam/list.jsp |
| /department/jiaow/newexam/analyse/ajax/searchStudent.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：examId, searchKey, examType |  | examId, searchKey, examType |  |
| /department/jiaow/newexam/analyse/go-analyse.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  | 成绩统计 @ /department/jiaow/exam/analyse/audit-set.jsp； 成绩统计 @ /department/jiaow/exam/analyse/fenduan.jsp； 成绩统计 @ /department/jiaow/exam/analyse/morecourse-error-set.jsp |
| /department/jiaow/newexam/analyse/score-line.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  |  |
| /department/jiaow/newexam/analyse/stu-power.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  |  |
| /department/jiaow/newexam/analyse/stu-power100.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-manager | top-active=dept; dept-id=jiaow; dept-left=exam-manager |  |  |
| /department/jiaow/newexam/analyse/tea-power-def.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  | 配置默认权限 @ /department/jiaow/newexam/analyse/tea-power.jsp |
| /department/jiaow/newexam/analyse/tea-power.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  | 返回 @ /department/jiaow/newexam/analyse/tea-power-def.jsp |
| /department/jiaow/newexam/analyse/zero-score.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  | 成绩不完整临时统计 @ /department/jiaow/newexam/entry/entry.jsp |
| /department/jiaow/newexam/count/class/stu_tb.jsp | 【班级分析-学生分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | sf, gids, ccs, cids, o |  |
| /department/jiaow/newexam/count/class/zong_view.jsp | 【班级分析-综合分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：sf, gids, ccs, cids, o |  | sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/newexam/count/class/zong.jsp |
| /department/jiaow/newexam/count/class/zong.jsp | 【班级分析-综合分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/newexam/count/class/zong_view.jsp |
| /department/jiaow/newexam/count/course/ban_view.jsp | 【科目分析-版块分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：sf, gids, ccs, cids, o, gradeId, classId, courseId, code |  | sf, gids, ccs, cids, o, gradeId, classId, courseId, code | > 常规--%> 全体 常规 {{g.name}} {{gc.name}} {{cc.name}} 统计 查看图表 @ /department/jiaow/newexam/count/course/ban.jsp |
| /department/jiaow/newexam/count/course/ban.jsp | 【科目分析-版块分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/newexam/count/course/ban_view.jsp |
| /department/jiaow/newexam/count/course/zlfx_look.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m | 查看他人质量分析 @ /department/jiaow/newexam/count/course/zlfx.jsp |
| /department/jiaow/newexam/count/course/zlfx.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m | 返回 @ /department/jiaow/newexam/count/course/zlfx_look.jsp |
| /department/jiaow/newexam/count/course/zong_view.jsp | 【科目分析-综合分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：sf, gids, ccs, cids, o |  | sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/newexam/count/course/zong.jsp |
| /department/jiaow/newexam/count/course/zong.jsp | 【科目分析-综合分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/newexam/count/course/zong_view.jsp |
| /department/jiaow/newexam/count/quick.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/newexam/count/school/zong_view.jsp | 【全校分析-综合分析】 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：sf, gids, ccs, cids, o |  | sf, gids, ccs, cids, o | 查看图表 @ /department/jiaow/newexam/count/school/zong.jsp |
| /department/jiaow/newexam/count/school/zong.jsp | 【全校分析-综合分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | sf, gids, ccs, cids, o | 查看表格 @ /department/jiaow/newexam/count/school/zong_view.jsp |
| /department/jiaow/newexam/count/student/pingyu_print.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 打印 @ /department/jiaow/newexam/count/student/pingyu.jsp |
| /department/jiaow/newexam/count/student/pingyu.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/newexam/count/student/zong_view.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | {{s.stuName}} @ /department/jiaow/newexam/count/class/zong.jsp； {{s.stuName}} @ /department/jiaow/newexam/count/course/zong.jsp； {{s.stuName}} @ /department/jiaow/newexam/count/school/zong.jsp |
| /department/jiaow/newexam/count/toolbar.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | examName, modual, from, identity, gradeIds, chooseClass, courseIds, objNo, active |  |
| /department/jiaow/newexam/count/user_number3.html |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/newexam/entry/class.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | openURL, close, inputType | 返回 @ /department/jiaow/newexam/entry/updateStu.jsp |
| /department/jiaow/newexam/entry/entry-power.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= | examClassId |  |
| /department/jiaow/newexam/entry/entry.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= | examClassId | 成绩录入 @ /department/jiaow/newexam/entry/entry-power.jsp |
| /department/jiaow/newexam/entry/pingyu_class_look.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | openURL |  |
| /department/jiaow/newexam/entry/pingyu_class.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | openURL |  |
| /department/jiaow/newexam/entry/pingyu_stu_look.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | openURL |  |
| /department/jiaow/newexam/entry/pingyu_stu.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | openURL |  |
| /department/jiaow/newexam/entry/teach_go.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | openURL | 评语未录 @ /teacher/exam/entry-list.jsp |
| /department/jiaow/newexam/entry/updateStu.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | openURL, entryType | 学生名单更新 @ /department/jiaow/newexam/entry/class.jsp |
| /department/jiaow/newexam/exam-info.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= | examClassId |  |
| /department/jiaow/newexam/go.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | @ /department/jiaow/newexam/list.jsp |
| /department/jiaow/newexam/list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= | code, termId, courseCode |  |
| /department/jiaow/newexam/nav.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | examId, examName, examStatus, step, examType |  |
| /department/jiaow/newexam/set-info.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  | @ /department/jiaow/newexam/temp-show.jsp； 返回 @ /department/jiaow/newexam/temp-show.jsp； 返回 @ /department/jiaow/newexam/temp-show.jsp |
| /department/jiaow/newexam/set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  | @ /department/jiaow/newexam/temp-edit.jsp； 返回 @ /department/jiaow/newexam/temp-edit.jsp； 返回 @ /department/jiaow/newexam/temp-edit.jsp |
| /department/jiaow/newexam/set/huizong.jsp | 汇总规则 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> newexam-template | top-active=dept; dept-id=jiaow; dept-left=newexam-template |  | 汇总规则 @ /department/jiaow/newexam/set/huizong.jsp； 汇总规则 @ /department/jiaow/newexam/set/level_vue3.jsp； 汇总规则 @ /department/jiaow/newexam/set/level.jsp |
| /department/jiaow/newexam/set/level_vue3.jsp | 综评科目 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> newexam-template | top-active=dept; dept-id=jiaow; dept-left=newexam-template |  | 综评科目 @ /department/jiaow/newexam/set/huizong.jsp； 综评科目 @ /department/jiaow/newexam/set/level_vue3.jsp； 综评科目 @ /department/jiaow/newexam/set/module.jsp |
| /department/jiaow/newexam/set/level.jsp | 综评科目 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> newexam-template | top-active=dept; dept-id=jiaow; dept-left=newexam-template |  | 综评科目 @ /department/jiaow/newexam/set/level.jsp； 基础设置 @ /department/jiaow/newexam/set/test-all.jsp； 基础设置 @ /department/jiaow/newexam/set/test-level.jsp |
| /department/jiaow/newexam/set/module.jsp | 科目版块 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> newexam-template | top-active=dept; dept-id=jiaow; dept-left=newexam-template |  | 科目版块 @ /department/jiaow/newexam/set/huizong.jsp； 科目版块 @ /department/jiaow/newexam/set/level_vue3.jsp； 科目版块 @ /department/jiaow/newexam/set/level.jsp |
| /department/jiaow/newexam/set/ratelistshow.jsp | 默认模板 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> newexam-template | top-active=dept; dept-id=jiaow; dept-left=newexam-template |  | 默认模板 @ /department/jiaow/newexam/set/huizong.jsp； 默认模板 @ /department/jiaow/newexam/set/level_vue3.jsp； 默认模板 @ /department/jiaow/newexam/set/level.jsp |
| /department/jiaow/newexam/set/test-all.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> newexam-template | top-active=dept; dept-id=jiaow; dept-left=newexam-template |  | 查看全部 @ /department/jiaow/newexam/set/test-level.jsp |
| /department/jiaow/newexam/set/test-level.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> newexam-template | top-active=dept; dept-id=jiaow; dept-left=newexam-template |  | 测验模板 @ /department/jiaow/newexam/set/huizong.jsp； 测验模板 @ /department/jiaow/newexam/set/level.jsp； 测验模板 @ /department/jiaow/newexam/set/module.jsp |
| /department/jiaow/newexam/temp-edit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 newexam-list | top-active=dept; dept-id=jiaow; dept-left=newexam-list | tempId |  |
| /department/jiaow/newexam/temp-show.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> newexam-list | top-active=dept; dept-id=jiaow; dept-left=newexam-list | tempId | @ /department/jiaow/newexam/set-info.jsp |
| /department/jiaow/newexam/temp/add.jsp | 修改模板 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> newexam-template | top-active=dept; dept-id=jiaow; dept-left=newexam-template | tempId | 新增模板 @ /department/jiaow/newexam/temp/list.jsp；  @ /department/jiaow/newexam/temp/list.jsp； {{data.tempName}} @ /department/jiaow/newexam/temp/pingyu.jsp |
| /department/jiaow/newexam/temp/list.jsp | 综评模板 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> newexam-template | top-active=dept; dept-id=jiaow; dept-left=newexam-template |  | 模板管理 @ /department/jiaow/newexam/set.jsp； 返回 @ /department/jiaow/newexam/set/huizong.jsp； 返回 @ /department/jiaow/newexam/set/level_vue3.jsp |
| /department/jiaow/newexam/temp/pingyu.jsp | 评语设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> newexam-template | top-active=dept; dept-id=jiaow; dept-left=newexam-template | tempId | 评语设置 @ /department/jiaow/newexam/temp/add.jsp； 设置 @ /department/jiaow/newexam/temp/list.jsp |
| /department/jiaow/newexam/temp/temp-edit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 newexam-list | top-active=dept; dept-id=jiaow; dept-left=newexam-list | tempId |  |
| /department/jiaow/print/arrangePrint.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> addPrint | top-active=dept; dept-left=addPrint |  |  |
| /department/jiaow/print/handlePrint.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> handlePrint | top-active=dept; dept-left=handlePrint |  |  |
| /department/jiaow/print/inc_handle_tab.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | li |  |
| /department/jiaow/print/remindSet.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> handlePrint | top-active=dept; dept-left=handlePrint |  |  |
| /department/jiaow/print/setting.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | source, status |  |
| /department/jiaow/selcourse/add/adminAdd1.jsp | 新建选修课课程 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kec | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kec |  |  |
| /department/jiaow/selcourse/add/adminAdd2.jsp | 管理员新建课程 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kec | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kec |  |  |
| /department/jiaow/selcourse/clsQuery/clsQueryList.jsp | 选修课程 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-cls-stu | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-cls-stu |  |  |
| /department/jiaow/selcourse/clsQuery/courseStuList.jsp | 选修课程 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-course-stu | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-course-stu |  |  |
| /department/jiaow/selcourse/clsQuery/dn_selstu_list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | MAXRECORDS, SEL_TERM_CODE, SEL_GRADE_CODE, SEL_CLASS_ID, SEL_COURSE_ID |  |
| /department/jiaow/selcourse/clsQuery/print_selstu_list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | SEL_TERM_CODE, SEL_GRADE_CODE, SEL_CLASS_ID, SEL_COURSE_ID |  |
| /department/jiaow/selcourse/clsQuery/temp/table.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/selcourse/course/clsKqList_test.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | termId, openIndex, checkDate |  |
| /department/jiaow/selcourse/course/clsKqList.jsp | 单日考勤 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-total | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-total | termId, openIndex |  |
| /department/jiaow/selcourse/course/kq-total.jsp | 学期考勤 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-total | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-total | TERM_CODE, OPEN_INDEX, OPEN_NAME, GRADE_CODE, SEA_KEY | 学期考勤 @ /department/jiaow/selcourse/statandques/checkonState.jsp |
| /department/jiaow/selcourse/course/list.jsp | 社团选修汇总 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-total | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-total | termId, openIndex, gradeCode | 社团选修汇总 @ /coursespace/giveMark/jwGiveMarkList.jsp； 社团选修汇总 @ /department/jiaow/selcourse/course/clsKqList.jsp； 社团选修汇总 @ /department/jiaow/selcourse/course/kq-total.jsp |
| /department/jiaow/selcourse/course/listAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, SEA_TERM_CODE |  | pageSize, curPage, SEA_TERM_CODE |  |
| /department/jiaow/selcourse/fail/inAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/selcourse/fail/list.jsp | 课程审核 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-aduit | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-aduit |  | 未通过课程 @ /coursespace/inc/body-right-top.jsp； 驳回选修课 @ /department/jiaow/selcourse/inc/body-right-top.jsp |
| /department/jiaow/selcourse/inaduit/failReason.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | OP |  |
| /department/jiaow/selcourse/inaduit/inAjax_bak.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | ID |  |
| /department/jiaow/selcourse/inaduit/inAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/selcourse/inaduit/inAjaxW_bak.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | ID |  |
| /department/jiaow/selcourse/inaduit/inAjaxW.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/selcourse/inaduit/inList.jsp | 课程审核 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-aduit | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-aduit |  | 待审选修课 @ /department/jiaow/selcourse/inc/body-right-top.jsp |
| /department/jiaow/selcourse/inaduit/limitchoose.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/selcourse/inaduit/limitchoose2.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/selcourse/inc/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li |  | li |  |
| /department/jiaow/selcourse/inc/edit/courseArea.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/selcourse/inc/edit/selcourseAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：ID |  | ID |  |
| /department/jiaow/selcourse/inc/edit/selcourseArea.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：COURSE_ID |  | COURSE_ID |  |
| /department/jiaow/selcourse/inc/edit/selcourseArea1.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/selcourse/inc/edit/teacherArea.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/selcourse/inc/getCourseScope.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：COURSE_ID, IDS |  | COURSE_ID, IDS |  |
| /department/jiaow/selcourse/inc/getCourseScopeAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/selcourse/inc/getCourseScopeIfame.jsp | 待审核课程 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：COURSE_ID, IDS |  | COURSE_ID, IDS |  |
| /department/jiaow/selcourse/inc/getCourseTime.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：COURSE_ID, IDS |  | COURSE_ID, IDS |  |
| /department/jiaow/selcourse/inc/getCourseTimeAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/selcourse/inc/getSchClass.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：COURSE_ID, IDS |  | COURSE_ID, IDS |  |
| /department/jiaow/selcourse/inc/getSchClassAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/selcourse/inc/getTSGradeScope.jsp | 待审核课程 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：COURSE_ID, IDS, INDEX |  | COURSE_ID, IDS, INDEX |  |
| /department/jiaow/selcourse/inc/getTsOpenGradeScope.jsp | 待审核课程 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：COURSE_ID, IDS, INDEX |  | COURSE_ID, IDS, INDEX |  |
| /department/jiaow/selcourse/inc/view/courseInfo_view.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/selcourse/inc/view/courseInfo.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/selcourse/inc/view/courseTitle.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/selcourse/inc/view/failInfo.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/selcourse/inc/view/selcourseInfo.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/selcourse/inc/view/teacherInfo.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/selcourse/lib/list-template-page-Vue3.jsp | 选修课程 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-temp | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-temp | SEA_COURSE_TYPE, SEA_CATEGORY, SEA_STATUS, SEA_NAME |  |
| /department/jiaow/selcourse/lib/list.jsp | 选修课程模板 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-temp | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-temp | SEA_COURSE_TYPE, SEA_CATEGORY, SEA_STATUS, SEA_NAME | 选修课程模板 @ /coursespace/inc/body-right-top.jsp； 选修课程模板 @ /department/jiaow/selcourse/inc/body-right-top.jsp； 选修课程模板 @ /department/jiaow/selcourse/lib/pubCommentLib.jsp |
| /department/jiaow/selcourse/lib/listAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, COURSE_TYPE, seaCategory, seaStatus, seaName |  | pageSize, curPage, COURSE_TYPE, seaCategory, seaStatus, seaName |  |
| /department/jiaow/selcourse/lib/pubCommentLib.jsp | 公共评语库 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-temp | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-temp |  |  |
| /department/jiaow/selcourse/statandques/checkonState.jsp | 学期考勤详情 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-total | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-total | curCourseId, TERM_CODE, termId, openIndex, gradeCode | 查看详情 @ /department/jiaow/selcourse/course/kq-total.jsp；  @ /department/jiaow/selcourse/course/listAjax.jsp； ">查看 @ /department/jiaow/selcourse/statandques/courseStat/list.jsp |
| /department/jiaow/selcourse/statandques/courseStat.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-tongj | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-tongj |  | 统计评价 @ /inc/page/body-left_bak.jsp |
| /department/jiaow/selcourse/statandques/courseStat/list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | termId |  |
| /department/jiaow/selcourse/statandques/cousePjState.jsp | 评价统计 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-total | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-total | curCourseId | 查看 @ /department/jiaow/selcourse/course/list.jsp；  @ /department/jiaow/selcourse/course/listAjax.jsp； 评价统计 @ /department/jiaow/selcourse/statandques/checkonState.jsp |
| /department/jiaow/selcourse/statandques/cousePjState/list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | curCourseId |  |
| /department/jiaow/selcourse/success/inAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：ID |  | ID |  |
| /department/jiaow/selcourse/success/inAjaxW.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/selcourse/success/list.jsp | 课程审核 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-aduit | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-aduit |  | 已通过课程 @ /coursespace/inc/body-right-top.jsp； 通过选修课 @ /department/jiaow/selcourse/inc/body-right-top.jsp |
| /department/jiaow/shzp/base/export-field.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> shzp-baseset | top-active=dept; dept-id=jiaow; dept-left=shzp-baseset |  | 年级导出名称 @ /department/jiaow/shzp/base/head.jsp |
| /department/jiaow/shzp/base/export-subfield.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> shzp-baseset | top-active=dept; dept-id=jiaow; dept-left=shzp-baseset |  | 课程导出名称 @ /department/jiaow/shzp/base/head.jsp |
| /department/jiaow/shzp/base/head.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | li |  |
| /department/jiaow/shzp/ha/groupFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：ITEM_ID, HA_TYPE |  | ITEM_ID, HA_TYPE | 集体填报 @ /department/jiaow/shzp/ha/healthedu_project.jsp |
| /department/jiaow/shzp/ha/ha_stu_view.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/shzp/ha/head.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | type |  |
| /department/jiaow/shzp/ha/healthedu_add_step1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：TERM_CODE, HA_TYPE |  | TERM_CODE, HA_TYPE |  |
| /department/jiaow/shzp/ha/healthedu_add_step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：TERM_CODE, HA_TYPE, QUEUE_ID |  | TERM_CODE, HA_TYPE, QUEUE_ID |  |
| /department/jiaow/shzp/ha/healthedu_edit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：termId, type, dataId |  | termId, type, dataId |  |
| /department/jiaow/shzp/ha/healthedu_group_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：queue_id, term_code, fill_type, type |  | queue_id, term_code, fill_type, type |  |
| /department/jiaow/shzp/ha/healthedu_index.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | type |  |
| /department/jiaow/shzp/ha/healthedu_out.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | termId, type |  |
| /department/jiaow/shzp/ha/healthedu_outview.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：statId, termId, type |  | statId, termId, type | {{el.NAME}} @ /department/jiaow/shzp/ha/healthedu_out.jsp |
| /department/jiaow/shzp/ha/healthedu_project.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | type |  |
| /department/jiaow/shzp/mc/groupFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：ITEM_ID, HA_TYPE |  | ITEM_ID, HA_TYPE | 集体填报 @ /department/jiaow/shzp/mc/mc_project.jsp |
| /department/jiaow/shzp/mc/head.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | type |  |
| /department/jiaow/shzp/mc/mc_add_step1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：TERM_CODE, HA_TYPE |  | TERM_CODE, HA_TYPE |  |
| /department/jiaow/shzp/mc/mc_add_step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：TERM_CODE, HA_TYPE, QUEUE_ID |  | TERM_CODE, HA_TYPE, QUEUE_ID |  |
| /department/jiaow/shzp/mc/mc_edit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：type, termId, dataId, a_name |  | type, termId, dataId, a_name |  |
| /department/jiaow/shzp/mc/mc_index.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | type |  |
| /department/jiaow/shzp/mc/mc_out.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | termId, type |  |
| /department/jiaow/shzp/mc/mc_outview.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：statId, termId, type |  | statId, termId, type |  |
| /department/jiaow/shzp/mc/mc_project.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | type |  |
| /department/jiaow/shzp/mc/mc_stu_view.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/shzp/score/baseindex.jsp | 基础型课程成绩 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/shzp/score/basestep1.jsp | 基础型课程成绩 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：type |  | type |  |
| /department/jiaow/shzp/score/basestep2.jsp | 基础型课程成绩 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：type |  | type |  |
| /department/jiaow/shzp/score/basestep3.jsp | 基础型课程成绩 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：type |  | type |  |
| /department/jiaow/shzp/score/basestep4.jsp | 基础型课程成绩 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：type |  | type |  |
| /department/jiaow/shzp/score/basestep5.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/shzp/score/courseindex.jsp | 学业水平考试结果 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/shzp/score/head.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/shzp/selcourse/expandindex.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | type |  |
| /department/jiaow/shzp/selcourse/expandstep1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：type |  | type |  |
| /department/jiaow/shzp/selcourse/expandstep2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：type |  | type |  |
| /department/jiaow/shzp/selcourse/expandstep3.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：type |  | type |  |
| /department/jiaow/shzp/selcourse/expandstep4.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/shzp/selcourse/expandsubmit.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/shzp/selcourse/expandsubmit4.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/student/addParentDialog.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | studentId, parentId, sex, name, phone, unit, post, rest, title |  |
| /department/jiaow/student/ajax/stuListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：searchKey, gradeId, classId, curPage, pageSize, showPwd |  | searchKey, gradeId, classId, curPage, pageSize, showPwd |  |
| /department/jiaow/student/analyse_show.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> examstat-temp | top-active=dept; dept-id=jiaow; dept-left=examstat-temp |  | 考试统计样本 @ /department/jiaow/student/stu.jsp |
| /department/jiaow/student/chcode/change-detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 jiaow-student | top-active=dept; dept-left=jiaow-student | TASK_ID, CLASS_ID |  |
| /department/jiaow/student/chcode/change-index.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> jiaow-student | top-active=dept; dept-left=jiaow-student | gradeId, classId |  |
| /department/jiaow/student/chcode/change-result.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> jiaow-student | top-active=dept; dept-left=jiaow-student | TASK_ID |  |
| /department/jiaow/student/chcode/change-submit.jsp | 未上传 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | term_code, page_size, page_index |  |
| /department/jiaow/student/class/exam_add.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | gradeId, className |  |
| /department/jiaow/student/class/fenban_info.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 查看 @ /department/jiaow/student/class/fenban.jsp |
| /department/jiaow/student/class/fenban_print.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 打印 @ /department/jiaow/student/class/fenban_info.jsp |
| /department/jiaow/student/class/fenban.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 返回重新分班 @ /department/jiaow/student/class/fenban_info.jsp； 智能分班 @ /department/jiaow/student/class/list.jsp |
| /department/jiaow/student/class/list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | gradeId | 分班管理 @ /department/jiaow/student/class/exam_add.jsp； 返回 @ /department/jiaow/student/class/exam_add.jsp； 返回 @ /department/jiaow/student/class/fenban.jsp |
| /department/jiaow/student/files/stuDataFiles.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | SCHOOL_JOINYEAR, STU_TYPE |  |
| /department/jiaow/student/files/stuFiles.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | searchKey |  |
| /department/jiaow/student/files/stuListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：searchKey, gradeId, classId, curPage, pageSize, showPwd |  | searchKey, gradeId, classId, curPage, pageSize, showPwd |  |
| /department/jiaow/student/print/print_student_list.jsp | 打印人员信息 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | searchKey, gradeId, classId, curPage, pageSize, showPwd |  |
| /department/jiaow/student/stu_avatar.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | gradeId, classId |  |
| /department/jiaow/student/stu_avatar2.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | gradeId, classId |  |
| /department/jiaow/student/stu_clear.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | type |  |
| /department/jiaow/student/stu_code.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | gradeId, classId |  |
| /department/jiaow/student/stu_defineinfo.jsp | 学生管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | gradeId, classId |  |
| /department/jiaow/student/stu_import.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student |  | 返回 @ /department/jiaow/student/stu_importinfo.jsp； 导入学生 @ /department/jiaow/student/stu.jsp |
| /department/jiaow/student/stu_importinfo.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student |  | 查看 @ /department/jiaow/student/stu_import.jsp |
| /department/jiaow/student/stu_log.jsp | 学籍异动记录 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | SEA_TYPE, LOG_TYPE, SEA_NAME, START_DATE, END_DATE, gradeId, classId |  |
| /department/jiaow/student/stu_power.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | gradeId, classId |  |
| /department/jiaow/student/stu_xueji.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | gradeId, classId |  |
| /department/jiaow/student/stu-add.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> venue -> venue | top-active=dept; dept-right=venue; dept-left=venue; dept-id=jiaow; dept-left=jiaow-student |  | 新增学生 @ /department/jiaow/student/stu.jsp |
| /department/jiaow/student/stu-edit.jsp | 编辑学生信息 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 ${param.Top} -> 左侧 ${param.Left} | top-active=${param.Top}; dept-id=${param.deptId}; dept-left=${param.Left} | classId, Top, deptId, Left, Identity, tid, gradeId, type | 编辑 @ /department/jiaow/student/stu.jsp；  @ /department/jiaow/student/stu.jsp |
| /department/jiaow/student/stu-exportStuInfo.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/student/stu-importStuHistoryDetail.jsp | 导入学生信息项 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | searchKey |  |
| /department/jiaow/student/stu-importStuInfo.jsp | 导入学生信息项 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | searchKey | 导入学生信息项 @ /department/jiaow/student/stu.jsp |
| /department/jiaow/student/stu.jsp | 学生管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | searchKey | 返回 @ /department/jiaow/student/stu_avatar2.jsp； 返回 @ /department/jiaow/student/stu_import.jsp； 返回 @ /department/jiaow/student/stu-add.jsp |
| /department/jiaow/student/stuCount.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | gradeId, classId |  |
| /department/jiaow/student/stuinfo.jsp | 学生管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-student | top-active=dept; dept-id=jiaow; dept-left=jiaow-student | searchKey |  |
| /department/jiaow/student/stuInfoAuth.jsp | 学生信息授权 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-stuInfoAuth | top-active=dept; dept-id=jiaow; dept-left=jiaow-stuInfoAuth |  |  |
| /department/jiaow/sydx/cls/auditClsStus_vue3.jsp | 学生学期报告 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的班级 left -> 学生学期报告 | top-active=class; dept-left=class-cmaudit |  | 学生学期报告 @ /school/grade/classView.jsp； 学生学期报告 @ /inc/page/body-left.jsp |
| /department/jiaow/sydx/cls/auditClsStus.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 学生学期报告 | top-active=class; dept-left=class-cmaudit | CLASS_ID, REPORT_ID | 学生学期报告 @ /fix/test_body_left.jsp； 学生学期报告 @ /inc/page/body-left.jsp |
| /department/jiaow/sydx/cls/stuAudit.jsp | 报告审核 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 class -> 左侧 class-cmaudit | top-active=class; dept-left=class-cmaudit | REPORT_ID, STU_ID |  |
| /department/jiaow/sydx/fills/clsTeaFill_bak.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> user-trans | top-active=affair; dept-left=user-trans | ID |  |
| /department/jiaow/sydx/fills/clsTeaFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 affair -> 左侧 user-trans | top-active=affair; dept-left=user-trans | ID, CLASS_ID |  |
| /department/jiaow/sydx/fills/clsTeaFillDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 affair -> 左侧 user-trans | top-active=affair; dept-left=user-trans | ID, CLASS_ID |  |
| /department/jiaow/sydx/fills/clsTeaMultFill_vue3.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> user-trans | top-active=affair; dept-left=user-trans | REPORT_ID, CLASS_ID, STU_IDS |  |
| /department/jiaow/sydx/fills/clsTeaMultFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 affair -> 左侧 user-trans | top-active=affair; dept-left=user-trans | REPORT_ID, CLASS_ID, STU_IDS |  |
| /department/jiaow/sydx/fills/clsTeaSingleFill_vue3.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> user-trans | top-active=affair; dept-left=user-trans | REPORT_ID, CLASS_ID, STU_IDS |  |
| /department/jiaow/sydx/fills/clsTeaSingleFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 affair -> 左侧 user-trans | top-active=affair; dept-left=user-trans | REPORT_ID, CLASS_ID, STU_IDS |  |
| /department/jiaow/sydx/fills/stuParFill_AvalonJs.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> user-trans | top-active=affair; dept-left=user-trans | ID |  |
| /department/jiaow/sydx/fills/stuParFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 affair -> 左侧 user-trans | top-active=affair; dept-left=user-trans | ID |  |
| /department/jiaow/sydx/fills/toMyFill.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/sydx/report/all_reports.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sydx-report-list | top-active=dept; dept-left=sydx-report-list | TERM_CODE |  |
| /department/jiaow/sydx/report/classReportPrint.jsp | 整班打印件 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 class -> 左侧 class-cmaudit | top-active=class; dept-left=class-cmaudit | reportId |  |
| /department/jiaow/sydx/report/go.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/sydx/report/nav.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | nvaReportId, reportName, status, step |  |
| /department/jiaow/sydx/report/reportCls.jsp | 查看打印件 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> class-cmaudit | top-active=dept; dept-left=class-cmaudit | REPORT_ID |  |
| /department/jiaow/sydx/report/reportList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sydx-report-list | top-active=dept; dept-left=sydx-report-list | TERM_CODE |  |
| /department/jiaow/sydx/report/reportTeaCls.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> class-cmaudit | top-active=class; dept-left=class-cmaudit | REPORT_ID |  |
| /department/jiaow/sydx/report/reportView.jsp | 查看填报统计 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 sydx-report-list | top-active=dept; dept-left=sydx-report-list | REPORT_ID, CLASS_ID, GRADE_CODE |  |
| /department/jiaow/sydx/report/rptFillInfo.jsp | 查看填报统计 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> class-cmaudit | top-active=dept; dept-left=class-cmaudit | REPORT_ID | 填报统计 @ /department/jiaow/sydx/report/reportView.jsp |
| /department/jiaow/sydx/report/step1_info.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 sydx-report-mgr | top-active=dept; dept-left=sydx-report-mgr |  |  |
| /department/jiaow/sydx/report/step1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 sydx-report-list | top-active=dept; dept-left=sydx-report-list |  |  |
| /department/jiaow/sydx/report/step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 sydx-report-list | top-active=dept; dept-left=sydx-report-list |  |  |
| /department/jiaow/sydx/report/step3.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 sydx-report-list | top-active=dept; dept-left=sydx-report-list |  |  |
| /department/jiaow/sydx/report/step4.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 sydx-report-list | top-active=dept; dept-left=sydx-report-list |  |  |
| /department/jiaow/sydx/report/stu_pdfs.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/sydx/report/stuReportPrint.jsp | 个人打印件 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 class -> 左侧 class-cmaudit | top-active=class; dept-left=class-cmaudit | reportId, classId |  |
| /department/jiaow/sydx/report/viewPdf.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | REPORT_ID, STU_ID |  |
| /department/jiaow/sydx/report/viewPdfData.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | REPORT_ID, STU_ID |  |
| /department/jiaow/sydx/stu/stuReport.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 学期学年报告 | top-active=teach; dept-left=class-cmaudit |  | 学期学年报告 @ /fix/test_body_left.jsp； 学期学年报告 @ /fix/test_body_left.jsp； 学期学年报告 @ /inc/page/body-left.jsp |
| /department/jiaow/sydx/temp/auto_set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sydx-report-temp | top-active=dept; dept-left=sydx-report-temp |  |  |
| /department/jiaow/sydx/temp/fill_set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sydx-report-temp | top-active=dept; dept-left=sydx-report-temp | TEMP_ID, is_set1 |  |
| /department/jiaow/sydx/temp/frm_add_healthedu.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | type |  |
| /department/jiaow/sydx/temp/tempMgr.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> sydx-report-temp | top-active=dept; dept-id=jiaow; dept-left=sydx-report-temp |  | 模板管理 @ /department/jiaow/sydx/temp/auto_set.jsp； 取消 @ /department/jiaow/sydx/temp/auto_set.jsp； 模板管理 @ /department/jiaow/sydx/temp/fill_set.jsp |
| /department/jiaow/teacherArrange/admin.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-tea | top-active=dept; dept-id=jiaow; dept-left=jiaow-tea |  | 任教管理 @ /department/jiaow/teacherArrange/teacher_import.jsp； 任教管理 @ /department/jiaow/teacherArrange/teacher_importinfo.jsp； 任教设置 @ /inc/left.jsp |
| /department/jiaow/teacherArrange/adminBak.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-tea | top-active=dept; dept-id=jiaow; dept-left=jiaow-tea |  |  |
| /department/jiaow/teacherArrange/ajax/adminAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：SEL_GRADE |  | SEL_GRADE |  |
| /department/jiaow/teacherArrange/ajax/statAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curPage, pageSize, GRADE, NAME |  | curPage, pageSize, GRADE, NAME |  |
| /department/jiaow/teacherArrange/statistics.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-tea-tongj | top-active=dept; dept-id=jiaow; dept-left=jiaow-tea-tongj | GRADE, NAME | 教师任教统计 @ /inc/page/body-left_bak.jsp |
| /department/jiaow/teacherArrange/teacher_import.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-tea | top-active=dept; dept-id=jiaow; dept-left=jiaow-tea |  | 导入任教 @ /department/jiaow/teacherArrange/teacher_importinfo.jsp |
| /department/jiaow/teacherArrange/teacher_importinfo.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-tea | top-active=dept; dept-id=jiaow; dept-left=jiaow-tea |  |  |
| /department/jiaow/test/body-right-top.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | li, returnUrl |  |
| /department/jiaow/test/detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：termId, gradeCode, classId, classNO, objNo, courseCode, teacherName, teacherId |  | termId, gradeCode, classId, classNO, objNo, courseCode, teacherName, teacherId |  |
| /department/jiaow/test/input.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | testId, testName, objNo, inputLength | {{el.TEST_NAME}} @ /department/jiaow/test/detail.jsp； {{el.TEST_NAME}} @ /department/jiaow/test/list.jsp |
| /department/jiaow/test/list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> test-all-list | top-active=dept; dept-id=jiaow; dept-left=test-all-list |  | 测验详情 @ /department/jiaow/test/body-right-top.jsp |
| /department/jiaow/test/usually-all.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> test-all-list | top-active=dept; dept-id=jiaow; dept-left=test-all-list |  | 测验汇总 @ /department/jiaow/test/body-right-top.jsp |
| /department/jiaow/xuanx/adjust/add-fail-stu.jsp | 报名调整 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | openParam, openIndex, termId | 加入缺课学生 @ /department/jiaow/xuanx/adjust/adjust-info.jsp； 加入缺课学生 @ /department/jiaow/xuanx/adjust/adjust-info.jsp |
| /department/jiaow/xuanx/adjust/adjust-info.jsp | 报名调整 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | openParam, isOver, openName, openIndex, termId | 返回 @ /department/jiaow/xuanx/adjust/add-fail-stu.jsp； 返回 @ /department/jiaow/xuanx/adjust/add-fail-stu.jsp； 返回 @ /department/jiaow/xuanx/adjust/find-stu.jsp |
| /department/jiaow/xuanx/adjust/adjust-published.jsp | 报名调整 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | openParam, openName, openIndex, termId, tz |  |
| /department/jiaow/xuanx/adjust/adjust.jsp | 报名调整 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | termId, courseIdx | 返回 @ /department/jiaow/xuanx/adjust/adjust-info.jsp； 报名调整 @ /department/jiaow/xuanx/adjust/import-stu-info.jsp； 返回 @ /department/jiaow/xuanx/adjust/import-stu-info.jsp |
| /department/jiaow/xuanx/adjust/find-stu.jsp | 报名调整 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | openParam, openIndex, termId | 查找学生 @ /department/jiaow/xuanx/adjust/adjust-info.jsp； 查找学生 @ /department/jiaow/xuanx/adjust/adjust-info.jsp |
| /department/jiaow/xuanx/adjust/history-info.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | openParam, openName, openIndex |  |
| /department/jiaow/xuanx/adjust/import-stu-info.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | openParam, importId | 查看 @ /department/jiaow/xuanx/adjust/import-stu.jsp |
| /department/jiaow/xuanx/adjust/import-stu.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | openParam, openName |  |
| /department/jiaow/xuanx/ajax/publishListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/jiaow/xuanx/ajax/searchStuAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：searchKey, selCourseId, termId |  | searchKey, selCourseId, termId |  |
| /department/jiaow/xuanx/applicationRecord.jsp | 申请记录 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif |  | 申请记录 @ /department/jiaow/xuanx/nav-tabs.jsp |
| /department/jiaow/xuanx/detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | tabID, ID |  |
| /department/jiaow/xuanx/examen/addExamen.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | openParam, openName, openIndex |  |
| /department/jiaow/xuanx/examen/detailFrm.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/xuanx/examen/editExamen.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | examenId, title |  |
| /department/jiaow/xuanx/examen/preViewNpExamen_1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, type, title |  |
| /department/jiaow/xuanx/examen/questions/multAdd.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | examenId, type, questionId, canEdit, title |  |
| /department/jiaow/xuanx/examen/questions/multEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId, canEdit, title |  |
| /department/jiaow/xuanx/examen/questions/qrAdd.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | examenId, questionId, canEdit, title |  |
| /department/jiaow/xuanx/examen/questions/qrEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId, canEdit, title |  |
| /department/jiaow/xuanx/examen/questions/scrAdd.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | examenId, canEdit, title, questionId, type |  |
| /department/jiaow/xuanx/examen/questions/scrEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, questionId, canEdit, title |  |
| /department/jiaow/xuanx/examen/questions/twsmAdd.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | examenId, questionId, canEdit, title |  |
| /department/jiaow/xuanx/examen/viewListByQuestion.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | examenId, questionId |  |
| /department/jiaow/xuanx/examen/viewNpExamen_1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | examenId, openParam, canEdit, title, str |  |
| /department/jiaow/xuanx/examen/viewNpExamen.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> question -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=question | examenId, openParam |  |
| /department/jiaow/xuanx/examen/viewNpList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | examenId, fromType |  |
| /department/jiaow/xuanx/examen/viewStatistics.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | examenId, title |  |
| /department/jiaow/xuanx/examenDetail.jsp | 未上传 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：name, code, teacher, courseId |  | name, code, teacher, courseId |  |
| /department/jiaow/xuanx/examenXuanxu.jsp | 学生评课 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | openParam, openName, openIndex |  |
| /department/jiaow/xuanx/nav-tabs.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | tab |  |
| /department/jiaow/xuanx/open/index.jsp | 选课批次 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif |  | 返回 @ /department/jiaow/xuanx/open/start.jsp； 开放选课 @ /inc/page/body-left_bak.jsp |
| /department/jiaow/xuanx/open/reopen.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | openedId, courseIdx | 课程调整或补选 @ /department/jiaow/xuanx/publish.jsp |
| /department/jiaow/xuanx/open/setMore.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | selCourseId, selCourseName |  |
| /department/jiaow/xuanx/open/start.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif | selCourse, maxPerson, prePerson, openedId | 修改设置 @ /department/jiaow/xuanx/publish.jsp |
| /department/jiaow/xuanx/publish.jsp | 选课批次 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif |  | 选课批次 @ /department/jiaow/xuanx/nav-tabs.jsp； 返回 @ /department/jiaow/xuanx/open/index.jsp； 返回 @ /department/jiaow/xuanx/open/reopen.jsp |
| /department/jiaow/xuanx/setting-stu.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif |  | 学生申报页面 @ /department/jiaow/xuanx/setting.jsp |
| /department/jiaow/xuanx/setting.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-kaif | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-kaif |  | 设置说明 @ /department/jiaow/xuanx/nav-tabs.jsp； 教师申报页面 @ /department/jiaow/xuanx/setting-stu.jsp |
| /department/jiaow/xuanx/simpleXuanxu.jsp | 选课简报 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | openParam, openName, openIndex |  |
| /department/jiaow/xuanx/teaPower.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/xzexam/count/ban_export.jsp | 导出报表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/xzexam/count/ban.jsp | 【班级分析-版块分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o |  |
| /department/jiaow/xzexam/count/compare_bankuai.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | classId, cExamId, cClassId |  |
| /department/jiaow/xzexam/count/compare_course.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | classId, cExamId, cClassId |  |
| /department/jiaow/xzexam/count/compare_tbankuai.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/xzexam/count/compare_tcourse.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/xzexam/count/course_zlfx.bak.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m |  |
| /department/jiaow/xzexam/count/course_zlfx.jsp | 【科目分析-质量分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o |  |
| /department/jiaow/xzexam/count/coursezlfx_compare.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o |  |
| /department/jiaow/xzexam/count/student.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/jiaow/xzexam/count/zlfx_compare.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o |  |
| /department/jiaow/xzexam/count/zlfx_print.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：m, f, sf, gradeIds, chooseClass, courseIds, objNo |  | m, f, sf, gradeIds, chooseClass, courseIds, objNo | 打印 @ /department/jiaow/xzexam/count/course_zlfx.bak.jsp； 打印表格 @ /department/jiaow/xzexam/count/course_zlfx.jsp； 打印 @ /department/jiaow/xzexam/count/zlfx.jsp |
| /department/jiaow/xzexam/count/zlfx_print1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m | 打印表格 @ /department/jiaow/xzexam/count/zlfx.jsp |
| /department/jiaow/xzexam/count/zlfx_printall.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gradeIds, chooseClass, courseIds, objNo | 打印报告 @ /department/jiaow/xzexam/count/course_zlfx.jsp |
| /department/jiaow/xzexam/count/zlfx_printall1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 打印报告 @ /department/jiaow/xzexam/count/zlfx.jsp |
| /department/jiaow/xzexam/count/zlfx.jsp | 【班级分析-质量分析】 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | m, f, sf, gids, ccs, cids, o |  |
| /department/jiaow/xzexam/entry_class.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | gradeId, classId, courseId, openURL, close | 成绩录入 @ /department/jiaow/xzexam/import.jsp |
| /department/jiaow/xzexam/import.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | gradeId, openURL |  |
| /department/jiaow/xzexam/model_set_level.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  | @ /department/jiaow/xzexam/model_set.jsp |
| /department/jiaow/xzexam/model_set_score.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  | @ /department/jiaow/xzexam/model_set.jsp |
| /department/jiaow/xzexam/model_set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  | {{param.examName}} @ /department/jiaow/xzexam/model_set_level.jsp； 返回 @ /department/jiaow/xzexam/model_set_level.jsp； {{param.examName}} @ /department/jiaow/xzexam/model_set_score.jsp |
| /department/jiaow/xzexam/zero-score.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> | top-active=dept; dept-id=jiaow; dept-left= |  | ==1){ setTimeout("window.location.href='/department/jiaow/newexam/analyse/zero-score.jsp?examId=';", 2000); } },function(){ }); } .kaoshi-title{ font-size: 16px;color: #666666; } .font-color{color: #666666} .a_green:hover{ color: #48B319} .a_warning:hover{ color: #ED9C28} .a_danger:hover{ color:#d9534f} .no-line:hover{text-decoration: none;} 成绩录入 录入授权 @ /department/jiaow/newexam/entry/entry.jsp； 成绩不完整临时统计 @ /department/jiaow/newexam/entry/entry.jsp |
| /department/jiaow/xzexam/zong_entry.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | gradeId, classId, courseId, openURL, close | "+aText+"未录 @ /teacher/exam/entry-list.jsp |

### 部门-德育（253）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /department/dyc/jc/bak/classEducation.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dy-record -> 部门页签 -> dy-pshbns | top-active=dept; dept-id=dy-record; dept-left=dy-pshbns |  |  |
| /department/dyc/jc/bak/classEducationAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /department/dyc/jc/bak/classEducationCon.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/jc/bak/classEducationList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/jc/bak/classEducationWarn.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dy-record -> 部门页签 -> dy-warn | top-active=dept; dept-id=dy-record; dept-left=dy-warn |  |  |
| /department/dyc/jc/bak/detailsPage.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | TYPE |  |
| /department/dyc/jc/classEducation.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dy-record -> 部门页签 -> dy-pshbns | top-active=dept; dept-id=dy-record; dept-left=dy-pshbns | GRADE_CODE, CLASS_ID | 奖励表彰 @ /department/dyc/jc/import_record.jsp； 奖励表彰 @ /department/dyc/jc/import.jsp； 返回 @ /department/dyc/jc/import.jsp |
| /department/dyc/jc/classEducationWarn.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dy-record -> 部门页签 -> dy-warn | top-active=dept; dept-id=dy-record; dept-left=dy-warn | GRADE_CODE, CLASS_ID |  |
| /department/dyc/jc/export_gc.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 导出表格 @ /department/dyc/jc/guildDetailsStu.jsp |
| /department/dyc/jc/guildCount.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dy-record -> 部门页签 -> dy-rulerpt | top-active=dept; dept-id=dy-record; dept-left=dy-rulerpt |  |  |
| /department/dyc/jc/guildCountAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /department/dyc/jc/guildCountStu.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dy-record -> 部门页签 -> dy-rulerpt | top-active=dept; dept-id=dy-record; dept-left=dy-rulerpt |  |  |
| /department/dyc/jc/guildDetails.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/jc/guildDetailsAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /department/dyc/jc/guildDetailsStu.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/jc/guildDetailsStuAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /department/dyc/jc/guildView.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/jc/import_record.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 dy-pshbns | top-active=dept; dept-id=jiaow; dept-left=dy-pshbns | record_id |  |
| /department/dyc/jc/import.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> dy-pshbns | top-active=dept; dept-id=jiaow; dept-left=dy-pshbns |  | 批量导入 @ /department/dyc/jc/import_record.jsp |
| /department/dyc/jc/new/classEducation.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dy-record -> 部门页签 -> dy-pshbns | top-active=dept; dept-id=dy-record; dept-left=dy-pshbns | GRADE_CODE, CLASS_ID |  |
| /department/dyc/jc/new/classEducationWarn.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dy-record -> 部门页签 -> dy-warn | top-active=dept; dept-id=dy-record; dept-left=dy-warn | GRADE_CODE, CLASS_ID |  |
| /department/dyc/kq/addCard.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> kq-card-lib | top-active=dept; dept-left=kq-card-lib | QUERY_TYPE, USER_TYPE, SEARCH_KEY |  |
| /department/dyc/kq/addMCard.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> kq-card-lib | top-active=dept; dept-left=kq-card-lib |  |  |
| /department/dyc/kq/bindMStu.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> kq-card-lib | top-active=dept; dept-left=kq-card-lib | uType |  |
| /department/dyc/kq/bindResult_export.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 导出表格 @ /department/dyc/kq/bindResult.jsp |
| /department/dyc/kq/bindResult.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-set | top-active=dept; dept-left=sg-set |  |  |
| /department/dyc/kq/cardLib.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> kq-card-lib | top-active=dept; dept-left=kq-card-lib | QUERY_TYPE, USER_TYPE, SEARCH_KEY | 卡片库 @ /department/dyc/kq/addMCard.jsp； 卡片库 @ /department/dyc/kq/bindMStu.jsp； 卡片库 @ /department/dyc/kq/bindResult.jsp |
| /department/dyc/kq/kq_today.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> kq-history | top-active=dept; dept-left=kq-history |  | 今日实时统计 @ /department/dyc/kq/week_view.jsp |
| /department/dyc/kq/kq.jsp | Insert title here | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/kq/leave/compensatory/index.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> office-leave_deduction | top-active=dept; dept-left=office-leave_deduction |  |  |
| /department/dyc/kq/leave/compensatory/operation_record.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> office-leave_deduction | top-active=dept; dept-left=office-leave_deduction |  |  |
| /department/dyc/kq/leave/compensatory/use_leave.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> office-leave_deduction | top-active=dept; dept-left=office-leave_deduction | id |  |
| /department/dyc/kq/leave/conflict_dialog.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | leave_id, from_page |  |
| /department/dyc/kq/leave/frm_leave_total_set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/kq/leave/frm_leave_total_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：term_code, teacher_id, search_val, search_type, start_date, end_date |  | term_code, teacher_id, search_val, search_type, start_date, end_date |  |
| /department/dyc/kq/leave/inc_leave_info.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | leave_id, page, cc_id, top_active, from_page |  |
| /department/dyc/kq/leave/inc_leave_tab.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | li |  |
| /department/dyc/kq/leave/leave_approve_cc_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 affair -> 左侧 user-trans | top-active=affair; dept-left=user-trans | cc_id |  |
| /department/dyc/kq/leave/leave_approve_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 office-leave_approve | top-active=dept; dept-left=office-leave_approve | leave_id |  |
| /department/dyc/kq/leave/leave_approve.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> office-leave_approve | top-active=dept; dept-left=office-leave_approve | leave_id |  |
| /department/dyc/kq/leave/leave_cc_set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> office-leave_set | top-active=dept; dept-left=office-leave_set |  |  |
| /department/dyc/kq/leave/leave_dept_record_list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> office-leave_record | top-active=dept; dept-left=office-leave_record |  | 请假记录 @ /department/dyc/kq/leave/leave_record_view.jsp |
| /department/dyc/kq/leave/leave_dept_set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> office-leave_set | top-active=dept; dept-left=office-leave_set |  | 请假设置 @ /department/dyc/kq/leave/leave_cc_set.jsp |
| /department/dyc/kq/leave/leave_fin_list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> office-leave_approve | top-active=dept; dept-left=office-leave_approve |  | 已处理 @ /department/dyc/kq/leave/inc_leave_tab.jsp |
| /department/dyc/kq/leave/leave_notify_set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> office-leave_approve | top-active=dept; dept-left=office-leave_approve |  | 提醒设置 @ /department/dyc/kq/leave/inc_leave_tab.jsp |
| /department/dyc/kq/leave/leave_ready_list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> office-leave_approve | top-active=dept; dept-left=office-leave_approve |  | 待处理 @ /department/dyc/kq/leave/inc_leave_tab.jsp |
| /department/dyc/kq/leave/leave_record_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 office-leave_record | top-active=dept; dept-left=office-leave_record | leave_id |  |
| /department/dyc/kq/leave/leave_total_diy.jsp | 自定义汇总 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> office-leave_total | top-active=dept; dept-left=office-leave_total |  | 自定义汇总 @ /department/dyc/kq/leave/leave_total.jsp |
| /department/dyc/kq/leave/leave_total.jsp | 请假汇总 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> office-leave_total | top-active=dept; dept-left=office-leave_total |  | 请假汇总 @ /department/dyc/kq/leave/leave_total_diy.jsp |
| /department/dyc/kq/leave/leave_user_info.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> office-leave_set | top-active=dept; dept-left=office-leave_set |  |  |
| /department/dyc/kq/multImport.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> kq-card-lib | top-active=dept; dept-left=kq-card-lib | QUERY_TYPE, USER_TYPE, SEARCH_KEY |  |
| /department/dyc/kq/pushSetting.jsp | 推送设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> kq-history | top-active=dept; dept-left=kq-history |  | 推送设置 @ /department/dyc/kq/pushSetting.jsp； 推送设置 @ /department/dyc/kq/week_view.jsp |
| /department/dyc/kq/stu_mk.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> kq-stu-mk | top-active=dept; dept-left=kq-stu-mk |  |  |
| /department/dyc/kq/stuCard_export.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 导出表格 @ /department/dyc/kq/stuCardMgr.jsp |
| /department/dyc/kq/stuCardMgr.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> kq-card-stu | top-active=dept; dept-left=kq-card-stu | GRADE_CODE, CLASS_ID, SEARCH_KEY, NO_CARD_STU |  |
| /department/dyc/kq/studentLeave/leaveRecord.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> dyc-kq_stuLeaveRecord | top-active=dept; dept-left=dyc-kq_stuLeaveRecord |  |  |
| /department/dyc/kq/studentLeave/leaveSetting.jsp | 学生请假设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> dyc-kq_stuLeaveSetting | top-active=dept; dept-left=dyc-kq_stuLeaveSetting |  |  |
| /department/dyc/kq/studentLeave/oneDayRecord.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> dyc-kq_stuLeaveRecord | top-active=dept; dept-left=dyc-kq_stuLeaveRecord |  |  |
| /department/dyc/kq/tea/frm_add_mult.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | year |  |
| /department/dyc/kq/tea/frm_add_single.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | year |  |
| /department/dyc/kq/tea/frm_rule_set_detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：rule_id |  | rule_id |  |
| /department/dyc/kq/tea/holiday_cloud_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 office-sch-xueq | top-active=dept; dept-id=office; dept-left=office-sch-xueq | year |  |
| /department/dyc/kq/tea/holiday_school.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> office-sch-xueq | top-active=dept; dept-id=office; dept-left=office-sch-xueq | year |  |
| /department/dyc/kq/tea/kq_stat_list.jsp | 自定义统计 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 自定义统计 @ /department/dyc/kq/tea/kq_stat_view_detail.jsp； 自定义统计 @ /department/dyc/kq/tea/kq_stat_view.jsp； 自定义统计 @ /department/dyc/kq/tea/step1.jsp |
| /department/dyc/kq/tea/kq_stat_user_view.jsp | 考勤自定义统计 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：stat_id, user_id, status |  | stat_id, user_id, status |  |
| /department/dyc/kq/tea/kq_stat_view_detail.jsp | 考勤统计细目 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：check_nc_mk, id, group_id |  | check_nc_mk, id, group_id |  |
| /department/dyc/kq/tea/kq_stat_view.jsp | 考勤统计查看 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：check_nc_mk, id, group_id |  | check_nc_mk, id, group_id |  |
| /department/dyc/kq/tea/kq_today_view.jsp | 每日详情 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/kq/tea/kq_user_view_v2.jsp | 考勤记录 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | from_page, stat_id, user_id, status |  |
| /department/dyc/kq/tea/kq_user_view.jsp | 考勤记录 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：user_id |  | user_id |  |
| /department/dyc/kq/tea/mult_repair_v2.jsp | 批量补签 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | from_page, repair_name, id, type, date |  |
| /department/dyc/kq/tea/mult_repair.jsp | 批量补签 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/kq/tea/rule_set.jsp | 考勤规则设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/kq/tea/step1.jsp | 考勤自定义统计 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/dyc/kq/tea/step2.jsp | 考勤自定义统计 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：id |  | id |  |
| /department/dyc/kq/teaCard_export.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 导出表格 @ /department/dyc/kq/teaCardMgr.jsp |
| /department/dyc/kq/teaCardMgr.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> kq-card-tea | top-active=dept; dept-left=kq-card-tea | SEARCH_KEY, NO_CARD_TEA |  |
| /department/dyc/kq/unbindMstu.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> kq-card-lib | top-active=dept; dept-left=kq-card-lib | TERM_CODE, GRADE_CODE, CLSID |  |
| /department/dyc/kq/week_view.jsp | 卡考勤统计 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> kq-history | top-active=dept; dept-left=kq-history |  | 学生卡考勤统计 @ /department/dyc/kq/kq_today.jsp； 卡考勤统计 @ /department/dyc/kq/pushSetting.jsp； 卡考勤统计 @ /department/dyc/kq/week_view.jsp |
| /department/dyc/mgr/dyConfirm1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/mgr/dyRuleTempDetail.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/mgr/nav.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/mgr/score/score1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/mgr/score/score2.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/mgr/score/score3.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/mgr/scoreBegin.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/mgr/step1.jsp | 评价体系信息 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 rate-table | top-active=dept; dept-left=rate-table | ID |  |
| /department/dyc/mgr/step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 rate-table | top-active=dept; dept-left=rate-table | ID |  |
| /department/dyc/mgr/step25_bak.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 rate-mgr | top-active=dept; dept-left=rate-mgr | ID |  |
| /department/dyc/mgr/step25.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 rate-table | top-active=dept; dept-left=rate-table | ID |  |
| /department/dyc/mgr/step3.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 rate-table | top-active=dept; dept-left=rate-table | ID |  |
| /department/dyc/mgr/step35.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 rate-table | top-active=dept; dept-left=rate-table | ID |  |
| /department/dyc/mgr/step4.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 rate-table | top-active=dept; dept-left=rate-table | ID |  |
| /department/dyc/mgr/step5.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 rate-table | top-active=dept; dept-left=rate-table | ID |  |
| /department/dyc/mgr/toRateDetail.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/mgr/toRateMgr.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/ratetab/addFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; top-active=class | id, rateId |  |
| /department/dyc/ratetab/editModel.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/ratetab/rateDetails.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> rate-table | top-active=dept; dept-left=rate-table; top-active=class |  |  |
| /department/dyc/ratetab/rateJob.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/ratetab/rateTabList.jsp | 班级综评评价体系 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> rate-table | top-active=dept; dept-left=rate-table |  | 评价体系列表 @ /department/dyc/ratetab/addFill.jsp； 评价体系 @ /department/dyc/ratetab/rateDetails.jsp； 评价体系 @ /department/dyc/ratetab/ruleFill.jsp |
| /department/dyc/ratetab/ruleFill.jsp | 填表安排 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> rate-table | top-active=dept; dept-left=rate-table |  | 填表人方案 @ /department/dyc/ratetab/addFill.jsp |
| /department/dyc/report/dyClsReport.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的班级 left -> 星级班级评比 | top-active=class; dept-left=teach-class-dy | RATE_ID, CLASS_ID | 星级班级评比 @ /school/grade/classView.jsp；  @ /fix/test_body_left.jsp；  @ /inc/page/body-left.jsp |
| /department/dyc/report/dyClsReportStu.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> /department/dyc/report/dyClsReportStu.jsp | top-active=class; dept-left=stu-class-dy | RATE_ID, CLASS_ID | @ /fix/test_body_left.jsp；  @ /fix/test_body_left.jsp；  @ /inc/page/body-left.jsp |
| /department/dyc/report/dyDayReport.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> teach-class-dy | top-active=class; dept-left=teach-class-dy; dept-left=stu-class-dy; top-active=dept; dept-left=rate-table | RPT_ID, CLS_ID |  |
| /department/dyc/report/dyReport.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> rate-table | top-active=dept; dept-left=rate-table | ID, TERM_CODE |  |
| /department/dyc/report/dyReportView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 class -> 左侧 teach-class-dy | top-active=class; dept-left=teach-class-dy; dept-left=stu-class-dy | RATE_ID, CLASS_ID |  |
| /department/dyc/report/temp/temp0.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/report/temp/temp1.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/report/temp/tempCls.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/report/temp/tempTeaCls.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/report/view_detail.jsp | Insert title here | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：DETAIL_ID |  | DETAIL_ID |  |
| /department/dyc/task/myFinTaskList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> user-trans | top-active=affair; dept-left=user-trans |  | 已完成 @ /department/dyc/kq/leave/leave_approve_cc_view.jsp； 已完成 @ /department/dyc/task/myTaskFill.jsp； 已完成 @ /department/dyc/task/myTaskList.jsp |
| /department/dyc/task/myFinTaskListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /department/dyc/task/myTaskFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 affair -> 左侧 user-trans | top-active=affair; dept-left=user-trans | SEQ_ID, TASK_ID, ID, from_page |  |
| /department/dyc/task/myTaskList.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的事务 left -> 事务 1847 | top-active=affair; dept-left=user-trans |  | 事务提醒 @ /teacher/tea-index.jsp； 事务 1847 @ /oa/notice/myListNotice.jsp； 事务 1847 @ /inc/error/nonFunc.jsp |
| /department/dyc/temp/addModel.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/temp/addTempType.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/temp/addTypeDetails.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/temp/copyModel.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/temp/delTempType.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/temp/modelDetails.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/temp/setProList_bak.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> rate-temp | top-active=dept; dept-left=rate-temp |  |  |
| /department/dyc/temp/setProList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> rate-temp | top-active=dept; dept-left=rate-temp |  |  |
| /department/dyc/temp/tempManage.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> rate-temp | top-active=dept; dept-left=rate-temp |  | 模板管理 @ /department/dyc/temp/setProList_bak.jsp； 模板管理 @ /department/dyc/temp/setProList.jsp |
| /department/dyc/termComment/commentSet.jsp | 寄语设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> term-comment-lib | top-active=dept; dept-left=term-comment-lib |  |  |
| /department/dyc/termComment/edit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：id, type, LIMIT, from_page, classId, teacherType, num |  | id, type, LIMIT, from_page, classId, teacherType, num |  |
| /department/dyc/termComment/editCommentLib.jsp | 寄语设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> term-comment-lib | top-active=dept; dept-left=term-comment-lib |  |  |
| /department/dyc/termComment/termCommentLib.jsp | 寄语汇总 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> term-comment-lib | top-active=dept; dept-left=term-comment-lib |  |  |
| /department/dyc/ts/common/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li, tag |  | li, tag |  |
| /department/dyc/ts/common/uploadImgFile.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：choise1 |  | choise1 |  |
| /department/dyc/ts/frm_setlib.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | CODE |  |
| /department/dyc/ts/frm_stat_pick_date.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | term_code |  |
| /department/dyc/ts/limitchoose.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | id, index |  |
| /department/dyc/ts/limitchoose2.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/ts/limitchoose3.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | id, index, open_param |  |
| /department/dyc/ts/limitchoose4.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | id, index, open_param |  |
| /department/dyc/ts/mgr_choose.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/ts/mult_open_space.jsp | 导师空间 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> ts_mgr | top-active=dept; dept-left=ts_mgr | ts_ids |  |
| /department/dyc/ts/resourceManagement/fileManagement.jsp | 文件管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> ts_res | top-active=dept; dept-left=ts_res |  |  |
| /department/dyc/ts/resourceManagement/imgManagement.jsp | 图片管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> ts_res | top-active=dept; dept-left=ts_res |  |  |
| /department/dyc/ts/secret_tab.jsp | 秘密标注 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | student_id, term_code, ts_id |  |
| /department/dyc/ts/step1_choose.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/dyc/ts/step3_choose.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：open_param |  | open_param |  |
| /department/dyc/ts/step3_choose2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：open_param |  | open_param |  |
| /department/dyc/ts/ts_act_op.jsp | 学生导师制档案 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | ts_id, student_id, term_code, from_page, act_type |  |
| /department/dyc/ts/ts_add_fail_stu.jsp | 导师管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> ts_mgr | top-active=dept; dept-id=dsz; dept-left=ts_mgr | ts_id, term_code, grade_code |  |
| /department/dyc/ts/ts_comment_lib.jsp | 快捷语库 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> ts_mgr | top-active=dept; dept-id=dsz; dept-left=ts_mgr |  |  |
| /department/dyc/ts/ts_discuss.jsp | 家校留言 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | student_id, term_code, ts_id |  |
| /department/dyc/ts/ts_find_stu.jsp | 导师管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> ts_mgr | top-active=dept; dept-id=dsz; dept-left=ts_mgr | ts_id, term_code, grade_code |  |
| /department/dyc/ts/ts_lib_detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：lib_id |  | lib_id |  |
| /department/dyc/ts/ts_lib_limit.jsp | 导师选报设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> ts_lib | top-active=dept; dept-id=dsz; dept-left=ts_lib | type, grade_code |  |
| /department/dyc/ts/ts_lib.jsp | 导师库 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> ts_lib | top-active=dept; dept-id=dsz; dept-left=ts_lib | type, grade_code |  |
| /department/dyc/ts/ts_mgr_info.jsp | 导师管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> ts_mgr | top-active=dept; dept-id=dsz; dept-left=ts_mgr | ts_id, term_code, grade_code |  |
| /department/dyc/ts/ts_mgr_yanyong.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/ts/ts_mgr.jsp | 导师管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> ts_mgr | top-active=dept; dept-id=dsz; dept-left=ts_mgr | term_code, grade_code | 导师管理 @ /department/dyc/ts/common/body-right-top.jsp |
| /department/dyc/ts/ts_open_analyse.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | open_param, count, gradeClass |  |
| /department/dyc/ts/ts_open_step1_back.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 ts_open | top-active=dept; dept-id=dsz; dept-left=ts_open | open_param |  |
| /department/dyc/ts/ts_open_step1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 ts_open | top-active=dept; dept-id=dsz; dept-left=ts_open | index |  |
| /department/dyc/ts/ts_open_step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 ts_open | top-active=dept; dept-id=dsz; dept-left=ts_open | open_param |  |
| /department/dyc/ts/ts_open_step3_add_fail_stu.jsp | 导师管理 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 ts_open | top-active=dept; dept-id=dsz; dept-left=ts_open | open_param, opt_id |  |
| /department/dyc/ts/ts_open_step3_bx.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 ts_open | top-active=dept; dept-id=dsz; dept-left=ts_open | open_param |  |
| /department/dyc/ts/ts_open_step3_info.jsp | 导师管理 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 ts_open | top-active=dept; dept-id=dsz; dept-left=ts_open | open_param, opt_id |  |
| /department/dyc/ts/ts_open_step3_redo.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 ts_open | top-active=dept; dept-id=dsz; dept-left=ts_open | open_param |  |
| /department/dyc/ts/ts_open_step3.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 ts_open | top-active=dept; dept-id=dsz; dept-left=ts_open | open_param |  |
| /department/dyc/ts/ts_open.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> ts_open | top-active=dept; dept-id=dsz; dept-left=ts_open |  | 导师选报 @ /department/dyc/ts/ts_open_step1_back.jsp； 导师选报 @ /department/dyc/ts/ts_open_step1.jsp； 导师选报 @ /department/dyc/ts/ts_open_step2.jsp |
| /department/dyc/ts/ts_space.jsp | 导师空间 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> ts_mgr | top-active=dept; dept-left=ts_mgr | term_code, grade_code | 导师空间 @ /department/dyc/ts/common/body-right-top.jsp |
| /department/dyc/ts/ts_special_attention.jsp | 特别关注 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> ts_mgr | top-active=dept; dept-id=dsz; dept-left=ts_mgr |  | 特别关注 @ /department/dyc/ts/common/body-right-top.jsp |
| /department/dyc/ts/ts_work_his_view.jsp | 导师工作详情 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：ts_id, term_code |  | ts_id, term_code |  |
| /department/dyc/ts/ts_work_his_vue3.jsp | 导师工作 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> ts_mgr | top-active=dept; dept-left=ts_mgr |  | 导师工作 @ /department/dyc/ts/common/body-right-top.jsp |
| /department/dyc/ts/ts_work_his.jsp | 导师管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> ts_mgr | top-active=dept; dept-left=ts_mgr |  |  |
| /department/dyc/tspdf/fixDict.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/tspdf/frm_add_detail.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/tspdf/printModel.jsp | 一师一册 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> tspdf | top-active=dept; dept-id=dsz; dept-left=tspdf |  |  |
| /department/dyc/tspdf/setting_vue3.jsp | 一师一册 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> tspdf | top-active=dept; dept-id=dsz; dept-left=tspdf | type |  |
| /department/dyc/tspdf/setting.jsp | 一师一册 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> tspdf | top-active=dept; dept-id=dsz; dept-left=tspdf |  |  |
| /department/dyc/tspdf/students.jsp | 一生一档 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> tspdf | top-active=dept; dept-id=dsz; dept-left=tspdf | teacherId, termCode |  |
| /department/dyc/tspdf/studentsVueVer.jsp | 一生一档 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> tspdf | top-active=dept; dept-id=dsz; dept-left=tspdf | teacherId, termCode |  |
| /department/dyc/tspdf/tsCommentLib_vue3.jsp | 一师一册 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> tspdf | top-active=dept; dept-id=dsz; dept-left=tspdf | type, tid |  |
| /department/dyc/tspdf/tspdf_vue3.jsp | 一师一册 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> tspdf | top-active=dept; dept-id=dsz; dept-left=tspdf |  |  |
| /department/dyc/tspdf/tspdf.jsp | 一师一册 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> tspdf | top-active=dept; dept-id=dsz; dept-left=tspdf |  |  |
| /department/dyc/usercfg/multSetUTemp.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/usercfg/setNoDateMult.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | RATE_ID |  |
| /department/dyc/usercfg/usercfg.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> rate-table | top-active=dept; dept-left=rate-table | ID |  |
| /department/dyc/usercfg/userCfgAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/dyc/usercfg/userTempView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：ID |  | ID |  |
| /department/dyc/zh/count/zhfx_class_tm.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 条目分析 @ /department/dyc/zh/count/zhfx_class.jsp |
| /department/dyc/zh/count/zhfx_class.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 版块分析 @ /department/dyc/zh/count/zhfx_class_tm.jsp；  @ /department/dyc/zh/list.jsp；  @ /department/dyc/zh/zh_week_list.jsp |
| /department/dyc/zh/count/zhfx_stu_detail_tm.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 评价记录 @ /department/dyc/zh/count/zhfx_stu_tm.jsp |
| /department/dyc/zh/count/zhfx_stu_detail.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | 评价记录 @ /department/dyc/zh/count/zhfx_stu.jsp |
| /department/dyc/zh/count/zhfx_stu_dev_tm.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | reportId, studentId, typeCode | 个人发展 @ /department/dyc/zh/count/zhfx_stu_detail_tm.jsp； 个人发展 @ /department/dyc/zh/count/zhfx_stu_tm.jsp |
| /department/dyc/zh/count/zhfx_stu_dev.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | reportId, studentId | 个人发展 @ /department/dyc/zh/count/zhfx_stu_detail.jsp； 个人发展 @ /department/dyc/zh/count/zhfx_stu.jsp |
| /department/dyc/zh/count/zhfx_stu_tm.jsp | 学生个人报表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | {{el.STU_NAME}} @ /department/dyc/zh/count/zhfx_class_tm.jsp； 综合分析 @ /department/dyc/zh/count/zhfx_stu_detail_tm.jsp |
| /department/dyc/zh/count/zhfx_stu.jsp | 学生个人报表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  | {{el.STU_NAME}} @ /department/dyc/zh/count/zhfx_class.jsp； 综合分析 @ /department/dyc/zh/count/zhfx_stu_detail.jsp |
| /department/dyc/zh/honor/body-right-top.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | li, tag |  |
| /department/dyc/zh/honor/frm_zh_class_honor.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | term_code, class_id, honor_id |  |
| /department/dyc/zh/honor/zh_honor_ryjl_stumode.jsp | 班级视图 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh_score_ry | top-active=dept; dept-id=dsz; dept-left=zh_score_ry |  |  |
| /department/dyc/zh/honor/zh_honor_ryjl.jsp | 班级视图 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh_score_ry | top-active=dept; dept-id=dsz; dept-left=zh_score_ry |  | 荣誉记录 @ /department/dyc/zh/honor/body-right-top.jsp |
| /department/dyc/zh/honor/zh_honor_rysz_add.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> venue -> zh_score_ry | top-active=dept; dept-right=venue; dept-left=zh_score_ry | id |  |
| /department/dyc/zh/honor/zh_honor_rysz.jsp | 班级视图 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh_score_ry | top-active=dept; dept-id=dsz; dept-left=zh_score_ry |  | 荣誉设置 @ /department/dyc/zh/honor/body-right-top.jsp |
| /department/dyc/zh/honor/zh_honor_xqjf.jsp | 班级视图 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh_score_ry | top-active=dept; dept-id=dsz; dept-left=zh_score_ry |  | 学期积分 @ /department/dyc/zh/honor/body-right-top.jsp |
| /department/dyc/zh/import/tea/stuRecs.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | EVAL_ID, CODE, STU_ID |  |
| /department/dyc/zh/import/tea/teaFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 class -> 左侧 zh-imp | top-active=class; dept-left=zh-imp | CODE, EVAL_ID, CLASS_ID, CLASS_TYPE |  |
| /department/dyc/zh/import/tea/teaImp.jsp | 评价录入 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 评价录入 | top-active=class; dept-left=zh-imp | COMMENT_TYPE | 学生综合评价录入 @ /department/dyc/zh/import/tea/teaFill.jsp； 评价录入 @ /fix/test_body_left.jsp； 评价录入 @ /inc/page/body-left.jsp |
| /department/dyc/zh/list.jsp | 其他报表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dyc -> 部门页签 -> zh_bbck | top-active=dept; dept-id=dyc; dept-left=zh_bbck | eval_id | 其他报表 @ /department/dyc/zh/list.jsp； 其他报表 @ /department/dyc/zh/zh_week_list.jsp |
| /department/dyc/zh/score/batch_stu_change.jsp | 批量兑换 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh_score_dh | top-active=dept; dept-id=dsz; dept-left=zh_score_dh | grade_id, type, class_id |  |
| /department/dyc/zh/score/body-right-top.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | li, tag |  |
| /department/dyc/zh/score/change_record.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 zh_score_dh | top-active=dept; dept-id=dsz; dept-left=zh_score_dh | type | 操作记录 @ /department/dyc/zh/score/body-right-top.jsp |
| /department/dyc/zh/score/frm_dept_stu_change.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | grade_code, class_name, stu_name, class_id, stu_id, score |  |
| /department/dyc/zh/score/frm_zh_stock_his.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | item_id |  |
| /department/dyc/zh/score/zh_score_dhhz_pro_detail.jsp | 班级视图 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：item_id, item_name, count |  | item_id, item_name, count |  |
| /department/dyc/zh/score/zh_score_dhhz_pro.jsp | 兑换汇总-兑换品视图 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh_score_dh | top-active=dept; dept-id=dsz; dept-left=zh_score_dh | term_code, grade_code | 兑换汇总 @ /department/dyc/zh/score/body-right-top.jsp |
| /department/dyc/zh/score/zh_score_dhhz_stu.jsp | 兑换汇总-学生视图 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh_score_dh | top-active=dept; dept-id=dsz; dept-left=zh_score_dh | term_code, grade_code |  |
| /department/dyc/zh/score/zh_score_dhsz.jsp | 兑换设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh_score_dh | top-active=dept; dept-id=dsz; dept-left=zh_score_dh |  | 兑换设置 @ /department/dyc/zh/score/body-right-top.jsp |
| /department/dyc/zh/score/zh_score_item_set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> venue -> zh_score_dh | top-active=dept; dept-right=venue; dept-left=zh_score_dh | id |  |
| /department/dyc/zh/score/zh_score_kdjl_detail_vue3.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | stu_id, className, stuName |  |
| /department/dyc/zh/score/zh_score_kdjl_detail.jsp | 班级视图 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：stu_id |  | stu_id |  |
| /department/dyc/zh/score/zh_score_kdjl.jsp | 可兑积分 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh_score_dh | top-active=dept; dept-id=dsz; dept-left=zh_score_dh | term_code, grade_code | 积分币 @ /department/dyc/zh/score/body-right-top.jsp |
| /department/dyc/zh/step1.jsp | 报表汇总 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 zh_bbhz | top-active=dept; dept-id=dyc; dept-left=zh_bbhz |  |  |
| /department/dyc/zh/step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 zh_bbhz | top-active=dept; dept-id=dyc; dept-left=zh_bbhz |  |  |
| /department/dyc/zh/txgl/addpc.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> venue -> zh_pjtxgl | top-active=dept; dept-right=venue; dept-left=zh_pjtxgl | seq_id, eval_id, title, detail_code, detail_id |  |
| /department/dyc/zh/txgl/body-right-top.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | li, tag |  |
| /department/dyc/zh/txgl/checkpc.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> venue -> zh_pjtxgl | top-active=dept; dept-right=venue; dept-left=zh_pjtxgl |  | 详情 @ /department/dyc/zh/txgl/eval_seq.jsp |
| /department/dyc/zh/txgl/editEvalDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：ID |  | ID |  |
| /department/dyc/zh/txgl/eval_seq.jsp | 条目二维码 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> zh_pjtxgl | top-active=dept; dept-left=zh_pjtxgl | eval_id, title, detail_code, detail_id |  |
| /department/dyc/zh/txgl/evalSet.jsp | 评价体系设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> zh_pjtxgl | top-active=dept; dept-left=zh_pjtxgl | ID | 设置 @ /department/dyc/zh/txgl/checkpc.jsp； 设置 @ /department/dyc/zh/txgl/eval_seq.jsp； 设置 @ /department/dyc/zh/txgl/qrcode_set.jsp |
| /department/dyc/zh/txgl/frm_cur_pic.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | url, width, height, object_name, object_id, file_size |  |
| /department/dyc/zh/txgl/frm_related_teachers.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | seq_id, seq_idx, item_count |  |
| /department/dyc/zh/txgl/frm_zh_report_class_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：eval_id, class_id, type_code, obj_code, obj_type, start_date, end_date |  | eval_id, class_id, type_code, obj_code, obj_type, start_date, end_date |  |
| /department/dyc/zh/txgl/frm_zh_report_tea_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：eval_id, tea_id, start_date, end_date, type_code, score_type, tea_name |  | eval_id, tea_id, start_date, end_date, type_code, score_type, tea_name |  |
| /department/dyc/zh/txgl/importEval.jsp | 导入评价 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh_pjjl_bj | top-active=dept; dept-id=dsz; dept-left=zh_pjjl_bj |  |  |
| /department/dyc/zh/txgl/lib/libList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> zh_pjtxgl | top-active=dept; dept-left=zh_pjtxgl |  | 评价条目库 @ /department/dyc/zh/txgl/txgl.jsp |
| /department/dyc/zh/txgl/lib/setCommLib.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | ID, NAME |  |
| /department/dyc/zh/txgl/medalPrinting.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> user-trans | top-active=affair; dept-left=user-trans |  |  |
| /department/dyc/zh/txgl/printTemplate.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> zh_pjtxgl | top-active=dept; dept-id=jiaow; dept-left=zh_pjtxgl |  | 打印件模板 @ /department/dyc/zh/txgl/txgl.jsp |
| /department/dyc/zh/txgl/qrcode_set.jsp | 评价体系设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> zh_pjtxgl | top-active=dept; dept-left=zh_pjtxgl | ID |  |
| /department/dyc/zh/txgl/selEvalDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：EVAL_ID, TYPE_ID |  | EVAL_ID, TYPE_ID |  |
| /department/dyc/zh/txgl/setDetailComm.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | ID, NAME |  |
| /department/dyc/zh/txgl/setMyCommLib.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | CODE |  |
| /department/dyc/zh/txgl/txgl.jsp | 评价体系 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> zh_pjtxgl | top-active=dept; dept-id=jiaow; dept-left=zh_pjtxgl |  | 评价体系 @ /department/dyc/zh/txgl/addpc.jsp； 评价体系 @ /department/dyc/zh/txgl/checkpc.jsp； 评价体系 @ /department/dyc/zh/txgl/eval_seq.jsp |
| /department/dyc/zh/txgl/zh_pjjl_bj.jsp | 班级视图 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh_pjjl_bj | top-active=dept; dept-id=dsz; dept-left=zh_pjjl_bj | term_code, grade_code, start_date, end_date, eval_id |  |
| /department/dyc/zh/txgl/zh_pjjl_js.jsp | 教师视图 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh_pjjl_bj | top-active=dept; dept-id=dsz; dept-left=zh_pjjl_bj | term_code, grade_code, start_date, end_date, eval_id |  |
| /department/dyc/zh/week_report_set.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dyc -> 部门页签 -> zh_bbck | top-active=dept; dept-id=dyc; dept-left=zh_bbck |  |  |
| /department/dyc/zh/ycb-view-term.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/zh/ycb-view-week.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/dyc/zh/zh_week_list.jsp | 周报表 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> zh_bbck | top-active=dept; dept-left=zh_bbck |  | 周报表 @ /department/dyc/zh/list.jsp； 周报表 @ /department/dyc/zh/zh_week_list.jsp |
| /department/dyc/zh/zphx/body-right-top.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | li, tag |  |
| /department/dyc/zh/zphx/zh_hxcl_detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 office-leave_deduction | top-active=dept; dept-left=office-leave_deduction; dept-id=dsz; dept-left=zh-zphx | set_id |  |
| /department/dyc/zh/zphx/zh_hxcl.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh-zphx | top-active=dept; dept-id=dsz; dept-left=zh-zphx |  | 画像话语策略 @ /department/dyc/zh/zphx/body-right-top.jsp |
| /department/dyc/zh/zphx/zh_zphx_look.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh-zphx | top-active=dept; dept-id=dsz; dept-left=zh-zphx | statisticID, isAdmin |  |
| /department/dyc/zh/zphx/zh_zphx_start_step2.jsp | 启动画像报告 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 zh-zphx | top-active=dept; dept-id=dsz; dept-left=zh-zphx | term, grade, id |  |
| /department/dyc/zh/zphx/zh_zphx_start.jsp | 启动画像报告 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh-zphx | top-active=dept; dept-id=dsz; dept-left=zh-zphx |  |  |
| /department/dyc/zh/zphx/zh_zphx.jsp | 画像报告 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dsz -> 部门页签 -> zh-zphx | top-active=dept; dept-id=dsz; dept-left=zh-zphx | admin | 画像报告 @ /department/dyc/zh/zphx/body-right-top.jsp |

### 部门-办公室（58）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /department/bgs/dict/dictMgr.jsp | 数据字典 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> dicts | top-active=dept; dept-id=office; dept-left=dicts |  |  |
| /department/bgs/func/deptFuncs.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> dept_funcs | top-active=dept; dept-id=office; dept-left=dept_funcs |  |  |
| /department/bgs/group/addClassGp.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> venue -> venue | top-active=dept; dept-right=venue; dept-left=venue |  |  |
| /department/bgs/group/class-group.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> teacher-group | top-active=dept; dept-id=office; dept-left=teacher-group |  | 班级群组 @ /department/office/teacher-group.jsp |
| /department/bgs/wage/mgr/adultWage.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/bgs/wage/mgr/ajax/setp2Ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/bgs/wage/mgr/ajax/teaTotalDetail.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：DETAIL_ID |  | DETAIL_ID |  |
| /department/bgs/wage/mgr/exportTotalWage.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | MAXRECORDS, TOTAL_ID |  |
| /department/bgs/wage/mgr/exportWage.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | MAXRECORDS, ID |  |
| /department/bgs/wage/mgr/nav.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/bgs/wage/mgr/previewWage.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | ID, TASK_ID | 查看核对 @ /department/bgs/wage/mgr/step3.jsp |
| /department/bgs/wage/mgr/schoolTotal.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | TEMP_CODE, TOTAL_ID, TOTAL_YEAR, TOTAL_OBJNAME, TEACHER_ID |  |
| /department/bgs/wage/mgr/schoolTotalDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：TEMP_CODE, TOTAL_ID, TOTAL_YEAR, TOTAL_OBJNAME, TEACHER_ID |  | TEMP_CODE, TOTAL_ID, TOTAL_YEAR, TOTAL_OBJNAME, TEACHER_ID |  |
| /department/bgs/wage/mgr/schoolTotalTeaDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：TEMP_CODE, TOTAL_ID, TOTAL_YEAR, TOTAL_OBJNAME, TEACHER_ID |  | TEMP_CODE, TOTAL_ID, TOTAL_YEAR, TOTAL_OBJNAME, TEACHER_ID |  |
| /department/bgs/wage/mgr/step1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 wage-mgr | top-active=dept; dept-left=wage-mgr | ID |  |
| /department/bgs/wage/mgr/step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 wage-mgr | top-active=dept; dept-left=wage-mgr | ID |  |
| /department/bgs/wage/mgr/step3.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 wage-mgr | top-active=dept; dept-left=wage-mgr | ID |  |
| /department/bgs/wage/mgr/step4.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 wage-mgr | top-active=dept; dept-left=wage-mgr | ID |  |
| /department/bgs/wage/mgr/toWageMgr.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/bgs/wage/mgr/un/exportUnTotalWage.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | MAXRECORDS, TOTAL_ID |  |
| /department/bgs/wage/mgr/un/frm_unTotalDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：DETAIL_ID, OBJ_NAME, TEA_ID, MAIN_ID |  | DETAIL_ID, OBJ_NAME, TEA_ID, MAIN_ID |  |
| /department/bgs/wage/mgr/un/nav.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/bgs/wage/mgr/un/schoolUnTotal.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | TOTAL_ID |  |
| /department/bgs/wage/mgr/un/schoolUnTotalDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：TOTAL_ID |  | TOTAL_ID |  |
| /department/bgs/wage/mgr/un/schoolUnTotalTeaDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：TOTAL_ID, TOTAL_TEA |  | TOTAL_ID, TOTAL_TEA |  |
| /department/bgs/wage/mgr/un/step1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 wage-mgr | top-active=dept; dept-left=wage-mgr | TOTAL_YEAR |  |
| /department/bgs/wage/mgr/un/step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 wage-mgr | top-active=dept; dept-left=wage-mgr | ID |  |
| /department/bgs/wage/mgr/un/step3.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 wage-mgr | top-active=dept; dept-left=wage-mgr | ID |  |
| /department/bgs/wage/mgr/un/step3Sel.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/bgs/wage/mgr/un/step4.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 wage-mgr | top-active=dept; dept-left=wage-mgr | ID |  |
| /department/bgs/wage/mgr/un/wageUnTotalInfo.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> wage-tab | top-active=dept; dept-left=wage-tab | ID |  |
| /department/bgs/wage/mgr/un/wageUnTotalList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> wage-tab | top-active=dept; dept-left=wage-tab | TOTAL_YEAR |  |
| /department/bgs/wage/mgr/wage.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/bgs/wage/mgr/wageDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 rate-mgr | top-active=dept; dept-left=rate-mgr | ID |  |
| /department/bgs/wage/mgr/wageList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> wage-tab | top-active=dept; dept-left=wage-tab | CREATE_TIME | 工资表列表 @ /department/bgs/wage/mgr/un/step2.jsp； 工资表列表 @ /department/bgs/wage/mgr/un/step2.jsp； 工资表列表 @ /department/bgs/wage/mgr/un/step3.jsp |
| /department/bgs/wage/mgr/wageTotalList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> wage-tab | top-active=dept; dept-left=wage-tab | TOTAL_YEAR |  |
| /department/bgs/wage/temp/modelDetails.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/bgs/wage/temp/tempDetail.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> wage-temp | top-active=dept; dept-left=wage-temp |  |  |
| /department/bgs/wage/temp/tempList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> wage-temp | top-active=dept; dept-left=wage-temp |  | 模板管理 @ /department/bgs/wage/temp/tempDetail.jsp |
| /department/bgs/webFav/favMgr.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sch-web-fav | top-active=dept; dept-left=sch-web-fav |  |  |
| /department/office/addGroup.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> venue -> venue | top-active=dept; dept-right=venue; dept-left=venue |  |  |
| /department/office/ajax/userSetingAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curPage, pageSize, searchKey, showPwd |  | curPage, pageSize, searchKey, showPwd |  |
| /department/office/campus/campusCfg.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> venue -> venue | top-active=dept; dept-right=venue; dept-left=venue | ID |  |
| /department/office/campus/DataHub/DataHub-bjzp-daily.jsp | 数据中枢管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> venue -> digital_set_ | top-active=dept; dept-right=venue; dept-left=digital_set_ |  |  |
| /department/office/campus/DataHub/DataHub-bjzp.jsp | 数据中枢管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> venue -> digital_set_ | top-active=dept; dept-right=venue; dept-left=digital_set_ |  |  |
| /department/office/campus/DataHub/DataHub-index-Pic.jsp | 数据中枢管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/office/campus/DataHub/DataHub-index.jsp | 数据中枢管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> venue -> digital_set_ | top-active=dept; dept-right=venue; dept-left=digital_set_ |  |  |
| /department/office/campus/DataHub/DataHub-tab.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | tab |  |
| /department/office/campus/DataHub/DataHub-xszhpj.jsp | 数据中枢管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> venue -> digital_set_ | top-active=dept; dept-right=venue; dept-left=digital_set_ |  |  |
| /department/office/campus/setting.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> office-campusSet | top-active=dept; dept-id=office; dept-left=office-campusSet |  |  |
| /department/office/leaveSchoolList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> office-userSet | top-active=dept; dept-id=office; dept-left=office-userSet |  | 离校人员查看 @ /department/office/user-setting.jsp |
| /department/office/notice_view_power.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> office-userSet | top-active=dept; dept-left=office-userSet |  | 通知查阅权限 @ /department/office/user-setting.jsp |
| /department/office/office.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/head.jsp -> 我的空间 | top-active=dept; dept-id=office |  | 我的空间 @ /inc/page/cloud/head.jsp； 办公室 @ /inc/page/Copy of neck.jsp； 我的空间 @ /inc/page/head.jsp |
| /department/office/print/print_teacher_list.jsp | 打印人员信息 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | curPage, pageSize, searchKey, showPwd |  |
| /department/office/teacher-edit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 office-userSet | top-active=dept; dept-id=office; dept-left=office-userSet | tid | 新增教职工 @ /department/office/user-setting.jsp；  @ /department/office/user-setting.jsp |
| /department/office/teacher-group.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> teacher-group | top-active=dept; dept-id=office; dept-left=teacher-group |  | 人员群组 @ /department/bgs/group/class-group.jsp |
| /department/office/user-import.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> office-userSet | top-active=dept; dept-id=office; dept-left=office-userSet | importId | 导入教职工 @ /department/office/user-setting.jsp |
| /department/office/user-setting.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/teacher/body-left.jsp -> 人员设置 | top-active=dept; dept-id=office; dept-left=office-userSet | searchKey | 人员设置 @ /department/office/notice_view_power.jsp； 返回 @ /department/office/teacher-edit.jsp； 返回 @ /department/office/user-import.jsp |

### 部门-总务（48）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /department/zongw/matm/assetsApply/alertConfig.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> assets-apply | top-active=dept; dept-left=assets-apply |  | 申领设置 @ /department/zongw/matm/assetsApply/assetsApply.jsp； 申领设置 @ /department/zongw/matm/assetsApply/inc_assets_tab.jsp |
| /department/zongw/matm/assetsApply/assetsApply.jsp | 申领处理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> assets-apply | top-active=dept; dept-left=assets-apply | status |  |
| /department/zongw/matm/assetsApply/inc_assets_tab.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  |  |  |
| /department/zongw/matm/consumables.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> consumables | top-active=dept; dept-left=consumables |  |  |
| /department/zongw/matm/faMgr.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> fixed-assets | top-active=dept; dept-left=fixed-assets | zcStatus, cateId, varId |  |
| /department/zongw/matm/matCcCfg.jsp | 部门设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> mat-cfg | top-active=dept; dept-left=mat-cfg |  | 易耗品 @ /department/zongw/matm/matCcCfg.jsp； 易耗品 @ /department/zongw/matm/matFaCfg.jsp |
| /department/zongw/matm/matFaCfg.jsp | 部门设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> mat-cfg | top-active=dept; dept-left=mat-cfg |  | 资产 @ /department/zongw/matm/matCcCfg.jsp |
| /department/zongw/matm/matRecord.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> assetsApply | top-active=dept; dept-left=assetsApply |  | 资产记录 @ /department/zongw/matm/matStatOne.jsp； 资产记录 @ /department/zongw/matm/matTeacher.jsp |
| /department/zongw/matm/matStat.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> mat-stat | top-active=dept; dept-left=mat-stat |  | 类别统计 @ /department/zongw/matm/matRecord.jsp； 类别统计 @ /department/zongw/matm/matStatOne.jsp； 类别统计 @ /department/zongw/matm/matStatStatus.jsp |
| /department/zongw/matm/matStatOne.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> mat-stat | top-active=dept; dept-left=mat-stat |  | 单项统计 @ /department/zongw/matm/matRecord.jsp； 单项统计 @ /department/zongw/matm/matStat.jsp； 单项统计 @ /department/zongw/matm/matStatOne.jsp |
| /department/zongw/matm/matStatStatus.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> mat-stat | top-active=dept; dept-left=mat-stat |  | 状态统计 @ /department/zongw/matm/matRecord.jsp； 状态统计 @ /department/zongw/matm/matStat.jsp； 状态统计 @ /department/zongw/matm/matStatOne.jsp |
| /department/zongw/matm/matTeacher.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> mat-stat | top-active=dept; dept-left=mat-stat |  | 教师物资 @ /department/zongw/matm/matRecord.jsp； 教师物资 @ /department/zongw/matm/matStat.jsp； 教师物资 @ /department/zongw/matm/matStatOne.jsp |
| /department/zongw/matm/schoolConfig.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> school-config | top-active=dept; dept-left=school-config |  |  |
| /department/zongw/matm/venueFaView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 venue | top-active=dept; dept-right=venue; dept-left=venue | VID, CATE | {{el.FA_COUNT}} @ /department/venue/venueManager.jsp |
| /department/zongw/sg/bed/bedList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-set | top-active=dept; dept-left=sg-set | ROOM_ID |  |
| /department/zongw/sg/build/buildDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 sg-set | top-active=dept; dept-left=sg-set | ID |  |
| /department/zongw/sg/build/buildList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-set | top-active=dept; dept-left=sg-set |  |  |
| /department/zongw/sg/kq/bedUserRec.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-mgr | top-active=dept; dept-left=sg-mgr |  | 宿员记录 @ /department/zongw/sg/kq/kaoqin.jsp； 宿员记录 @ /department/zongw/sg/kq/kaoqinUser.jsp； 宿员记录 @ /department/zongw/sg/kq/roomRec.jsp |
| /department/zongw/sg/kq/kaoqin.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-mgr | top-active=dept; dept-left=sg-mgr | ID, QUERY_DATE | 宿舍考勤 @ /department/zongw/sg/kq/bedUserRec.jsp； 宿舍考勤 @ /department/zongw/sg/kq/roomRec.jsp |
| /department/zongw/sg/kq/kaoqinUser.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-mgr | top-active=dept; dept-left=sg-mgr | RID, QUERY_DATE |  |
| /department/zongw/sg/kq/query/art/kqs.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | BID, RID, UID, NAME, STU_NO, START_DATE, END_DATE |  |
| /department/zongw/sg/kq/query/art/recs.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | UID, NAME, STU_NO, START_DATE, END_DATE |  |
| /department/zongw/sg/kq/query/classKgQuery.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-user-stat | top-active=dept; dept-left=sg-user-stat |  | 按班级查询 @ /department/zongw/sg/kq/query/roomKgQuery.jsp； 按班级查询 @ /department/zongw/sg/kq/query/userKgQuery.jsp |
| /department/zongw/sg/kq/query/roomKgQuery.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-user-stat | top-active=dept; dept-left=sg-user-stat |  | 按宿舍查询 @ /department/zongw/sg/kq/query/classKgQuery.jsp； 按宿舍查询 @ /department/zongw/sg/kq/query/userKgQuery.jsp |
| /department/zongw/sg/kq/query/userKgQuery.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-user-stat | top-active=dept; dept-left=sg-user-stat |  | 按人员查询 @ /department/zongw/sg/kq/query/classKgQuery.jsp； 按人员查询 @ /department/zongw/sg/kq/query/roomKgQuery.jsp |
| /department/zongw/sg/kq/roomRec.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-mgr | top-active=dept; dept-left=sg-mgr |  | 宿舍记录 @ /department/zongw/sg/kq/bedUserRec.jsp； 宿舍记录 @ /department/zongw/sg/kq/kaoqin.jsp； 宿舍记录 @ /department/zongw/sg/kq/kaoqinUser.jsp |
| /department/zongw/sg/rate/art/roomRates.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 |  | RID, START_DATE, END_DATE |  |
| /department/zongw/sg/rate/classRateQuery.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-stat | top-active=dept; dept-left=sg-stat |  | 按班级查询 @ /department/zongw/sg/rate/roomRateQuery.jsp |
| /department/zongw/sg/rate/recDynamic.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-dy-rec | top-active=dept; dept-left=sg-dy-rec |  |  |
| /department/zongw/sg/rate/roomRateQuery.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-stat | top-active=dept; dept-left=sg-stat |  | 按楼栋查询 @ /department/zongw/sg/rate/classRateQuery.jsp |
| /department/zongw/sg/room/room.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-set | top-active=dept; dept-left=sg-set | RID |  |
| /department/zongw/sg/room/roomArr.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 | top-active=dept | IDS, BID |  |
| /department/zongw/sg/room/roomCopy.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 | top-active=dept | RID |  |
| /department/zongw/sg/room/roomDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept | BID, ID |  |
| /department/zongw/sg/room/roomInfo.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-info | top-active=dept; dept-left=sg-info |  |  |
| /department/zongw/sg/room/roomList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sg-set | top-active=dept; dept-left=sg-set | BID |  |
| /department/zongw/sg/room/roomSet.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> 左侧菜单 | top-active=dept | BID, IDS |  |
| /department/zongw/sg/room/step0.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/zongw/sg/room/step1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/zongw/sg/room/step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/zongw/sg/stu/stuKqInfo.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> stu-sg-room | top-active=apply; dept-left=stu-sg-room |  | 住宿出勤 @ /department/zongw/sg/stu/stuSgRec.jsp； 住宿出勤 @ /department/zongw/sg/stu/stuSgRoomQuery.jsp |
| /department/zongw/sg/stu/stuSgRec.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> stu-sg-room | top-active=apply; dept-left=stu-sg-room |  | 住宿记录 @ /department/zongw/sg/stu/stuKqInfo.jsp； 住宿记录 @ /department/zongw/sg/stu/stuSgRoomQuery.jsp |
| /department/zongw/sg/stu/stuSgRoomQuery.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 我的宿舍 | top-active=apply; dept-left=stu-sg-room |  | 宿舍记录 @ /department/zongw/sg/stu/stuKqInfo.jsp； 宿舍记录 @ /department/zongw/sg/stu/stuSgRec.jsp； 我的宿舍 @ /fix/test_body_left.jsp |
| /department/zongw/sg/tea/roomMsg.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> teach-class-sg | top-active=class; dept-left=teach-class-sg | RID |  |
| /department/zongw/sg/tea/teaSgInfo.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的班级 left -> 本班宿舍 | top-active=class; dept-left=teach-class-sg |  | 本班宿舍 @ /school/grade/classView.jsp； 宿舍信息 @ /department/zongw/sg/tea/teaStuSgInfo.jsp； 本班宿舍 @ /fix/test_body_left.jsp |
| /department/zongw/sg/tea/teaStuSgInfo.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> teach-class-sg | top-active=class; dept-left=teach-class-sg |  | 人员信息 @ /department/zongw/sg/tea/roomMsg.jsp； 人员信息 @ /department/zongw/sg/tea/teaSgInfo.jsp |
| /department/zongw/vehicle/vehicleDetail.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> vehicle_mgr -> vehicle_mgr | top-active=dept; dept-right=vehicle_mgr; dept-left=vehicle_mgr |  |  |
| /department/zongw/vehicle/vehicleManager.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> vehicle_mgr -> vehicle_mgr | top-active=dept; dept-right=vehicle_mgr; dept-left=vehicle_mgr |  |  |

### 部门功能（37）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /department/avatar/upload.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/course_detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：courseDetailId |  | courseDetailId |  |
| /department/funcs/dataFun.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> file -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=file |  |  |
| /department/funcs/deptMember.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：OP_MODULE, OP_CODE |  | OP_MODULE, OP_CODE |  |
| /department/headmaster/mailBox/mailDetail.jsp | 信件详情 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 principal_mainbox | top-active=dept; dept-left=principal_mainbox | id, status, mail_type, mail_user_type, query_user, search_key |  |
| /department/headmaster/mailBox/newMail.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> principal_mainbox | top-active=dept; dept-left=principal_mainbox | status | 新信件 @ /department/headmaster/mailBox/setting.jsp； 沟通中 @ /department/headmaster/mailBox/setting.jsp； 已归档 @ /department/headmaster/mailBox/setting.jsp |
| /department/headmaster/mailBox/setting.jsp | 信箱设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> principal_mainbox | top-active=dept; dept-left=principal_mainbox |  | 信箱设置 @ /department/headmaster/mailBox/newMail.jsp |
| /department/headmaster/parent_list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> XZS -> 部门页签 -> stat_parent | top-active=dept; dept-id=XZS; dept-left=stat_parent | searchKey, gradeId, classId |  |
| /department/index.jsp |  | 部门/集团入口：用于设置上下文后跳转 | 从顶部“我的部门/集团”或部门条点击进入，用于写入会话上下文 | top-active=dept; dept-id= |  |  |
| /department/list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> exam-list | top-active=dept; dept-id=jiaow; dept-left=exam-list | termId, courseCode |  |
| /department/notice/addNotice.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> 左侧菜单 | top-active=dept; dept-id=jiaow |  | 发新通知 @ /department/notice/common/body-right-top.jsp |
| /department/notice/common/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li |  | li |  |
| /department/notice/listNotice.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> 左侧菜单 | top-active=dept; dept-id=jiaow |  | 已发通知 @ /department/notice/common/body-right-top.jsp |
| /department/print/inc_print_tab.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：li |  | li |  |
| /department/print/remindSet.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> viewPrint | top-active=dept; dept-left=viewPrint |  | 提醒设置 @ /department/print/inc_print_tab.jsp； 提醒设置 @ /department/print/viewPrint.jsp |
| /department/print/viewPrint.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> viewPrint | top-active=dept; dept-left=viewPrint |  |  |
| /department/spaceauth/classSpaceMgr.jsp | 班级空间 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> spaceauth | top-active=dept; dept-left=spaceauth | GRADE_CODE, QUERY_TERM_CODE | 班级空间 @ /department/spaceauth/inc/body-right-top.jsp |
| /department/spaceauth/inc/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li |  | li |  |
| /department/spaceauth/inc/pickDate.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/spaceauth/independentSetting.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> special -> sp_space | top-active=dept; dept-right=special; dept-left=sp_space |  | 自定义权限 @ /space/specialspace/manager/managerHeader.jsp |
| /department/spaceauth/selSpaceMgr.jsp | 社团选修空间 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> spaceauth | top-active=dept; dept-left=spaceauth | QUERY_TERM_CODE, NAME | 社团选修空间 @ /department/spaceauth/inc/body-right-top.jsp |
| /department/spaceauth/spaceauth.jsp | 空间权限 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> spaceauth | top-active=dept; dept-id=office; dept-left=spaceauth | QUERY_TERM_CODE, NAME | 空间权限 @ /department/spaceauth/inc/body-right-top.jsp |
| /department/spaceauth/specialSpaceMgr.jsp | 专项空间 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> special -> sp_space | top-active=dept; dept-right=special; dept-left=sp_space | QUERY_TERM_CODE, NAME | 专项空间统计 @ /space/specialspace/manager/managerHeader.jsp |
| /department/spaceauth/tagstat/class_space_list.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：classId |  | classId | 主题统计 @ /space/common/jsp/nav.jsp |
| /department/spaceauth/tagstat/classspace_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：STAT_ID |  | STAT_ID |  |
| /department/spaceauth/tagstat/frm_class_space_add_stat.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/spaceauth/tagstat/frm_classspace_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：stat_id, class_id |  | stat_id, class_id |  |
| /department/spaceauth/tagstat/specialspace-addStat.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/spaceauth/tagstat/specialspace-list.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/spaceauth/tagstat/specialspace-tea-view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：STAT_ID |  | STAT_ID |  |
| /department/spaceauth/tagstat/specialspace-view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：STAT_ID |  | STAT_ID |  |
| /department/spaceauth/tagstat/specialspace-viewwindow.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/spaceauth/teachSpaceMgr.jsp | 教学空间 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> spaceauth | top-active=dept; dept-left=spaceauth | GRADE_TYPE, QUERY_TERM_CODE | 教学空间 @ /department/spaceauth/inc/body-right-top.jsp |
| /department/spaceauth/topicSetting.jsp | 班级空间自定义 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> spaceauth | top-active=dept; dept-left=spaceauth |  |  |
| /department/timetable/ajax/submitAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：classId, weekData |  | classId, weekData |  |
| /department/timetable/common/timetable.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：classId |  | classId |  |
| /department/timetable/course.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | classId |  |

### 集团/组织部门（48）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /department/org/collect/addCollect.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> collect -> 左侧菜单 | top-active=dept; dept-id=jiaow; dept-right=collect |  | 资料收集 @ /department/org/collect/body-right-top.jsp |
| /department/org/collect/body-right-top.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：li, returnUrl |  | li, returnUrl |  |
| /department/org/collect/listPCollect.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/org_neck.jsp -> 收集 | top-active=org; dept-right=collect |  | 已发布收集 @ /department/org/collect/body-right-top.jsp； 收集 @ /department/org/index.jsp； 收集 @ /inc/page/org_neck.jsp |
| /department/org/collect/listPCollectAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /department/org/collect/preViewNpCollect.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 org -> 左侧 对应菜单 | top-active=org; dept-right=collect | collectId, type | {{el.TITLE}} @ /department/org/collect/listPCollect.jsp |
| /department/org/collect/viewCountCollect.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 org -> 左侧 对应菜单 | top-active=org; dept-right=collect | collectId | 已交：{{el.VIEWCOUNT}}/{{el.ALLCOUNT}}-- @ /department/org/collect/listPCollect.jsp； / @ /department/org/collect/preViewNpCollect.jsp |
| /department/org/comm/check-org-user.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/org/comm/choiseDeptDataFile.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/org/comm/setUserMode.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/org_neck.jsp -> 切换到身份 |  |  | 切换到身份 @ /inc/page/org_neck.jsp |
| /department/org/comm/toOrgDept.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/org/data/dataFun.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 org -> 左侧 对应菜单 | top-active=org; dept-right=file |  |  |
| /department/org/data/dataManager.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/org_neck.jsp -> 资料 | top-active=org; dept-right=file |  | 资料 @ /department/org/index.jsp； 资料 @ /inc/page/org_neck.jsp |
| /department/org/data/deptMember.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：OP_MODULE, OP_CODE |  | OP_MODULE, OP_CODE |  |
| /department/org/data/dirAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：ids |  | ids |  |
| /department/org/data/fileListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pFile, dataType, pageIndex, pageCount, orderCode, orderType, searchText |  | pFile, dataType, pageIndex, pageCount, orderCode, orderType, searchText |  |
| /department/org/data/searchFileListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：searchText, dataType |  | searchText, dataType |  |
| /department/org/dept/addDept.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：NODE_DID, NODE_CODE |  | NODE_DID, NODE_CODE |  |
| /department/org/dept/addDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：NODE_DID, NODE_CODE |  | NODE_DID, NODE_CODE |  |
| /department/org/dept/ajaxDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：DID, DCODE |  | DID, DCODE |  |
| /department/org/dept/manDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：MID, DID, MCODE |  | MID, DID, MCODE |  |
| /department/org/dept/mgr.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 org -> 左侧 org-deptmgr | top-active=org; dept-left=org-deptmgr |  | 部门管理 @ /inc/page/org-body-left.jsp |
| /department/org/deptIdx.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 org -> 左侧 对应菜单 | top-active=org |  |  |
| /department/org/func/dept-func.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/org_neck.jsp -> 权限 | top-active=org; dept-right=power |  | 权限 @ /department/org/index.jsp； 权限 @ /inc/page/org_neck.jsp |
| /department/org/func/deptMember.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/org/func/event-func.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 org -> 左侧 org-event-func | top-active=org; dept-left=org-event-func |  | 活动报道权限 @ /inc/page/org-body-left.jsp |
| /department/org/func/share-data-func.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 org -> 左侧 org-sharedata-func | top-active=org; dept-left=org-sharedata-func |  | 资源共享权限 @ /inc/page/org-body-left.jsp |
| /department/org/group/addOrgGroup.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> venue -> venue | top-active=dept; dept-right=venue; dept-left=venue |  |  |
| /department/org/group/org-group.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 org -> 左侧 org-group | top-active=org; dept-left=org-group |  | 群组管理 @ /inc/page/org-body-left.jsp |
| /department/org/index.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 org -> 左侧 对应菜单 | top-active=org |  |  |
| /department/org/news/addTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 org -> 左侧 对应菜单 | top-active=org; dept-right=news | topicId |  |
| /department/org/news/comment/ajax/commentAllList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, p_lock, p_del_flag |  | p_id, p_obj, p_lock, p_del_flag |  |
| /department/org/news/comment/ajax/commentListWithPageList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, inc_clp_p_id, p_obj, inc_clp_p_obj, pageSize, p_del_flag, inc_clp_p_del_flag, p_lock, inc_clp_p_lock |  | p_id, inc_clp_p_id, p_obj, inc_clp_p_obj, pageSize, p_del_flag, inc_clp_p_del_flag, p_lock, inc_clp_p_lock |  |
| /department/org/news/comment/ajax/commentListWithPageMain.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, p_lock, p_del_flag |  | p_id, p_obj, p_lock, p_del_flag |  |
| /department/org/news/comment/ajax/commentNewTwo.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, p_lock, p_del_flag |  | p_id, p_obj, p_lock, p_del_flag |  |
| /department/org/news/comment/comment.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, p_lock, f_show, p_zan_show, p_reply_type, p_show_point, p_del_flag |  | p_id, p_obj, p_lock, f_show, p_zan_show, p_reply_type, p_show_point, p_del_flag |  |
| /department/org/news/comment/commentWihtZan.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, p_lock, p_reply_type |  | p_id, p_obj, p_lock, p_reply_type |  |
| /department/org/news/comment/commentWithOa.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /department/org/news/showTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：topicId, type |  | topicId, type | {{el.TITLE}} @ /department/org/news/topicIndex.jsp； {{el.TITLE}} @ /department/org/news/topicIndex.jsp； {{el.TITLE}} @ /department/org/news/topicList.jsp |
| /department/org/news/topicIndex.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/org_neck.jsp -> 活动报道 | top-active=org; dept-right=news |  | 活动报道 @ /inc/page/org_neck.jsp |
| /department/org/news/topicList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SEA_TYPE |  | SEA_TYPE |  |
| /department/org/notice/addNotice.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 org -> 左侧 对应菜单 | top-active=org; dept-right=notice |  | 发新通知 @ /department/org/notice/body-right-top.jsp |
| /department/org/notice/body-right-top.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：li, so, returnUrl |  | li, so, returnUrl |  |
| /department/org/notice/editNotice0.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 org -> 左侧 对应菜单 | top-active=org; dept-right=notice | noticeId | 只改内容不重发 @ /department/org/notice/viewNotice.jsp |
| /department/org/notice/editNotice1.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 org -> 左侧 对应菜单 | top-active=org; dept-right=notice | noticeId | 修改并重发 @ /department/org/notice/viewNotice.jsp |
| /department/org/notice/listNotice.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/org_neck.jsp -> 通知 | top-active=org; dept-right=notice |  | 通知 @ /department/org/index.jsp； 已发通知 @ /department/org/notice/body-right-top.jsp； 通知 @ /inc/page/org_neck.jsp |
| /department/org/notice/viewCountNotice.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 org -> 左侧 对应菜单 | top-active=org; dept-right=notice | noticeId, fromtype | 阅读：{{el.VIEWCOUNT}}/{{el.ALLCOUNT}}-- @ /department/org/notice/listNotice.jsp； / -- @ /department/org/notice/viewNotice.jsp |
| /department/org/notice/viewNotice.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 org -> 左侧 对应菜单 | top-active=org; dept-right=notice |  | {{el.TITLE}} @ /department/org/notice/listNotice.jsp |
| /department/org/sdata/sdataMgr.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/org_neck.jsp -> 资源共享 | top-active=org; dept-right=share |  | 资源共享 @ /department/org/index.jsp； 资源共享 @ /inc/page/org_neck.jsp |

### 空间（273）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /space/classspace/album/album_pic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | aid, pid, classId |  |
| /space/classspace/album/album_piclist.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | OBJECT_ID, ID, classId, isLock |  |
| /space/classspace/album/album.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | classId, OBJECT_ID, SEA_NAME | 班级相册 @ /space/common/jsp/nav.jsp |
| /space/classspace/checkon/ajax/checkAllAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：weekNum, classId, checkDate |  | weekNum, classId, checkDate |  |
| /space/classspace/checkon/ajax/checkonTotalDayAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：selectedDate, classId |  | selectedDate, classId |  |
| /space/classspace/checkon/ajax/checkonTotalStudentAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：weekNum, curStudent, classId |  | weekNum, curStudent, classId |  |
| /space/classspace/checkon/ajax/headAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：weekNum, classId |  | weekNum, classId |  |
| /space/classspace/checkon/ajax/submitAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：classId, checkDate, checkCode, temp_code, checkData |  | classId, checkDate, checkCode, temp_code, checkData |  |
| /space/classspace/checkon/ajax/submitQuitAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：classId, checkDate, checkCode, temp_code, checkData |  | classId, checkDate, checkCode, temp_code, checkData |  |
| /space/classspace/checkon/checkonDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 class -> 左侧 对应菜单 | top-active=class | classId, OBJECT_ID, checkDate, weekNum, checkCode, temp_code | @ /space/classspace/checkon/checkonMain.jsp；  @ /space/classspace/checkon/checkonMain.jsp； 有缺勤 @ /space/classspace/checkon/checkonMain.jsp |
| /space/classspace/checkon/checkonMain.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | OBJECT_ID, classId | 班主任考勤 @ /space/classspace/checkon/checkonDetail.jsp； 班主任考勤 @ /space/classspace/checkon/checkonTotalDay.jsp； 班主任考勤 @ /space/classspace/checkon/checkonTotalStudent.jsp |
| /space/classspace/checkon/checkonTotalDay.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | classId, OBJECT_ID | 时间视图 @ /space/classspace/checkon/checkonTotalStudent.jsp |
| /space/classspace/checkon/checkonTotalStudent.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | classId, OBJECT_ID | 考勤统计 @ /space/classspace/checkon/checkonDetail.jsp； 考勤统计 @ /space/classspace/checkon/checkonMain.jsp； 学生视图 @ /space/classspace/checkon/checkonTotalDay.jsp |
| /space/classspace/checkon/course.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | classId |  |
| /space/classspace/classData.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | OBJECT_ID, classId | 班级资料 @ /space/common/jsp/nav.jsp； 班级资料 @ /space/common/jsp/nav.jsp |
| /space/classspace/classlist/ajax/allClassAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：termId, gradeId |  | termId, gradeId |  |
| /space/classspace/classlist/ajax/myClassAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, termId, gradeId |  | pageSize, termId, gradeId |  |
| /space/classspace/classlist/allClassList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | classId, termId | 全校班级 @ /space/classspace/classlist/myClassList.jsp； 全校班级 @ /space/classspace/classlist/topicList.jsp |
| /space/classspace/classlist/myClassList.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的班级 left -> 班级空间 | top-active=class | classId, termId | 班级空间 @ /school/grade/classView.jsp；  @ /space/classspace/classlist/allClassList.jsp |
| /space/classspace/classlist/topicList-detail.jsp | 帖子详情 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/classspace/classlist/topicList.jsp | 空间主题贴 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /teacher/tea-index.jsp -> /space/classspace/classlist/topicList.jsp | top-active=class |  | 空间主题贴 @ /space/classspace/classlist/allClassList.jsp； 空间主题贴 @ /space/classspace/classlist/myClassList.jsp；  @ /teacher/tea-index.jsp |
| /space/classspace/classSpaceManger.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 class-space | top-active=class; dept-left=class-space | classId | 空间 @ /school/grade/classView.jsp； 空间 @ /school/grade/classView.jsp； 空间 @ /school/grade/classView.jsp |
| /space/classspace/dy/classEducation_bak.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 对应菜单 | top-active=class |  |  |
| /space/classspace/dy/classEducation.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 对应菜单 | top-active=class |  | 德育记录 @ /space/common/jsp/space-left-class.jsp |
| /space/classspace/dy/classEducationAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /space/classspace/dy/classEducationList.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/classspace/dy/detailsPage.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：OBJECT_ID, TYPE, STUID, CLASSID |  | OBJECT_ID, TYPE, STUID, CLASSID |  |
| /space/classspace/index.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 教师首页 left -> 初二1班 | top-active=class | classId, OBJECT_ID | 初二1班 @ /teacher/tea-index.jsp； 初二3班 @ /teacher/tea-index.jsp； 初三1班 @ /teacher/tea-index.jsp |
| /space/classspace/kq/checkon_detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 class -> 左侧 对应菜单 | top-active=class | classId, OBJECT_ID | 班级考勤 @ /space/classspace/kq/class_check_count.jsp； 班级考勤 @ /space/classspace/kq/my_class_record.jsp； 班级考勤 @ /space/classspace/kq/stu_week_view.jsp |
| /space/classspace/kq/class_check_count.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | classId, OBJECT_ID | 缺勤统计 @ /space/classspace/kq/stu_week_view.jsp |
| /space/classspace/kq/conflict_handle.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：exist_kq_list, no_conflict_list, opUserId, class_id, stu_array, remark, check_date, time_type, status |  | exist_kq_list, no_conflict_list, opUserId, class_id, stu_array, remark, check_date, time_type, status |  |
| /space/classspace/kq/frm_add_class_queqin.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：class_id, check_date, stu_ids |  | class_id, check_date, stu_ids |  |
| /space/classspace/kq/frm_view_class_queqin.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：record_id |  | record_id |  |
| /space/classspace/kq/frm_view_stu_kq_detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：term_code, class_id, student_id, start_date, end_date, search_val, search_type |  | term_code, class_id, student_id, start_date, end_date, search_val, search_type |  |
| /space/classspace/kq/my_class_record.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 class -> 左侧 对应菜单 | top-active=class | classId, OBJECT_ID |  |
| /space/classspace/kq/stu_week_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 class -> 左侧 对应菜单 | top-active=class | classId, OBJECT_ID, studentId |  |
| /space/classspace/spacepic/space_pic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：tid, pid, classId, OBJECT_ID |  | tid, pid, classId, OBJECT_ID |  |
| /space/classspace/spTopic/addTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | topicId, OBJECT_ID, classId | 分享 @ /space/common/jsp/nav.jsp |
| /space/classspace/spTopic/addTopicStep1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 class -> 左侧 对应菜单 | top-active=class | OBJECT_ID, classId |  |
| /space/classspace/spTopic/addTopicStep2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 class -> 左侧 对应菜单 | top-active=class | OBJECT_ID, classId |  |
| /space/classspace/spTopic/topicList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | OBJECT_ID, classId | 班级广场 @ /space/common/jsp/nav.jsp； 班级广场 @ /space/common/jsp/nav.jsp |
| /space/classspace/topic/addTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | OBJECT_ID, classId |  |
| /space/classspace/topic/editTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | topicId, OBJECT_ID, classId |  |
| /space/classspace/topic/showTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | OBJECT_ID, classId, topicId | @ /space/common/jsp/space-left-class.jsp； &OBJECT_ID=&classId="> @ /space/common/jsp/space-left-class.jsp |
| /space/classspace/topic/topicItems.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | classId, topicId |  |
| /space/classspace/topic/topicList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | OBJECT_ID, classId |  |
| /space/common/album/in_album_pic_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：iapa_aid, iapa_pid, iapa_oid, iapa_oname |  | iapa_aid, iapa_pid, iapa_oid, iapa_oname |  |
| /space/common/album/in_album_pic.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：aid, pid, classId, schoolId, auth_type, auth_code, user_type, spaceId |  | aid, pid, classId, schoolId, auth_type, auth_code, user_type, spaceId |  |
| /space/common/album/in_album_piclist.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：inc_aid, permission, isLock, inc_classId, inc_oid, oname, schoolId, auth_type, auth_code, user_type, isObjUsr, isObjMgr |  | inc_aid, permission, isLock, inc_classId, inc_oid, oname, schoolId, auth_type, auth_code, user_type, isObjUsr, isObjMgr |  |
| /space/common/album/in_album.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：ia_oid, oname, isObjUsr, isObjMgr, classId, schoolId, auth_type, auth_code, user_type, ia_seaName, url, permission |  | ia_oid, oname, isObjUsr, isObjMgr, classId, schoolId, auth_type, auth_code, user_type, ia_seaName, url, permission |  |
| /space/common/album/in_albumAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curPage, iaa_oid, oid, oname, permission, iaa_classId, classId, auth_type, auth_code, user_type, iaa_seaName |  | curPage, iaa_oid, oid, oname, permission, iaa_classId, classId, auth_type, auth_code, user_type, iaa_seaName |  |
| /space/common/album/in_albumDetail.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：ID, OBJECT_ID, auth_type, OBJECT_NAME |  | ID, OBJECT_ID, auth_type, OBJECT_NAME |  |
| /space/common/album/in_discussList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：id_tname, id_tid, id_delete, id_cid |  | id_tname, id_tid, id_delete, id_cid |  |
| /space/common/album/in_getDiscussListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：index, size, count, tname, tid, cid, delete |  | index, size, count, tname, tid, cid, delete |  |
| /space/common/album/in_piclistAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curPage, INC_ALBUMID, ALBUMID, INC_OID, OID, ONAME, isObjUsr_, isObjMgr_, schoolId, auth_type, auth_code, user_type |  | curPage, INC_ALBUMID, ALBUMID, INC_OID, OID, ONAME, isObjUsr_, isObjMgr_, schoolId, auth_type, auth_code, user_type |  |
| /space/common/album/in_sendDiscuss.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：TARGET_NAME, TARGET_ID, parm, tname, tid |  | TARGET_NAME, TARGET_ID, parm, tname, tid |  |
| /space/common/album/inc/picupload.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：ID, OID, ONAME |  | ID, OID, ONAME |  |
| /space/common/album/inc/spUpload.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/common/album/inc/upload.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/common/album/inc/upload5.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/common/album/inc/uploadify.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/common/data/advancedManager.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/common/data/ajax/dirAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：OBJECT_ID, OBJECT_NAME, ids |  | OBJECT_ID, OBJECT_NAME, ids |  |
| /space/common/data/ajax/downloadAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：ID |  | ID |  |
| /space/common/data/ajax/fileListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：OBJECT_ID, OBJECT_NAME, pFile, pageIndex, pageCount, orderCode, orderType, searchText |  | OBJECT_ID, OBJECT_NAME, pFile, pageIndex, pageCount, orderCode, orderType, searchText |  |
| /space/common/data/ajax/searchFileListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：OBJECT_ID, OBJECT_NAME, searchText |  | OBJECT_ID, OBJECT_NAME, searchText |  |
| /space/common/data/dataManager.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/common/jsp/nav.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：SELECTED_ON, REF_ON, INC_CLASS_ID, INC_OBJECT_ID, space_type, hide, permission |  | SELECTED_ON, REF_ON, INC_CLASS_ID, INC_OBJECT_ID, space_type, hide, permission |  |
| /space/common/jsp/space-left-class.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：INC_CLASS_ID, INC_OBJECT_ID |  | INC_CLASS_ID, INC_OBJECT_ID |  |
| /space/common/jsp/space-left-course.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curCourseId |  | curCourseId |  |
| /space/common/jsp/space-left-special.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/common/jsp/space-left-teach.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/common/jsp/top-info.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：INC_CLASS_ID |  | INC_CLASS_ID |  |
| /space/common/spacepic/examen_space_pic.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：tid, pid, classId, OBJECT_ID, objname, uid, question_id, examen_id |  | tid, pid, classId, OBJECT_ID, objname, uid, question_id, examen_id |  |
| /space/common/spacepic/homework_pic.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：workId, mainId, quesId, imgId |  | workId, mainId, quesId, imgId | @ /space/teachspace/homework/common/Am-homework_fin_total-avg.jsp；  @ /space/teachspace/homework/common/Am-homework_fin_total-avg.jsp；  @ /space/teachspace/homework/common/Am-homework_fin_total-avg.jsp |
| /space/common/spacepic/in_homework_pic.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：workId, mainId, quesId, imgId, pictype, classId, objid, objname |  | workId, mainId, quesId, imgId, pictype, classId, objid, objname |  |
| /space/common/spacepic/in_space_pic.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：tid, pid, classId, objid, objname |  | tid, pid, classId, objid, objname |  |
| /space/common/spacepic/space_pic.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：tid, pid, classId, OBJECT_ID, objname |  | tid, pid, classId, OBJECT_ID, objname | @ /common/comment/ajax/commentAllList.jsp；  @ /coursespace/courseTopic/courseTopicSpace/list.jsp；  @ /coursespace/courseTopic/courseTopicSpace/list.jsp |
| /space/common/spTopic/addTopic.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：topicId, OBJECT_ID, OBJECT_NAME, TO_URL, TOPIC_TYPE |  | topicId, OBJECT_ID, OBJECT_NAME, TO_URL, TOPIC_TYPE |  |
| /space/common/spTopic/addTopic1.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：OBJECT_ID, OBJECT_NAME, TO_URL, TOPIC_TYPE |  | OBJECT_ID, OBJECT_NAME, TO_URL, TOPIC_TYPE |  |
| /space/common/spTopic/topicItems.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：OBJECT_ID, OBJECT_NAME, ADMIN_AUTH, SHOW_URL, EDIT_URL, EDIT_URL1, auth_type, permission, CLASS_ID, TO_URL, pageSize, curPage |  | OBJECT_ID, OBJECT_NAME, ADMIN_AUTH, SHOW_URL, EDIT_URL, EDIT_URL1, auth_type, permission, CLASS_ID, TO_URL, pageSize, curPage |  |
| /space/common/spTopic/topicList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：INC_TOPIC_ID, INC_OBJECT_ID, OBJECT_NAME, auth_type, ADMIN_AUTH, TO_URL, ADD_URL, SHOW_URL, EDIT_URL, EDIT_URL1, IS_PAGING, permission |  | INC_TOPIC_ID, INC_OBJECT_ID, OBJECT_NAME, auth_type, ADMIN_AUTH, TO_URL, ADD_URL, SHOW_URL, EDIT_URL, EDIT_URL1, IS_PAGING, permission |  |
| /space/common/spTopic/topicOne.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：INC_TOPIC_ID, INC_OBJECT_ID, INC_classId, auth_type, ADMIN_AUTH, EDIT_URL, EDIT_URL1, TO_URL, SHOW_URL, permission |  | INC_TOPIC_ID, INC_OBJECT_ID, INC_classId, auth_type, ADMIN_AUTH, EDIT_URL, EDIT_URL1, TO_URL, SHOW_URL, permission |  |
| /space/common/topic/addTopic.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：OBJECT_ID, OBJECT_NAME, TO_URL, TOPIC_TYPE |  | OBJECT_ID, OBJECT_NAME, TO_URL, TOPIC_TYPE |  |
| /space/common/topic/editTopic.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：INC_TOPIC_ID, TO_URL, INC_OBJECT_ID, TOPIC_TYPE |  | INC_TOPIC_ID, TO_URL, INC_OBJECT_ID, TOPIC_TYPE |  |
| /space/common/topic/showTopic.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：INC_TOPIC_ID, INC_OBJECT_ID, OBJECT_NAME, INC_classId, ADMIN_AUTH, EDIT_URL, EDIT_URL1, TO_URL, permission |  | INC_TOPIC_ID, INC_OBJECT_ID, OBJECT_NAME, INC_classId, ADMIN_AUTH, EDIT_URL, EDIT_URL1, TO_URL, permission |  |
| /space/common/topic/topicItems.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：OBJECT_ID, OBJECT_NAME, ADMIN_AUTH, SHOW_URL, EDIT_URL, permission, TO_URL, pageSize, curPage |  | OBJECT_ID, OBJECT_NAME, ADMIN_AUTH, SHOW_URL, EDIT_URL, permission, TO_URL, pageSize, curPage |  |
| /space/common/topic/topicList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：INC_TOPIC_ID, INC_OBJECT_ID, OBJECT_NAME, permission, ADMIN_AUTH, TO_URL, SHOW_URL, EDIT_URL |  | INC_TOPIC_ID, INC_OBJECT_ID, OBJECT_NAME, permission, ADMIN_AUTH, TO_URL, SHOW_URL, EDIT_URL |  |
| /space/count/check_count.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> stu_check_stat | top-active=dept; dept-left=stu_check_stat |  |  |
| /space/count/checkCount_.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> dy-record -> 部门页签 -> stu_check_stat | top-active=dept; dept-id=dy-record; dept-left=stu_check_stat | SEA_CLASS_ID, SEA_GRADE_CODE, SEA_TERM_CODE, TABLE_ORDER |  |
| /space/count/checkCount.jsp | 学生考勤统计 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> stu_check_stat | top-active=dept; dept-left=stu_check_stat |  | 学生考勤统计 @ /space/count/classview_check_count.jsp； 学生考勤统计 @ /space/count/inc_check_count.jsp |
| /space/count/checkCountAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, SEA_GRADE_CODE, SEA_CLASS_ID, CURR_TERM_ID, TABLE_ORDER |  | pageSize, curPage, SEA_GRADE_CODE, SEA_CLASS_ID, CURR_TERM_ID, TABLE_ORDER |  |
| /space/count/checkDetails.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：STUID, TERM, TABLE_ORDER, TABLE_ORDER_PX |  | STUID, TERM, TABLE_ORDER, TABLE_ORDER_PX |  |
| /space/count/checkDetailsAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, STU_ID, TABLE_ORDER, TABLE_ORDER_PX |  | pageSize, curPage, STU_ID, TABLE_ORDER, TABLE_ORDER_PX |  |
| /space/count/classview_check_count.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> stu_check_stat | top-active=dept; dept-left=stu_check_stat | class_id, term_code, search_type, start_date, end_date |  |
| /space/count/cm_check_view.jsp | 班主任记录汇总 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 stu_check_stat | top-active=dept; dept-left=stu_check_stat | term_code, sea_code |  |
| /space/count/frm_view_class_stu_kq_detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：term_code, obj_id, obj_name, student_id, start_date, end_date, search_val, search_type |  | term_code, obj_id, obj_name, student_id, start_date, end_date, search_val, search_type |  |
| /space/count/inc_check_count.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：li |  | li |  |
| /space/specialspace/album/album_pic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 对应菜单 | top-active=apply | aid, pid |  |
| /space/specialspace/album/album_piclist.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 对应菜单 | top-active=apply | OBJECT_ID, ID, isLock |  |
| /space/specialspace/album/album.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 对应菜单 | top-active=apply | OBJECT_ID, SEA_NAME | 相册 @ /space/specialspace/common/jsp/nav.jsp |
| /space/specialspace/common/jsp/nav.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：SELECTED_ON, REF_ON, hide |  | SELECTED_ON, REF_ON, hide |  |
| /space/specialspace/common/jsp/top-info.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/specialspace/index.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 教师首页 left -> 校园风采`2 | top-active=apply | OBJECT_ID | 校园风采`2 @ /teacher/tea-index.jsp； 失物招领晒米在 @ /teacher/tea-index.jsp； chrisceshi @ /teacher/tea-index.jsp |
| /space/specialspace/manager/managerHeader.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：tab |  | tab |  |
| /space/specialspace/manager/normalRight.jsp | 专项空间 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> special -> sp_space | top-active=dept; dept-right=special; dept-left=sp_space | QUERY_TERM_CODE, NAME | 通用权限 @ /space/specialspace/manager/managerHeader.jsp |
| /space/specialspace/manager/specialDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 sp_space | top-active=dept; dept-right=venue; dept-left=sp_space | id | @ /space/specialspace/manager/specialSpaceManager.jsp |
| /space/specialspace/manager/specialEnter.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 教师首页 left -> 专项空间 | top-active=apply; dept-left=specialSpace |  | 专项空间 @ /teacher/tea-index.jsp； ．．． @ /teacher/tea-index.jsp； 专项空间 @ /user/headupload.jsp |
| /space/specialspace/manager/specialSpaceManager.jsp | 专项空间管理 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> special -> sp_space | top-active=dept; dept-right=special; dept-left=sp_space |  | 专项空间设置 @ /space/specialspace/manager/managerHeader.jsp |
| /space/specialspace/notice/publishNotice.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 对应菜单 | top-active=apply | OBJECT_ID | 发布公告 @ /space/common/jsp/space-left-special.jsp |
| /space/specialspace/spaceData.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 对应菜单 | top-active=apply | OBJECT_ID | 资料 @ /space/specialspace/common/jsp/nav.jsp； 资料 @ /space/specialspace/common/jsp/nav.jsp |
| /space/specialspace/topic/addTopic_.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 对应菜单 | top-active=apply | OBJECT_ID |  |
| /space/specialspace/topic/addTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 对应菜单 | top-active=apply | OBJECT_ID | 分享 @ /space/specialspace/common/jsp/nav.jsp |
| /space/specialspace/topic/editTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 对应菜单 | top-active=apply | topicId, OBJECT_ID |  |
| /space/specialspace/topic/showTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 对应菜单 | top-active=apply | OBJECT_ID, topicId | &OBJECT_ID="> @ /space/common/jsp/space-left-special.jsp； &OBJECT_ID="> @ /space/common/jsp/space-left-special.jsp |
| /space/specialspace/topic/topicItems.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 对应菜单 | top-active=apply | classId |  |
| /space/specialspace/topic/topicList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 对应菜单 | top-active=apply | OBJECT_ID | 广场 @ /space/specialspace/common/jsp/nav.jsp； 广场 @ /space/specialspace/common/jsp/nav.jsp |
| /space/teachspace/common/allgroup-top-nav.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：_type, _space_id, hide |  | _type, _space_id, hide |  |
| /space/teachspace/common/docView.jsp | OFFICE在线编辑 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：fileId, bHeight |  | fileId, bHeight |  |
| /space/teachspace/common/docViewReadOnly.jsp | OFFICE在线编辑 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：fileId, planId |  | fileId, planId |  |
| /space/teachspace/common/docViewTrace.jsp | OFFICE在线编辑 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：fileId, planId |  | fileId, planId |  |
| /space/teachspace/common/group-top-nav.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：_type, _space_id, hide |  | _type, _space_id, hide |  |
| /space/teachspace/common/nav.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：SELECTED_ON, REF_ON, _SPACE_ID, hide, permission |  | SELECTED_ON, REF_ON, _SPACE_ID, hide, permission |  |
| /space/teachspace/common/open-top-nav.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：_type, _space_id |  | _type, _space_id |  |
| /space/teachspace/common/savefile.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：fileId |  | fileId |  |
| /space/teachspace/common/top-info.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：_SPACE_ID |  | _SPACE_ID |  |
| /space/teachspace/common/top-nav-share.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：_type, _plan_id, _space_id |  | _type, _plan_id, _space_id |  |
| /space/teachspace/common/top-nav.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：_type, _plan_id, _space_id |  | _type, _plan_id, _space_id |  |
| /space/teachspace/dataManager/userDataManager.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId | 我的资料 @ /space/common/jsp/space-left-teach.jsp |
| /space/teachspace/entry-space.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 teach -> 左侧 user-trans | top-active=teach; dept-left=user-trans |  |  |
| /space/teachspace/homework/ajax/getShareFileListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：plan_id, space_id |  | plan_id, space_id |  |
| /space/teachspace/homework/ajax/homeworkHadDocCheckListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：aClassId, aSpaceId, aWorkId |  | aClassId, aSpaceId, aWorkId |  |
| /space/teachspace/homework/ajax/homeworkListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, a_spaceId |  | pageSize, a_spaceId |  |
| /space/teachspace/homework/ajax/homeworkListStuAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, a_spaceId, curPage |  | pageSize, a_spaceId, curPage |  |
| /space/teachspace/homework/ajax/homeworkMainAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：a_space_id, a_plan_id |  | a_space_id, a_plan_id |  |
| /space/teachspace/homework/ajax/homeworkMainListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, a_spaceId, curPage |  | pageSize, a_spaceId, curPage |  |
| /space/teachspace/homework/ajax/shareHomeworkMainAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：a_plan_id |  | a_plan_id |  |
| /space/teachspace/homework/common/Am-homework_fin_total-avg.jsp | 作业详情及时长 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/teachspace/homework/common/Am-homework_fin_total-detail.jsp | 作业详情及时长 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/teachspace/homework/common/homeworkMain.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId |  |
| /space/teachspace/homework/common/homeworkView.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId |  |
| /space/teachspace/homework/common/inc_homework_fill.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：spaceId, homeworkId, questionId, planId |  | spaceId, homeworkId, questionId, planId |  |
| /space/teachspace/homework/common/inc_homework_mult.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：spaceId, homeworkId, type, questionId, planId |  | spaceId, homeworkId, type, questionId, planId |  |
| /space/teachspace/homework/common/inc_homework_qr.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：spaceId, homeworkId, type, questionId, planId |  | spaceId, homeworkId, type, questionId, planId |  |
| /space/teachspace/homework/common/inc_viewNpList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：homeworkId, spaceId, planId, homework_platform |  | homeworkId, spaceId, planId, homework_platform |  |
| /space/teachspace/homework/common/shareViewNpList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：homeworkId, spaceId, planId |  | homeworkId, spaceId, planId |  |
| /space/teachspace/homework/common/spaceViewNpList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：homeworkId, spaceId, planId |  | homeworkId, spaceId, planId |  |
| /space/teachspace/homework/common/viewDoList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：homeworkId, VIEW_TOTAL, spaceId, planId, userId |  | homeworkId, VIEW_TOTAL, spaceId, planId, userId |  |
| /space/teachspace/homework/common/viewDoList2.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：homeworkId, VIEW_TOTAL, spaceId, planId, userId |  | homeworkId, VIEW_TOTAL, spaceId, planId, userId |  |
| /space/teachspace/homework/common/viewHadDoAnsList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：homeworkId, spaceId, planId, _USER_ID |  | homeworkId, spaceId, planId, _USER_ID |  |
| /space/teachspace/homework/common/viewHadDoList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：homeworkId, spaceId, planId, _USER_ID |  | homeworkId, spaceId, planId, _USER_ID |  |
| /space/teachspace/homework/common/viewNpList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：homeworkId, spaceId, planId |  | homeworkId, spaceId, planId |  |
| /space/teachspace/homework/frm_homework_edit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：work_id |  | work_id |  |
| /space/teachspace/homework/frm_homework_fin_view.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：term_code, grade_code, week_no, class_id, week_day |  | term_code, grade_code, week_no, class_id, week_day |  |
| /space/teachspace/homework/homework_fin_total.jsp | 作业时长 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 stat_dept | top-active=teach; dept-id=office; dept-left=stat_dept | teachtype, termId, gradeId, courseId | 作业时长 @ /space/teachspace/homework/homework_fin_total.jsp； 作业时长 @ /space/teachspace/teachSpaceTotal/common/top-nav.jsp |
| /space/teachspace/homework/homeworkBackComment.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：homeworkId, userId, classId |  | homeworkId, userId, classId |  |
| /space/teachspace/homework/homeworkDoView.jsp | 作业详情 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId | &homeworkId="> @ /space/classspace/index.jsp； &homeworkId="> @ /space/classspace/index.jsp； {{el.RENDER_TITLE\|html}} @ /space/teachspace/homework/homeworkList.jsp |
| /space/teachspace/homework/homeworkFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId, type, questionId | 填空题 @ /space/teachspace/homework/homeworkView.jsp |
| /space/teachspace/homework/homeworkHadDoCheckList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId | 查看评价 @ /space/teachspace/homework/homeworkList.jsp |
| /space/teachspace/homework/homeworkHadDoCheckStuList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId, userId, select_classId | 作业批改 @ /space/teachspace/homework/homeworkHadDoCheckView.jsp； 返回 @ /space/teachspace/homework/homeworkHadDoCheckView.jsp； 已完成{{el.FINALCOUNT}}/{{el.STUDENTCOUNT}} @ /space/teachspace/homework/homeworkList.jsp |
| /space/teachspace/homework/homeworkHadDoCheckView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId, userId, classId, select_classId | {{el.CLASSNO\|type}}{{el.CLASS_NO}} {{el.NAME}} @ /space/teachspace/homework/homeworkHadDoCheckStuList.jsp； {{el.CLASSNO\|type}}{{el.CLASS_NO}} {{el.NAME}} @ /space/teachspace/homework/homeworkHadDoCheckStuList.jsp； {{el.CLASSNO\|type}}{{el.CLASS_NO}} {{el.NAME}} @ /space/teachspace/homework/homeworkHadDoCheckStuList.jsp |
| /space/teachspace/homework/homeworkHadDoCheckView2.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId, userId, classId, userName |  |
| /space/teachspace/homework/homeworkHadDoView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId | &homeworkId="> @ /space/classspace/index.jsp； {{el.RENDER_TITLE\|html}} @ /space/teachspace/homework/homeworkList.jsp； "> @ /space/teachspace/index.jsp |
| /space/teachspace/homework/homeworkList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId | {{rec.HOMEWORK}} @ /department/spaceauth/teachSpaceMgr.jsp； 作业 @ /space/teachspace/common/nav.jsp； 作业 @ /space/teachspace/homework/homeworkDoView.jsp |
| /space/teachspace/homework/homeworkMain.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId | 作业 @ /space/teachspace/common/top-nav.jsp；  @ /space/teachspace/PreLession/myPreLessOpenCourse.jsp；  @ /space/teachspace/PreLession/myPreLessOpenCourse.jsp |
| /space/teachspace/homework/homeworkMainList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId |  |
| /space/teachspace/homework/homeworkMult.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId, type, questionId | 单选题 @ /space/teachspace/homework/homeworkView.jsp； 多选题 @ /space/teachspace/homework/homeworkView.jsp |
| /space/teachspace/homework/homeworkMultAdd.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId, type | 单选题 @ /space/teachspace/homework/common/homeworkView.jsp； 多选题 @ /space/teachspace/homework/common/homeworkView.jsp |
| /space/teachspace/homework/homeworkMultEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId, questionId |  |
| /space/teachspace/homework/homeworkOrder.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId | 题目排序 @ /space/teachspace/homework/common/homeworkView.jsp； 题目排序 @ /space/teachspace/homework/homeworkView.jsp |
| /space/teachspace/homework/homeworkQr.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId, type, questionId | 自定义 @ /space/teachspace/homework/homeworkView.jsp； 判断题 @ /space/teachspace/homework/homeworkView.jsp； 问答题 @ /space/teachspace/homework/homeworkView.jsp |
| /space/teachspace/homework/homeworkQrAdd.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId, type | 文本行 @ /space/teachspace/homework/common/homeworkView.jsp； 判断题 @ /space/teachspace/homework/common/homeworkView.jsp； 问答题 @ /space/teachspace/homework/common/homeworkView.jsp |
| /space/teachspace/homework/homeworkQrEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId, questionId | .［问答题］ @ /space/teachspace/homework/common/viewDoList.jsp； .［多选题］ @ /space/teachspace/homework/common/viewDoList.jsp；  @ /space/teachspace/homework/common/viewDoList2.jsp |
| /space/teachspace/homework/homeworkView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId | {{el.TITLE}} @ /space/teachspace/homework/common/homeworkMain.jsp； {{el.TITLE}} @ /space/teachspace/homework/homeworkMain.jsp； 取消 @ /space/teachspace/homework/homeworkMultAdd.jsp |
| /space/teachspace/homework/homeworkViewPublish.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId | {{el.TITLE}} @ /space/teachspace/homework/common/homeworkMain.jsp； {{el.TITLE}} @ /space/teachspace/homework/homeworkMain.jsp |
| /space/teachspace/homework/shareHomeworkFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId, type | 填空题 @ /space/teachspace/homework/shareHomeworkView.jsp |
| /space/teachspace/homework/shareHomeworkMain.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId | 作业 @ /space/teachspace/common/top-nav-share.jsp； 暂存 @ /space/teachspace/homework/shareHomeworkView.jsp；  @ /space/teachspace/PreLession/sharePreLessMainPlan.jsp |
| /space/teachspace/homework/shareHomeworkMult.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId, type, questionId | 单选题 @ /space/teachspace/homework/shareHomeworkView.jsp； 多选题 @ /space/teachspace/homework/shareHomeworkView.jsp |
| /space/teachspace/homework/shareHomeworkMultAdd.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId, type |  |
| /space/teachspace/homework/shareHomeworkMultEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId, questionId |  |
| /space/teachspace/homework/shareHomeworkOrder.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId | 题目排序 @ /space/teachspace/homework/shareHomeworkView.jsp |
| /space/teachspace/homework/shareHomeworkQr.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId, type, questionId | 自定义 @ /space/teachspace/homework/shareHomeworkView.jsp； 判断题 @ /space/teachspace/homework/shareHomeworkView.jsp； 问答题 @ /space/teachspace/homework/shareHomeworkView.jsp |
| /space/teachspace/homework/shareHomeworkQrAdd.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId, type |  |
| /space/teachspace/homework/shareHomeworkQrEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId, questionId |  |
| /space/teachspace/homework/shareHomeworkView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId | {{el.TITLE}} @ /space/teachspace/homework/shareHomeworkMain.jsp； 取消 @ /space/teachspace/homework/shareHomeworkQrEdit.jsp |
| /space/teachspace/homework/spaceHomeworkFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId, type, questionId | 填空题 @ /space/teachspace/homework/spaceHomeworkView.jsp |
| /space/teachspace/homework/spaceHomeworkFillAdd.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId, type, questionId, planId |  |
| /space/teachspace/homework/spaceHomeworkMult.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId, questionId | 单选题 @ /space/teachspace/homework/spaceHomeworkView.jsp； 多选题 @ /space/teachspace/homework/spaceHomeworkView.jsp |
| /space/teachspace/homework/spaceHomeworkMultAdd.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId, type, planId |  |
| /space/teachspace/homework/spaceHomeworkMultEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId, questionId, planId |  |
| /space/teachspace/homework/spaceHomeworkOrder.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId | 题目排序 @ /space/teachspace/homework/spaceHomeworkView.jsp |
| /space/teachspace/homework/spaceHomeworkQr.jsp | 发作业 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId, type | 自定义 @ /space/teachspace/homework/spaceHomeworkView.jsp； 判断题 @ /space/teachspace/homework/spaceHomeworkView.jsp； 问答题 @ /space/teachspace/homework/spaceHomeworkView.jsp |
| /space/teachspace/homework/spaceHomeworkQrAdd.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId, questionId, type, planId |  |
| /space/teachspace/homework/spaceHomeworkQrEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId, questionId, planId |  |
| /space/teachspace/homework/spaceHomeworkView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId | {{el.RENDER_TITLE\|html}} @ /space/teachspace/homework/homeworkList.jsp； 取消 @ /space/teachspace/homework/spaceHomeworkFillAdd.jsp； 取消 @ /space/teachspace/homework/spaceHomeworkMultAdd.jsp |
| /space/teachspace/homework/spaceHomeworkViewPublish.jsp | 作业详情 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId | {{el.RENDER_TITLE\|html}} @ /space/teachspace/homework/homeworkList.jsp； {{el.TITLE}} @ /space/teachspace/homework/shareHomeworkMain.jsp； " title="" > @ /space/teachspace/index.jsp |
| /space/teachspace/homework/uploadFile.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：choise1 |  | choise1 |  |
| /space/teachspace/homework/uploadImgFile.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：choise1 |  | choise1 |  |
| /space/teachspace/homework/view/viewAll.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：spaceId, homeworkId |  | spaceId, homeworkId |  |
| /space/teachspace/homework/view/viewDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：spaceId, homeworkId, quesId |  | spaceId, homeworkId, quesId |  |
| /space/teachspace/homework/view/viewMain.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：spaceId, homeworkId |  | spaceId, homeworkId |  |
| /space/teachspace/homeworkCount.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：spaceId, classId |  | spaceId, classId |  |
| /space/teachspace/homeworkCountView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：courseCode, termId, gradeId, userId, classId |  | courseCode, termId, gradeId, userId, classId |  |
| /space/teachspace/inc/uploaddxa.jsp | 导学案 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/teachspace/inc/uploadja.jsp | 课件上传 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/teachspace/inc/uploadkj.jsp | 课件上传 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/teachspace/index.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 教师首页 left -> 初二语文啊啊？？ | top-active=teach | spaceId | 初二语文啊啊？？ @ /teacher/tea-index.jsp； {{rec.NAME}} @ /department/spaceauth/teachSpaceMgr.jsp； " title=""> @ /parent/par-index.jsp |
| /space/teachspace/myTeachSpaces.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的教学 left -> 教学空间 | top-active=teach; dept-left=user-trans | termId | 教学空间 @ /teacher/exam/entry-list.jsp |
| /space/teachspace/PreLessGroup/DataManager.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, OBJECT_ID, Type | 备课组 @ /space/common/jsp/space-left-teach.jsp； 公共资料 @ /space/teachspace/common/group-top-nav.jsp |
| /space/teachspace/PreLessGroup/topic/addTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, OBJECT_ID | 发帖 @ /space/teachspace/common/group-top-nav.jsp |
| /space/teachspace/PreLessGroup/topic/editTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, topicId, OBJECT_ID |  |
| /space/teachspace/PreLessGroup/topic/showTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | topicId, spaceId, OBJECT_ID |  |
| /space/teachspace/PreLessGroup/topic/topicItems.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | classId |  |
| /space/teachspace/PreLessGroup/topic/topicList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, OBJECT_ID | 集体研修 @ /space/teachspace/common/group-top-nav.jsp |
| /space/teachspace/PreLessGroupAll/DataManager.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, OBJECT_ID, Type | 教研组 @ /space/common/jsp/space-left-teach.jsp； 公共资料 @ /space/teachspace/common/allgroup-top-nav.jsp |
| /space/teachspace/PreLessGroupAll/topic/addTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, OBJECT_ID | 发帖 @ /space/teachspace/common/allgroup-top-nav.jsp |
| /space/teachspace/PreLessGroupAll/topic/editTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, topicId, OBJECT_ID |  |
| /space/teachspace/PreLessGroupAll/topic/showTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | topicId, spaceId, OBJECT_ID |  |
| /space/teachspace/PreLessGroupAll/topic/topicItems.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | classId |  |
| /space/teachspace/PreLessGroupAll/topic/topicList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, OBJECT_ID | 集体研修 @ /space/teachspace/common/allgroup-top-nav.jsp |
| /space/teachspace/PreLession/ajax/commentListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, p_id, p_obj, curPage |  | pageSize, p_id, p_obj, curPage |  |
| /space/teachspace/PreLession/ajax/expPlanAjax_bak.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, a_space_id, type, curPage |  | pageSize, a_space_id, type, curPage |  |
| /space/teachspace/PreLession/ajax/expPlanAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, a_space_id, curPage |  | pageSize, a_space_id, curPage |  |
| /space/teachspace/PreLession/ajax/myPreLessOpenCourseAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, a_space_id, curPage |  | pageSize, a_space_id, curPage |  |
| /space/teachspace/PreLession/ajax/perLessDetailAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：a_planId |  | a_planId |  |
| /space/teachspace/PreLession/ajax/perLessFileListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：a_plan_id |  | a_plan_id |  |
| /space/teachspace/PreLession/ajax/perLessMainAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：a_weekno, a_space_id |  | a_weekno, a_space_id |  |
| /space/teachspace/PreLession/ajax/perLessOpenCourse.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：a_planId |  | a_planId |  |
| /space/teachspace/PreLession/ajax/perLessVideoAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：a_planId |  | a_planId |  |
| /space/teachspace/PreLession/ajax/preLessVideoListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, a_spaceId, curPage |  | pageSize, a_spaceId, curPage |  |
| /space/teachspace/PreLession/ajax/sharePreLessMainAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, a_course_id, a_grade_code, a_term_id, a_space_id, curPage |  | pageSize, a_course_id, a_grade_code, a_term_id, a_space_id, curPage |  |
| /space/teachspace/PreLession/ajax/termPreLessOpenCourseAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, a_space_id, curPage |  | pageSize, a_space_id, curPage |  |
| /space/teachspace/PreLession/expMasterpreLess.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId |  |
| /space/teachspace/PreLession/expMepreLess.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId |  |
| /space/teachspace/PreLession/myPreLessOpenCourse.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId | 公开课 @ /space/common/jsp/space-left-teach.jsp； 我的公开课 @ /space/teachspace/common/open-top-nav.jsp |
| /space/teachspace/PreLession/openCourseAudit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 affair -> 左侧 user-trans | top-active=affair; dept-left=user-trans | adultId, type | 1x公开课 @ /teacher/tea-index.jsp； 2公开课 @ /teacher/tea-index.jsp； xx公开课 @ /teacher/tea-index.jsp |
| /space/teachspace/PreLession/openCourseAudit1.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId |  |
| /space/teachspace/PreLession/openCourseEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId | 公开课 @ /space/teachspace/common/top-nav.jsp；  @ /space/teachspace/PreLession/preLessMain.jsp；  @ /space/teachspace/PreLession/preLessMain.jsp |
| /space/teachspace/PreLession/openCourseView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId, homeworkId | 公开课 @ /space/teachspace/common/top-nav.jsp；  @ /space/teachspace/PreLession/preLessMain.jsp； {{el.OPENTITLE}} @ /space/teachspace/teachSpaceTotal/allOpenCourseList.jsp |
| /space/teachspace/PreLession/preLessDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId | 教案课件 @ /space/teachspace/common/top-nav.jsp； {{el.TITLE}} @ /space/teachspace/homework/homeworkMainList.jsp；  @ /space/teachspace/PreLession/myPreLessOpenCourse.jsp |
| /space/teachspace/PreLession/preLessMain.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId | 备课 @ /space/teachspace/common/nav.jsp； 备课 @ /space/teachspace/homework/common/homeworkMain.jsp； 备课 @ /space/teachspace/homework/common/homeworkView.jsp |
| /space/teachspace/PreLession/preLessMainOrder.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, weekNo | 排序 @ /space/teachspace/PreLession/preLessMainPlan.jsp |
| /space/teachspace/PreLession/preLessMainPlan.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, weekNo | ' == ''" --%> class="btn btn-sm btn-green"> 教学计划 @ /space/teachspace/PreLession/preLessMain.jsp； 我的教学计划 @ /space/teachspace/PreLession/preLessMainOrder.jsp |
| /space/teachspace/PreLession/preLessMicro.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId | 微教学 @ /space/teachspace/common/top-nav.jsp；  @ /space/teachspace/PreLession/myPreLessOpenCourse.jsp；  @ /space/teachspace/PreLession/myPreLessOpenCourse.jsp |
| /space/teachspace/PreLession/preLessVideoList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId | 微教学 @ /space/teachspace/common/nav.jsp； 微教学 @ /space/teachspace/PreLession/preLessVideoView.jsp |
| /space/teachspace/PreLession/preLessVideoView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, videoId | "> @ /space/teachspace/index.jsp； {{el.FILE_NAME}} @ /space/teachspace/PreLession/preLessMicro.jsp；  @ /space/teachspace/PreLession/preLessVideoList.jsp |
| /space/teachspace/PreLession/sharePreLessDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId | 教案课件 @ /space/teachspace/common/top-nav-share.jsp； {{el.CONTENT}} @ /space/teachspace/PreLession/sharePreLessMainPlan.jsp；  @ /space/teachspace/PreLession/sharePreLessMainPlan.jsp |
| /space/teachspace/PreLession/sharePreLessMainPlan.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId | 集体备课 @ /space/common/jsp/space-left-teach.jsp； 集体备课 @ /space/teachspace/homework/shareHomeworkFill.jsp； 集体备课 @ /space/teachspace/homework/shareHomeworkMain.jsp |
| /space/teachspace/PreLession/sharePreLessMicro.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId | 微教学 @ /space/teachspace/common/top-nav-share.jsp；  @ /space/teachspace/PreLession/sharePreLessMainPlan.jsp；  @ /space/teachspace/PreLession/sharePreLessMainPlan.jsp |
| /space/teachspace/PreLession/sharePreLessViewOnlyDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId |  |
| /space/teachspace/PreLession/sharePreLessViewOnlyMicro.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, planId | @ /space/teachspace/PreLession/sharePreLessMainPlan.jsp |
| /space/teachspace/PreLession/teachStat.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 stat_dept | top-active=teach; dept-id=office; dept-left=stat_dept | teachtype | 教学统计 @ /space/teachspace/homework/homework_fin_total.jsp； 教学统计 @ /space/teachspace/teachSpaceTotal/common/top-nav.jsp |
| /space/teachspace/PreLession/termPreLessOpenCourse.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId | 备课组公开课 @ /space/teachspace/common/open-top-nav.jsp |
| /space/teachspace/stuList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | spaceId, homeworkId, userId | 我的学生 @ /space/common/jsp/space-left-teach.jsp |
| /space/teachspace/teachSpaceSetting.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> spacesetting | top-active=dept; dept-id=jiaow; dept-left=spacesetting |  |  |
| /space/teachspace/teachSpaceTotal/ajax/addCookiesAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /space/teachspace/teachSpaceTotal/ajax/allOpenCourseListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, termId, gradeId, courseId |  | pageSize, curPage, termId, gradeId, courseId |  |
| /space/teachspace/teachSpaceTotal/ajax/allPlanAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：termId, gradeId, courseId |  | termId, gradeId, courseId |  |
| /space/teachspace/teachSpaceTotal/ajax/allTeachSpaceListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：termId, gradeId |  | termId, gradeId |  |
| /space/teachspace/teachSpaceTotal/ajax/allVideoAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：termId, gradeId, courseId |  | termId, gradeId, courseId |  |
| /space/teachspace/teachSpaceTotal/ajax/myTeachSpaceListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, termId, gradeId |  | pageSize, termId, gradeId |  |
| /space/teachspace/teachSpaceTotal/allOpenCourseList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | classId, termId, gradeId, courseId | 公开课 @ /space/teachspace/homework/homework_fin_total.jsp； 公开课 @ /space/teachspace/teachSpaceTotal/common/top-nav.jsp |
| /space/teachspace/teachSpaceTotal/allPlanList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | classId, termId, gradeId, courseId | 热门备课 @ /space/teachspace/homework/homework_fin_total.jsp； 热门备课 @ /space/teachspace/teachSpaceTotal/common/top-nav.jsp |
| /space/teachspace/teachSpaceTotal/allTeachSpaceList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | classId, termId, gradeId, teachtype | @ /space/teachspace/common/top-info.jsp； 全校空间 @ /space/teachspace/homework/homework_fin_total.jsp； 全校空间 @ /space/teachspace/teachSpaceTotal/common/top-nav.jsp |
| /space/teachspace/teachSpaceTotal/allVideoList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | classId, termId, gradeId, courseId | 热门微视频 @ /space/teachspace/homework/homework_fin_total.jsp； 热门微视频 @ /space/teachspace/teachSpaceTotal/common/top-nav.jsp |
| /space/teachspace/teachSpaceTotal/common/top-nav.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：_type, teachtype |  | _type, teachtype |  |
| /space/teachspace/teachSpaceTotal/myTeachSpaceList.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /parent/par-index.jsp -> ．．． | top-active=teach | classId, termId, gradeId, courseId | ．．． @ /parent/par-index.jsp； ．．． @ /parent/par-note.jsp；  @ /space/teachspace/common/top-info.jsp |
| /space/teachspace/topic/addTopic_.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | OBJECT_ID |  |
| /space/teachspace/topic/addTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | OBJECT_ID | 分享 @ /space/teachspace/common/nav.jsp |
| /space/teachspace/topic/editTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | OBJECT_ID, topicId |  |
| /space/teachspace/topic/showTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | OBJECT_ID, topicId | "> @ /space/common/jsp/space-left-teach.jsp； " title="" > @ /space/teachspace/index.jsp |
| /space/teachspace/topic/topicItems.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | classId |  |
| /space/teachspace/topic/topicList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 teach -> 左侧 对应菜单 | top-active=teach | OBJECT_ID | 师生探讨 @ /space/teachspace/common/nav.jsp |

### 课程空间（82）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /coursespace/album/add.jsp | Insert title here | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /coursespace/album/album_error.jsp | 页面404错误 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：error |  | error |  |
| /coursespace/album/album_pic_ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：aid, pid, cid |  | aid, pid, cid |  |
| /coursespace/album/album_pic.jsp | 社团选修空间 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | aid, pid | &pid="> @ /coursespace/mainPage/index/topicListAjax.jsp |
| /coursespace/album/album_piclist.jsp | 社团选修空间 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | ID, isLock | @ /coursespace/album/albumAjax.jsp；  @ /coursespace/album/albumAjax.jsp |
| /coursespace/album/album.jsp | 社团选修空间 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | OBJECT_ID, SEA_NAME | 班级相册 @ /coursespace/common/courseInfo.jsp； 班级相册 @ /coursespace/mainPage/index/topicListAjax.jsp； 班级相册 @ /coursespace/spTopic/nav.jsp |
| /coursespace/album/albumAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curPage, SELCOURSE_ID, OBJECT_ID, OBJECT_NAME, INC_SEA_NAME |  | curPage, SELCOURSE_ID, OBJECT_ID, OBJECT_NAME, INC_SEA_NAME |  |
| /coursespace/album/albumDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：ID, OBJECT_ID, OBJECT_NAME |  | ID, OBJECT_ID, OBJECT_NAME |  |
| /coursespace/album/discussList.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /coursespace/album/getDiscussListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：index, size, count, tname, tid, delete, cid |  | index, size, count, tname, tid, delete, cid |  |
| /coursespace/album/inc/piclist.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curPage, ALBUMID, SELCOURSE_ID |  | curPage, ALBUMID, SELCOURSE_ID |  |
| /coursespace/album/inc/picupload.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：ID, SELCOURSE_ID |  | ID, SELCOURSE_ID |  |
| /coursespace/album/inc/upload.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /coursespace/album/inc/uploadify.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /coursespace/album/sendDiscuss.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：TARGET_NAME, TARGET_ID, parm, tname, tid |  | TARGET_NAME, TARGET_ID, parm, tname, tid |  |
| /coursespace/checkon/checkOnMainList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId | 返回 @ /coursespace/checkon/checkOnMainView.jsp； 返回 @ /coursespace/checkon/checkOnMainViewEdit.jsp； ">查看 @ /coursespace/selCourseTotal/selCourseTotal/schoolSelCourseAjax.jsp |
| /coursespace/checkon/checkOnMainView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId, checkMainId, date | &curCourseId=&date=" title="查看"> @ /coursespace/checkon/mainList/topicListAjax.jsp |
| /coursespace/checkon/checkOnMainView/list.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：checkMainId |  | checkMainId |  |
| /coursespace/checkon/checkOnMainViewEdit.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId, checkMainId, date | &curCourseId=&date=" title="修改" class="a_green"> @ /coursespace/checkon/mainList/topicListAjax.jsp |
| /coursespace/checkon/checkStudentTotalList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId |  |
| /coursespace/checkon/mainList/topicListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curCourseId, pageSize |  | curCourseId, pageSize |  |
| /coursespace/checkon/myCheckOn.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId |  |
| /coursespace/checkon/myCheckOn/myCheckOnAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curCourseId |  | curCourseId |  |
| /coursespace/common/courseInfo.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curCourseId, asHead, hide, REF_ON |  | curCourseId, asHead, hide, REF_ON |  |
| /coursespace/courseTopic/addTopic_.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId |  |
| /coursespace/courseTopic/addTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId |  |
| /coursespace/courseTopic/ajax/topicListDiscussAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：topicId, curCourseId, pageSize |  | topicId, curCourseId, pageSize |  |
| /coursespace/courseTopic/courseTopicSpace.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId | 学习广场 @ /coursespace/common/courseInfo.jsp； 学习广场 @ /coursespace/courseTopic/courseTopicSpace/list.jsp； 学习广场 @ /coursespace/courseTopic/courseTopicView.jsp |
| /coursespace/courseTopic/courseTopicSpace/authList.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 从首页空间卡片、班级/教学/社团列表点击进入；通常要带空间 ID |  |  |  |
| /coursespace/courseTopic/courseTopicSpace/list.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：curCourseId, pageSize, curPage |  | curCourseId, pageSize, curPage |  |
| /coursespace/courseTopic/courseTopicSpace/twoDiscussList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：topicId, curCourseId |  | topicId, curCourseId |  |
| /coursespace/courseTopic/courseTopicView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId, topicId | @ /coursespace/courseTopic/courseTopicSpace/list.jsp；  @ /coursespace/mainPage/index/topicListAjax.jsp； &curCourseId="> @ /space/common/jsp/space-left-course.jsp |
| /coursespace/courseTopic/editTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId, topicId |  |
| /coursespace/giveMark/giveMarkList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId |  |
| /coursespace/giveMark/giveMarkListView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId |  |
| /coursespace/giveMark/jwGiveMarkList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-xuanx-total | top-active=dept; dept-id=jiaow; dept-left=jiaow-xuanx-total | curCourseId | 评价 @ /department/jiaow/selcourse/course/list.jsp |
| /coursespace/giveMark/mainList/topicListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：courseId |  | courseId |  |
| /coursespace/giveMark/mainListView/topicListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curCourseId |  | curCourseId |  |
| /coursespace/group/ajax/studentLeaderSelect.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：id, groupId |  | id, groupId |  |
| /coursespace/group/ajax/studentSelect.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：id, groupId |  | id, groupId |  |
| /coursespace/group/classesSelStudent.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId | 学生增减 @ /coursespace/group/classesStudentAllList.jsp |
| /coursespace/group/classesStudentAllList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId |  |
| /coursespace/group/classesStudentManager.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId | 分组设置 @ /coursespace/group/classesStudentAllList.jsp |
| /coursespace/group/classesStudentPhoto.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId | 学生照片查看 @ /coursespace/group/classesStudentAllList.jsp |
| /coursespace/homework/addHomework.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId |  |
| /coursespace/homework/ajax/HomeWorkGroupListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：workId, curCourseId, pageSize |  | workId, curCourseId, pageSize |  |
| /coursespace/homework/ajax/HomeWorkListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curCourseId, workId, pageSize |  | curCourseId, workId, pageSize |  |
| /coursespace/homework/ajax/mainListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curCourseId, pageSize, curPage |  | curCourseId, pageSize, curPage |  |
| /coursespace/homework/ajax/MyHomeWorkListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curCourseId |  | curCourseId |  |
| /coursespace/homework/ajax/topicListDiscussAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：replayId |  | replayId |  |
| /coursespace/homework/ajax/topicListDiscussGroupAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：replayId |  | replayId |  |
| /coursespace/homework/ajax/topicListTwoDiscussAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：topicId |  | topicId |  |
| /coursespace/homework/editHomework.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId, homeWorkId | @ /coursespace/homework/ajax/mainListAjax.jsp；  @ /coursespace/homework/homeWorkView.jsp |
| /coursespace/homework/HomeWorkSpace.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId | 作业专区 @ /coursespace/common/courseInfo.jsp； 作业专区 @ /coursespace/homework/ajax/mainListAjax.jsp； 作业专区 @ /coursespace/homework/homeWorkView.jsp |
| /coursespace/homework/homeWorkView.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 course -> 左侧 对应菜单 | top-active=course | homeWorkId, curCourseId | @ /coursespace/homework/ajax/mainListAjax.jsp； &curCourseId="> @ /coursespace/homework/ajax/MyHomeWorkListAjax.jsp；  @ /coursespace/mainPage/index/topicListAjax.jsp |
| /coursespace/homework/MyHomeWork.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId |  |
| /coursespace/inc/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li |  | li |  |
| /coursespace/inc/coursespace_top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：TOP_SELCOURSE_ID |  | TOP_SELCOURSE_ID |  |
| /coursespace/mainPage/index.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId | " title=""> @ /coursespace/common/courseInfo.jsp； 首页 @ /coursespace/common/courseInfo.jsp； {{el.NAME}} @ /coursespace/selCourseTotal/mySelCourse.jsp |
| /coursespace/mainPage/index/topicListAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curCourseId, pageSize, curPage |  | curCourseId, pageSize, curPage |  |
| /coursespace/mainPage/index/topicListTwoDiscussAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：topicId |  | topicId |  |
| /coursespace/mainPage/index/twoDiscussList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：topicId, curCourseId |  | topicId, curCourseId |  |
| /coursespace/mainPage/index1.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId |  |
| /coursespace/managerStudent/ajax/studentLeaderSelect.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：id, groupId |  | id, groupId |  |
| /coursespace/managerStudent/ajax/studentSelect.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：id, groupId |  | id, groupId |  |
| /coursespace/managerStudent/classesStudentAllList.jsp | Insert title here | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：id |  | id |  |
| /coursespace/managerStudent/classesStudentManager.jsp | Insert title here | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：id |  | id |  |
| /coursespace/selCourseTotal/myCourseScore.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId |  |
| /coursespace/selCourseTotal/myCourseScore/myCourseScoreAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：courseId |  | courseId |  |
| /coursespace/selCourseTotal/myCourseScore/myCourseTermSum.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：courseId |  | courseId |  |
| /coursespace/selCourseTotal/mySelCourse.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | classId, termId | @ /coursespace/selCourseTotal/schoolSelCourse.jsp |
| /coursespace/selCourseTotal/mySelCourse/mySelCourseAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：termId, typeId, categoryId |  | termId, typeId, categoryId |  |
| /coursespace/selCourseTotal/schoolSelCourse.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | classId, termId | @ /coursespace/common/courseInfo.jsp； 全校空间 @ /coursespace/selCourseTotal/mySelCourse.jsp |
| /coursespace/selCourseTotal/schoolSelCourse/schoolSelCourseAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：termId, typeId, categoryId |  | termId, typeId, categoryId |  |
| /coursespace/selCourseTotal/selCourseTotal.jsp | 选修课程 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 course -> 左侧 对应菜单 | top-active=course |  |  |
| /coursespace/selCourseTotal/selCourseTotal/schoolSelCourseAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：termId |  | termId |  |
| /coursespace/spacepic/space_pic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId |  |
| /coursespace/spTopic/addTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId, topicId | 分享 @ /coursespace/spTopic/nav.jsp |
| /coursespace/spTopic/editTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 course -> 左侧 对应菜单 | top-active=course | curCourseId, topicId |  |
| /coursespace/spTopic/nav.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：curCourseId, SELECTED_ON, REF_ON, hide, permission |  | curCourseId, SELECTED_ON, REF_ON, hide, permission |  |
| /coursespace/spTopic/showTopic.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 class -> 左侧 对应菜单 | top-active=class | curCourseId, topicId |  |
| /coursespace/spTopic/top-info.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：curCourseId |  | curCourseId |  |

### 数字中枢（10）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /digitalHub/a.html | Title | 数字中枢：可直链静态壳，但真实数据通常需要 school_id 等上下文 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /digitalHub/bjzhpb-daily.html | 绿蜻蜓智能数字中枢-班级综合评比 | 数字中枢：可直链静态壳，但真实数据通常需要 school_id 等上下文 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /digitalHub/bjzhpb.html | 绿蜻蜓智能数字中枢-班级综合评比 | 数字中枢：可直链静态壳，但真实数据通常需要 school_id 等上下文 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /digitalHub/index.html | 绿蜻蜓智能数字中枢 | 数字中枢：可直链静态壳，但真实数据通常需要 school_id 等上下文 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /digitalHub/indexTest.html | 绿蜻蜓智能数字中枢 | 数字中枢：可直链静态壳，但真实数据通常需要 school_id 等上下文 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /digitalHub/mainindex.html | 绿蜻蜓智能数字中枢 | 数字中枢：可直链静态壳，但真实数据通常需要 school_id 等上下文 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /digitalHub/model.html | 绿蜻蜓智能数字中枢-学生综合评价 | 数字中枢：可直链静态壳，但真实数据通常需要 school_id 等上下文 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /digitalHub/xszhpj/xszhpj.html | 绿蜻蜓智能数字中枢-学生综合评价 | 数字中枢：可直链静态壳，但真实数据通常需要 school_id 等上下文 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /digitalHub/xxdt.html | 绿蜻蜓智能数字中枢-学生综合评价 | 数字中枢：可直链静态壳，但真实数据通常需要 school_id 等上下文 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /digitalHub/xxdtTest.html | 绿蜻蜓智能数字中枢-学生综合评价 | 数字中枢：可直链静态壳，但真实数据通常需要 school_id 等上下文 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### H5（36）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /h5/app/api.jsp | H5相关接口说明 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/app/common/appCheckLogin.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：token |  | token |  |
| /h5/app/common/appCheckLogin1.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：token |  | token |  |
| /h5/app/common/appCheckLoginAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：token |  | token |  |
| /h5/app/error/404.jsp | 页面404错误 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/app/error/500.jsp | 页面500错误 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/app/error/img/404.jsp | 页面404错误 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/app/login.jsp | 登录测试 | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：username, password |  | username, password |  |
| /h5/app/public/font/icon-demo.html | icon Regular Specimen | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/app/views/ajax/commentAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：initTime, pageNum, noticeId |  | initTime, pageNum, noticeId |  |
| /h5/app/views/ajax/homeworkAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：type, initTime, pageNum, updateTime |  | type, initTime, pageNum, updateTime |  |
| /h5/app/views/ajax/noticeAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：type, initTime, pageNum, updateTime |  | type, initTime, pageNum, updateTime |  |
| /h5/app/views/ajax/resultsAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：type, pageNum, updateTime |  | type, pageNum, updateTime |  |
| /h5/app/views/homework_bak.jsp | 作业 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/app/views/homework-complete.html | 作业-已完成 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/app/views/homework-complete.jsp | 作业-已完成 | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：homeworkId |  | homeworkId |  |
| /h5/app/views/homework-detail-begin.jsp | 作业 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/app/views/homework-detail.html | 作业 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/app/views/homework-detail.jsp | 作业 | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：homeworkId |  | homeworkId |  |
| /h5/app/views/homework.html | 作业 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/app/views/homework.jsp | 作业 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 作业 @ /h5/app/login.jsp |
| /h5/app/views/notice-detail.html | 通知详情 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 开学大检查 总务处 @ /h5/app/views/notice.html； 关于开展文明卫生办公室关于开展文明卫生办公室 教学处 @ /h5/app/views/notice.html |
| /h5/app/views/notice-detail.jsp | 通知详情 | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：noticeId |  | noticeId | "> &#x0029; @ /h5/app/views/notice.jsp； "> @ /h5/app/views/notice.jsp |
| /h5/app/views/notice.html | 通知 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/app/views/notice.jsp | 通知 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 通知 @ /h5/app/login.jsp |
| /h5/app/views/post/commentPost.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：noticeId, content |  | noticeId, content |  |
| /h5/app/views/post/homeworkPost.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：id, answer |  | id, answer |  |
| /h5/app/views/results-detail.html | 成绩分析 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 2015学年第1学期 联合考试 @ /h5/app/views/results.html； 2014学年第1学期 期末考试 @ /h5/app/views/results.html |
| /h5/app/views/results-detail.jsp | 成绩分析 | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：resultsId |  | resultsId | &#x002a; @ /h5/app/views/results.jsp；  @ /h5/app/views/results.jsp |
| /h5/app/views/results.html | 成绩 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/app/views/results.jsp | 成绩 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 成绩 @ /h5/app/login.jsp |
| /h5/app/views/test.html | 本地缓存 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/complete.jsp | 联系绿蜻蜓 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/contactDetail.jsp | 联系绿蜻蜓 | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：id |  | id |  |
| /h5/exchangeMachineContact.jsp | 联系绿蜻蜓 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /h5/kbInfo.jsp | 调代课提示 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### 微信端（116）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /weixin/api.html | H5相关接口说明 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/authLogin.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：schoolId |  | schoolId |  |
| /weixin/common/checkLogin.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/common/checkLoginAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/digitalBaseAuthH5.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：code, orgCode |  | code, orgCode |  |
| /weixin/error/500.html | 服务器访问出错 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/error/login_error.html | 账号登录错误 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/error/login_info.html | 绿蜻蜓云校园 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/error/notFound.html | 找不到指定内容 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/error/sessionFail.html | 会话失效 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/examen.html | 实验东校测试 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/login.jsp | 登录测试 | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：username, password, appId, pwd |  | username, password, appId, pwd |  |
| /weixin/loginEx.jsp | 绿蜻蜓云校园 | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：username, password, appId, pwd |  | username, password, appId, pwd |  |
| /weixin/service/ajax/cardInfoAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/service/ajax/commentAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：initTime, pageNum, noticeId |  | initTime, pageNum, noticeId |  |
| /weixin/service/ajax/homeworkAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：page |  | page |  |
| /weixin/service/ajax/likecommentAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/service/ajax/noticeAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：page |  | page |  |
| /weixin/service/ajax/qa/infoAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：qid |  | qid |  |
| /weixin/service/ajax/qa/listAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：status, listType, page |  | status, listType, page |  |
| /weixin/service/ajax/repair/infoAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：repairId, listType |  | repairId, listType |  |
| /weixin/service/ajax/repair/listAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：status, listType, page |  | status, listType, page |  |
| /weixin/service/ajax/resultsAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：page |  | page |  |
| /weixin/service/ajax/spaceAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/service/ajax/spaceDetailAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：page |  | page |  |
| /weixin/service/ajax/spaceTopicAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：page |  | page |  |
| /weixin/service/ajax/user/infoAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/service/ajax/vote/infoAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：voteId |  | voteId |  |
| /weixin/service/ajax/vote/listAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：status, listType, page |  | status, listType, page |  |
| /weixin/service/pay/unifiedorder_hua2.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/service/post/commentPost.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：noticeId, content |  | noticeId, content |  |
| /weixin/service/post/homeworkPost.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：id, answer |  | id, answer |  |
| /weixin/service/post/likePost.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/service/post/qaPost.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：qid, answer |  | qid, answer |  |
| /weixin/service/post/repair/accept.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：repairId |  | repairId |  |
| /weixin/service/post/repair/add.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：content, place, phone, imgs |  | content, place, phone, imgs |  |
| /weixin/service/post/repair/comment.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：repairId, content, imgs |  | repairId, content, imgs |  |
| /weixin/service/post/repair/finish.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：repairId |  | repairId |  |
| /weixin/service/post/repair/score.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：repairId, score |  | repairId, score |  |
| /weixin/service/post/topicCommentPost.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/service/post/topicPost.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：SPACE_ID, CONTENT, IMG_LIST |  | SPACE_ID, CONTENT, IMG_LIST |  |
| /weixin/service/post/votePost.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：voteId, answer |  | voteId, answer |  |
| /weixin/testSession.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/toLogin.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：token, userId, t, msgToken |  | token, userId, t, msgToken |  |
| /weixin/wechat/dist/index.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：url |  | url |  |
| /weixin/wechat/fileview/go_page.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | &fileName=">预览 @ /weixin/wechat/views/homework/homework-complete.jsp； &fileName=">预览 @ /weixin/wechat/views/homework/homework-detail.jsp； 预览 @ /weixin/wechat/views/homework/homework-view.jsp |
| /weixin/wechat/fileview/pdf/viewer.html | PDF.js viewer | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/fileview/pdf1/viewer.html | PDF.js viewer | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/msgGoPage_.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：msgToken |  | msgToken |  |
| /weixin/wechat/msgGoPage.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：msgToken |  | msgToken |  |
| /weixin/wechat/msgHelps.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：token, sign |  | token, sign |  |
| /weixin/wechat/public/font/icon-demo.html | icon Regular Specimen | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/public/js/msgHelps.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：objectId, objectName |  | objectId, objectName |  |
| /weixin/wechat/v2/index.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：url |  | url |  |
| /weixin/wechat/views/card/info.html | 一卡通 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/card/info.jsp | 一卡通明细 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/card/pay.jsp | 一卡通充值 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 充值 @ /weixin/wechat/views/card/info.html； 返回一卡通 @ /weixin/wechat/views/card/info.jsp； 返回 @ /weixin/wechat/views/card/info.jsp |
| /weixin/wechat/views/card/test.jsp | 测试编码 | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：wxpayBody |  | wxpayBody |  |
| /weixin/wechat/views/class/detail.html | 详情 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/class/detail.jsp | 详情 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/class/home-detail.html | 全校教学动态 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/class/home-detail.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/class/home.html | 专项空间 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/class/home.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 返回空间 @ /weixin/wechat/views/class/home-detail.jsp |
| /weixin/wechat/views/class/no-power.jsp |  | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/homework/homework-backshow.jsp | 作业- | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/homework/homework-complete.html | 作业-已完成 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/homework/homework-complete.jsp | 作业-已完成 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/homework/homework-detail-begin.jsp | 作业 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/homework/homework-detail.html | 作业 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/homework/homework-detail.jsp | 作业 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/homework/homework-view.jsp | 作业 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/homework/index.html | 作业 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 返回作业 @ /weixin/wechat/views/homework/homework-complete.jsp； 返回作业 @ /weixin/wechat/views/homework/homework-detail.jsp； 作业 @ /weixin/wechat/views/profile/profile.html |
| /weixin/wechat/views/notice/notice-detail_1.jsp | 通知详情 | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：par |  | par |  |
| /weixin/wechat/views/notice/notice-detail_bak.html | 通知详情 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/notice/notice-detail.html | 通知详情 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/notice/notice-detail.jsp | 通知详情 | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：par |  | par |  |
| /weixin/wechat/views/profile/profile.html | 个人中心 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 我的 @ /weixin/wechat/views/profile/profile.html |
| /weixin/wechat/views/profile/profile.jsp | 个人中心 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 我的 @ /weixin/wechat/views/profile/profile.jsp； 我的 @ /weixin/wechat/views/school/home.html |
| /weixin/wechat/views/profile/qa_detail.html | 问卷详情 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/profile/qa_detail.jsp | 问卷详情 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/profile/qa_list.html | 问卷列表 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 问卷 @ /weixin/wechat/views/profile/profile.html； 问卷 @ /weixin/wechat/views/profile/profile.jsp； 返回问卷列表 @ /weixin/wechat/views/profile/qa_detail.html |
| /weixin/wechat/views/profile/qa_result.html | 问卷详情 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/profile/qa_result.jsp | 问卷详情 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/profile/repair_detail.html | 报修详情 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/profile/repair_detail.jsp | 报修详情 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/profile/repair_form.html | 提交报修 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 我要报修 @ /weixin/wechat/views/profile/repair_list.html |
| /weixin/wechat/views/profile/repair_form.jsp | 提交报修 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 我要报修 @ /weixin/wechat/views/profile/repair_list.jsp |
| /weixin/wechat/views/profile/repair_list.html | 报修列表 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 报修 @ /weixin/wechat/views/profile/profile.html； 成绩 @ /weixin/wechat/views/profile/profile.html； 报修处理 @ /weixin/wechat/views/profile/profile.html |
| /weixin/wechat/views/profile/repair_list.jsp | 报修列表 | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：listType |  | listType | 报修 @ /weixin/wechat/views/profile/profile.jsp； 报修处理 @ /weixin/wechat/views/profile/profile.jsp； 返回 @ /weixin/wechat/views/profile/repair_detail.jsp |
| /weixin/wechat/views/profile/vote_detail.html | 投票详情 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/profile/vote_detail.jsp | 投票详情 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/profile/vote_list.html | 投票列表 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 投票 @ /weixin/wechat/views/profile/profile.html； 投票 @ /weixin/wechat/views/profile/profile.jsp； 返回投票列表 @ /weixin/wechat/views/profile/vote_detail.html |
| /weixin/wechat/views/profile/vote_result.html | 投票结果 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/profile/vote_result.jsp | 投票结果 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/publish/publish.html | 发布 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/publish/publish.jsp | 发布 | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：type |  | type |  |
| /weixin/wechat/views/publish/video1.1/new.html |  | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | demo1 @ /weixin/login.jsp |
| /weixin/wechat/views/publish/video1.2/new.html |  | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | demo2 @ /weixin/login.jsp |
| /weixin/wechat/views/publish/video1.3/android.html |  | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | demo3安卓 @ /weixin/login.jsp |
| /weixin/wechat/views/publish/video1.3/ios.html |  | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | demo3苹果 @ /weixin/login.jsp |
| /weixin/wechat/views/results/index.html | 成绩 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 成绩 @ /weixin/wechat/views/profile/profile.jsp； 返回成绩 @ /weixin/wechat/views/results/results-detail-new.html； 返回成绩 @ /weixin/wechat/views/results/results-detail-new.jsp |
| /weixin/wechat/views/results/results-detail-new.html | 成绩分析 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/results/results-detail-new.jsp | 成绩分析 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | @ /weixin/wechat/views/results/results-detail-new.jsp |
| /weixin/wechat/views/results/results-detail.html | 成绩分析 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/results/results-detail.jsp | 成绩分析 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/results/results-easy.html | 成绩分析 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/results/results-easy.jsp | 成绩分析 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/results/test-detail.jsp | 成绩 | 移动端/H5：按移动端路由或微信入口访问 | 先打开上级列表/查询页，再点击记录进入；参数：resultsName |  | resultsName |  |
| /weixin/wechat/views/school/home.html | 首页 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 返回 @ /weixin/wechat/views/class/home.html； 返回 @ /weixin/wechat/views/class/home.jsp； 返回 @ /weixin/wechat/views/class/no-power.jsp |
| /weixin/wechat/views/school/home.jsp | 首页 | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/views/test/t1.jsp | html5 capture test | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/wechat/dist/index.html |  | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/wechat/dist/static/img_editor_iframe/editor.html | Document | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/wechat/dist/static/img_editor_iframe/index.html | 2. Mobile | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /weixin/wechat/wechat/v2/index.html |  | 移动端/H5：按移动端路由或微信入口访问 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### 公共框架/片段（46）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /inc/admin/check-login-ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/admin/check-login.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/common/check-login-ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/common/check-login.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/common/lqt-modal.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：modalId |  | modalId |  |
| /inc/common/lqt-msg.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/error/404.jsp | 页面404错误 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/error/500.jsp | 页面500错误 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/error/502.html | 页面502错误 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/error/502.jsp | 页面502错误 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/error/504.html | 页面504错误 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/error/504.jsp | 页面504错误 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/error/limit.jsp | 限流页面 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：url |  | url |  |
| /inc/error/nonFunc.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id= |  |  |
| /inc/foot.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/head.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/headXhedit.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/left.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：left-active |  | left-active |  |
| /inc/page-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：active, schoolName |  | active, schoolName |  |
| /inc/page/body-left_bak.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/page/body-left.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/page/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/page/cloud/head.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/page/Copy of neck.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/page/courseDetail.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/page/courseTeacherDetail.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/page/courseTeacherView.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：courseDetailId |  | courseDetailId |  |
| /inc/page/courseView.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：courseDetailId |  | courseDetailId |  |
| /inc/page/foot.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/page/head.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：schoolName, dept-id, top-active, dept-left, dept-right |  | schoolName, dept-id, top-active, dept-left, dept-right |  |
| /inc/page/neck.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/page/org_head.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：schoolName, org-dept-id, top-active, dept-left, dept-right |  | schoolName, org-dept-id, top-active, dept-left, dept-right |  |
| /inc/page/org_neck.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：is-index |  | is-index |  |
| /inc/page/org-body-left.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/page/stu/body-left.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/page/stu/foot.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/page/stu/head.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：schoolName, top-active, dept-left |  | schoolName, top-active, dept-left |  |
| /inc/page/stu/neck.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/page/teacher/body-left.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/page/teacher/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li |  | li |  |
| /inc/page/teacherView.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：courseDetailId |  | courseDetailId |  |
| /inc/page/toIndex.jsp |  | 部门/集团入口：用于设置上下文后跳转 | 从顶部“我的部门/集团”或部门条点击进入，用于写入会话上下文 |  | DEPT, DEPT_NAME |  |
| /inc/page/toMyDept.jsp |  | 部门/集团入口：用于设置上下文后跳转 | 运行时 教师首页 top -> 我的部门 |  | DEPT | 我的部门 @ /teacher/tea-index.jsp； 我的部门 @ /school/grade/classView.jsp； 我的部门 @ /department/mycourse/myselcourse/list.jsp |
| /inc/page/toOrgDeptIndex.jsp |  | 部门/集团入口：用于设置上下文后跳转 | 源码菜单 /inc/page/head.jsp -> 集团 |  |  | 集团 @ /inc/page/head.jsp； 集团 @ /inc/page/org_head.jsp |
| /inc/tab.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /inc/top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### 公共组件/片段（42）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /common/ajax/lqtCityAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：curCity |  | curCity |  |
| /common/comment/ajax_old/commentAllList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, p_lock, p_del_flag |  | p_id, p_obj, p_lock, p_del_flag |  |
| /common/comment/ajax_old/commentListWithPageList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, pageSize, p_lock, p_del_flag |  | p_id, p_obj, pageSize, p_lock, p_del_flag |  |
| /common/comment/ajax_old/commentListWithPageMain.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, p_del_flag |  | p_id, p_obj, p_del_flag |  |
| /common/comment/ajax_old/commentNewTwo.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, p_lock, p_del_flag |  | p_id, p_obj, p_lock, p_del_flag |  |
| /common/comment/ajax/commentAllList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, auth_type, auth_code, user_type, isObjUsr, isObjMgr, p_lock, p_del_flag, OBJECT_ID, permission |  | p_id, p_obj, auth_type, auth_code, user_type, isObjUsr, isObjMgr, p_lock, p_del_flag, OBJECT_ID, permission |  |
| /common/comment/ajax/commentListWithPageList_notice.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, inc_clp_p_id, p_obj, inc_clp_p_obj, pageSize, p_del_flag, inc_clp_p_del_flag, p_lock, inc_clp_p_lock |  | p_id, inc_clp_p_id, p_obj, inc_clp_p_obj, pageSize, p_del_flag, inc_clp_p_del_flag, p_lock, inc_clp_p_lock |  |
| /common/comment/ajax/commentListWithPageList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, inc_clp_p_id, p_obj, inc_clp_p_obj, auth_type, auth_code, user_type, isObjUsr, isObjMgr, pageSize, p_del_flag, inc_clp_p_del_flag |  | p_id, inc_clp_p_id, p_obj, inc_clp_p_obj, auth_type, auth_code, user_type, isObjUsr, isObjMgr, pageSize, p_del_flag, inc_clp_p_del_flag |  |
| /common/comment/ajax/commentListWithPageMain_notice.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, p_lock, p_del_flag |  | p_id, p_obj, p_lock, p_del_flag |  |
| /common/comment/ajax/commentListWithPageMain.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, p_lock, p_del_flag, auth_type, auth_code, user_type, isObjUsr, isObjMgr, permission |  | p_id, p_obj, p_lock, p_del_flag, auth_type, auth_code, user_type, isObjUsr, isObjMgr, permission |  |
| /common/comment/ajax/commentNewTwo.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, auth_type, auth_code, user_type, isObjUsr, isObjMgr, p_lock, p_del_flag, OBJECT_ID, permission |  | p_id, p_obj, auth_type, auth_code, user_type, isObjUsr, isObjMgr, p_lock, p_del_flag, OBJECT_ID, permission |  |
| /common/comment/comment.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, permission, p_lock, f_show, p_zan_show, p_reply_type, p_show_point, p_del_flag, auth_type, auth_code, user_type |  | p_id, p_obj, permission, p_lock, f_show, p_zan_show, p_reply_type, p_show_point, p_del_flag, auth_type, auth_code, user_type |  |
| /common/comment/commentWihtZan.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：p_id, p_obj, p_lock, p_reply_type |  | p_id, p_obj, p_lock, p_reply_type |  |
| /common/comment/commentWithOa.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /common/comment/test.jsp | Insert title here | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /common/expexcel.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：MAXRECORDS, EXCEL_FILENAME |  | MAXRECORDS, EXCEL_FILENAME |  |
| /common/fileview/go_page.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 预览 @ /department/jiaow/selcourse/inc/edit/courseArea.jsp； 预览 @ /department/org/notice/viewNotice.jsp； 预览 @ /oa/collect/collectHander.jsp |
| /common/fileview/office.jsp | 绿蜻蜓·在线预览 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /common/js/grade_class.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：schoolId, allGrade, modelName, noClass, _term_code |  | schoolId, allGrade, modelName, noClass, _term_code |  |
| /common/selector/class.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /common/selector/classSelByTerm.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /common/selector/detail.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 顶部 dept -> 左侧 jiaow-kec-zongh | top-active=dept; dept-id=jiaow; dept-left=jiaow-kec-zongh |  |  |
| /common/selector/emoji_test.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /common/selector/emoji.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /common/selector/org_teacher.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：multiSelect, org_id |  | multiSelect, org_id |  |
| /common/selector/parent_tree.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：multiSelect, idEncode |  | multiSelect, idEncode |  |
| /common/selector/parent.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：multiSelect, idEncode |  | multiSelect, idEncode |  |
| /common/selector/scope_tree_gc.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /common/selector/scope_tree_grade.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /common/selector/scope_tree_iframe_ts_limit.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：title, type, groups, ids, INDEX, need_init |  | title, type, groups, ids, INDEX, need_init |  |
| /common/selector/scope_tree_iframe_ts_open.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：title, type, groups, ids, INDEX, need_init |  | title, type, groups, ids, INDEX, need_init |  |
| /common/selector/scope_tree_iframe.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：title, type, groups, ids, need_init |  | title, type, groups, ids, need_init |  |
| /common/selector/scope_tree.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /common/selector/student_gc.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：multiSelect, idEncode, term_code |  | multiSelect, idEncode, term_code |  |
| /common/selector/student_term.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：multiSelect, idEncode, term_code |  | multiSelect, idEncode, term_code |  |
| /common/selector/student.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：multiSelect, idEncode |  | multiSelect, idEncode |  |
| /common/selector/teacher.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：multiSelect |  | multiSelect |  |
| /common/upload/ajax/attFileList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：object_id, object_type |  | object_id, object_type |  |
| /common/upload/avater_upload.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：url, width, height, file_size, student_id |  | url, width, height, file_size, student_id |  |
| /common/upload/test.jsp | Insert title here | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /common/upload/upload.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：object_type, object_id |  | object_type, object_id |  |
| /common/yzm/checkYZM.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：YZM, FORM |  | YZM, FORM |  |

### 基础模板（2）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /base.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /ebase.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### 导出脚本（19）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /export/index.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /export/script/examenStat.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：examenId |  | examenId |  |
| /export/script/export_sel_class.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：head, openParam, type, grade, openName, termName, gradeName |  | head, openParam, type, grade, openName, termName, gradeName |  |
| /export/script/exportDeptExamen.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：start, end |  | start, end |  |
| /export/script/exportHonorDetail.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：term |  | term |  |
| /export/script/exportRemainJF.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /export/script/exportReword.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /export/script/exportTermTsCount.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：term |  | term |  |
| /export/script/exportVote.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：voteId |  | voteId |  |
| /export/script/exportZhItemDetail.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：time |  | time |  |
| /export/script/exportZhpjReport.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：id |  | id |  |
| /export/script/exportZpJf.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：term, evalId |  | term, evalId |  |
| /export/script/sel_kaoqin.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：term, courseId, openIndex, openName |  | term, courseId, openIndex, openName |  |
| /export/script/ts_record_dn.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：term |  | term |  |
| /export/script/ts_space_pic_dn.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：term |  | term |  |
| /export/script/ts_stu_pdf_dn.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：term |  | term |  |
| /export/script/tsOpenTeacherList.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：openParam |  | openParam |  |
| /export/script/tsRecord.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：term, ids, file |  | term, ids, file |  |
| /export/script/tsTeacherList.jsp |  | 导出脚本：通常由按钮/表单触发，不作为普通页面入口 | 先打开上级列表/查询页，再点击记录进入；参数：term, grade, file |  | term, grade, file |  |

### 修复工具（235）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /fix/check_import_stu_joinyear.jsp | 排查导入学生信息项-入学年份 | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：import_id, detail_id, value |  | import_id, detail_id, value |  |
| /fix/check_import_stu_loginname.jsp | 排查导入学生信息项-登录名 | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：import_id, detail_id, value, loginname |  | import_id, detail_id, value, loginname |  |
| /fix/compress_pic.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fix_1715.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fix_act_mbr_count.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fix_add_notice_see.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fix_album_cuturl.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fix_album_pic.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fix_class_student.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fix_import_teacher.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fix_kq_leave_funcs.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fix_kq_log.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fix_lab_file_name.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fix_qr_html.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fix_rate_deptcode.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fix_t_class_course.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fixHaData.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fixHomework.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fixJsp.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/fixMetaFile.jsp | Insert title here | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/get_token.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/init_dept_oa_funcs.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/init_term_week.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/initTeachWeek.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/addDAuth.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/addDict.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/addSchoolAuth.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/addTagGrade.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/addVenueUser.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/addVoteUser.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/albumZans.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：id |  | id |  |
| /fix/jb/cpyTsTemp.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/deleteSxExamenUser.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/examenUserList.jsp | Title | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/export_xuanxiu_examen_ans.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：examen_id |  | examen_id |  |
| /fix/jb/exportDeptExamen.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：start, end |  | start, end |  |
| /fix/jb/fixAssetsCate.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/fixAssetsDictOrder.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/fixAssetsOrder.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/fixDyWeek.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/fixFaVariety.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/fixJwcType.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/fixSpaceAdmin.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/fixTsTemp.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/importStudentIntoGroup.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/spaceStat.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：id |  | id |  |
| /fix/jb/test.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/test2.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/tsRecord.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：term, ids, file |  | term, ids, file |  |
| /fix/jb/updateStudentInfo.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/updateSydxPdf.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/updateTsTemp.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/zkAddPeople.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/jb/zkAddSchool.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/school_31854_username.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/sel_2_ts.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/set_term_student.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/space_homework_transcode.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/sync_space_user.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_1686.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_1844.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_bar_gen.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_body_left.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_clear_redis.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_consume.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_date.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_examen.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_getTempFile.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_getundoworklist.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_html.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_hua2_balance_change.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_kq_notify.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_kq_stat.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_mytasklist.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_new_school.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_open_list.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_quote_homework.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：OLDOBJECTVALUE |  | OLDOBJECTVALUE |  |
| /fix/test_red_point.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_report_status.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_save_avatar.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_sydx_report.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_t_teach_plan.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_task_service.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_transcode.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_ts_service.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_view_notice.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test_zip.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/add_notice_user.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/add_single_notice_user.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/barcode/test_generate_barcode_v2.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/barcode/test.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/barcode/test2.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/barcode/test3.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/del_school.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/dy_rate/test2.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/get_file_path.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/get_stu_data.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/get_sync_consume_his.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：page_index |  | page_index |  |
| /fix/test/init_holiday.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/kq/class_kq_view.jsp | Title | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/kq/m_queue.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/kq/m_test_notify.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/open_ids.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/preview.jsp | 绿蜻蜓云校园 | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/t_kq_leave_days_fix.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_avatar_barcode.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_check_leave_days.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_edit_examen.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_fix_rate_teachweek.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_kq_job.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_method_save_class_kq_conflict.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_npe.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_npe2.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_oneDayRecord.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_pwd.jsp | Insert title here | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_query_db.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_render_kq_list_v2.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_repair_date.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_search.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_sort.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_start_term.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_stat_class_space_tag.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_stu_kq.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_stu_list.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_term_list.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_vue3_component.jsp | JSP + Vue 3 + Element UI | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_vue3.jsp | Vue 3 + Element UI Integration | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/test_zh_report.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/ts_youhua.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/zh_score/dn_zh_code_type_mult_thread_huajiang_v2.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：school_id, eval_id, detail_ids, op_date |  | school_id, eval_id, detail_ids, op_date |  |
| /fix/test/zh_score/dn_zh_code_type_mult_thread_huajiang_v3.jsp | 二维码批量导出 v3 | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：school_id, eval_id, detail_ids, start_date, end_date, action, thread_count, regen |  | school_id, eval_id, detail_ids, start_date, end_date, action, thread_count, regen |  |
| /fix/test/zh_score/dn_zh_code_type_mult_thread_huajiang.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：eval_id, op_date |  | eval_id, op_date |  |
| /fix/test/zh_score/dn_zh_code_type_mult_thread.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：eval_id, type_id, detail_id |  | eval_id, type_id, detail_id |  |
| /fix/test/zh_score/dn_zh_code_type_v1.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：type_id |  | type_id |  |
| /fix/test/zh_score/eval_honor.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/zh_score/stat_stu_honor.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/zh_score/test_exchange.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/zh_score/test_singe_pdf2jpeg.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/zh_score/total_honor.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/zh_score/type_score.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/zip/test_zip_v2.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/test/zip/test_zip.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/add_class_kq.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/add_first_char.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/add_kq_year.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/add_leave_kq_op.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/add_report_queue.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/add_sydx_report.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/bar_code_info.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：id |  | id |  |
| /fix/tools/change_app_url.jsp | $Title$ | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/check_zh_score_add_abnormal.jsp | 积分加分异常排查 | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：school_id, term_code, op_id, score_userid, student_id, start_date, row_limit, only_abnormal |  | school_id, term_code, op_id, score_userid, student_id, start_date, row_limit, only_abnormal |  |
| /fix/tools/decrypt_barcode_test.jsp | Decrypt Barcode Test | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：encryptedId |  | encryptedId |  |
| /fix/tools/dk_info.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/dn_examen_pic.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/dn_lab_file_folder.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/dn_lab_file.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/dn_local_file.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/dn_student_avatar.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/dn_zh_code_type.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：type_id |  | type_id |  |
| /fix/tools/dn_zh_code.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/down_homework.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/dy_rate_week_job.jsp | 班级综评周定时器测试 | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：RUN |  | RUN |  |
| /fix/tools/dy_user_giveup.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/examen_dn_file_db.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/export_1.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：page_index |  | page_index |  |
| /fix/tools/export_examen_ans.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/export_examen_total.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/export_sel_class.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/export_sel_course_class.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/export_sel_course_good_class.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/export_vote_ans.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/export_zh_score_missing_balance_backup.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：school_id, student_id, start_date, end_date |  | school_id, student_id, start_date, end_date | &start_date=&end_date=">导出需退回学生当前余额备份Excel @ /fix/tools/view_zh_score_missing_add.jsp |
| /fix/tools/export.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/findJar.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/finish_collect.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/fix_func_term.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/fix_mult_barcode.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/fix_rate_schoolarea.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/fix_red_point.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/fix_single_barcode.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/fix_term_name.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/fix_ts_act_user.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/fix_zh_honor_icon_color_default.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：run, school_id |  | run, school_id |  |
| /fix/tools/fix_zh_honor_order_no_default.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：run, school_id |  | run, school_id |  |
| /fix/tools/gen_medal_front_samples.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：school_id, eval_id, detail_id, inline |  | school_id, eval_id, detail_id, inline |  |
| /fix/tools/get_consume_his.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：page_index |  | page_index |  |
| /fix/tools/get_stu_data.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/get_stu_term_data.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/get_zh_order.jsp | Title | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：student_id |  | student_id |  |
| /fix/tools/hua2_service.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/notice_service.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/open_list.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/pic_json_data.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/retry_weixinNotify.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/sel_kaoqin.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/show_class_noaduit_student.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：class_id, report_id |  | class_id, report_id |  |
| /fix/tools/show_status_object.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/split_ts_record.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/start_img_service.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/start_kq_service.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/start_notice_service.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/start_oss_service.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/start_pdf_service.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/start_service.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/start_spacepic_service.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/start_stat_service.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/stat_dy_report.jsp | 班级综评周汇总批量统计 | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：RUN |  | RUN |  |
| /fix/tools/stat_sydx_report_data2.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_781.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：startDate, endDate |  | startDate, endDate |  |
| /fix/tools/test_add_druid_pool.jsp | $Title$ | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_barcode_api.jsp | test barcode api | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_barcode_teacher.jsp | Insert title here | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_class_all_term.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_consume_info.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_consume_service.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_create_videopic.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_evalExchangeReturn.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_hk.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_is_work_day.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_leave_days.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_leave_dept_record_list.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_parent.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_redpointJobj.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_stat_honor.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/test_zip_is.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/ts_record_dn.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/ts_space_pic_dn.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/video_service.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/view_zh_score_del_his_check.jsp | 加分撤销积分流水统一核对 | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：school_id, term_code, op_id, row_limit, do_fix, confirm_fix |  | school_id, term_code, op_id, row_limit, do_fix, confirm_fix |  |
| /fix/tools/view_zh_score_flow.jsp | 学生积分流水排查 | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：student_id, school_id, row_limit |  | student_id, school_id, row_limit |  |
| /fix/tools/view_zh_score_missing_add.jsp | 撤销已扣但原加分未入流水排查 | 修复/测试工具：只按明确任务直链，不能随意执行 | 先打开上级列表/查询页，再点击记录进入；参数：school_id, student_id, start_date, end_date, do_fix, confirm_fix |  | school_id, student_id, start_date, end_date, do_fix, confirm_fix |  |
| /fix/tools/zh_honor_job.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/zh_job.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/tools/zh_week_job.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /fix/work_file.jsp |  | 修复/测试工具：只按明确任务直链，不能随意执行 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### 预约/场地（14）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /department/venue/ajax/myApplyVenueAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, cate, curPage |  | pageSize, cate, curPage |  |
| /department/venue/applyDetail.jsp | 预约单详情 | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部  -> 左侧 | top-active=; dept-left= | fromDept, cate, applyOpId, isMgr, from_page | 详情 @ /department/venue/myApplyVenue.jsp； 详情 @ /department/venue/venueMgr.jsp |
| /department/venue/applyVenue.jsp | 我要预约 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 user-venue | top-active=apply; dept-left=user-venue |  | 预约 @ /department/venue/myVenue.jsp |
| /department/venue/auditVenueDetail.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 affair -> 左侧 对应菜单 | top-active=affair; dept-right=user-trans |  |  |
| /department/venue/common/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li |  | li |  |
| /department/venue/frm_disable_time.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：list |  | list |  |
| /department/venue/myApplyVenue.jsp | 我已预约 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的应用 left -> 我的预约 | top-active=apply; dept-left=user-venue | CATE | 我的预约 @ /user/headupload.jsp； 我已预约 @ /department/venue/common/body-right-top.jsp； 我的预约 @ /fix/test_body_left.jsp |
| /department/venue/myVenue.jsp | 我要预约 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 user-venue | top-active=apply; dept-left=user-venue | CATE | 取消 @ /department/venue/applyVenue.jsp； 我要预约 @ /department/venue/common/body-right-top.jsp |
| /department/venue/venueCfg.jsp | 预约设置 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> venue_cfg | top-active=dept; dept-left=venue_cfg |  | 预约设置 @ /department/venue/venueCfg.jsp； 预约设置 @ /department/venue/venueStatics.jsp |
| /department/venue/venueDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 | top-active=dept; dept-right=; dept-left= | CATE | @ /department/venue/venueManager.jsp；  @ /department/zongw/vehicle/vehicleManager.jsp |
| /department/venue/venueManager.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> venue -> venue | top-active=dept; dept-right=venue; dept-left=venue | CATE |  |
| /department/venue/venueMgr.jsp | 预约管理 | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 user-venue | top-active=apply; dept-left=user-venue | ID | 预约管理 @ /department/venue/common/body-right-top.jsp |
| /department/venue/venueMultDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 venue | top-active=dept; dept-right=venue; dept-left=venue | CATE |  |
| /department/venue/venueStatics.jsp | 预约统计 | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> venue_cfg | top-active=dept; dept-left=venue_cfg |  | 预约统计 @ /department/venue/venueCfg.jsp； 预约统计 @ /department/venue/venueStatics.jsp |

### about（9）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /about/fu.html | 福利待遇 \| 绿蜻蜓云校园 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 福利待遇 @ /about/fu.html； 福利待遇 @ /about/he.html； 福利待遇 @ /about/index.html |
| /about/he.html | 合作交流 \| 绿蜻蜓云校园 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 交流合作 @ /about/fu.html； 合作交流 @ /about/he.html； 交流合作 @ /about/index.html |
| /about/importSmall.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：excelFile, examId, classId, gradeId, courseId |  | excelFile, examId, classId, gradeId, courseId |  |
| /about/index.html | 关于我们 \| 绿蜻蜓云校园 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 关于我们 @ /about/fu.html； 关于我们 @ /about/he.html； 关于我们 @ /about/index.html |
| /about/jia.html | 加入我们 \| 绿蜻蜓云校园 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 加入我们 @ /about/fu.html； 加入我们 @ /about/he.html； 加入我们 @ /about/index.html |
| /about/ming.html | 鸣谢用户 \| 绿蜻蜓云校园 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 鸣谢用户 @ /about/fu.html； 鸣谢用户 @ /about/he.html； 鸣谢用户 @ /about/index.html |
| /about/qing.html | 清亭科技 \| 绿蜻蜓云校园 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 清亭科技 @ /about/fu.html； 清亭科技 @ /about/he.html； 清亭科技 @ /about/index.html |
| /about/shi.html | 使命愿景 \| 绿蜻蜓云校园 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 使命愿景 @ /about/fu.html； 使命愿景 @ /about/he.html； 使命愿景 @ /about/index.html |
| /about/zhao.html | 招聘信息 \| 绿蜻蜓云校园 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 招聘信息 @ /about/fu.html； 招聘信息 @ /about/he.html； 招聘信息 @ /about/index.html |

### ajax（8）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /ajax/ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /ajax/ck/demo.htm | ckplayer简单调用演示 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 简单播放代码演示（已不推荐使用） @ /ajax/ck/index.htm |
| /ajax/ck/demo1.htm | ckplayer 只调用flash播放器 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 只调用Flash播放代码演示 @ /ajax/ck/index.htm |
| /ajax/ck/demo2.htm | ckplayer只调用html5播放器 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 只调用HTML5播放代码演示 @ /ajax/ck/index.htm |
| /ajax/ck/demo3.htm | ckplayer简单调用演示 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 简单播放代码演示(自行选择优先使用Flash播放器还是HTML5播放器) @ /ajax/ck/index.htm |
| /ajax/ck/help.htm | 升级文档 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 查看升级说明 @ /ajax/ck/index.htm |
| /ajax/ck/index.htm | ckplayer6.5 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /ajax/ck/index.jsp | Insert title here | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### applets（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /applets/test.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### avalonTest.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /avalonTest.jsp | Insert title here | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### base-HugePageHeadCss.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /base-HugePageHeadCss.jsp | 超大页面-头部 | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### base-uploadPic.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /base-uploadPic.jsp | Title | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：limit |  | limit |  |

### baseOAtab（8）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /baseOAtab/dataManager.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /baseOAtab/list_cal.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /baseOAtab/list.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /baseOAtab/listNotice.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /baseOAtab/listOfiice.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /baseOAtab/listPCollect.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /baseOAtab/listPExamen.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /baseOAtab/listPVote.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### builder（4）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /builder/ajax/DetailList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /builder/ajax/mainList.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage |  | pageSize, curPage |  |
| /builder/formAdd.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 class-view | top-active=class; dept-left=class-view |  | 新建表单 @ /builder/formBuilder.jsp |
| /builder/formBuilder.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 class -> 左侧 class-view | top-active=class; dept-left=class-view |  |  |

### cache（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /cache/test.jsp | 缓存测试界面 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：opr, key, val |  | opr, key, val |  |

### ck（7）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /ck/demo.htm | ckplayer简单调用演示 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 简单播放代码演示（已不推荐使用） @ /ck/index.htm |
| /ck/demo1.htm | ckplayer 只调用flash播放器 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 只调用Flash播放代码演示 @ /ck/index.htm |
| /ck/demo2.htm | ckplayer只调用html5播放器 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 只调用HTML5播放代码演示 @ /ck/index.htm |
| /ck/demo3.htm | ckplayer简单调用演示 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 简单播放代码演示(自行选择优先使用Flash播放器还是HTML5播放器) @ /ck/index.htm |
| /ck/help.htm | 升级文档 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 查看升级说明 @ /ck/index.htm |
| /ck/index.htm | ckplayer6.5 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /ck/index.jsp | Insert title here | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### cloud（33）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /cloud/account/mgrDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：SCHOOL_ID |  | SCHOOL_ID |  |
| /cloud/devopt/serviceQueue.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /cloud/exchangeMachine/message.jsp | 兑换机留言 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /cloud/func/authFunc.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SCHOOL_ID |  | SCHOOL_ID |  |
| /cloud/func/getTreeTable.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SID |  | SID |  |
| /cloud/func/setFunc.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SCHOOL_ID |  | SCHOOL_ID |  |
| /cloud/index.jsp | Insert title here | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /cloud/login.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：u, p |  | u, p |  |
| /cloud/school/addNotice.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：ID |  | ID |  |
| /cloud/school/detail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：ID |  | ID |  |
| /cloud/school/frm_kq_add_day.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：year, id |  | year, id |  |
| /cloud/school/kq_holiday_set.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /cloud/school/list.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：name |  | name |  |
| /cloud/school/listAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, name |  | pageSize, curPage, name |  |
| /cloud/school/login_upload.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：choise1 |  | choise1 |  |
| /cloud/school/loginPic-cfg.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /cloud/school/schData.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：TYPE, SCHOOL_ID, joinYear |  | TYPE, SCHOOL_ID, joinYear |  |
| /cloud/school/schDataExport.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SCHOOL_ID |  | SCHOOL_ID |  |
| /cloud/school/schOrgMgr.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /cloud/school/schOrgMgrDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：ID |  | ID |  |
| /cloud/school/set/course_list.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SCHOOL_ID |  | SCHOOL_ID | 课程排序 @ /cloud/school/set/course_list.jsp； 课程排序 @ /cloud/school/set/kq_set.jsp； 课程排序 @ /cloud/temp/setTemp.jsp |
| /cloud/school/set/kq_set.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SCHOOL_ID |  | SCHOOL_ID | 考勤开关 @ /cloud/school/set/kq_set.jsp |
| /cloud/school/setNotice.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：name |  | name |  |
| /cloud/school/showNotice.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/head.jsp -> /cloud/school/showNotice.jsp |  |  | 2024年8月23日更新公告 @ /teacher/tea-index.jsp； 2024年8月23日更新公告 @ /school/grade/classView.jsp； 2024年8月23日更新公告 @ /department/mycourse/myselcourse/list.jsp |
| /cloud/school/slowLogCfg.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：IS_SET, COST |  | IS_SET, COST |  |
| /cloud/school/slowPageList.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /cloud/school/transfer/opList.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SEARCH_KEY |  | SEARCH_KEY |  |
| /cloud/school/transfer/transferMgr.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /cloud/school/upload.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /cloud/school/view_contact_us.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：name |  | name |  |
| /cloud/ss.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /cloud/temp/setTemp.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SCHOOL_ID |  | SCHOOL_ID | 学制 @ /cloud/school/set/course_list.jsp； 学制 @ /cloud/school/set/kq_set.jsp； 学制 @ /cloud/temp/setTemp.jsp |
| /cloud/temp/setTemp1.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：SCHOOL_ID |  | SCHOOL_ID | 学制 @ /cloud/temp/setTemp1.jsp |

### del_queue_sql.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /del_queue_sql.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：ID |  | ID |  |

### digitalBaseAuth.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /digitalBaseAuth.jsp | 绿蜻蜓云校园 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：code, orgCode |  | code, orgCode |  |

### ebase-Upload.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /ebase-Upload.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### fixZhEval.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /fixZhEval.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### glyphion.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /glyphion.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### gridstack（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /gridstack/grid.jsp | 绿蜻蜓云校园 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### help（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /help/result.jsp | 绿蜻蜓云校园 \| 帮助文档 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：keyWord |  | keyWord |  |

### html（62）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /html/aboutUs.jsp | 绿蜻蜓云校园 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：type, lqtType |  | type, lqtType |  |
| /html/dy2/tableCheck.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> 左侧菜单 | top-active=dept; dept-id=jiaow; top-active=class | DEPT |  |
| /html/dy2/xieribao.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 affair -> 左侧 user-repairs | top-active=affair; dept-left=user-repairs |  |  |
| /html/dyc/bjzh/fillDetails.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/dyc/bjzh/inc/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/dyc/bjzh/index.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> 左侧菜单 | top-active=dept; dept-id=jiaow; top-active=class | DEPT |  |
| /html/dyc/bjzh/modelDetails.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/dyc/bjzh/onlineRule.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> 左侧菜单 | top-active=dept; dept-id=jiaow; top-active=class | DEPT | 评分设置 @ /html/dyc/bjzh/ruleDetails.jsp |
| /html/dyc/bjzh/ruleDetails.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> 左侧菜单 | top-active=dept; dept-id=jiaow; top-active=class | DEPT |  |
| /html/dyc/bjzh/selModel.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> 左侧菜单 | top-active=dept; dept-id=jiaow; top-active=class | DEPT |  |
| /html/dyc/bjzh/setInfo.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> 左侧菜单 | top-active=dept; dept-id=jiaow; top-active=class | DEPT |  |
| /html/dyc/bjzh/start.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> 左侧菜单 | top-active=dept; dept-id=jiaow; top-active=class | DEPT |  |
| /html/dyc/mbgl/modelDetails.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/dyc/mbgl/setProList.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> rate-temp | top-active=dept; dept-left=rate-temp | examenId |  |
| /html/dyc/mbgl/tempManage.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> 左侧菜单 | top-active=dept; dept-id=jiaow; top-active=class | DEPT | 模板管理 @ /html/dyc/mbgl/setProList.jsp |
| /html/dyc/myTask/myListTask.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 affair -> 左侧 user-repairs | top-active=affair; dept-left=user-repairs |  | 待处理 @ /html/dy2/xieribao.jsp； 待处理 @ /html/dyc/myTask/myListTask.jsp； 待处理 @ /html/dyc/myTask/myTaskFill.jsp |
| /html/dyc/myTask/myTaskFill.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 affair -> 左侧 user-repairs | top-active=affair; dept-left=user-repairs |  | 11-28 班级综合评比表（第5周） @ /html/dyc/myTask/myListTask.jsp； 11-28 班级综合评比表（第5周） @ /html/dyc/pblb/compareList.jsp |
| /html/dyc/pblb/addFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; top-active=class | DEPT |  |
| /html/dyc/pblb/compareDetails.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> 左侧菜单 | top-active=dept; dept-id=jiaow; top-active=class | DEPT |  |
| /html/dyc/pblb/compareList.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 affair -> 左侧 user-repairs | top-active=affair; dept-left=user-repairs |  | 评比表列表 @ /html/dyc/pblb/addFill.jsp； 评比表信息 @ /html/dyc/pblb/compareDetails.jsp； 评比表列表 @ /html/dyc/pblb/formCheck.jsp |
| /html/dyc/pblb/formCheck.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> 左侧菜单 | top-active=dept; dept-id=jiaow; top-active=class | DEPT |  |
| /html/dyc/pblb/planDetails.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/dyc/pblb/planFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; top-active=class | DEPT |  |
| /html/dyc/pblb/searchFill.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 dept -> 左侧 对应菜单 | top-active=dept; dept-id=jiaow; top-active=class | DEPT | 填表人方案 @ /html/dyc/pblb/addFill.jsp |
| /html/inc/footpage.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/inc/top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/joinUs.jsp | 绿蜻蜓云校园 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：type, lqtType |  | type, lqtType |  |
| /html/note/myNote.jsp | 我的日程 - | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/pageHtml/gongZi.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 顶部 apply -> 左侧 myapp-salary | top-active=apply; dept-left=myapp-salary | seaType |  |
| /html/pageHtml/list.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-kec-jic | top-active=dept; dept-id=jiaow; dept-left=jiaow-kec-jic | seaType |  |
| /html/sg/add_sg.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> calendar -> 左侧菜单 | top-active=dept; dept-right=calendar |  |  |
| /html/sg/addFloor.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> office-sch-struct | top-active=dept; dept-id=office; dept-left=office-sch-struct |  |  |
| /html/sg/anpai_sg.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> calendar -> 左侧菜单 | top-active=dept; dept-right=calendar |  |  |
| /html/sg/fuzhi_sg.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> calendar -> 左侧菜单 | top-active=dept; dept-right=calendar |  |  |
| /html/sg/liebiao_sg.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> calendar -> 左侧菜单 | top-active=dept; dept-right=calendar |  |  |
| /html/sg/set_sg.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> calendar -> 左侧菜单 | top-active=dept; dept-right=calendar |  |  |
| /html/sg/zsgl/djkaoqin.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> calendar -> 左侧菜单 | top-active=dept; dept-right=calendar |  | 考勤 @ /html/sg/zsgl/lianjie.jsp |
| /html/sg/zsgl/inc/body-right-top.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：li |  | li |  |
| /html/sg/zsgl/inc/user.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/sg/zsgl/kaoqin.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> calendar -> 左侧菜单 | top-active=dept; dept-right=calendar |  | 宿舍考勤（点击详情） @ /html/sg/zsgl/lianjie.jsp |
| /html/sg/zsgl/ldxx.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> dicts | top-active=dept; dept-id=office; dept-left=dicts |  | 住宿信息（楼栋） @ /html/sg/zsgl/lianjie.jsp |
| /html/sg/zsgl/lianjie.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> calendar -> 左侧菜单 | top-active=dept; dept-right=calendar |  |  |
| /html/sg/zsgl/ssjl.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> dicts | top-active=dept; dept-id=office; dept-left=dicts |  | 宿舍记录 @ /html/sg/zsgl/lianjie.jsp |
| /html/sg/zsgl/syjl.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> dicts | top-active=dept; dept-id=office; dept-left=dicts |  | 宿员记录 @ /html/sg/zsgl/lianjie.jsp |
| /html/sg/zsgl/zsxx.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> dicts | top-active=dept; dept-id=office; dept-left=dicts |  | 住宿信息 @ /html/sg/zsgl/lianjie.jsp |
| /html/shortMess/addMessModel.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/shortMess/messMgr.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 usercfg-headpic | top-active=apply; dept-left=usercfg-headpic |  | 发送短信 @ /html/shortMess/page/body-right-top.jsp |
| /html/shortMess/messModel.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 usercfg-headpic | top-active=apply; dept-left=usercfg-headpic |  | 短信模板 @ /html/shortMess/page/body-right-top.jsp |
| /html/shortMess/messRecord.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 usercfg-headpic | top-active=apply; dept-left=usercfg-headpic |  | 发送记录 @ /html/shortMess/page/body-right-top.jsp |
| /html/shortMess/messRecordDetails.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 usercfg-headpic | top-active=apply; dept-left=usercfg-headpic |  | @ /html/shortMess/messRecord.jsp；  @ /html/shortMess/messRecord.jsp |
| /html/shortMess/page/body-right-top.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：li |  | li |  |
| /html/shortMess/selMessAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/shortMess/selMessModel.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/term/step1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 teach -> 左侧 user-trans | top-active=teach; dept-left=user-trans |  |  |
| /html/term/step2.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 teach -> 左侧 user-trans | top-active=teach; dept-left=user-trans |  |  |
| /html/thankUser.jsp | 绿蜻蜓云校园 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：type, lqtType |  | type, lqtType |  |
| /html/wage/class.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/wage/nav.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/wage/openClass.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /html/wage/step1.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 rate-mgr | top-active=dept; dept-left=rate-mgr | ID |  |
| /html/wage/step3.jsp |  | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 顶部 dept -> 左侧 rate-mgr | top-active=dept; dept-left=rate-mgr | ID |  |
| /html/work.jsp | 绿蜻蜓云校园 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：type, lqtType |  | type, lqtType |  |

### im（9）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /im/ajax/chatHisAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize, curPage, IM_ID, CHAT_ID, TIME, CONTENT, RANGE, COUNT |  | pageSize, curPage, IM_ID, CHAT_ID, TIME, CONTENT, RANGE, COUNT |  |
| /im/chatHis.jsp | 聊天记录 | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：imId, SEA_IM_ID, SEA_TIME, SEA_CONTENT, SEA_RANGE, SEA_CHAT_ID |  | imId, SEA_IM_ID, SEA_TIME, SEA_CONTENT, SEA_RANGE, SEA_CHAT_ID |  |
| /im/debug.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /im/im.jsp | 绿蜻蜓云校园 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /im/imOne.jsp | Insert title here | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /im/inc/face.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /im/screen.jsp | 请调整浏览器窗口 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /im/toViewChatHis.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：IM_ID |  | IM_ID |  |
| /im/upload.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### kq（7）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /kq/import.jsp | Insert title here | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /kq/kqJob.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /kq/queueQuery.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：CREATE_DATE, TYPE, CARD_NO |  | CREATE_DATE, TYPE, CARD_NO |  |
| /kq/resultQuery.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：CREATE_DATE, TYPE, CARD_NO |  | CREATE_DATE, TYPE, CARD_NO |  |
| /kq/systemSet.jsp | 系统设置 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /kq/teaKq.jsp | 教师考勤 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 教师考勤统计 @ /department/dyc/kq/tea/kq_stat_list.jsp； 教师考勤统计 @ /department/dyc/kq/tea/kq_stat_view_detail.jsp； 教师考勤统计 @ /department/dyc/kq/tea/kq_stat_view.jsp |
| /kq/teaKqDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：KQ_DATE, UID, KQ_TYPE |  | KQ_DATE, UID, KQ_TYPE |  |

### kq.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /kq.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：CARD_NO, CREATE_TIME, TYPE |  | CARD_NO, CREATE_TIME, TYPE |  |

### lostpwd-app.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /lostpwd-app.jsp | 绿蜻蜓云校园 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### luna（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /luna/addpc.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> venue -> zh_score_dh | top-active=dept; dept-right=venue; dept-left=zh_score_dh | id |  |

### model（3）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /model/classHour.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-kec-jic | top-active=dept; dept-id=jiaow; dept-left=jiaow-kec-jic | seaType |  |
| /model/setHour.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /model/timeSetting.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> jiaow -> 部门页签 -> jiaow-kec-jic | top-active=dept; dept-id=jiaow; dept-left=jiaow-kec-jic | seaType | @ /model/classHour.jsp |

### old.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /old.jsp | 绿蜻蜓云校园 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### outsite（4）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /outsite/ajaxLogin.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：UNAME, UPWD, SITE |  | UNAME, UPWD, SITE |  |
| /outsite/login.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：UNAME, UPWD, SITE |  | UNAME, UPWD, SITE |  |
| /outsite/test.jsp | 外网登录接口Demo | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /outsite/testAjaxLogin.jsp | 外网登录接口Demo | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### queue.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /queue.jsp | Insert title here | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### Res（80）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /Res/glyphicons_filetypes/index.html | Glyphicons - File Types | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/glyphicons_social/index.html | Glyphicons - Social | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/glyphicons/index.html | Glyphicons | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/adGallery/ajax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/jcrop/demos/non-image.html | Non-image Cropping \| Jcrop Demo | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/jcrop/demos/styling.html | CSS Styling Example \| Jcrop Demo | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/jcrop/demos/tutorial1.html | Hello World \| Jcrop Demo | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/jcrop/demos/tutorial2.html | Basic Handler \| Jcrop Demo | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/jcrop/demos/tutorial3.html | Aspect Ratio with Preview Pane \| Jcrop Demo | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/jcrop/demos/tutorial4.html | Animations + Transitions \| Jcrop Demo | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/jcrop/demos/tutorial5.html | API Demo \| Jcrop Demo | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/lqtUI/table/avalon.lqttable.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/lqtUI/table1/avalon.lqttable.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/qrCode/index-svg.html | Cross-Browser QRCode generator for Javascript | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/qrCode/index.html | Cross-Browser QRCode generator for Javascript | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/rating/avalon.rating.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/raty/__MACOSX/._index.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/raty/index.html | jQuery Raty - A Star Rating Plugin | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/sys/func/getOrgtreeAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/sys/func/getOrgtreeC.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：CODE |  | CODE |  |
| /Res/js/sys/func/list.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/sys/org/addDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：NODE_ID, CODE |  | NODE_ID, CODE |  |
| /Res/js/sys/org/ajaxDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：CODE |  | CODE |  |
| /Res/js/sys/org/mgr.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/tableDrag/demo.jsp | My JSP 'temp.jsp' starting page | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/uploadify/test.jsp | 新上传 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/uploadify5/demo.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/xheditor-1.2.1/demos/ckfinder/ckfinder.html | CKFinder | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/xheditor-1.2.1/demos/ckfinder/plugins/flashupload/Uploader.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/xheditor-1.2.1/demos/ckfinder/upload.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/xheditor-1.2.1/demos/demo01.html | xhEditor demo1 : 默认模式 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 默认模式 @ /Res/js/xheditor-1.2.1/demos/demo01.html； 默认模式 @ /Res/js/xheditor-1.2.1/demos/demo02.html； 默认模式 @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/demos/demo02.html | xhEditor demo2 : 自定义按钮 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 自定义按钮 @ /Res/js/xheditor-1.2.1/demos/demo01.html； 自定义按钮 @ /Res/js/xheditor-1.2.1/demos/demo02.html； 自定义按钮 @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/demos/demo03.html | xhEditor demo3 : 皮肤选择 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 皮肤选择 @ /Res/js/xheditor-1.2.1/demos/demo01.html； 皮肤选择 @ /Res/js/xheditor-1.2.1/demos/demo02.html； 皮肤选择 @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/demos/demo04.html | xhEditor demo4 : 其它选项 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 其它选项 @ /Res/js/xheditor-1.2.1/demos/demo01.html； 其它选项 @ /Res/js/xheditor-1.2.1/demos/demo02.html； 其它选项 @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/demos/demo05.html | xhEditor demo5 : Javascript API交互 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | API交互 @ /Res/js/xheditor-1.2.1/demos/demo01.html； API交互 @ /Res/js/xheditor-1.2.1/demos/demo02.html； API交互 @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/demos/demo06.html | xhEditor demo6 : 非utf-8编码网页调用 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 非utf-8编码调用 @ /Res/js/xheditor-1.2.1/demos/demo01.html； 非utf-8编码调用 @ /Res/js/xheditor-1.2.1/demos/demo02.html； 非utf-8编码调用 @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/demos/demo07.html | xhEditor demo7 : UBB可视化编辑 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | UBB可视化 @ /Res/js/xheditor-1.2.1/demos/demo01.html； UBB可视化 @ /Res/js/xheditor-1.2.1/demos/demo02.html； UBB可视化 @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/demos/demo08.html | xhEditor demo8 : Ajax文件上传 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | Ajax上传 @ /Res/js/xheditor-1.2.1/demos/demo01.html； Ajax上传 @ /Res/js/xheditor-1.2.1/demos/demo02.html； Ajax上传 @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/demos/demo09.html | xhEditor demo9 : 自定义按钮之插件扩展 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 插件扩展 @ /Res/js/xheditor-1.2.1/demos/demo01.html； 插件扩展 @ /Res/js/xheditor-1.2.1/demos/demo02.html； 插件扩展 @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/demos/demo10.html | xhEditor demo10 : showIframeModal接口的iframe文件上传 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | iframe调用上传 @ /Res/js/xheditor-1.2.1/demos/demo01.html； iframe调用上传 @ /Res/js/xheditor-1.2.1/demos/demo02.html； iframe调用上传 @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/demos/demo11.html | xhEditor demo11 : 异步加载 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 异步加载 @ /Res/js/xheditor-1.2.1/demos/demo01.html； 异步加载 @ /Res/js/xheditor-1.2.1/demos/demo02.html； 异步加载 @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/demos/demo12.html | xhEditor demo12 : 远程抓图&amp;剪切板图片粘贴上传 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 远程抓图 @ /Res/js/xheditor-1.2.1/demos/demo01.html； 远程抓图 @ /Res/js/xheditor-1.2.1/demos/demo02.html； 远程抓图 @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/demos/demo13.html | xhEditor demo13 : 结合CKFinder上传演示 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 结合CKFinder @ /Res/js/xheditor-1.2.1/demos/demo01.html； 结合CKFinder @ /Res/js/xheditor-1.2.1/demos/demo02.html； 结合CKFinder @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/demos/demo14.html | xhEditor demo14 : Markdown可视化 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | Markdown可视化 @ /Res/js/xheditor-1.2.1/demos/demo01.html； Markdown可视化 @ /Res/js/xheditor-1.2.1/demos/demo02.html； Markdown可视化 @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/demos/googlemap/googlemap.html | Google Maps | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/xheditor-1.2.1/demos/index.html | xhEditor demos | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/xheditor-1.2.1/demos/uptest.html | 上传接口测试程序 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/xheditor-1.2.1/wizard.html | xhEditor初始化代码生成向导 for xhEditor | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  | 生成代码 @ /Res/js/xheditor-1.2.1/demos/demo01.html； 生成代码 @ /Res/js/xheditor-1.2.1/demos/demo02.html； 生成代码 @ /Res/js/xheditor-1.2.1/demos/demo03.html |
| /Res/js/xheditor-1.2.1/xheditor_plugins/multiupload/multiupload.html | MultiUpload Demo | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/xheditor/upload_image.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/js/xheditor/xheditor_plugins/multiupload/multiupload.html | MultiUpload Demo | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/lqtui/dropdown/avalon.dropdown.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/test/crud.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/anchor/anchor.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/attachment/attachment.html | ueditor图片对话框 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/background/background.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/charts/charts.html | chart | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/emotion/emotion.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/gmap/gmap.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/help/help.html | 帮助 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/image/image.html | ueditor图片对话框 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/insertframe/insertframe.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/link/link.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/map/map.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/map/show.html | 百度地图API自定义地图 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/music/music.html | 插入音乐 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/preview/preview.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/scrawl/scrawl.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/searchreplace/searchreplace.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/snapscreen/snapscreen.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/spechars/spechars.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/table/edittable.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/table/edittd.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/table/edittip.html | 表格删除提示 | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/template/template.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/video/video.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/webapp/webapp.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/dialogs/wordimage/wordimage.html |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/index.html | 完整demo | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /Res/ueditor1_4_3/jsp/controller.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### statistics（4）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /statistics/ajax/deptAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：start_date, end_date |  | start_date, end_date |  |
| /statistics/ajax/teacherAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：start_date, end_date |  | start_date, end_date |  |
| /statistics/deptStati.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> stat_dept | top-active=dept; dept-id=office; dept-left=stat_dept |  |  |
| /statistics/teacherStati.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> office -> 部门页签 -> stat_school | top-active=dept; dept-id=office; dept-left=stat_school |  |  |

### sys（6）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /sys/func/getOrgtreeAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /sys/func/getOrgtreeC.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：CODE |  | CODE |  |
| /sys/func/list.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /sys/org/addDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：NODE_ID, CODE |  | NODE_ID, CODE |  |
| /sys/org/ajaxDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 先打开上级列表/查询页，再点击记录进入；参数：CODE |  | CODE |  |
| /sys/org/mgr.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### table.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /table.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### tableAjax.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /tableAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### test.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /test.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### testDir.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /testDir.jsp | Insert title here | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### testParam（3）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /testParam/lv1.jsp | Insert title here | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /testParam/lv2.jsp | Insert title here | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /testParam/lv3.jsp | Insert title here | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：_id |  | _id |  |

### toMobileSetup.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /toMobileSetup.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### total.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /total.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### ueditor（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /ueditor/controller.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### updateStuPower.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /updateStuPower.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |

### updateYCB.jsp（1）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /updateYCB.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：excelFile, examId, classId, gradeId, courseId |  | excelFile, examId, classId, gradeId, courseId |  |

### user（42）

| 页面 | 标题 | 访问类型 | 点击/到达方式 | 导航参数 | 疑似参数 | 入链证据 |
| --- | --- | --- | --- | --- | --- | --- |
| /user/cfg/pwd_step1.jsp | 绿蜻蜓云校园 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 先打开上级列表/查询页，再点击记录进入；参数：appid |  | appid |  |
| /user/cfg/pwd_step2.jsp | 绿蜻蜓云校园 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/cfg/pwd_step3.jsp | 绿蜻蜓云校园 | 流程步骤页：必须按上一步按钮进入，避免跳过状态 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/cfg/userMenuSet.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的应用 left -> 个人偏好 | top-active=apply; dept-left=usercfg-menuset |  | 个人偏好 @ /user/headupload.jsp； 个人偏好 @ /fix/test_body_left.jsp； 个人偏好 @ /inc/page/body-left.jsp |
| /user/headupload.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 教师首页 top -> 我的应用 | top-active=apply; dept-left=usercfg-headpic |  | 我 @ /teacher/tea-index.jsp； 我的应用 @ /teacher/tea-index.jsp； 我的信息 @ /teacher/tea-index.jsp |
| /user/loginname.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 设置登录名 | top-active=apply; dept-left=usercfg-loginname |  | 设置登录名 @ /fix/test_body_left.jsp； 设置登录名 @ /inc/page/body-left_bak.jsp； 设置登录名 @ /inc/page/body-left.jsp |
| /user/note/calDetail.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/note/cfgDetail.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/note/myNote.jsp | 我的便笺 - | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的应用 left -> 我的便笺 |  |  | 我的便笺 @ /user/headupload.jsp； 我的便笺 @ /fix/test_body_left.jsp； 我的便笺 @ /inc/page/body-left.jsp |
| /user/note/myNoteAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/password.jsp | 修改密码 | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的应用 left -> 修改密码 | top-active=apply; dept-left=usercfg-password | status | 修改密码 @ /user/headupload.jsp； 修改密码 @ /fix/test_body_left.jsp； 修改密码 @ /inc/page/body-left_bak.jsp |
| /user/sms/auth/multAdd.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/sms/auth/smsAuth.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 短信授权 | top-active=dept; dept-left=sms_auth |  | 短信授权 @ /fix/test_body_left.jsp； 短信授权 @ /inc/page/body-left.jsp |
| /user/sms/auth/smsLimitCfg.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/sms/his/messRecord.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 myapp-sendMsg | top-active=apply; dept-left=myapp-sendMsg |  | 发送记录 @ /user/sms/send/messMgr.jsp； 发送记录 @ /user/sms/temp/messManage.jsp； 发送记录 @ /user/sms/temp/messModel.jsp |
| /user/sms/his/messRecordAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/sms/his/messRecordDetails.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 usercfg-headpic | top-active=apply; dept-left=usercfg-headpic |  | @ /user/sms/his/messRecordAjax.jsp |
| /user/sms/his/messRecordDetailsAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/sms/send/messMgr.jsp | 发送短信 - | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 源码菜单 /inc/page/body-left.jsp -> 发送短信 | top-active=apply; dept-left=myapp-sendMsg |  | 发送短信 @ /fix/test_body_left.jsp； 发送短信 @ /inc/page/body-left.jsp； 发送短信 @ /user/sms/his/messRecord.jsp |
| /user/sms/send/selMessAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/sms/send/selMessModel.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/sms/temp/addCommModel.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/sms/temp/addCommType.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/sms/temp/addMessModel.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/sms/temp/addMessType.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/sms/temp/changeMessType.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 未发现稳定菜单链；按直链或代码入链继续追踪 |  |  |  |
| /user/sms/temp/commManage.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> usercfg-headpic | top-active=dept; dept-left=usercfg-headpic |  |  |
| /user/sms/temp/messManage.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 usercfg-headpic | top-active=apply; dept-left=usercfg-headpic |  |  |
| /user/sms/temp/messModel.jsp |  | 直链可尝试：登录态下打开，若 nonFunc 再回菜单链路 | 顶部 apply -> 左侧 myapp-sendMsg | top-active=apply; dept-left=myapp-sendMsg |  | 短信模板 @ /user/sms/his/messRecord.jsp； 短信模板 @ /user/sms/his/messRecordDetails.jsp； 短信模板 @ /user/sms/send/messMgr.jsp |
| /user/sms/temp/messModelAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize |  | pageSize |  |
| /user/sms/temp/sysComm.jsp |  | 部门上下文页：先进“我的部门”选择部门/设置 curDept，再点左侧菜单 | 首页 -> 我的部门 -> 对应部门 -> 部门页签 -> sms_comm_temp | top-active=dept; dept-left=sms_comm_temp |  |  |
| /user/sms/temp/sysCommAjax.jsp |  | 内部片段/API：不要当页面直接点，先找引用它的页面 | 先打开上级列表/查询页，再点击记录进入；参数：pageSize |  | pageSize |  |
| /user/upload/mo/fileUpload.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：token |  | token |  |
| /user/upload/mo/headUpload.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：token |  | token |  |
| /user/upload/mo/testFileUpload.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：token |  | token |  |
| /user/upload/mo/testHeadUpload.jsp | Insert title here | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：token |  | token |  |
| /user/upload/upload.jsp |  | 带参数页面：直链需补参数，优先从上级页面点击 | 先打开上级列表/查询页，再点击记录进入；参数：choise1 |  | choise1 |  |
| /user/userinfo.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的应用 left -> 身份信息 | top-active=apply; dept-left=usercfg-userinfo |  | 身份信息 @ /user/headupload.jsp； 身份信息 @ /fix/test_body_left.jsp； 身份信息 @ /inc/page/body-left.jsp |
| /user/wage/myWageDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 apply -> 左侧 myapp-salary | top-active=apply; dept-left=myapp-salary | ID |  |
| /user/wage/myWageList.jsp |  | 菜单直达：登录后按顶部/左侧菜单点击，通常也可直链 | 运行时 我的应用 left -> 我的工资 | top-active=apply; dept-left=myapp-salary | CREATE_TIME | 我的工资 @ /user/headupload.jsp； 我的工资 @ /fix/test_body_left.jsp； 我的工资 @ /inc/page/body-left.jsp |
| /user/wage/myWageTotalDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 apply -> 左侧 myapp-salary | top-active=apply; dept-left=myapp-salary | ID |  |
| /user/wage/myWageUnTotalDetail.jsp |  | 参数/详情页：从列表、记录或上一步点击进入，直链需带参数 | 顶部 apply -> 左侧 myapp-salary | top-active=apply; dept-left=myapp-salary | ID |  |

## 已验证证据

- 已切到本地 `master`，基准提交 `5d06517d`。
- 已读取 `D:\software\Amadeus-AI-SKILL-QA-FILE\md\01-path-and-source-rules.md`，确认完整知识写入目标是 Amadeus `md`。
- 已读取 `06-project-function-map.md`，确认 LQTedu 是 JSP/Servlet 单体，部门菜单依赖数据库权限而不是纯静态文件。
- 已读取源码入口：`web/toPage.jsp`、`web/inc/page/head.jsp`、`web/inc/page/body-left.jsp`、`web/inc/page/neck.jsp`、`web/inc/page/toMyDept.jsp`、`web/inc/page/toIndex.jsp`、`web/department/index.jsp`。
- 已用当前登录账号运行时抽取教师端顶部和左侧菜单样本。

## 剩余风险

- 本地 `master` 落后 `origin/master` 34 个提交；本文没有覆盖远端新增页面。
- 全量页面索引是静态+当前账号运行时菜单证据，不能替代每个学校、每个角色、每个部门权限下的数据库菜单。
- 老 JSP 中大量详情、弹窗、AJAX、导出、修复页依赖运行时数据，文档只能给出进入策略，不能保证缺参数直链可用。