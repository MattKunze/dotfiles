---
name: repo-conventions
description: Single canonical home of the shared development conventions for the sibling projects — git/tangled workflow, lint policy, deploy-racing hazard, TASKS.md discipline, and the APP.md intake convention. Load this before git/PR/CI/branching work, before touching TASKS.md coordination entries, and when starting or finishing a feature.
---

# Skill: repo-conventions — shared development conventions

The single source of truth for the convention blocks formerly duplicated
across the projects' AGENTS.md files. Project-specific substance (ports,
env prefixes, trigger/pipeline nuances, project-only caveats) stays in each
project's AGENTS.md; anything restated here exists in that project's file
only as a pointer or a project-scoped addition.

## Git / tangled workflow

- **Worktrees are the default for non-trivial feature development** — load
  `@skill:feature-worktrees` for the lifecycle. Working directly on a main
  checkout is only for trivial changes or when the operator explicitly
  requests it.
- **Feature branches + PRs — never push directly to main.** Branch naming:
  `feature/<description>` or `fix/<description>`. The only historic
  exception was initial scaffolding, pushed directly to main; treat it as
  once-only. PRs require review before merge.
- **Checks**: run `mise run ci` before pushing a branch, and again before
  PR creation and before every `tg pr update`. PRs merge only when the
  tangled `ci` pipeline (`.tangled/workflows/ci.yml`) is green — a
  convention, not enforcement: tangled has no required-checks/merge gating
  yet (tangled.org/core#454; re-check docs.tangled.org/spindles before
  assuming the limitation still holds). The pipeline mirrors `mise run
  ci`'s checks — keep the two lists in sync. `ci` never requires a running
  dev stack or Docker daemon.
- **Tangled operations** (PRs, issues, pipelines, auth) use the `tg` CLI
  (https://tangled.org/aly.codes/tg), not project-local scripts.
- `tg` derives the repo from the `origin` remote: run it from the repo root
  and omit `--repo` (explicit values fail to resolve, surfacing as
  misleading 502s). The remote should use the handle form
  (`git@tangled.org:<handle>/<repo>`), not the repo DID.
- `tg pr create` flags: `--title`, `--body`, `--body-file <path>` (`-` for
  stdin is not supported; write a temp file).
- Pushing to a PR branch does **not** update the PR (unlike GitHub): after
  each push, run `tg pr update <rkey>` to submit a new round.
- **Trigger nuances** (which workflows run on push vs pull_request vs
  explicit `tg pipeline trigger`) are per-project — see that project's
  AGENTS.md and `.tangled/workflows/`; do not assume GitHub-style
  push-triggered CI.

## Lint policy

CI must pass with **zero lint warnings** (`eslint --max-warnings 0`): fix
the issue outright; if genuinely unfixable, use a scoped per-instance
`eslint-disable` with the justification in the adjacent comment — never a
blanket rule-off or warning-count padding, so real problems don't drown in
console noise.

## Deploy racing on rapid merges

Tangled pipelines have no per-branch/per-repo concurrency control (no
concurrency groups, no cancel-in-progress; limits are host-side spindle
knobs like `maxJobCount`/`maxConcurrentWorkflows` that only queue when the
shared runner is saturated). Two PRs merged back-to-back run the deploy
pipeline in parallel. Image tags don't collide (each build pushes its own
`$TANGLED_SHA` tags), but both pipelines POST to the deploy endpoint and
the stack's final tags are last-write-wins — if the older commit's build
finishes last, it wins and the deploy regresses.

For release deployments: don't merge multiple deploy-triggering PRs in
quick succession without verifying both pipelines finished and the
*newer* commit's deploy landed last. Mitigation (in each project's
`deploy.yml`): the `Deploy` step fetches `main` and skips the POST when the
pushed commit is no longer main's tip — superseded pipelines no-op, and
manual runs bypass the check so intentional redeploys of older commits
still work. Residual risk: a merge landing between a pipeline's tip check
and its POST can still win by ordering; only deploy-agent-side
serialization (or a native upstream concurrency feature) closes that
window.

## TASKS.md discipline

TASKS.md is the cross-agent coordination surface, kept per-branch and
per-checkout: the copy in each worktree is the coordination surface for
that branch.

- **Section format**: one section per branch, headed
  `## <feature> (date)` with a `Branch:` line, and the subsections
  `### In progress`, `### Done`, `### Known limitations`. Section titles
  have historically differed from branch names — don't assume they match
  when correlating.
- **Owner tags**: every in-flight item under `In progress` carries an owner
  tag (`[agent-name]` or `[human]`) and status.
- **Claim-then-commit**: at session start, read TASKS.md in your checkout;
  claim work by adding your owner tag and committing the claim; update and
  commit TASKS.md when finishing or handing off.
- **Don't duplicate in progress**: if TASKS.md shows another owner in
  progress on the same item, don't duplicate — check `git status`/recent
  commits for their progress first.
- **Trim on merge**: when a branch's PR merges, trim its section to a
  2–4 line summary — what shipped, the residual limitation(s) worth
  surfacing, and the branch/PR reference. Durable knowledge that matters
  long-term (features, decisions) moves into `APP.md` at that moment; git
  history preserves the removed detail. Unmerged frontier work keeps full
  detail.
- **`tg`/API-host failure logging**: when a `tg` call fails, record the
  exact failure in TASKS.md and surface the pending steps to the operator;
  never claim success from a failed call.

## Intake & control doc convention

Every repo in the family keeps an `APP.md` at its root: the controlling
document that says what the application *is* — the record new work must
ground in.

- **Vocabulary**:
  - *application* — the product as a whole (the repo).
  - *components* — the major deliverables/parts it is built from.
  - *capability* — a group of related user-facing features.
  - *feature* — an individual user-facing capability.
  - *decisions* — the significant, dated, tradeoff-bearing choices.
  Dev/deploy infra is documented under components, not as capabilities —
  APP.md takes a user-facing lens.
- **Intake for any plan or proposal**:
  1. Start from `APP.md`: consult it first, and build the plan on what it
     records.
  2. State in the plan how the proposed feature interacts with existing
     capabilities, and explicitly note conflicts with named invariants
     (each project's APP.md/AGENTS.md names its own).
  3. Update `APP.md` — including adding any significant new decisions —
     in the same PR that carries the change.
- **Decisions entries**: concise, dated, statement + tradeoff only. Keep
  off minute choices; keep genuinely significant/tradeoff-bearing items.
