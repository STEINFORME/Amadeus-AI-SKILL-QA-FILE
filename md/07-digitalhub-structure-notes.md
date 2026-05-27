# 数字中枢结构速记摘要

## 结论

数字中枢不是单个前端页面，而是三段式链路：

`JSP 管理页 -> /digitalHub 静态大屏 -> 后端接口`

不要裸开 `web/digitalHub/*.html` 下结论；必须从管理页启动并带加密 `school_id`。

## 入口链路

1. 管理页在 `web/department/office/campus/DataHub/*.jsp`。
2. 点击“启动页面”。
3. JSP 调 `/digitalHub/get_en_school_id` 获取加密 `school_id`。
4. JSP 打开 `/digitalHub/*.html?school_id=...&currentTime=0&musicSwitch=true&rgbswitch=true&`。
5. 静态页读 URL 参数。
6. 静态页请求 `/digitalHub/*` 或 `/zhpj/report/*` 接口取数。

## 管理页和静态页映射

| 管理页 | 静态页 | 优先查 |
| --- | --- | --- |
| `DataHub-index.jsp` | `/digitalHub/index.html` | `getMain`、`getPicList`、`getBaseInfo`、`getFrequentNumber`、`getTsInfo` |
| `DataHub-xszhpj.jsp` | `/digitalHub/xszhpj/xszhpj.html` | `get_digital_hub_sets`、`get_digital_hub_data`、`get_zh_pic_stu_rec` |
| `DataHub-bjzp.jsp` | `/digitalHub/bjzhpb.html` | `getDySetting`、`getReportListByRateId`、`getReportDetail` |
| `DataHub-bjzp-daily.jsp` | `/digitalHub/bjzhpb-daily.html` | `getDyDailySetting`、`getDyDailyReport` |
| `DataHub-index-Pic.jsp` | 无直接大屏 | `getPicList`、`savePicList` |

## 目录分层

| 层级 | 位置 | 作用 |
| --- | --- | --- |
| 管理页 | `web/department/office/campus/DataHub/` | 后台配置页、启动页、图片配置页 |
| 静态大屏 | `web/digitalHub/` | 展示大屏 html、css、js、图片、音乐 |
| 学生综评子模块 | `web/digitalHub/xszhpj/` | 学生综评专页和局部组件 |
| 后端控制器 | `src/com/ajax/openAPI/DigitalHubController.java` | `/digitalHub/*` 路由入口 |
| 后端服务 | `src/com/ajax/openAPI/DigitalHubService.java` | 基础数据、配置、图片、列表等 |
| 综评数据能力 | `ZhpjReportUtils` | 学生综评核心数据 |

## 调试顺序

1. 管理页入口能不能进。
2. `school_id` 是否由入口页生成且已加密。
3. 静态页 URL 参数是否完整。
4. 接口是否返回。
5. 最后才看图表、轮播、头像和视觉。

## 学生综评页

- 主文件：`web/digitalHub/xszhpj/xszhpj.html`
- 组件：
  - `component/leftTop.js`
  - `component/rightTop.js`
  - `component/studentPortraits.js`
  - `component/pointsMall.js`
- 核心接口：
  - `/digitalHub/get_digital_hub_sets?school_id=...`
  - `/digitalHub/get_digital_hub_data?school_id=...`
  - `/digitalHub/get_zh_pic_stu_rec?stu_id=...&school_id=...`
  - `/digitalHub/get_digital_hub_dict?school_id=...`

学生综评核心数据很多在 `report_service` / `ZhpjReportUtils`，不是全在 `DigitalHubService`。

## 主首页

- 主文件：`web/digitalHub/index.html`
- 主要板块：学校概况、高频行为、综合评价、导师制、图片轮播、跳转入口。
- 核心接口：
  - `/digitalHub/getSchoolUserCount`
  - `/digitalHub/get_zh_digital_hut_data?school_id=...`
  - `/digitalHub/getMain`
  - `/digitalHub/getPicList`
  - `/digitalHub/getBaseInfo`
  - `/digitalHub/getFrequentNumber`
  - `/digitalHub/getTsInfo`

## 常见坑

- `DataHub`、`digitalHub`、`DigtalHub`、`get_zh_digital_hut_data` 同时存在，不能按正常命名猜。
- `web/digitalHub/` 有测试页、demo 素材、旧结构目录，不要顺手乱改。
- 首页 `COURSE_TYPE -> 校本课程显示` 链路未完全打透，动首页时必须重新顺源码。
- 不能把管理配置页和静态大屏当成同一个页面改。
- 测试时不能裸开静态 HTML 后就写业务结论。
