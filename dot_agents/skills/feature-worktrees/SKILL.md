---
name: feature-worktrees
description: The isolated sibling-worktree feature lifecycle for the dev projects — create, work, sync, finish, cleanup. Load this before starting or dispatching feature work in a project that uses `mise run wt`.
---

# Skill: feature-worktrees — the worktree feature lifecycle

Purpose: develop a feature in a fully isolated sibling worktree — its own
branch, its own dev stack (ports, containers, data), never contending with
sibling stacks — so any number of features run concurrently. Skills are
instructions, not scripts; the mise tasks do the work.

Port reservation ranges are per project on the shared dev machine: check
the project's AGENTS.md for which ranges belong to which project before
debugging overlaps.

## Create

`mise run wt <feature>` (works from any checkout, including a worktree):

- Creates sibling `../<app>-<feature>` with branch `feature/<feature>` from
  main. The sibling placement is the shared convention of the sibling
  projects on this machine (and keeps any sibling compose build contexts
  resolving).
- Copies the gitignored `.env` files from the main checkout.
- Auto-allocates free host ports per the project's reserved ranges and bakes
  them into the worktree's `.env`, together with rewritten origin/URL values
  (the project's AGENTS.md documents which variables and what derives from
  them).
- Installs deps and registers the worktree's dev route in the shared
  dev-domain registry.

## Work

- `cd ../<app>-<feature>` — all mise/docker commands resolve to that
  checkout automatically (its own `.env`, its own compose project/stack).
- Running and verifying against this checkout's dev stack: load
  `@skill:dev-stack`.
- In-branch TASKS.md coordination (owner tags, claim-then-commit,
  don't-duplicate): load `@skill:repo-conventions` — it is the single home
  of those rules.

## Sync

Stay current with main regularly:

```bash
git fetch origin && git rebase origin/main
```

(merge instead of rebase if the branch is shared with another agent/human).

## Finish

1. Push the branch and open a PR with `tg` (rules in `@skill:repo-conventions`:
   run `tg` from the repo root, no `--repo`; after each push run
   `tg pr update <rkey>`). Run `mise run ci` first — green before push and
   before every `tg pr update` (trigger/pipeline nuances are project AGENTS.md
   material).
2. After the PR merges, from any checkout: `mise run wt-cleanup <feature>` —
   it refuses unmerged branches, tears down the worktree's stack and
   removes the worktree dir and branch.
3. `mise run wt-cleanup <feature>` also fast-forwards main in the main
   checkout (best-effort: if that checkout is dirty or diverged it skips
   with a hint — `git pull` manually there once clean).

## Caveats

- The tangled API host (`bobbin.klbr.net`) is not a stable precondition:
  when `tg` operations fail there, record the exact failure in TASKS.md and
  surface the pending push/pipeline steps to the operator — never block
  in-repo work on `tg` or claim success from a failed call.
  Whether that caveat plus any push-trigger/pipeline nuances apply lives in
  the project's AGENTS.md.
