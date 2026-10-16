# AGENTS.md

Standing rules for every session, every working directory. Per-project
specifics (ports, env prefixes, origin modes, trigger/pipeline nuances,
project-only caveats) live in each project's own AGENTS.md — this file does
not restate them.

- Feature work happens in a sibling worktree (`mise run wt <feature>` in
  the project), not on a main checkout.
- Never push directly to main; feature branches + PRs, merge after review.
- Run the project's `mise run ci` green before pushing and before every PR
  update; PRs merge on a green tangled `ci` pipeline.
- Zero lint warnings (`--max-warnings 0`): fix outright; scoped
  per-instance disables with a justification comment are the only escape.
- Tangled API host flakiness (`bobbin.klbr.net`): when a `tg` call fails,
  record the exact failure in TASKS.md and surface the pending steps to the
  operator — never claim success from a failed call.

Shared procedure skills (dotfiles-managed, in `~/.agents/skills/`):

- `repo-conventions` — load before git/PR/CI/branching work or when
  starting or finishing a feature; it is the single home of the git/
  tangled workflow, lint policy, deploy-racing hazard, TASKS.md
  discipline, and the APP.md intake convention.
- `feature-worktrees` — the sibling-worktree feature lifecycle.
- `dev-stack` — running/verifying against a checkout's dev stack without
  disturbing sibling stacks.
