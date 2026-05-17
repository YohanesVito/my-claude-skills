# References

External resources studied while building this collection. **Each entry says when to reach for it** — so you can decide between using our skills vs. installing/forking someone else's.

## Quick decision tree

| Need | Go to section |
|---|---|
| Add Foundry test / audit / gas skill | [Foundry & Solidity skills](#foundry--solidity-skills) |
| Discover other Claude Code skills | [Awesome lists](#awesome-lists) |
| Install ready-made skill via marketplace | [Marketplaces](#marketplaces) |
| Find design inspiration beyond our 4 presets | [Design inspiration](#design-inspiration) |
| Understand Claude Code skill format itself | [Format & methodology](#format--methodology) |

---

## Foundry & Solidity skills

> **When to use:** you need to test, audit, optimize, or analyze an **existing** Solidity contract. None of these are scaffolds — they assume a contract is already written.

### [trailofbits/skills](https://github.com/trailofbits/skills)

- **What:** Official Trail of Bits skills for security research, vuln detection, audit-context-building.
- **Authority:** Highest — Trail of Bits audits Optimism, Uniswap, MakerDAO.
- **When to use:** You're preparing for a serious audit (post-hackathon production launch). Methodology-heavy, slow but thorough.
- **When to skip:** Hackathon-speed. Too heavy. Reach for max-taylor's `audit` skill instead.

### [max-taylor/Claude-Solidity-Skills](https://github.com/max-taylor/Claude-Solidity-Skills)

- **What:** 4 skills — `audit`, `gas-optimize`, `test-foundry`, `test-hardhat`. Plugin format.
- **License:** MIT (declared in `.claude-plugin/plugin.json`, no LICENSE file at root).
- **Activity:** 3 stars / 3 forks / 0 issues / 0 PRs. Last push ~3 months ago. Solo dev.
- **Install:** `claude plugin marketplace add max-taylor/Claude-Solidity-Skills && claude plugin install solidity-skills@Claude-Solidity-Skills`
- **When to use:** You need to generate Foundry/Hardhat tests, run a checklist-driven audit, or get gas optimization recs on an existing contract. Hackathon-friendly speed.
- **When to skip:** You want active maintenance / community-vetted. Stale-ish.

### [doxielabs/claude-solidity-testing](https://github.com/doxielabs/claude-solidity-testing)

- **What:** Fork of max-taylor's. Split `test-foundry` into `unit-test-foundry` + `invariant-test-foundry` with `references/` folder for deep methodology.
- **Activity:** 0 stars / 0 forks. Last push ~1 month ago. Internal corporate fork ("Doxie Intern" email).
- **When to use:** You specifically want **invariant testing** done well — their `invariant-test-foundry` is more refined than max-taylor's original. They added a 331-line methodology reference doc.
- **When to skip:** General-purpose testing. Zero community traction, no maintenance guarantees.

### [forefy/.context](https://github.com/forefy/.context)

- **What:** Multi-expert audit framework. Supports Solidity, Anchor (Solana), Vyper, TON (FunC/Tact), Sui (Move). Generates triaged industry-grade findings with PoCs + attacker flow graphs.
- **When to use:** Multi-chain audit. You're auditing more than just EVM (Solana, TON, Sui projects). Or you need formal findings report.
- **When to skip:** EVM-only + hackathon scope. Too heavy.

### [Cyfrin/security-and-auditing-full-course-s23](https://github.com/Cyfrin/security-and-auditing-full-course-s23)

- **What:** Patrick Collins's audit course (not a skill, educational repo).
- **When to use:** You want to learn audit patterns yourself before adopting any skill. Educational reference, not a tool.

---

## Awesome lists

> **When to use:** Exploring the Claude Code skill ecosystem. Not for installing — these point you to repos, you still evaluate each.

| Repo | Coverage | When to use |
|---|---|---|
| [rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) | 135 agents, 35 skills, 42 commands, 176+ plugins | Most comprehensive single catalog |
| [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) | 1000+ skills, multi-platform (Claude, Codex, Gemini, Cursor) | Want broadest coverage including non-Claude agents |
| [gmh5225/awesome-skills](https://github.com/gmh5225/awesome-skills) | Multi-platform skill list | Smaller, more curated than VoltAgent |
| [travisvn/awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills) | Claude-specific | Want Claude-only without Codex/Gemini noise |
| [jqueryscript/awesome-claude-code](https://github.com/jqueryscript/awesome-claude-code) | Tools, IDE integrations, frameworks | Looking beyond skills (hooks, plugins, IDE integrations) |

---

## Marketplaces

> **When to use:** Want one-click installable skills. Trade depth-of-review for speed-of-adoption.

| Marketplace | Strength | When to skip |
|---|---|---|
| [MCPMarket — Solidity Security](https://mcpmarket.com/tools/skills/solidity-security-smart-contract-patterns) | Paid, curated, security-focused | Free options sufficient |
| [MCPMarket — Foundry Solidity](https://mcpmarket.com/tools/skills/foundry-solidity-development) | Foundry-specific dev | Already using max-taylor's `test-foundry` |
| [agent-skills.cc — Blockchain](https://agent-skills.cc/claude-skills/blockchain) | Directory of Solidity skills | Just need a quick browse |
| [LobeHub Skills](https://lobehub.com/skills) | Multi-category browseable | Looking for non-Web3 skills too |

---

## Design inspiration

> **When to use:** Want to invent a 5th, 6th style for `web-design-style/styles/`. Or want to compose blends.

### Per current style

**neo-brutalism**
- [neobrutalism.dev](https://www.neobrutalism.dev) — Tailwind-first component library
- [ekmas/neobrutalism-components](https://github.com/ekmas/neobrutalism-components) — open-source components
- [gumroad.com](https://www.gumroad.com), [ahrefs.com](https://www.ahrefs.com), [figma.com/blog](https://www.figma.com/blog) — live examples

**grunge**
- [are.na](https://www.are.na), [dispatch.show](https://www.dispatch.show), [workinprogress.fund](https://www.workinprogress.fund) — paper / zine aesthetic
- David Carson designs (Ray Gun magazine) — print reference

**retro-90s / Y2K**
- bratdiet.com (Brat album site)
- spacejam.com (1996 original — still up)
- yamsisland.com (Tyler, the Creator's IGOR site)
- Geocities archives / early MySpace

**awwwards-motion**
- [studio.locomotive.ca](https://studio.locomotive.ca), [studiothomas.com](https://studiothomas.com) — agency-tier motion
- [linear.app](https://linear.app), [vercel.com](https://vercel.com), [arc.net](https://arc.net) — motion timing reference
- [awwwards.com/sites_of_the_day](https://www.awwwards.com/sites_of_the_day) — daily inspiration feed

### Discovery hubs (style-agnostic)

- [awwwards.com/inspiration](https://www.awwwards.com/inspiration)
- [brutalist.org](https://www.brutalist.org) — directory of brutalist sites
- [siteinspire.com](https://www.siteinspire.com)

---

## Format & methodology

> **When to use:** Want to understand the Claude Code skill format itself (frontmatter conventions, `allowed-tools`, `argument-hint`, etc.).

- **max-taylor's `test-foundry/SKILL.md`** — best example of "expert persona + step-by-step methodology + extensive code samples" skill style.
- **doxielabs's `invariant-test-foundry/SKILL.md` + `references/`** — best example of "splitting heavy skill into focused skill + auxiliary reference doc" (similar pattern to our `templates/` and `styles/` folders).
- **HN Show HN — Arbitrum Stylus scaffold** ([thread](https://news.ycombinator.com/item?id=46898008)) — direct competitor to `new-hackathon-project` but Arbitrum-specific.

---

## How to integrate any of these

1. **For inspiration only**: read, take notes, don't fork. Most valuable for methodology and reference patterns.
2. **For one-time use**: clone to `/tmp/`, run, discard.
3. **For ongoing use**: install as Claude Code plugin if available (`claude plugin install`). Don't fork into our repo unless we're committed to maintaining it ourselves.
4. **For pattern adoption**: cherry-pick frontmatter conventions (`allowed-tools`, `argument-hint`), not content. Content adoption = skill bloat + maintenance burden.

## Rule of thumb (from this session)

- **Hackathon speed?** → use max-taylor's plugin as-is.
- **Audit production launch?** → use Trail of Bits or forefy.
- **Multi-chain audit beyond EVM?** → use forefy.
- **Just want invariant tests done well?** → use doxielabs's specifically.
- **Want broadest exploration?** → start with `rohitg00/awesome-claude-code-toolkit`.
- **None of the above fits?** → write your own here, in `my-claude-skills`.
