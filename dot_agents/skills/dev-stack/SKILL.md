---
name: dev-stack
description: Run, inspect, and verify against the current checkout's dev stack without duplicating it or disturbing sibling worktree stacks. Load this before starting, probing, or verifying against any checkout's dev stack (mise-managed).
---

# Skill: dev-stack — run/verify against this checkout's dev stack

Purpose: start, inspect, and verify against the dev stack of the checkout
you're working in **without duplicating it or disturbing sibling worktree
stacks**. Skills are instructions, not scripts — the mise tasks do the work
(all defined in the checkout's `mise.toml`).

Per-project specifics (env prefixes, port reservation ranges, origin-mode
mechanics, the full task list) live in that project's `AGENTS.md` — this
skill carries only the shared lifecycle rules.

## Procedure

1. **Check first**: run `mise run status`. Output is per-service, scoped to
   this checkout (ports come from this checkout's gitignored `.env`), and
   identifies which checkout/compose project it is — use that to confirm
   you're in the checkout you think. Exit code 0 means everything is up —
   safe to assert on in scripts.
2. **If the stack is up**: use it. Do not restart it, do not hunt ports.
3. **If it's down**: run `mise run dev` (background it if you're driving a
   harness). It is idempotent — when the stack is already up it prints the
   serving URLs and exits 0 without starting anything, and it clears a stale
   dev-server listener on this checkout's port first. Whether the stack
   serves a public https domain or plain loopback is the sign-in origin mode
   documented in the project's AGENTS.md; `mise run dev` reconciles the
   checkout `.env` to the mode on every run.
4. **Verify against the running checkout** using the checkout's own mise
   verify tasks (`smoke`, `health`, `logs`, … — which tasks exist comes from
   that project's AGENTS.md, not from this skill), and any `curl` probes
   against the *actual* ports read from the checkout's `.env`. Never probe a
   hardcoded `127.0.0.1:<default>` for a non-default checkout.
5. **When done**: leave the stack running unless asked to stop. If stopping,
   `mise run stop` in *that* checkout only — it is port-scoped (this
   checkout's compose project / listeners) and removes this checkout's dev
   route, so its domain hostname starts 502-ing while sibling hostnames keep
   working.

## Never hardcode ports

Don't write any `127.0.0.1:<default>` (or any baked port number) in scripts,
checks, or commands — read the project's `<APP>_*_PORT` values from the
checkout's gitignored `.env`. The service defaults apply to the **main
checkout only**; every worktree gets an automatically allocated free port
baked into its `.env` at creation.

## Troubleshooting

- Never grep processes to "find the port conflict" — ports are per-checkout
  in the gitignored `.env`.
- A `DOWN` status after `dev` means: read the checkout's logs (its mise
  `logs` task or `docker compose logs`), not reconfigure ports.
- If `status` shows a port occupied while the service behind it is DOWN, a
  stale listener from an interrupted run holds the port: `mise run stop` (or
  simply re-running `mise run dev`) clears the stale listener on *this
  checkout's* port only.
