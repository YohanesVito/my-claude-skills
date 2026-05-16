---
name: new-hackathon-project
description: Scaffold a new Web3 hackathon project with the user's standard 3-repo layout (sc/be/fe) under a GitHub organization. TRIGGER when user wants to bootstrap a new hackathon project, start a new dApp, or says "bikin project hackathon baru" / "init project hackathon". SKIP for adding features to existing projects, non-Web3 scaffolding, or single-repo projects.
---

# New Hackathon Project Scaffold

Bootstraps a new Web3 hackathon project using the user's standard layout. Concrete config files for SC, FE, and supported chains live in `./templates/` — skill loads them rather than generating inline, so output is deterministic and version-controlled.

## Layout produced

- **GitHub Organization** — PascalCase, no dashes/spaces (e.g. `MantleRiskGate`)
- **3 repos inside the org**, all `kebab-case`, all `public`:
  - `<project>-sc` — smart contract (Foundry)
  - `<project>-be` — backend (stack chosen per project)
  - `<project>-fe` — frontend (Next.js + Bun)

## Inputs to collect (ask all in one batched message)

1. **Project name** (human readable, e.g. "Mantle Risk Gate")
   - Derive `OrgName` = PascalCase no-dash (`MantleRiskGate`)
   - Derive repo names = kebab-case + suffix (`mantle-risk-gate-sc`, `-be`, `-fe`)
2. **Backend stack** — present options:
   - Hono + Bun (recommended, matches FE runtime)
   - Express + Bun
   - Fastify + Bun
   - NestJS
   - FastAPI (Python)
   - Go (Fiber / Gin)
   - Skip — create empty `-be` repo with README only
3. **Target chain(s)** for deploy (multi-select OK) — see `./templates/chains.json` for full list: `base-sepolia`, `arbitrum-sepolia`, `optimism-sepolia`, `mantle-sepolia`, `monad-testnet`
4. **Local parent directory** for the 3 repos (default: current working dir)

Confirm derived names back to user before executing.

## Pre-flight checks

Run in parallel; abort with actionable message if any fail:

- `gh auth status` — must be logged in with `repo` scope (`admin:org` not required if org already exists)
- `forge --version` — Foundry installed
- `bun --version` — Bun installed
- `git --version`
- `jq --version` — required by `export-abi.sh`

## Workflow

### Step 1 — Ensure GitHub Organization exists

- Check: `gh api orgs/<OrgName> 2>/dev/null`
- If exists: confirm reuse with user
- If not: GitHub **does not support programmatic org creation** for normal users. Instruct user to create it manually at https://github.com/account/organizations/new (Free plan is fine), then resume.

### Step 2 — Local parent dir

```bash
mkdir -p <parent>/<OrgName>
cd <parent>/<OrgName>
```

Mirror org name locally for organization on disk.

### Step 3 — Scaffold `-sc` (Foundry) using `./templates/sc/`

```bash
mkdir <project>-sc && cd <project>-sc
forge init --no-commit .
forge install OpenZeppelin/openzeppelin-contracts --no-commit
```

Copy templates (overwrite forge init defaults where applicable):
- `./templates/sc/foundry.toml` → `foundry.toml` (with multi-chain rpc_endpoints + etherscan)
- `./templates/sc/Deploy.s.sol` → `script/Deploy.s.sol`
- `./templates/sc/env.example` → `.env.example`
- `./templates/sc/export-abi.sh` → `script/export-abi.sh` then `chmod +x script/export-abi.sh`

Sample test from forge init stays (Counter.sol + Counter.t.sol).

Git: forge init may already create `.git` — check before `git init`. Then `git add -A && git commit -m "chore: scaffold from new-hackathon-project skill"`. `cd ..`

### Step 4 — Scaffold `-fe` (Next.js + Bun) using `./templates/fe/`

```bash
bunx create-next-app@latest <project>-fe \
  --typescript --tailwind --eslint --app --src-dir \
  --import-alias "@/*" --no-git --use-bun --yes
cd <project>-fe
```

⚠ `--no-git` is **ignored** by current create-next-app (it inits git anyway). Don't `git init` again.

Install deps:
```bash
bun add wagmi viem @rainbow-me/rainbowkit @tanstack/react-query
```

Copy templates:
- `./templates/fe/wagmi.ts` → `src/lib/wagmi.ts`
- `./templates/fe/providers.tsx` → `src/app/providers.tsx`
- `./templates/fe/vercel.json` → `vercel.json`
- `./templates/fe/env.example` → `.env.example`

Wire providers in `src/app/layout.tsx`:
- Add import: `import { Providers } from "./providers"`
- Wrap `{children}` with `<Providers>{children}</Providers>` inside `<body>`

Create empty ABI sink dir: `mkdir -p src/abi`

(Optional) Tighten `tsconfig.json` with `noUncheckedIndexedAccess: true`.

`git add -A && git commit -m "chore: scaffold from new-hackathon-project skill"`. `cd ..`

### Step 4.5 — Optional: apply design style (hook to `web-design-style`)

After `-fe` scaffold succeeds, ask user:

> "Mau langsung apply design style ke `-fe`? Pilihan preset: **neo-brutalism**, **grunge**, **retro-90s**, **awwwards-motion**, atau skip."

If user picks a style:
- Invoke `web-design-style` skill with: `scope=theme-only`, `target=<project>-fe`, `style=<chosen>`
- Wait for skill to finish + run `bun run build` to validate
- Commit the style changes as a separate commit (`feat(fe): apply <style> design preset`)

If skip: continue to Step 5.

### Step 5 — Scaffold `-be` (chosen stack)

`mkdir <project>-be && cd <project>-be`, then by stack:

- **Hono + Bun**: `bun create hono@latest . --template bun --install --pm bun`
- **Express + Bun**: `bun init -y` → `bun add express` → minimal `src/index.ts`
- **Fastify + Bun**: `bun init -y` → `bun add fastify` → minimal server
- **NestJS**: `bunx @nestjs/cli new . --package-manager bun --skip-git`
- **FastAPI**: `python -m venv .venv && source .venv/bin/activate && pip install fastapi uvicorn && pip freeze > requirements.txt` + `app/main.py`
- **Go**: `go mod init github.com/<OrgName>/<project>-be` + Fiber/Gin starter `main.go`
- **Skip**: just write `README.md` placeholder

For every stack: write `.env.example`, `.gitignore`, `README.md`.

`git init` if needed, then `git add -A && git commit -m "chore: scaffold from new-hackathon-project skill"`. `cd ..`

### Step 6 — Create remote repos & push

Sequential (not parallel — `gh` rate limits):

```bash
for suffix in sc fe be; do
  cd <project>-$suffix
  gh repo create <OrgName>/<project>-$suffix --public --source=. --remote=origin --push
  cd ..
done
```

### Step 7 — Validation

In parallel:
- `gh repo view <OrgName>/<project>-sc --json url,visibility`
- `gh repo view <OrgName>/<project>-fe --json url,visibility`
- `gh repo view <OrgName>/<project>-be --json url,visibility`
- `git -C <project>-sc log --oneline -1`
- `git -C <project>-fe log --oneline -1`
- `git -C <project>-be log --oneline -1`

## Stack quirks (Next.js 16 + Tailwind 4 + Foundry 1.x, late 2025+)

Hard rules learned from skill testing:

1. **Tailwind 4 is default** — `create-next-app@latest --tailwind` generates Tailwind 4 (CSS-only config via `@theme` in `src/app/globals.css`), not v3. No `tailwind.config.ts` is generated. Design style integration (Step 4.5) must target this format — `web-design-style` skill handles it.

2. **`--no-git` ignored by create-next-app & forge init** — both init git regardless. Skip the redundant `git init` step.

3. **Auto-generated `CLAUDE.md` / `AGENTS.md`** — recent `create-next-app` drops these into project root. Leave alone (useful context for future Claude sessions).

4. **Default Geist font stays for non-styled projects** — only `web-design-style` skill (when invoked via Step 4.5) handles font swap. If user skips Step 4.5, Geist is fine as-is.

5. **GitHub Organization is NOT programmatically creatable** — user must do this once via UI. Skill checks existence and instructs manual creation if missing.

## Done report (to user)

Output:
- 3 GitHub URLs
- 3 local paths
- Chosen design style (or "default Next.js look")
- Next steps checklist:
  - [ ] Set Vercel project → import `<project>-fe`, set env vars (use `.env.example` as guide)
  - [ ] Get [WalletConnect project ID](https://cloud.walletconnect.com)
  - [ ] Grab testnet faucet(s) — links in `<project>-sc/.env.example`
  - [ ] First contract: write in `<project>-sc/src/`, then `forge build && bash script/export-abi.sh`
  - [ ] First deploy: `forge script script/Deploy.s.sol --rpc-url <chain> --broadcast --verify`

## Failure recovery

Never proceed past a failure. Report what's done and what's not. Common cases:

- **Org missing** → instruct manual creation, do not retry until confirmed
- **Repo name conflict** → ask user for alternate suffix or different project name
- **`forge install` network fail** → retry once; if still fails, surface error and `cd ..` cleanly
- **`gh repo create` 403** → likely missing `repo` scope; tell user to `gh auth refresh -s repo`
- **`bun create` hangs** → kill, report; do not auto-retry (may leave partial dir)
- **Template file missing** → report as skill installation issue; offer to generate inline as fallback

## What NOT to do

- Do not amend or force-push.
- Do not skip git hooks.
- Do not pre-create files inside repos the user might already have personalized.
- Do not run `git init` if `.git` already exists (forge init / create-next-app already created it).
- Templates ARE expected to exist in `./templates/`. If missing, that's a skill installation bug — surface to user, don't silently generate.

## Related skills

- **`web-design-style`** — invoked by Step 4.5 for FE style application. Presets: neo-brutalism, grunge, retro-90s, awwwards-motion.

## Community references (for future SC engineering skills)

These don't replace this skill, but are reference patterns for future skills the user might want (audit, gas-optimize, test generation):

- `trailofbits/skills` — official Trail of Bits security audit workflows
- `max-taylor/Claude-Solidity-Skills` — Foundry test-gen, gas-optimize, audit (closest pattern match)
- `forefy/.context` — multi-expert audit framework

See `reference-web3-skills-community` memory for full list and adoption guidance.
