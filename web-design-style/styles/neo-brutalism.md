---
name: neo-brutalism
description: Chunky, confrontational, anti-corporate. Hard black borders, offset hard shadows, bright primary colors, uppercase bold typography. No gradients, no radius, no soft easing.
mood: chunky, loud, confrontational, anti-corporate, playful
era: 2020s revival (rooted in 1950s architectural Brutalism)
intensity_default: balanced
---

# Neo-Brutalism

Pakai gaya ini kalau project butuh **stand out & terlihat opinionated**. Cocok buat hackathon karena instant recognizable & memorable di mata judge.

## Tokens

### Color palette

| Token | Light mode | Dark mode |
|---|---|---|
| `bg` | `#FEFEFE` | `#0A0A0A` |
| `ink` | `#000000` | `#FFFFFF` |
| `yellow` | `#FFD93D` | `#FFD93D` |
| `red` | `#FF6B6B` | `#FF4747` |
| `green` | `#6BCB77` | `#4ADE80` |
| `blue` | `#4D96FF` | `#60A5FA` |
| `pink` | `#FF8FB1` | `#F472B6` |
| `purple` | `#A78BFA` | `#A78BFA` |

**Rule: pakai 2-3 warna primary per page max.** Semua sekaligus = chaos, bukan brutalism.

**Detect Tailwind version first**: `grep tailwindcss package.json` → kalau `^4.x` pakai @theme (canonical), kalau `^3.x` pakai config file.

#### Tailwind 4 (canonical, default di create-next-app 2025+)

Tailwind 4 pakai CSS-only config via `@theme` di `globals.css` — **tidak ada `tailwind.config.ts`**.

```css
/* src/app/globals.css */
@import "tailwindcss";

@theme {
  --color-brut-bg: #fefefe;
  --color-brut-ink: #000000;
  --color-brut-yellow: #ffd93d;
  --color-brut-red: #ff6b6b;
  --color-brut-green: #6bcb77;
  --color-brut-blue: #4d96ff;
  --color-brut-pink: #ff8fb1;
  --color-brut-purple: #a78bfa;

  --shadow-brut-sm: 4px 4px 0 0 #000;
  --shadow-brut: 8px 8px 0 0 #000;
  --shadow-brut-lg: 12px 12px 0 0 #000;
  --shadow-brut-hover: 4px 4px 0 0 #000;
  --shadow-brut-active: 0px 0px 0 0 #000;

  --font-display: "Archivo Black", sans-serif;
  --font-sans: "Space Grotesk", sans-serif;
  --font-mono: "JetBrains Mono", monospace;
}
```

Tailwind 4 auto-generate utility dari `--color-*` (→ `bg-brut-yellow`), `--shadow-*` (→ `shadow-brut`), `--font-*` (→ `font-display`). Tidak perlu `extend` config. Hapus block `:root` & `@theme inline` default yang ada di template — kita pakai brut tokens langsung.

#### Tailwind 3 (legacy projects)

```ts
// tailwind.config.ts
theme: {
  extend: {
    colors: { brut: { bg: '#FEFEFE', ink: '#000000', yellow: '#FFD93D', red: '#FF6B6B', green: '#6BCB77', blue: '#4D96FF', pink: '#FF8FB1', purple: '#A78BFA' } },
    boxShadow: {
      'brut-sm': '4px 4px 0 0 #000',
      'brut': '8px 8px 0 0 #000',
      'brut-lg': '12px 12px 0 0 #000',
      'brut-hover': '4px 4px 0 0 #000',
      'brut-active': '0px 0px 0 0 #000',
    },
    fontFamily: {
      display: ['Archivo Black', 'sans-serif'],
      sans: ['Space Grotesk', 'sans-serif'],
      mono: ['JetBrains Mono', 'monospace'],
    },
  },
}
```

### Typography

| Use | Font | Weight | Tracking | Case |
|---|---|---|---|---|
| Display (h1, hero) | Archivo Black | 900 | tight (-0.02em) | UPPERCASE |
| Heading (h2-h4) | Space Grotesk | 700 | normal | UPPERCASE or Sentence |
| Body | Space Grotesk | 500 | normal | sentence |
| Mono / data | JetBrains Mono | 500 | normal | as-is |

Sizes:
- Display: `text-6xl md:text-8xl`
- H2: `text-4xl md:text-5xl`
- H3: `text-2xl md:text-3xl`
- Body: `text-base md:text-lg`

### Spacing & shape

- **Border radius: 0** — sharp corners always
- **Border: 4px solid `brut-ink`** — di semua elemen yang punya bg
- **Padding generous** — minimal `p-4`, hero/section `p-8` to `p-16`
- **Gap chunky** — `gap-4` minimum, `gap-6` standard

### Shadows

Offset hard shadow, **no blur**:
- Small element (badge, input): `shadow-brut-sm` (4px)
- Standard (button, card): `shadow-brut` (8px)
- Hero / featured: `shadow-brut-lg` (12px)

Hover: shadow shrinks + element shifts toward shadow direction (illusion of being "pressed").

### Motion

- **Duration**: 100ms snap, atau 0ms instant
- **Easing**: `ease-linear` only. Avoid `ease-in-out`.
- **Transform**: translate by shadow offset

## Dependencies

```bash
bun add @fontsource/archivo-black @fontsource/space-grotesk @fontsource/jetbrains-mono
```

### Step A — Hapus default Geist font

`create-next-app` inject Geist + Geist_Mono di `src/app/layout.tsx`. Hapus dulu sebelum tambahin font kita, biar `--font-sans` var nggak bentrok:

```tsx
// REMOVE these lines from src/app/layout.tsx:
import { Geist, Geist_Mono } from "next/font/google";
const geistSans = Geist({ variable: "--font-geist-sans", subsets: ["latin"] });
const geistMono = Geist_Mono({ variable: "--font-geist-mono", subsets: ["latin"] });
// AND remove the className={`${geistSans.variable} ${geistMono.variable} ...`} on <html>
```

### Step B — Tambah @fontsource imports

```tsx
// src/app/layout.tsx (di atas import "./globals.css")
import '@fontsource/archivo-black/400.css'
import '@fontsource/space-grotesk/500.css'
import '@fontsource/space-grotesk/700.css'
import '@fontsource/jetbrains-mono/500.css'
import './globals.css'
```

### Step C — Base layer di `globals.css`

**Tailwind 4 — pakai raw CSS dengan `var()`** (lebih reliable daripada `@apply` di v4):

```css
@layer base {
  body {
    background: var(--color-brut-bg);
    color: var(--color-brut-ink);
    font-family: var(--font-sans);
    font-weight: 500;
  }
  h1, h2, h3, h4 {
    font-family: var(--font-display);
    text-transform: uppercase;
    letter-spacing: -0.02em;
  }
  *::selection {
    background: var(--color-brut-yellow);
    color: var(--color-brut-ink);
  }
}
```

**Tailwind 3 — `@apply` aman**:

```css
@layer base {
  body { @apply bg-brut-bg text-brut-ink font-sans; }
  h1, h2, h3, h4 { @apply font-display uppercase tracking-tight; }
  *::selection { @apply bg-brut-yellow text-brut-ink; }
}
```

## Component patterns

### Button — primary
```tsx
<button className="
  bg-brut-yellow text-brut-ink
  border-4 border-brut-ink
  font-display uppercase tracking-tight
  px-6 py-3 text-lg
  shadow-brut
  transition-all duration-100 ease-linear
  hover:translate-x-1 hover:translate-y-1 hover:shadow-brut-hover
  active:translate-x-2 active:translate-y-2 active:shadow-brut-active
">
  Get Started
</button>
```

### Button — secondary (inverted)
```tsx
<button className="
  bg-brut-bg text-brut-ink
  border-4 border-brut-ink
  font-display uppercase tracking-tight
  px-6 py-3 text-lg
  shadow-brut
  transition-all duration-100 ease-linear
  hover:bg-brut-pink
  hover:translate-x-1 hover:translate-y-1 hover:shadow-brut-hover
  active:translate-x-2 active:translate-y-2 active:shadow-brut-active
">
  Learn More
</button>
```

### Card
```tsx
<div className="bg-brut-bg border-4 border-brut-ink p-6 shadow-brut">
  <div className="inline-block bg-brut-pink border-2 border-brut-ink px-2 py-1 mb-3 text-xs font-bold uppercase">
    Feature
  </div>
  <h3 className="font-display uppercase text-2xl mb-2 tracking-tight">
    Card Title
  </h3>
  <p className="font-medium text-base">
    Card body text. Direct, no fluff.
  </p>
</div>
```

### Hero
```tsx
<section className="bg-brut-yellow border-b-4 border-brut-ink px-8 py-16 md:py-24">
  <div className="max-w-5xl mx-auto">
    <div className="inline-block bg-brut-bg border-4 border-brut-ink px-3 py-1 mb-6 text-sm font-bold uppercase shadow-brut-sm">
      🏁 New • v1.0
    </div>
    <h1 className="font-display uppercase text-6xl md:text-8xl tracking-tight leading-[0.9] mb-6">
      Big.<br/>
      <span className="bg-brut-bg border-4 border-brut-ink px-2 inline-block">Loud.</span><br/>
      Hackathon-ready.
    </h1>
    <p className="text-xl md:text-2xl font-medium max-w-2xl mb-8">
      A dApp that does X for Y users who hate Z.
    </p>
    <div className="flex flex-wrap gap-4">
      <button className="bg-brut-ink text-brut-bg border-4 border-brut-ink font-display uppercase px-6 py-3 text-lg shadow-brut hover:translate-x-1 hover:translate-y-1 hover:shadow-brut-hover transition-all duration-100 ease-linear">
        Launch App
      </button>
      <button className="bg-brut-bg text-brut-ink border-4 border-brut-ink font-display uppercase px-6 py-3 text-lg shadow-brut hover:bg-brut-pink hover:translate-x-1 hover:translate-y-1 hover:shadow-brut-hover transition-all duration-100 ease-linear">
        View Demo
      </button>
    </div>
  </div>
</section>
```

### Nav
```tsx
<nav className="border-b-4 border-brut-ink bg-brut-bg px-8 py-4 flex items-center justify-between">
  <div className="font-display uppercase text-2xl tracking-tight">
    Brand<span className="bg-brut-yellow border-2 border-brut-ink px-1 ml-1">Name</span>
  </div>
  <div className="flex items-center gap-2">
    {['Docs', 'Pricing', 'Github'].map(label => (
      <a key={label} className="border-4 border-brut-ink px-4 py-2 font-bold uppercase text-sm hover:bg-brut-yellow transition-colors duration-100 ease-linear">
        {label}
      </a>
    ))}
    <button className="bg-brut-blue text-brut-ink border-4 border-brut-ink font-display uppercase px-4 py-2 text-sm shadow-brut-sm hover:translate-x-0.5 hover:translate-y-0.5 hover:shadow-none transition-all duration-100 ease-linear">
      Connect Wallet
    </button>
  </div>
</nav>
```

### Input field
```tsx
<label className="block">
  <span className="block font-bold uppercase text-sm mb-2">Wallet Address</span>
  <input
    type="text"
    placeholder="0x..."
    className="w-full bg-brut-bg border-4 border-brut-ink px-4 py-3 font-mono text-base focus:outline-none focus:bg-brut-yellow placeholder:text-brut-ink/50"
  />
</label>
```

### Badge / tag
```tsx
<span className="inline-block bg-brut-green border-2 border-brut-ink px-2 py-0.5 text-xs font-bold uppercase">
  Live on Mantle
</span>
```

### Stat card (data-heavy)
```tsx
<div className="bg-brut-bg border-4 border-brut-ink p-6 shadow-brut">
  <div className="font-bold uppercase text-xs mb-2">TVL</div>
  <div className="font-display text-5xl tracking-tight">$1.2M</div>
  <div className="mt-2 inline-block bg-brut-green border-2 border-brut-ink px-2 py-0.5 text-xs font-bold">
    +12.4% 24h
  </div>
</div>
```

### Footer
```tsx
<footer className="bg-brut-ink text-brut-bg border-t-4 border-brut-ink px-8 py-12">
  <div className="max-w-5xl mx-auto grid grid-cols-2 md:grid-cols-4 gap-8">
    <div>
      <div className="font-display uppercase text-2xl tracking-tight mb-4">Brand</div>
      <p className="text-sm font-medium">Built for hackers, by hackers.</p>
    </div>
    {[
      ['Product', ['Docs', 'API', 'Status']],
      ['Community', ['Discord', 'Twitter', 'GitHub']],
      ['Legal', ['Terms', 'Privacy']],
    ].map(([title, links]) => (
      <div key={title as string}>
        <div className="font-bold uppercase text-sm mb-3">{title as string}</div>
        <ul className="space-y-2">
          {(links as string[]).map(l => (
            <li key={l}>
              <a className="text-sm hover:bg-brut-yellow hover:text-brut-ink px-1">{l}</a>
            </li>
          ))}
        </ul>
      </div>
    ))}
  </div>
</footer>
```

## Animation patterns

### Standard interactive (default for button/link/card)
Hover shifts element 4px toward shadow direction; shadow shrinks proportionally. Snap motion.

```css
.brut-interactive {
  @apply transition-all duration-100 ease-linear shadow-brut;
}
.brut-interactive:hover {
  @apply translate-x-1 translate-y-1 shadow-brut-hover;
}
.brut-interactive:active {
  @apply translate-x-2 translate-y-2 shadow-brut-active;
}
```

### Attention CTA (1 per page max)
Light wobble loop for primary CTA that needs to grab the eye:

```css
@keyframes brut-wobble {
  0%, 100% { transform: rotate(0deg); }
  25% { transform: rotate(-1deg); }
  75% { transform: rotate(1deg); }
}
.brut-wobble {
  animation: brut-wobble 1.5s ease-in-out infinite;
}
.brut-wobble:hover { animation: none; }
```

### Section reveal (use sparingly)
Hard slide-in — no fade (fades feel "smooth", anti-brutalist):

```tsx
<motion.div
  initial={{ x: -40, opacity: 0 }}
  whileInView={{ x: 0, opacity: 1 }}
  transition={{ duration: 0.15, ease: 'linear' }}
  viewport={{ once: true }}
>
  …content
</motion.div>
```

## Do

- ✅ Hard offset shadows (8px+, no blur)
- ✅ Thick black borders (4px) on bg'd elements
- ✅ UPPERCASE `font-display` headlines
- ✅ 2-3 clashing primary colors per page max
- ✅ Asymmetric, off-grid OK
- ✅ Inline "stickers" — bordered tags inside heading/paragraph
- ✅ Snap motion (100ms linear)
- ✅ Generous padding (no cramped feel)
- ✅ Specific, direct copy

## Don't

- ❌ NO gradients (kecuali stripe pattern as texture)
- ❌ NO border-radius (sharp corners always)
- ❌ NO soft shadows or blurs
- ❌ NO light font weight (anything below 500)
- ❌ NO `ease-in-out` (snap, not smooth)
- ❌ NO pastel-only palette (need contrast)
- ❌ NO fade-in animations
- ❌ NO Lorem ipsum (write thematic copy)

## References

Inspirasi:
- https://www.gumroad.com — pioneer of the revival
- https://www.brutalist.org — directory of brutalist sites
- https://www.ahrefs.com — semi-brutalist (yellow + hard shadows)
- https://www.figma.com/blog — neo-brutalist influences

Tooling:
- https://www.neobrutalism.dev — Tailwind-first component library
- https://github.com/ekmas/neobrutalism-components — open-source components

Anti-examples (study what NOT to copy):
- linear.app — refined, soft, opposite end
- vercel.com — modern minimal, anti-brutalist
