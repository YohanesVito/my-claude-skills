---
name: web-design-style
description: Apply non-mainstream, opinionated design styles (retro, grunge, neo-brutalism, awwwards-motion, cyberpunk, hand-drawn, etc.) to a Next.js + Tailwind + Bun frontend. TRIGGER when user wants to style their FE with a specific aesthetic, restyle existing UI with a vibe, asks "bikin gaya X", "apply Y style", references a style by name, or provides a reference URL/screenshot to match. SKIP for generic shadcn UI work, standard component generation, or when no style is specified.
---

# Web Design Style Applicator

Applies opinionated, non-mainstream design styles to Next.js + Tailwind + Bun projects. Built for hackathon FE that needs to *stand out* on judging day.

## Two input modes (auto-detect from user phrasing)

### Mode A — Preset
User names a style: *"pakai grunge"*, *"apply neo-brutalism"*, *"make it awwwards-level"*.
→ Read `./styles/<slug>.md` and follow its spec exactly.

### Mode B — Reference-driven
User pastes a URL or screenshot: *"kayak https://bratdiet.com"*, *"gaya kayak gambar ini"*.
→
1. URL: use `WebFetch` to grab the page, extract visual cues from HTML/CSS/copy
2. Image: read it directly and describe across the 6 axes (below)
3. Match to closest preset in `./styles/` → use as **base**
4. **Override** base preset with extracted details (palette, fonts, motion)
5. Confirm interpretation with user before generating ("aku baca styles ini: X, Y, Z — lanjut?")

### Mode C — Hybrid / blend
*"retro 90s tapi pakai serif, bukan pixel"*, *"70% brutalism + 30% editorial"*.
→ Load preset as base, apply textual overrides. For blends, pick dominant style as base, borrow specific axes from secondary.

## The 6 axes every style is defined by

1. **Color palette** — primary, secondary, accent, bg, fg, semantic
2. **Typography** — heading font, body font, mono, weights, tracking
3. **Spacing & shape** — radius, border width, padding rhythm
4. **Motion** — easing, duration, hover, scroll-tied, page transitions
5. **Texture & imagery** — noise, gradients, patterns, custom cursor
6. **Dependencies** — `bun add ...` commands required

Every `./styles/*.md` file MUST define all 6.

## Scope detection (ask user upfront)

After style is locked, ask which scope:

1. **Theme config only** — write `tailwind.config.ts`, `src/app/globals.css`, font imports in `src/app/layout.tsx`. User builds components manually after.
2. **Full page from scratch** — generate `src/app/<route>/page.tsx` with hero + 2-3 sections + footer, all styled.
3. **Re-style existing FE** — read named components/pages, rewrite preserving structure but applying tokens.
4. **Per-component** — only the named file (e.g. `src/components/Button.tsx`).

## Workflow

### Step 1 — Detect mode & gather inputs

Batch in one message:
- Style (preset slug OR reference URL OR image OR description)
- Scope (one of the 4 above)
- If scope ≠ theme-only: target route/component path(s)
- Optional: blend modifiers ("but use X font instead")

### Step 2 — Load style spec

- **Mode A**: `Read` the file `./styles/<slug>.md`. If missing, list available styles in `./styles/` and ask user to pick.
- **Mode B**: `WebFetch` URL or read image. Synthesize a temporary token spec across the 6 axes. Match to closest preset as base. Confirm interpretation back to user.
- **Mode C**: Load preset, parse user's override instructions, modify in-memory.

### Step 3 — Install dependencies

Run the `bun add` commands from the style spec. Skip packages already in `package.json`.

### Step 4 — Apply by scope

- **Theme config only**:
  - **Detect Tailwind version first**: `grep tailwindcss package.json` → branch to v3 or v4 path (see Stack Quirks below)
  - v4: write tokens via `@theme { ... }` block in `src/app/globals.css`
  - v3: extend `tailwind.config.ts` with colors, font families, custom shadows, radius
  - Add font imports to `src/app/layout.tsx` **after removing default Geist** (see Stack Quirks)
  - Update `globals.css` base layer
  - Do NOT touch existing components

- **Full page from scratch**:
  - Apply theme config first (above)
  - Write `src/app/<route>/page.tsx` using component patterns from the style file
  - Include hero, ≥2 content sections, footer
  - Use real placeholder copy (not Lorem ipsum) — make it sound like a hackathon dApp

- **Re-style existing**:
  - Apply theme config first
  - For each target component: `Read` it, then rewrite className strings and structure while preserving props/state/logic
  - DO NOT change component behavior or break existing imports

- **Per-component**:
  - Skip theme config (assume user wants isolated change)
  - Rewrite only the named file using inline styling

### Step 5 — Validate

- `bun run lint` (with `--fix` if available)
- `bun run build` — must pass; if fails, fix and retry once
- Tell user: `bun run dev` to preview

## Stack quirks (Next.js + Bun, late 2025+)

These are real gaps found during skill testing. Style files inherit these rules:

1. **Tailwind 4 is default** — `create-next-app@latest --tailwind` generates Tailwind 4 (CSS-only config via `@theme`), not 3. Always check `package.json` first. Most style files document both, with v4 as canonical.

2. **Default Geist font must be removed** — `layout.tsx` imports `Geist` and `Geist_Mono` from `next/font/google` and sets `--font-geist-sans/--font-geist-mono` CSS vars. If we add `@fontsource` fonts without removing these, the variables clash. Always strip Geist imports + className references on `<html>` before adding new fonts.

3. **`--no-git` flag may be ignored** — recent `create-next-app` versions init git regardless. If running scaffold workflow, check `.git` existence before `git init`.

4. **Auto-generated `CLAUDE.md` / `AGENTS.md`** — recent `create-next-app` versions drop these into project root. Leave alone unless user asks to customize.

5. **`@apply` flaky in Tailwind 4 `@layer base`** — prefer raw CSS with `var(--color-*)` for base styles. Reserve `@apply` for compound utility classes when needed.

## Composing & blending styles

When user says "X + Y" or "X tapi sentuhan Y":
- Pick dominant style as base
- Borrow specific axes from secondary (usually color or typography)
- ALWAYS confirm composition back to user before generating

## Reference-mode quality bar

When fetching a URL:
- Look for: font families (search HTML for `font-family`, `fonts.googleapis.com`, `@font-face`)
- Color palette: scan `style` attrs and inline CSS for hex/rgb values; pick most-frequent foreground/background
- Motion: look for `gsap`, `framer-motion`, `lenis`, `locomotive-scroll` in script tags
- Layout vibe: density (lots of whitespace vs packed?), grid vs asymmetric
- Output: a 6-axis summary back to user before generating

If extraction is too thin, fall back: ask user to describe the reference in their own words, or pick a closest preset.

## Failure modes

- **Style file not found**: list `./styles/*.md` slugs, ask user to pick or describe
- **Reference URL unreachable**: ask for alt URL or description
- **Existing component too tangled**: read it, ask user "ini struktur kompleks, rewrite full atau cuma className-nya?"
- **`bun run build` fails after restyle**: revert the failing file, report what broke, do NOT auto-rewrite again

## What NOT to do

- Do not invent style files that aren't in `./styles/` — fall back to mode B or ask
- Do not silently change component behavior during re-style
- Do not pick "safe" defaults when the style file says "be loud" — follow the spec's DOs/DON'Ts strictly
- Do not generate Lorem ipsum copy — write something thematic
- Do not skip the dependency install step — missing fonts break the whole vibe
