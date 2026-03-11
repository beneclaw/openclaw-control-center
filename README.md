# OpenClaw Control Center

<img src="docs/assets/overview-hero-zh.png" alt="OpenClaw Control Center 总览横幅截图" width="1200" />

OpenClaw 的安全优先、本地优先控制中心。

语言： [English](README.en.md) | **中文**

## 这个项目是做什么的
- 给 OpenClaw 提供一个本地控制中心，集中看系统是否稳定、谁在工作、哪些任务卡住了、今天花了多少。
- 面向非技术用户，重点是“看得懂、看得准”，不是暴露原始后端 payload。
- 首次接入默认安全：
  - 默认只读
  - 默认本地 token 鉴权
  - 默认关闭高风险写操作

## 你能得到什么
- `总览`：系统状态、待处理事项、关键风险和运营摘要
- `用量`：用量、花费、订阅窗口和连接状态
- `员工`：谁真的在工作，谁只是排队待命
- `任务`：当前任务、审批、执行链和运行证据
- `文档` 与 `记忆`：按活跃 OpenClaw agent 范围展示的源文件工作台

## 适合谁
- 已经在用 OpenClaw、想要一个统一控制中心的团队或个人
- 在同一台机器或可达本地环境里运行 OpenClaw 的使用者
- 想公开发布一个安全优先的 OpenClaw 控制台，而不是做通用 agent 平台的人

## 截图
以下截图来自一个本地 OpenClaw 环境：

<table>
  <tr>
    <td width="50%">
      <img src="docs/assets/overview-focus-zh.png" alt="OpenClaw Control Center 中文总控圆环截图" width="100%" />
    </td>
    <td width="50%">
      <img src="docs/assets/staff-zh.png" alt="OpenClaw Control Center 中文员工页截图" width="100%" />
    </td>
  </tr>
  <tr>
    <td><strong>总控圆环</strong><br />一眼看健康分、推进状态和预算风险。</td>
    <td><strong>员工页</strong><br />直接看谁在工作、谁待命、最近产出和排班状态。</td>
  </tr>
</table>

## 5 分钟启动
```bash
npm install
cp .env.example .env
npm run build
npm test
npm run smoke:ui
UI_MODE=true npm run dev
```

然后打开：
- `http://127.0.0.1:4310/?section=overview&lang=zh`
- `http://127.0.0.1:4310/?section=overview&lang=en`

## 分区功能说明

### 总览
- 给非技术用户看的主操作页。
- 集中展示当前总控态势、待处理事项、运行异常、停滞执行、预算风险、谁在忙、哪些地方需要优先关注。
- 最适合快速回答一句话：`OpenClaw 现在整体正常吗？`

### 用量
- 展示今日、7 天、30 天的用量和花费趋势。
- 包含订阅窗口、配额消耗、用量结构和数据连接状态。
- 最适合判断花费或额度是否开始有风险。

### 员工
- 展示谁现在真的在工作，谁只是有排队中的任务。
- 明确区分“正在执行”和“下一项”，避免把 backlog 误认为正在跑。
- 最适合判断谁忙、谁闲、谁卡住、谁在等待。

### 记忆
- 一个直接基于源文件的记忆工作台，用来查看和编辑每日记忆与长期记忆。
- 范围跟随 `openclaw.json` 里的活跃 agent，不会把已删除 agent 继续显示出来。
- 最适合查看或维护当前 OpenClaw 团队真实在用的记忆内容。

### 文档
- 一个直接基于源文件的文档工作台，用来查看和编辑共享文档与 agent 核心文档。
- 打开的是实际源文件，保存后也直接写回同一个源文件。
- 最适合维护系统背后真正生效的工作文档。

### 任务
- 把任务板、排期、审批、执行链和运行证据放在同一个分区里。
- 能帮助区分哪些只是看板映射，哪些已经有真实执行证据，哪些任务卡住了、需要跟进或待审。
- 最适合理解“现在到底在做什么、只是计划了什么、哪些需要你介入”。

### 设置
- 展示安全模式、连接器状态和数据链路预期。
- 会明确告诉你哪些数据已经接上，哪些还只是部分可见，哪些高风险动作是故意关闭的。
- 最适合排查环境配置、解释为什么某些信号缺失。

## 核心约束
- 只修改 `control-center/` 目录内的文件
- 默认 `READONLY_MODE=true`
- 默认 `LOCAL_TOKEN_AUTH_REQUIRED=true`
- 默认 `IMPORT_MUTATION_ENABLED=false`
- 默认 `IMPORT_MUTATION_DRY_RUN=false`
- 开启鉴权时，导入/导出和所有改状态接口都需要本地 token
- 审批动作有硬开关，默认关闭：`APPROVAL_ACTIONS_ENABLED=false`
- 审批动作默认 dry-run：`APPROVAL_ACTIONS_DRY_RUN=true`
- 不会改写 `~/.openclaw/openclaw.json`

## 安装与上手

### 1. 开始前准备
你最好已经有：
- 一个可用的 OpenClaw 安装
- 一个可连接的 OpenClaw Gateway
- 当前机器上的 `node` 和 `npm`
- 对 OpenClaw 主目录的读取权限

如果你希望 `用量 / 订阅` 信息更完整，当前机器最好还能读到：
- `~/.openclaw`
- `~/.codex`
- OpenClaw 订阅快照文件，尤其是它不在默认位置时

### 2. 安装项目
```bash
git clone <你的仓库地址>
cd control-center
npm install
cp .env.example .env
```

### 3. 配置 `.env`
第一次接入建议保持安全默认值，不要急着打开写操作。

基线配置如下：
```dotenv
GATEWAY_URL=ws://127.0.0.1:18789
READONLY_MODE=true
APPROVAL_ACTIONS_ENABLED=false
APPROVAL_ACTIONS_DRY_RUN=true
IMPORT_MUTATION_ENABLED=false
IMPORT_MUTATION_DRY_RUN=false
LOCAL_TOKEN_AUTH_REQUIRED=true
UI_MODE=false
UI_PORT=4310

# 只有路径不是默认值时才需要设置：
# OPENCLAW_HOME=/path/to/.openclaw
# CODEX_HOME=/path/to/.codex
# OPENCLAW_SUBSCRIPTION_SNAPSHOT_PATH=/path/to/subscription.json
```

一般只需要在这些情况下修改：
- `GATEWAY_URL`：你的 Gateway 不在默认本地地址
- `OPENCLAW_HOME`：OpenClaw 不在 `~/.openclaw`
- `CODEX_HOME`：Codex 数据不在 `~/.codex`
- `OPENCLAW_SUBSCRIPTION_SNAPSHOT_PATH`：订阅或账单快照文件在自定义位置
- `UI_PORT`：`4310` 已被占用

### 4. 可选：让你自己的 OpenClaw 帮你配置
你可以把下面这段提示词直接交给自己的 OpenClaw：

```text
你现在要帮我把 OpenClaw Control Center 接到这台机器自己的 OpenClaw 环境上。

只允许在 control-center 仓库里工作。
除非我明确要求，否则不要修改应用源码。
目标是完成一次安全的首次接入配置。

请按下面步骤执行：
1. 检查 OpenClaw Gateway 是否可达，并告诉我正确的 gateway URL。
2. 确认这台机器上正确的 OpenClaw 主目录和 Codex 主目录。
3. 对照 .env.example，创建或更新 .env。
4. 第一次接入时必须保持这些值：
   - READONLY_MODE=true
   - LOCAL_TOKEN_AUTH_REQUIRED=true
   - APPROVAL_ACTIONS_ENABLED=false
   - IMPORT_MUTATION_ENABLED=false
5. 不要开启 live import，也不要开启 approval mutation。
6. 不要改 OpenClaw 自己的配置文件。
7. 完成后输出：
   - 你实际修改了哪些 env 值
   - 我下一步应该执行的准确命令
   - 我应该先打开哪些页面来确认接入成功
8. 如果缺少必要的路径、进程或文件，不要猜，直接明确告诉我缺什么。
```

### 5. 验证安装
执行：
```bash
npm run build
npm test
npm run smoke:ui
```

预期结果：
- build 通过
- test 通过
- UI smoke 输出本地地址，例如 `http://127.0.0.1:<port>`

### 6. 启动界面
```bash
UI_MODE=true npm run dev
```

然后打开：
- 中文界面：`http://127.0.0.1:4310/?section=overview&lang=zh`
- 英文界面：`http://127.0.0.1:4310/?section=overview&lang=en`

如果你改了 `UI_PORT`，把 `4310` 替换成你的端口。

### 7. 首次检查顺序
1. `总览`：页面能正常打开，并且能看到当前系统状态
2. `用量`：能看到真实数字，或者明确的“数据源未连接”
3. `员工`：实时工作状态与真实 active session 基本一致
4. `任务`：当前工作、审批、执行链能正常加载，不会吐原始 payload
5. `文档` 与 `记忆`：显示的 agent 标签和 `openclaw.json` 中的活跃 agent 一致

### 8. 如果看起来不对
- 实时活动全空，通常是 `GATEWAY_URL` 错了，或者 OpenClaw Gateway 没启动
- `文档 / 记忆` 范围不对，通常是 `OPENCLAW_HOME` 指错了，或者 `openclaw.json` 不可读
- `用量 / 订阅` 没数据，通常是 `CODEX_HOME` 或 `OPENCLAW_SUBSCRIPTION_SNAPSHOT_PATH` 没配对
- 如果你只是想先安全观察，不要改默认的只读和 mutation 开关

## 本地命令
- `npm run build`
- `npm run dev`
- `npm run dev:continuous`
- `npm run dev:ui`
- `npm run smoke:ui`
- `npm run release:audit`
- `npm run command:backup-export`
- `npm run command:import-validate -- runtime/exports/<file>.json`
- `npm run command:acks-prune`
- `npm test`
- `npm run validate`

对于受保护的命令模式（如 `command:backup-export`、`command:import-validate`、`command:acks-prune`），如果 `LOCAL_TOKEN_AUTH_REQUIRED=true`，请先设置 `LOCAL_API_TOKEN=<token>`。

## 开源与发布卫生
- 仓库已经包含 `.gitignore`、`LICENSE` 和可发布的 package 元数据
- Gateway 地址可通过 `GATEWAY_URL` 配置，不再绑定单一本地 socket
- PM2、mission harness、workflow 和 verifier 示例都只用仓库相对路径和环境注入 secrets
- 公开文档统一使用通用 `~/.openclaw/...` 路径，不包含机器私有 home 目录
- 每次公开推送前，建议先运行 `npm run release:audit`
- 独立仓库发布流程见 [docs/PUBLISHING.md](docs/PUBLISHING.md)

## 本地 HTTP 接口
- `GET /snapshot`：原始快照 JSON
- `GET /projects`：项目列表，支持 `status`、`owner` 等查询过滤
- `GET /api/projects`：`/projects` 的兼容别名
- `POST /api/projects`：创建项目（`projectId`、`title`，可选 `status`、`owner`）
- `PATCH /api/projects/:projectId`：更新项目标题、状态或 owner
- `GET /tasks`：任务列表，支持 `status`、`owner`、`project` 过滤
- `GET /api/tasks`：`/tasks` 的兼容别名
- `POST /api/tasks`：按 schema 校验创建任务
- `PATCH /api/tasks/:taskId/status`：按 schema 校验更新任务状态
- `GET /sessions`：分页会话列表，支持 `state`、`agentId`、`q`、`page`、`pageSize`、`historyLimit`
- `GET /sessions/:id`：单会话 JSON 详情，支持 `historyLimit`
- `GET /api/sessions/:id`：单会话详情的 API 别名
- `GET /session/:id`：本地化会话详情页面，支持 `lang=en|zh`
- `GET /api/commander/exceptions`：仅异常视图的汇总
- `GET /exceptions`：按严重级别排序的异常流
- `GET /done-checklist`：最终集成检查清单与 readiness 评分
- `GET /api/action-queue`：基于异常流和 ack 状态生成的待处理队列
- `GET /graph`：项目-任务-会话关联图 JSON
- `GET /usage-cost`：跳转到 `/?section=usage-cost`
- `GET /api/usage-cost`：用量、花费、订阅窗口、拆分和 burn-rate 快照
- `POST /api/import/dry-run`：导入包 dry-run 校验，不写状态
- `POST /api/import/live`：可选 live import，高风险、本地专用，默认关闭
- `GET /cron`：定时任务与健康状态
- `GET /healthz`：系统健康载荷
- `GET /digest/latest`：最新 digest 的 HTML 页面
- `GET /api/search/tasks|projects|sessions|exceptions`：安全子串搜索接口
- `GET /api/replay/index`：timeline、digest、export、bundle 的 replay/debug 索引
- `GET /docs`：本地化 docs 索引
- `GET /docs/readme|runbook|architecture|progress`：本地 markdown 文档视图
- `POST /api/approvals/:approvalId/approve|reject`：审批动作服务（受 gate 和 dry-run 控制）
- `GET /audit`：本地审计时间线页面
- `GET /api/audit`：审计时间线 JSON

## 看板亮点

### 总览、审批、回放与工具活动
- 首页支持内联搜索，直接接 `/api/search/*`
- 回放和导出卡片会展示返回数量、过滤数量、延迟和体积指标
- 审批数量使用完整 live 审批集，不再因为 preview 截断而少算
- 工具活动详情会加载真实 session 证据，不再出现“上面有统计、下面却说没有工具会话”的冲突

### 文档、记忆与 agent 范围
- `文档` 和 `记忆` 现在优先跟随 `~/.openclaw/openclaw.json` 中的活跃 agent
- 已删除 agent 不会因为旧目录残留而重新出现在 facet 按钮中
- 根级 OpenClaw 文件会显示为 `Main`
- 打开和保存文件时都直接读写源文件，不走陈旧副本

### 执行链与任务可读性
- 执行链卡片不再直接显示原始 JSON payload
- 未映射的隔离执行会使用稳定标题，例如 `Main · Cron 隔离执行`
- 长标题、长 session key 和 badge 现在都会在卡片内安全换行
- 任务页会显示真实执行证据，而不是只看截断的最近几条会话

### 员工状态与实时性
- `工作中 / Working` 只代表真实 live execution，不再把“还有 backlog”误判为正在工作
- 有 backlog 但没有 live session 的 agent 会显示为待命语义
- `正在处理什么` 与 `下一项` 被明确区分

### 用量、订阅与正确性
- `总览 / 任务 / 设置 / 用量` 共享同一套 usage/quota 真相源
- 活跃会话统计在首页 KPI、侧栏、摘要条中保持一致
- Codex 配额窗口标签会自动归一成稳定标签，例如 `5h` 和 `Week`
- 对缺失数据会显示明确的未连接状态，而不是假零值

### 视觉与体验
- 整体 UI 已收敛到更接近 Apple 原生的层次和卡片风格
- 执行链卡片改成更宽的栅格，不再四张挤在一行里
- 侧边导航里 `用量` 已放在 `总览` 下方，信息架构更贴近日常运营使用顺序

### Mission Control v3 能力
- UI 已演进到 polished pixel-office 风格
- 覆盖会话、审批、cron、任务、用量、回放、健康、导入导出 dry-run 等关键控制面
- 全 roster office 模型会读取 `openclaw.json` 中已知 agent，而不只看当前活跃会话
- 支持 best-effort 的订阅用量/剩余额度展示

## API 校验与错误包络
- 所有修改型 API 都要求 `Content-Type: application/json`
- 导入/导出和所有修改型接口默认需要本地 token：
  - header：`x-local-token: <LOCAL_API_TOKEN>`
  - 或 `Authorization: Bearer <LOCAL_API_TOKEN>`
- 严格 query 校验会拒绝未知参数
- JSON 错误统一格式：
  - `{"ok":false,"requestId":"...","error":{"code":"...","status":<http>,"message":"...","issues":[],"requestId":"..."}}`
- JSON 响应会带 `requestId`，所有响应头都会带 `x-request-id`

## Live import 警告
- `POST /api/import/live` 默认关闭
- 除非你在做受控的本地恢复测试，否则不要开启
- Live mode 会修改本地 runtime 存储，例如：
  - `runtime/projects.json`
  - `runtime/tasks.json`
  - `runtime/budgets.json`
- 正常使用时请保持 `READONLY_MODE=true` 和 `IMPORT_MUTATION_ENABLED=false`

## Runtime 文件
- `runtime/last-snapshot.json`
- `runtime/timeline.log`
- `runtime/projects.json`
- `runtime/tasks.json`
- `runtime/budgets.json`
- `runtime/notification-policy.json`
- `runtime/model-context-catalog.json`
- `runtime/ui-preferences.json`
- `runtime/acks.json`
- `runtime/approval-actions.log`
- `runtime/operation-audit.log`
- `runtime/digests/YYYY-MM-DD.json`
- `runtime/digests/YYYY-MM-DD.md`
- `runtime/export-snapshots/*.json`
- `runtime/exports/*.json`

## 文档
- `docs/ARCHITECTURE.md`
- `docs/RUNBOOK.md`
- `docs/PROGRESS.md`
