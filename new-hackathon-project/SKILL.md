---
name: new-hackathon-project
description: Scaffold a new Web3 hackathon project with the user's standard 3-repo layout (sc/be/fe) under a GitHub organization. TRIGGER when user wants to bootstrap a new hackathon project, start a new dApp, or says "bikin project hackathon baru" / "init project hackathon". SKIP for adding features to existing projects, non-Web3 scaffolding, or single-repo projects.
---

# New Hackathon Project Scaffold

Bootstraps a new Web3 hackathon project using the user's standard layout.

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
3. **Target chain(s)** for deploy (multi-select OK) — Base Sepolia, Arbitrum Sepolia, Mantle Sepolia, Optimism Sepolia, Monad Testnet, etc.
4. **Local parent directory** for the 3 repos (default: current working dir)

Confirm derived names back to user before executing.

## Pre-flight checks

Run in parallel; abort with actionable message if any fail:

- `gh auth status` — must be logged in with `repo` and `admin:org` scope (for membership ops)
- `forge --version` — Foundry installed
- `bun --version` — Bun installed
- `git --version`

## Workflow

### Step 1 — Ensure GitHub Organization exists

- Check: `gh api orgs/<OrgName> 2>/dev/null`
- If exists: confirm reuse with user
- If not: GitHub does **not** support programmatic org creation for normal users. Instruct user to create it manually at https://github.com/account/organizations/new (Free plan is fine), then resume.

### Step 2 — Local parent dir

```bash
mkdir -p <parent>/<OrgName>
cd <parent>/<OrgName>
```

Mirror org name locally for organization on disk.

### Step 3 — Scaffold `-sc` (Foundry)

```bash
mkdir <project>-sc && cd <project>-sc
forge init --no-commit .
forge install OpenZeppelin/openzeppelin-contracts --no-commit
```

Then:
- Write `foundry.toml` with remappings, optimizer on, `extra_output = ["abi"]`
- Write `script/Deploy.s.sol` — multi-chain deploy template with `vm.envAddress`/`vm.envUint`
- Write `.env.example` with one line per target chain (`<CHAIN>_RPC_URL=`, `PRIVATE_KEY=`, `<EXPLORER>_API_KEY=`)
- Write `script/export-abi.sh` — copy `out/<Contract>.sol/<Contract>.json` → `../<project>-fe/src/abi/`
- Add sample test in `test/`
- `git init && git add -A && git commit -m "chore: scaffold from new-hackathon-project skill"`
- `cd ..`

### Step 4 — Scaffold `-fe` (Next.js + Bun)

```bash
bunx create-next-app@latest <project>-fe \
  --typescript --tailwind --eslint --app --src-dir \
  --import-alias "@/*" --no-git --use-bun
cd <project>-fe
```

Install deps:
```bash
bun add wagmi viem @rainbow-me/rainbowkit @tanstack/react-query
bunx shadcn@latest init -d
```

Then:
- Write `src/lib/wagmi.ts` — chains configured from user's target list, RainbowKit `getDefaultConfig`
- Write `src/app/providers.tsx` — WagmiProvider + QueryClientProvider + RainbowKitProvider
- Wire `providers.tsx` into `src/app/layout.tsx`
- Write `.env.example` (NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID, RPC URLs, contract addresses placeholder)
- Write `vercel.json` (framework: nextjs, env reference)
- Tighten `tsconfig.json` (`strict: true`, `noUncheckedIndexedAccess: true`)
- Add `.prettierrc` + `.prettierignore`
- `mkdir -p src/abi` (target dir for ABI export from `-sc`)
- `git init && git add -A && git commit -m "chore: scaffold from new-hackathon-project skill"`
- `cd ..`

### Step 5 — Scaffold `-be` (chosen stack)

`mkdir <project>-be && cd <project>-be`, then by stack:

- **Hono + Bun**: `bun create hono@latest . --template bun --install --pm bun`
- **Express + Bun**: `bun init -y` → `bun add express` → write minimal `src/index.ts`
- **Fastify + Bun**: `bun init -y` → `bun add fastify` → minimal server
- **NestJS**: `bunx @nestjs/cli new . --package-manager bun --skip-git`
- **FastAPI**: `python -m venv .venv && source .venv/bin/activate && pip install fastapi uvicorn && pip freeze > requirements.txt` + `app/main.py`
- **Go**: `go mod init github.com/<OrgName>/<project>-be` + Fiber/Gin starter `main.go`
- **Skip**: just write `README.md` placeholder

For every stack: write `.env.example`, `.gitignore`, `README.md`.

`git init && git add -A && git commit -m "chore: scaffold from new-hackathon-project skill"`
`cd ..`

### Step 6 — Create remote repos & push

For each of the 3 repos (sequential, not parallel — `gh` rate limits):

```bash
cd <project>-<suffix>
gh repo create <OrgName>/<project>-<suffix> --public --source=. --remote=origin --push
cd ..
```

### Step 7 — Validation

In parallel:
- `gh repo view <OrgName>/<project>-sc --json url,visibility`
- `gh repo view <OrgName>/<project>-be --json url,visibility`
- `gh repo view <OrgName>/<project>-fe --json url,visibility`
- `git -C <project>-sc log --oneline -1`
- `git -C <project>-be log --oneline -1`
- `git -C <project>-fe log --oneline -1`

## Done report (to user)

Output 3 GitHub URLs + 3 local paths + next steps checklist:
- [ ] Set Vercel project → import `<project>-fe`, set env vars
- [ ] Configure WalletConnect project ID
- [ ] Grab testnet faucet for chosen chains
- [ ] First contract: write in `src/`, then `forge build && bash script/export-abi.sh`

## Failure recovery

Never proceed past a failure. Report what's done and what's not.

Common failures and responses:
- **Org missing** → instruct manual creation, do not retry until confirmed
- **Repo name conflict** → ask user for alternate suffix or different project name
- **`forge install` network fail** → retry once; if still fails, surface error
- **`gh repo create` fails with 403** → likely missing `repo` or `admin:org` scope; tell user to run `gh auth refresh -s admin:org`
- **`bun create` hangs** → kill, report; do not auto-retry (may leave partial dir)

## What NOT to do

- Do not amend or force-push.
- Do not skip git hooks.
- Do not pre-create files inside repos the user might already have personalized (always assume fresh).
- Do not assume `~/.claude/skills/new-hackathon-project/templates/` files exist — they're optional; if missing, generate inline from this SKILL.md's spec.
