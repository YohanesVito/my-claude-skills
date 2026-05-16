---
name: grunge
description: Distressed, hand-made, anti-corporate. Aged paper bg, typewriter fonts, sepia/blood/olive palette, rough edges, tape strips, slight rotation, noise grain overlay, subtle jitter motion.
mood: distressed, raw, DIY, rebellious, lo-fi
era: 90s zines + punk + early-2000s anti-design revival
intensity_default: balanced
---

# Grunge

Cocok buat hackathon dApp yang mau terlihat **anti-establishment, anti-VC, raw**. DeFi privacy tools, anonymous protocols, cypherpunk vibe.

## Tokens

### Color palette

| Token | Hex | Use |
|---|---|---|
| `paper` | `#f4ede4` | Background utama, aged paper feel |
| `ink` | `#1a1611` | Foreground, almost black |
| `blood` | `#7d2027` | Primary accent — dried blood red |
| `olive` | `#4a5d23` | Secondary — military/decay green |
| `sepia` | `#8b6f47` | Aged photo tone |
| `mustard` | `#d4ae53` | Faded yellow, redacted highlight |
| `redact` | `#0d0a08` | Pure black for redactions |

**Rule:** 1 dominant warna accent per page (biasanya blood). Sepia + mustard untuk secondary. Olive sparingly.

**Detect Tailwind version first**: `grep tailwindcss package.json` → branch v3 atau v4.

#### Tailwind 4 (canonical)

```css
/* src/app/globals.css */
@import "tailwindcss";

@theme {
  --color-grunge-paper: #f4ede4;
  --color-grunge-ink: #1a1611;
  --color-grunge-blood: #7d2027;
  --color-grunge-olive: #4a5d23;
  --color-grunge-sepia: #8b6f47;
  --color-grunge-mustard: #d4ae53;
  --color-grunge-redact: #0d0a08;

  --font-display: "Permanent Marker", cursive;
  --font-sans: "Special Elite", monospace;
  --font-serif: "Courier Prime", serif;
}
```

#### Tailwind 3

```ts
theme: { extend: {
  colors: { grunge: { paper: '#f4ede4', ink: '#1a1611', blood: '#7d2027', olive: '#4a5d23', sepia: '#8b6f47', mustard: '#d4ae53', redact: '#0d0a08' } },
  fontFamily: {
    display: ['Permanent Marker', 'cursive'],
    sans: ['Special Elite', 'monospace'],
    serif: ['Courier Prime', 'serif'],
  },
}}
```

### Typography

| Use | Font | Weight | Case |
|---|---|---|---|
| Display (h1, posters) | Permanent Marker | 400 | UPPERCASE atau Mixed |
| Heading (h2-h4) | Special Elite | 400 | Sentence case |
| Body | Special Elite | 400 | sentence case |
| Mono / code / data | Courier Prime | 400/700 | as-is |

Sizes:
- Display: `text-5xl md:text-7xl`
- H2: `text-3xl md:text-4xl`
- Body: `text-base md:text-lg`

### Spacing & shape

- **Border radius: 0 atau sangat kecil** (1-2px max) — paper feels imperfect
- **Borders: hand-drawn feel** — irregular SVG borders atau `border-2 border-dashed`
- **Rotation kecil**: elemen di-rotate -2deg sampai +2deg. Bukan straight perfect grid.
- **Padding**: generous, paper has margins

### Texture (KEY differentiator)

Grunge tidak komplit tanpa overlay. Minimal:
- Grain/noise overlay di body
- Tape strips di pojok-pojok element
- Optional: paper texture background

Noise via inline SVG (preferred, no external dep):

```css
@layer base {
  body {
    background-color: var(--color-grunge-paper);
    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='3'/%3E%3CfeColorMatrix values='0 0 0 0 0.1 0 0 0 0 0.08 0 0 0 0 0.06 0 0 0 0.15 0'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
  }
}
```

### Motion

- **Duration**: 200-400ms, slight imperfection OK
- **Easing**: `ease-out` atau custom cubic-bezier
- **Hover**: subtle wiggle/jitter, atau tape-peel
- **Avoid**: clean linear transitions (kontradiksi mood-nya)

## Dependencies

```bash
bun add @fontsource/permanent-marker @fontsource/special-elite @fontsource/courier-prime
```

### Step A — Hapus default Geist

Sama seperti neo-brutalism: remove `Geist, Geist_Mono` imports dari `layout.tsx` + className references di `<html>`.

### Step B — @fontsource imports

```tsx
// src/app/layout.tsx (atas import "./globals.css")
import '@fontsource/permanent-marker/400.css'
import '@fontsource/special-elite/400.css'
import '@fontsource/courier-prime/400.css'
import '@fontsource/courier-prime/700.css'
import './globals.css'
```

### Step C — Base layer

```css
@layer base {
  body {
    background-color: var(--color-grunge-paper);
    color: var(--color-grunge-ink);
    font-family: var(--font-sans);
    /* noise overlay — see Texture section */
  }
  h1, h2, h3, h4 {
    font-family: var(--font-display);
  }
  *::selection {
    background: var(--color-grunge-blood);
    color: var(--color-grunge-paper);
  }
}
```

## Component patterns

### Button — primary
```tsx
<button className="
  bg-grunge-blood text-grunge-paper
  font-display text-lg uppercase
  px-6 py-3
  border-2 border-grunge-ink
  -rotate-1
  hover:rotate-1 hover:translate-y-[-2px]
  transition-transform duration-200
">
  Burn it down
</button>
```

### Button — secondary (typewriter feel)
```tsx
<button className="
  bg-transparent text-grunge-ink
  font-sans text-base
  px-4 py-2
  border-b-2 border-dashed border-grunge-ink
  hover:bg-grunge-mustard
  transition-colors duration-200
">
  → Read manifesto
</button>
```

### Card (polaroid-style)
```tsx
<div className="
  bg-grunge-paper p-6
  border border-grunge-ink/30
  shadow-[2px_2px_0_0_rgba(0,0,0,0.1),0_8px_24px_-8px_rgba(0,0,0,0.3)]
  rotate-[-1deg]
  relative
">
  {/* Tape strip */}
  <div className="absolute -top-3 left-6 w-16 h-6 bg-grunge-mustard/60 rotate-[-3deg] border border-grunge-ink/20" />
  <div className="text-xs uppercase font-serif tracking-widest text-grunge-sepia mb-2">
    Manifesto #03
  </div>
  <h3 className="font-display text-2xl mb-2">
    The protocol forgets you
  </h3>
  <p className="font-sans">
    No KYC. No emails. No analytics. Just code that runs.
  </p>
</div>
```

### Hero
```tsx
<section className="px-8 py-20 md:py-32 max-w-5xl mx-auto">
  <div className="inline-block bg-grunge-mustard/80 -rotate-1 px-3 py-1 mb-6 border border-grunge-ink/40 font-serif text-xs uppercase tracking-widest">
    Issue 01 • Underground
  </div>
  <h1 className="font-display text-5xl md:text-7xl leading-[1.05] mb-6 -rotate-[0.5deg]">
    Built by ghosts.<br/>
    <span className="bg-grunge-ink text-grunge-paper px-2 inline-block rotate-1">For ghosts.</span>
  </h1>
  <p className="font-sans text-lg md:text-xl max-w-2xl mb-8 leading-relaxed">
    An anonymous DEX that doesn't remember your wallet, your IP, or your jurisdiction.
    <span className="bg-grunge-redact text-grunge-redact select-none mx-1">[redacted]</span>
    pays the gas.
  </p>
  <div className="flex flex-wrap gap-4">
    <button className="bg-grunge-blood text-grunge-paper font-display text-lg uppercase px-6 py-3 border-2 border-grunge-ink -rotate-1 hover:rotate-1 transition-transform duration-200">
      Enter without trace
    </button>
    <button className="bg-transparent text-grunge-ink font-sans px-4 py-2 border-b-2 border-dashed border-grunge-ink hover:bg-grunge-mustard transition-colors duration-200">
      → Read the rules
    </button>
  </div>
</section>
```

### Nav
```tsx
<nav className="border-b border-dashed border-grunge-ink/40 px-8 py-4 flex items-center justify-between bg-grunge-paper/80 backdrop-blur-sm">
  <div className="font-display text-xl -rotate-1">
    ./<span className="bg-grunge-mustard/60 px-1">grunge</span>.zine
  </div>
  <div className="flex items-center gap-6 font-sans text-sm uppercase tracking-widest">
    {['Issues', 'Manifesto', 'Sigs'].map(l => (
      <a key={l} className="hover:bg-grunge-mustard/60 px-1 transition-colors duration-200 cursor-pointer">{l}</a>
    ))}
    <button className="bg-grunge-ink text-grunge-paper font-display px-3 py-1 -rotate-1 hover:rotate-1 transition-transform">
      Anon-in
    </button>
  </div>
</nav>
```

### Quote / pull
```tsx
<blockquote className="border-l-4 border-grunge-blood pl-6 py-2 my-8 font-serif text-xl italic text-grunge-sepia">
  "We're not asking permission anymore."
  <footer className="mt-2 text-sm uppercase tracking-widest text-grunge-olive">
    — anonymous, 2025
  </footer>
</blockquote>
```

### Footer
```tsx
<footer className="bg-grunge-ink text-grunge-paper px-8 py-12 mt-auto relative">
  <div className="absolute inset-0 opacity-20" style={{
    backgroundImage: "url(\"data:image/svg+xml,%3Csvg viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence baseFrequency='0.9'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E\")",
  }} />
  <div className="max-w-5xl mx-auto relative grid grid-cols-2 md:grid-cols-3 gap-8">
    <div>
      <div className="font-display text-2xl mb-4 -rotate-1">./grunge.zine</div>
      <p className="font-sans text-sm opacity-80">Burn after reading.</p>
    </div>
    <div>
      <div className="font-serif text-xs uppercase tracking-widest mb-3 text-grunge-mustard">Network</div>
      <ul className="space-y-2 font-sans text-sm">
        <li>Tor: <span className="font-mono">7g2x...onion</span></li>
        <li>Matrix: <span className="font-mono">#zine:anon</span></li>
      </ul>
    </div>
    <div>
      <div className="font-serif text-xs uppercase tracking-widest mb-3 text-grunge-mustard">Sig</div>
      <p className="font-mono text-xs opacity-60 leading-relaxed">
        BEGIN PGP<br/>
        QQbN/3lLLN2j+...<br/>
        END PGP
      </p>
    </div>
  </div>
</footer>
```

## Animation patterns

### Hover wiggle (default for buttons/interactive)
```css
.grunge-interactive {
  transition: transform 200ms ease-out;
  transform: rotate(-1deg);
}
.grunge-interactive:hover {
  transform: rotate(1deg) translateY(-2px);
}
```

### Text jitter (subtle, for headlines)
```css
@keyframes grunge-jitter {
  0%, 100% { transform: translate(0, 0); }
  20% { transform: translate(-0.5px, 0.5px); }
  40% { transform: translate(0.5px, -0.5px); }
  60% { transform: translate(-0.5px, -0.5px); }
  80% { transform: translate(0.5px, 0.5px); }
}
.grunge-jitter {
  animation: grunge-jitter 0.3s steps(1) infinite;
}
.grunge-jitter:hover { animation: none; }
```

### Tape peel-in (entrance)
```tsx
<motion.div
  initial={{ opacity: 0, rotate: -8, y: -20 }}
  whileInView={{ opacity: 1, rotate: -1, y: 0 }}
  transition={{ duration: 0.4, ease: [0.16, 1, 0.3, 1] }}
  viewport={{ once: true }}
>
```

## Do

- ✅ Slight rotation pada element (-2deg to +2deg)
- ✅ Noise/grain overlay di body
- ✅ Typewriter fonts untuk body, marker untuk display
- ✅ Tape strips, redacted text, hand-drawn underlines
- ✅ Muted desaturated palette
- ✅ Asymmetric, imperfect layouts
- ✅ Quote/manifesto blockquotes
- ✅ Mono untuk addresses/sigs/cryptography stuff

## Don't

- ❌ NO clean perfect grids
- ❌ NO bright saturated colors (kecuali sebagai 1 accent stark)
- ❌ NO smooth ease-in-out yang berlebihan
- ❌ NO gradients glossy
- ❌ NO Inter/SF Pro/Geist fonts (modern clean = anti-grunge)
- ❌ NO border-radius besar (corners selalu sharp atau dirty)
- ❌ NO Lorem ipsum — pakai copy yang feels handwritten/manifesto

## References

Inspirasi:
- https://www.are.na — community-curated, grungy academic vibe
- https://www.dispatch.show — newsletter aesthetic with paper feel
- https://www.workinprogress.fund — paper, zine layouts
- Old David Carson designs (Ray Gun magazine)
- Cypherpunk Manifesto, 2600 Magazine

Tooling:
- Lucide icons + offset positioning
- Inline SVG for grain (no extra dep)
- `framer-motion` optional, untuk entrance only

Anti-examples:
- linear.app — opposite (clean, modern)
- stripe.com — too polished
