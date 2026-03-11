# OpenClaw Control Center

<img src="docs/assets/overview-hero-en.png" alt="OpenClaw Control Center overview hero screenshot" width="1200" />

Safety-first local control center for OpenClaw.

Language: **English** | [中文](README.md)

## Why this exists
- One local place to see whether OpenClaw is healthy, busy, blocked, or drifting.
- Built for non-technical operators who need observability and certainty, not raw backend payloads.
- Safe first-run defaults:
  - read-only by default
  - local token auth by default
  - mutation routes disabled by default

## What you get
- `Overview`: health, current state, decisions waiting, and operator-facing summaries
- `Usage`: usage, spend, subscription windows, and connector status
- `Staff`: who is really working now versus only queued
- `Tasks`: current work, approvals, execution chains, and runtime evidence
- `Documents` and `Memory`: source-backed workbenches scoped to active OpenClaw agents

## Who it is for
- OpenClaw users who want one local control center for observability, usage, tasks, approvals, replay, documents, and memory
- teams running OpenClaw on one machine or a reachable local environment
- maintainers who want a public-ready, safety-first OpenClaw dashboard instead of a generic agent platform

## Screenshots
Example UI from a local OpenClaw environment:

<table>
  <tr>
    <td width="50%">
      <img src="docs/assets/overview-focus-en.png" alt="OpenClaw Control Center overview control posture ring screenshot" width="100%" />
    </td>
    <td width="50%">
      <img src="docs/assets/staff-en.png" alt="OpenClaw Control Center staff page screenshot" width="100%" />
    </td>
  </tr>
  <tr>
    <td><strong>Control ring</strong><br />See health, operating posture, and budget risk in one glance.</td>
    <td><strong>Staff page</strong><br />See who is working now, who is on standby, recent output, and schedule state.</td>
  </tr>
</table>

## 5-minute start
```bash
npm install
cp .env.example .env
npm run build
npm test
npm run smoke:ui
UI_MODE=true npm run dev
```

Then open:
- `http://127.0.0.1:4310/?section=overview&lang=en`
- `http://127.0.0.1:4310/?section=overview&lang=zh`

## Section-by-section tour

### Overview
- The main operating screen for non-technical users.
- Shows the current control posture, key action items, runtime issues, stalled runs, budget risk, who is active, and what needs attention first.
- Best when you want one fast answer to: “Is OpenClaw okay right now?”

### Usage
- Shows today, 7-day, and 30-day usage and spend trends.
- Includes subscription windows, quota consumption, usage mix, and connector status.
- Best when you want to know whether spend or quota is becoming risky.

### Staff
- Shows who is truly active now versus who only has queued work.
- Separates live work from “next up” so backlog is not confused with active execution.
- Best when you want to know who is busy, idle, blocked, or waiting.

### Memory
- A source-backed workbench for daily and long-term memory files.
- Scoped to active OpenClaw agents from `openclaw.json`, so deleted agents do not keep showing up.
- Best when you want to inspect or edit memory that the current OpenClaw team is actually using.

### Documents
- A source-backed workbench for shared and agent-specific core markdown docs.
- Reads the real source files and writes back to the same files.
- Best when you want to maintain the actual working documents behind the system.

### Tasks
- Combines task board, schedule, approvals, execution chains, and runtime evidence.
- Helps distinguish mapped work from real execution evidence, and shows what is blocked or needs review.
- Best when you want to understand what is being carried, what is only planned, and what needs intervention.

### Settings
- Shows safety mode, connector status, and data-link expectations.
- Makes it clear what is connected, what is still partial, and which high-risk actions are intentionally disabled.
- Best when you want to verify environment setup or explain why a signal is missing.

For:
- Existing OpenClaw users who want a local control center for observability, usage, staff activity, tasks, approvals, replay, and documents.
- Teams running OpenClaw on the same machine or a reachable local environment.
- Not a generic dashboard for non-OpenClaw agent stacks.

## Core constraints
- Only touches files in `control-center/`.
- `READONLY_MODE=true` by default.
- `LOCAL_TOKEN_AUTH_REQUIRED=true` by default.
- `IMPORT_MUTATION_ENABLED=false` by default.
- `IMPORT_MUTATION_DRY_RUN=false` by default.
- Import/export and all state-changing endpoints require a local token when auth is enabled.
- Approval actions are hard-gated (`APPROVAL_ACTIONS_ENABLED=false` default).
- Approval actions are dry-run by default (`APPROVAL_ACTIONS_DRY_RUN=true`).
- No mutation of `~/.openclaw/openclaw.json`.

## Quick start
1. `npm install`
2. `cp .env.example .env`
3. Keep safe defaults for the first run; only change `GATEWAY_URL` or path overrides if your OpenClaw setup is non-standard.
4. `npm run build`
5. `npm test`
6. `npm run smoke:ui`
7. `UI_MODE=true npm run dev`

## Installation and onboarding

### 1. Before you start
You should already have:
- a working OpenClaw installation
- a reachable OpenClaw Gateway
- shell access with `node` and `npm`
- read access to your OpenClaw home directory

For the richest dashboard data, it also helps if this machine has:
- `~/.openclaw`
- `~/.codex`
- a readable OpenClaw subscription snapshot, if your setup stores one outside the default locations

### 2. Install the project
```bash
git clone <your-repo-url>
cd control-center
npm install
cp .env.example .env
```

### 3. Configure `.env`
For a safe first run, keep the mutation guards in place.

Use this baseline:
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

# Optional only when your paths differ from the defaults:
# OPENCLAW_HOME=/path/to/.openclaw
# CODEX_HOME=/path/to/.codex
# OPENCLAW_SUBSCRIPTION_SNAPSHOT_PATH=/path/to/subscription.json
```

Change only these values if your environment needs it:
- `GATEWAY_URL`: when your OpenClaw Gateway is not on the default local socket
- `OPENCLAW_HOME`: when OpenClaw is not stored in `~/.openclaw`
- `CODEX_HOME`: when Codex data is not stored in `~/.codex`
- `OPENCLAW_SUBSCRIPTION_SNAPSHOT_PATH`: when your billing/subscription snapshot lives somewhere custom
- `UI_PORT`: when `4310` is already in use

### 4. Optional: ask your own OpenClaw to prepare the setup
If you want OpenClaw to help configure the environment, give it this prompt:

```text
You are helping me connect OpenClaw Control Center to this machine's OpenClaw installation.

Work only inside the control-center repository.
Do not modify application source code unless I explicitly ask.
Goal: prepare a safe first-run setup.

Please do the following:
1. Check whether the OpenClaw Gateway is reachable and tell me the correct gateway URL.
2. Confirm the correct OpenClaw home path and Codex home path on this machine.
3. Compare those paths with .env.example and create or update .env.
4. Keep these values safe for first run:
   - READONLY_MODE=true
   - LOCAL_TOKEN_AUTH_REQUIRED=true
   - APPROVAL_ACTIONS_ENABLED=false
   - IMPORT_MUTATION_ENABLED=false
5. Do not enable live import or approval mutations.
6. Do not change OpenClaw's own config.
7. At the end, print:
   - the final env values you changed
   - the exact commands I should run next
   - the first dashboard pages I should open to confirm everything works
8. If any required path, process, or file is missing, stop and tell me exactly what is missing instead of guessing.
```

### 5. Verify the install
Run:
```bash
npm run build
npm test
npm run smoke:ui
```

Expected result:
- build passes
- tests pass
- UI smoke reports a local URL such as `http://127.0.0.1:<port>`

### 6. Start the UI
```bash
UI_MODE=true npm run dev
```

Then open:
- English UI: `http://127.0.0.1:4310/?section=overview&lang=en`
- Chinese UI: `http://127.0.0.1:4310/?section=overview&lang=zh`

If you changed `UI_PORT`, replace `4310` with your chosen port.

### 7. First-use checklist
On your first launch, check these pages in order:
1. `Overview`: the app opens and shows current system state.
2. `Usage`: usage and subscription panels either show real numbers or a clear missing-connector state.
3. `Staff`: live work status matches real active sessions.
4. `Tasks`: current work, approvals, and execution-chain cards load without raw payload noise.
5. `Documents` and `Memory`: the visible agent tabs match your active agents from `openclaw.json`.

### 8. If something looks wrong
- Empty live activity usually means `GATEWAY_URL` is wrong or the OpenClaw Gateway is not running.
- Missing `Documents / Memory` agents usually means `OPENCLAW_HOME` points to the wrong OpenClaw root or `openclaw.json` is missing.
- Missing usage/subscription data usually means `CODEX_HOME` or `OPENCLAW_SUBSCRIPTION_SNAPSHOT_PATH` needs to be set.
- If you only want a safe read-only dashboard, do not change the mutation defaults.

## Local commands
- `npm run build`
- `npm run dev`
- `npm run dev:continuous`
- `npm run dev:ui`
- `npm run smoke:ui`
- `npm run command:backup-export`
- `npm run command:import-validate -- runtime/exports/<file>.json`
- `npm run command:acks-prune`
- `npm test`
- `npm run validate`

For protected command modes (`command:backup-export`, `command:import-validate`, `command:acks-prune`), set `LOCAL_API_TOKEN=<token>` unless `LOCAL_TOKEN_AUTH_REQUIRED=false`.

## Repository hygiene (Phase 113, Open-source release readiness)
- Repo now ships with `.gitignore`, `LICENSE`, and publishable package metadata.
- Gateway connectivity is configurable via `GATEWAY_URL` instead of being hard-wired to one local socket.
- PM2, mission harness, workflow, and verifier examples now use repo-relative paths and environment-injected secrets only.
- Public docs now refer to generic `~/.openclaw/...` locations instead of machine-specific home directories.
- Run `npm run release:audit` before every public push.
- See [`docs/PUBLISHING.md`](docs/PUBLISHING.md) for the recommended standalone-repo release flow.

## Local HTTP endpoints
- `GET /snapshot`: raw snapshot JSON
- `GET /projects`: list projects with optional query filters `status`, `owner`
- `GET /api/projects`: same as `/projects` for compatibility
- `POST /api/projects`: create project (`projectId`, `title`, optional `status`, `owner`)
- `PATCH /api/projects/:projectId`: update project title/status/owner
- `GET /tasks`: flattened task list with optional query filters `status`, `owner`, `project`
- `GET /api/tasks`: same as `/tasks` for compatibility
- `POST /api/tasks`: create task with schema validation
- `PATCH /api/tasks/:taskId/status`: update task status with schema validation
- `GET /sessions`: paginated session visibility list with optional filters `state`, `agentId`, `q`, and pagination params `page`, `pageSize`, `historyLimit`
- `GET /sessions/:id`: per-session JSON detail with latest history entries (`historyLimit` query supported)
- `GET /api/sessions/:id`: explicit API alias for per-session JSON detail
- `GET /session/:id`: localized session drill-down UI page (`lang=en|zh`) with latest messages, execution-chain evidence, and safe truncation
- `GET /api/sessions`: compatibility endpoint for `/sessions`
- `GET /api/commander/exceptions`: exceptions-only summary (blocked/errors/pending approvals/over-budget/tasks-due)
- `GET /exceptions`: routed exceptions feed with levels (`info`, `warn`, `action-required`), sorted by severity then newest event
- `GET /done-checklist`: final integration checklist + readiness scoring (`observability/governance/collaboration/security`)
- `GET /api/done-checklist`: API alias for done checklist
- `GET /api/action-queue`: notification center queue derived from exceptions feed + ack state + relevant session/task/project links
- `GET /api/action-queue/acks/prune-preview`: token-gated dry-run preview of stale ack prune counts (`before/removed/after`, no state mutation)
- `POST /api/action-queue/:itemId/ack`: acknowledge an action-required queue item (persisted), optional `ttlMinutes` or `snoozeUntil` to auto-expire ack state
- `GET /graph`: project-task-session linkage graph JSON (for future Gameboy view)
- `GET /view/pixel-state.json`: pixel-ready adapter state (`rooms`, `entities`, `links`) for future Gameboy canvas
- `GET /usage-cost`: product route alias that redirects to `/?section=usage-cost`
- `GET /api/usage-cost`: usage/billing observability snapshot (period totals, context windows, breakdowns, burn-rate, subscription consumed/remaining/cycle, connector TODOs)
- `GET /export/state.json`: bundled export with sessions/tasks/projects/budgets/exceptions + persisted debug snapshot + backup bundle in `runtime/exports/` (requires local token auth)
- `POST /api/import/dry-run`: dry-run validator for export bundles (`fileName` or inline `bundle`) with zero state mutation (requires local token auth)
- `POST /api/import/live`: optional live import mutation endpoint (high-risk, local-only); requires local token + `IMPORT_MUTATION_ENABLED=true`, blocked in readonly unless `dryRun=true`, and now returns validation errors instead of `500` for bad `fileName` paths
- `GET /notifications/preview`: notification policy preview with quiet-hours + severity routing
- `GET /cron`: cron overview with next run and health summary
- `GET /healthz`: system health payload (build info + snapshot freshness + monitor lag)
- `GET /digest/latest`: rendered HTML page from latest markdown digest file
- `GET /api/ui/preferences`: persisted dashboard UI preferences (`runtime/ui-preferences.json`)
- `PATCH /api/ui/preferences`: update dashboard UI preferences (`compactStatusStrip`, `quickFilter`, `taskFilters`)
- `GET /api/search/tasks`: safe substring search over tasks (`q`, `limit`), with `count` = total matches and `returned` = current response size
- `GET /api/search/projects`: safe substring search over projects (`q`, `limit`), with `count` = total matches and `returned` = current response size
- `GET /api/search/sessions`: safe substring search over sessions (`q`, `limit`), with `count` = total matches, `returned` = current response size, and live-session merge parity with `/sessions`
- `GET /api/search/exceptions`: safe substring search over exception feed (`q`, `limit`), with `count` = total matches and `returned` = current response size
- `GET /api/replay/index`: replay/debug index from timeline + digests + export snapshots + export bundles, optional `from`/`to` ISO time window filters, plus per-source `stats` (`total`, `returned`, `filteredOut`, window-vs-limit breakdown, `latencyMs`, `latencyBucketsMs` with `p50/p95`, `totalSizeBytes`, `returnedSizeBytes`)
- `GET /api/docs`: route + schema summary endpoint
- `GET /docs`: localized docs index page (read-only) with direct return path to the `Documents` section
- `GET /docs/readme|runbook|architecture|progress`: local markdown docs views (read-only, `lang` accepted for index/back-link flow)
- `POST /api/approvals/:approvalId/approve`: approval action service (gate + dry-run + audit)
- `POST /api/approvals/:approvalId/reject`: rejection action service (gate + dry-run + audit)
- `GET /audit`: local audit timeline page (newest-first, severity filter)
- `GET /api/audit`: audit timeline JSON (`severity=all|info|warn|action-required|error`)

## Dashboard highlights (Phase 14)
- Home page includes inline scoped search UI wired to `/api/search/*`.
- Home page replay/export visibility card now shows returned/filtered counts and latency/size indicators from `/api/replay/index`.
- Guard table shows explicit disabled/enabled badges and linked local docs references.

## Dashboard highlights (Phase 107, Approvals/replay/tool-activity correctness sweep)
- Approval counts now use the full live approval set:
  - sidebar and task-hub decision counts no longer under-report when approval previews are truncated
  - approval preview lists stay short but now make it explicit when only the latest subset is shown
- Replay visibility chips now show total available history:
  - timeline events
  - daily digests
  - export snapshots
  - backup bundles
- Overview tool activity detail now loads actual session evidence:
  - it no longer claims there are no tool-call sessions while the same page shows active tool-call counts
- User-facing parity routes no longer advertise deprecated dashboard sections:
  - approvals route points to the task hub decision lane
  - replay route points to `/audit`

## Dashboard highlights (Phase 110, Docs/memory active-agent scope alignment)
- `Documents` and `Memory` now follow active OpenClaw agent config instead of stale workspace folders:
  - facets are resolved from `~/.openclaw/openclaw.json` first
  - removed agents no longer appear just because an old folder still exists under `workspace/agents/`
  - root OpenClaw files are now shown as `Main` instead of `共享`
- Editable file content remains source-of-truth current:
  - file lists still read live filesystem metadata (`updatedAt`, size, path)
  - opening a file reads the current source file
  - saving a file writes directly back to that same source file

## Dashboard highlights (Phase 111, Execution-chain readability cleanup)
- `Execution chain` cards no longer surface raw JSON payloads as the visible headline or summary.
- Unmapped isolated-run cards now use stable labels such as `Main · Cron 隔离执行`.
- JSON-like payloads are summarized into short readable lines:
  - `成功 · 查询 30 · 成功 30`
  - `失败 · 错误 locked`
  - `成功 · 扫描 120 · 入选 2 · 发送 2`
- Long titles and session keys now wrap/clamp inside the card instead of pushing badges out of place.

## Dashboard highlights (Phase 112, Staff status freshness semantics)
- Staff `Working / 工作中` now means live execution, not just “still owns unfinished tasks”.
- Agents with backlog but no live session now stay in standby semantics instead of looking falsely active.
- Staff work labels now separate:
  - live work: `Working on / 正在处理什么`
  - queued next task: `Next up / 下一项`
- Staff/recent-activity cache remains short-lived at about `3s`; live-session polling baseline remains `5s`.

## Dashboard highlights (Phase 114, Execution-chain card hardening)
- Execution-chain cards no longer allow raw JSON-like payloads to become visible titles.
- Structured payload-shaped titles are converted into short human summaries or stable fallback labels instead.
- Long titles, meta rows, and badge rails are now overflow-safe inside the card grid.

## Dashboard highlights (Phase 115, Apple-native card elevation tune)
- Page canvas is slightly cooler and quieter so foreground cards stand out more cleanly.
- Core cards now use brighter layered fills, crisper borders, and deeper but still restrained elevation.
- The hierarchy is unchanged; this is a visual polish pass, not a layout rewrite.

## Dashboard highlights (Phase 116, Config-truthful document and memory scopes)
- `Documents / Memory` no longer revive deleted agents just because stale folders still remain on disk.
- Valid active-agent config remains the only truth source for those facet buttons.
- If config becomes unreadable, the workbench now falls back conservatively to `Main` only instead of showing stale agent folders.

## Dashboard highlights (Phase 106, Cold-path cache coalescing)
- Correctness stays unified across Overview / Settings / Usage:
  - no return to split summary/full quota logic
  - repeat navigations keep the same usage/quota truth when the underlying execution state is unchanged
- Heavy evidence scans are now reused instead of recomputed per page:
  - runtime usage logs
  - Codex subscription/quota telemetry
  - digest history
  - OpenClaw cron name catalog
- UI startup now primes dashboard caches, and concurrent page opens share the same heavy build work.
- In local smoke:
  - back-to-back `Overview` renders dropped to about `0.41s`
  - back-to-back `Usage` renders dropped to about `0.41s`
  - after one priming hit, concurrent `Overview / Settings / Usage` completed in about `1.13s`

## Dashboard highlights (Phase 105, Observability correctness alignment)
- Overview / Tasks / Settings / Usage now share one usage/quota truth source:
  - the same today-usage number
  - the same Codex quota windows
  - the same subscription-status judgement
- Active-session counts are aligned across:
  - overview KPI
  - certainty card
  - sidebar / summary strips
- Task certainty no longer depends on only the first recent-session page:
  - linked session evidence is loaded for the visible task set
  - task detail pages no longer stop at the first 6 linked sessions
- Detail links now keep the current UI language when opening task / cron drill-down pages.

## Dashboard highlights (Phase 15, UX v2)
- Home dashboard is now organized into six operator tabs with persistent left navigation:
  - `Overview`
  - `Office Space`
  - `Projects/Tasks`
  - `Alerts`
  - `Replay/Audit`
  - `Settings`
- UI moved to a colorful pixel-arcade visual style with dual sidebars (navigation + context rail).
- New `Office Space` view shows who is busy on what, grouped by office zones.
- Agent cards now include automatic animal identities derived from agent name semantics, with deterministic fallback mapping.
- Empty/zero-heavy blocks are softened:
  - non-actionable zero states are minimized
  - user-facing empty states now say `Not activated yet`.
- Home copy was rewritten from debug-heavy wording to operator-focused language while preserving all existing routes and backend behavior.

## Dashboard highlights (Phase 22, Usage/Cost parity surfaces)
- Added `Usage & Cost` section in the primary sidebar IA.
- Added Overview card-level usage/cost pulse:
  - period totals (`today`, `7d`, `30d`)
  - request-count source state
  - burn-rate headline
- Added dedicated Usage & Cost dashboard section:
  - context window visibility per active session/agent (absolute tokens + % when context catalog is available)
  - pace/trend labels + warning thresholds
  - usage/cost breakdown by agent, project, model, provider
  - budget burn-rate status and alert messaging
- Added graceful unavailable-state behavior:
  - explicit `Data source not connected` labels for disconnected metrics (instead of fake zeros)
  - connector TODO list surfaced in Settings
- Added usage adapter endpoint:
  - `GET /api/usage-cost`

## Dashboard highlights (Phase 25, Mission Control v3)
- UI visual reset to polished pixel-office style:
  - design-token based palette/spacing/radius/shadow system
  - layered office background grid + glow depth
  - responsive desktop/mobile hierarchy with subtle card/status motion
- Navigation and copy reset for operator clarity:
  - `Command Deck`, `Usage & Billing`, `Pixel Office`, `Work Board`, `Decisions`, `Timeline`, `Control Room`
  - reduced technical wording on primary surfaces
  - advanced links preserved under explicit disclosure
- Mac parity surfaces panel added with status + route entry for:
  - conversations, approvals/decision queue, cron, projects/tasks, usage/cost, replay/audit, health/digest, export/import dry-run safety, pixel adapter
- Full roster office model:
  - best-effort OpenClaw roster read from `~/.openclaw/openclaw.json` via `src/runtime/agent-roster.ts`
  - office floor now renders desk/zone occupancy and includes known agents beyond active sessions
- Subscription usage/remaining best-effort integration:
  - adapter support in `src/runtime/usage-cost.ts` for connected/partial/not_connected states
  - UI now shows consumed/remaining/limit/cycle/source and explicit connection targets when unavailable

## Dashboard highlights (Phase 68, Plain-language certainty)
- Added `Information certainty` card to Overview and Settings:
  - tells non-technical operators which parts of the picture are trustworthy now
  - calls out remaining blind spots in plain language
- Added `Execution certainty` board to Tasks:
  - scores whether each in-flight task is backed by real execution evidence
  - separates `evidence is strong` from `needs follow-up` and `evidence is weak`
- Task detail pages now act as evidence pages:
  - certainty judgement
  - linked session evidence and recent activity summaries

## API validation/error envelope
- API mutating routes require `Content-Type: application/json`.
- Import/export and mutating routes require local token auth by default:
  - header: `x-local-token: <LOCAL_API_TOKEN>`
  - or `Authorization: Bearer <LOCAL_API_TOKEN>`
- Strict API query validation rejects unknown query keys.
- JSON errors use a consistent envelope:
  - `{"ok":false,"requestId":"...","error":{"code":"...","status":<http>,"message":"...","issues":[],"requestId":"..."}}`
- JSON responses include `requestId` and all responses include `x-request-id` header for correlation.

## Live import warning
- `POST /api/import/live` is intentionally disabled by default.
- Do not enable it unless you are doing a controlled local restore test.
- Live mode mutates local runtime stores (`runtime/projects.json`, `runtime/tasks.json`, `runtime/budgets.json`).
- Keep `READONLY_MODE=true` and `IMPORT_MUTATION_ENABLED=false` in normal operation.

## Runtime files
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

## Docs
- `docs/ARCHITECTURE.md`
- `docs/RUNBOOK.md`
- `docs/PROGRESS.md`
