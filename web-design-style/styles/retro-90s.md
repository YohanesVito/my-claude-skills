---
name: retro-90s
description: 90s/Y2K web aesthetic. Pixel fonts, hot pink + electric blue + lime, hard pixel shadows, marquee, blink, sparkle decorations, scanlines, lavender background. Playful and chaotic.
mood: nostalgic, playful, chaotic, technicolor
era: 1995-2003 (Geocities → early MySpace)
intensity_default: balanced
---

# Retro 90s / Y2K

Cocok buat NFT mint pages, on-chain games, meme-coins, atau apapun yang mau **playful & memorable**. Bukan corporate finance. Loud.

## Tokens

### Color palette

| Token | Hex | Use |
|---|---|---|
| `bg` | `#fff0f5` | Lavender blush — pas Y2K vibe |
| `bgDark` | `#0a0a2e` | Deep space alt bg |
| `ink` | `#0a0a0a` | Foreground utama |
| `hotpink` | `#ff00ff` | Magenta — signature 90s |
| `cyan` | `#00ffff` | Electric blue |
| `lime` | `#00ff00` | Pure green |
| `yellow` | `#ffff00` | Pure yellow |
| `purple` | `#8b00ff` | Deep violet |
| `silver` | `#c0c0c0` | Holographic chrome |

**Rule:** 3-4 warna sekaligus OK (kebalikan dari neo-brutalism). Chaos = retro. Tapi pakai pasangan klasik: hotpink+cyan, lime+purple, yellow+hotpink.

**Detect Tailwind version first**: `grep tailwindcss package.json`.

#### Tailwind 4 (canonical)

```css
@import "tailwindcss";

@theme {
  --color-y2k-bg: #fff0f5;
  --color-y2k-bg-dark: #0a0a2e;
  --color-y2k-ink: #0a0a0a;
  --color-y2k-hotpink: #ff00ff;
  --color-y2k-cyan: #00ffff;
  --color-y2k-lime: #00ff00;
  --color-y2k-yellow: #ffff00;
  --color-y2k-purple: #8b00ff;
  --color-y2k-silver: #c0c0c0;

  --shadow-pixel-sm: 2px 2px 0 0 #000;
  --shadow-pixel: 4px 4px 0 0 #000;
  --shadow-pixel-lg: 6px 6px 0 0 #000;
  --shadow-glow-pink: 0 0 12px #ff00ff;
  --shadow-glow-cyan: 0 0 12px #00ffff;

  --font-pixel: "Press Start 2P", monospace;
  --font-terminal: "VT323", monospace;
  --font-mono: "Major Mono Display", monospace;
}
```

#### Tailwind 3

```ts
theme: { extend: {
  colors: { y2k: { bg: '#fff0f5', 'bg-dark': '#0a0a2e', ink: '#0a0a0a', hotpink: '#ff00ff', cyan: '#00ffff', lime: '#00ff00', yellow: '#ffff00', purple: '#8b00ff', silver: '#c0c0c0' } },
  boxShadow: { 'pixel-sm': '2px 2px 0 0 #000', 'pixel': '4px 4px 0 0 #000', 'pixel-lg': '6px 6px 0 0 #000', 'glow-pink': '0 0 12px #ff00ff', 'glow-cyan': '0 0 12px #00ffff' },
  fontFamily: { pixel: ['"Press Start 2P"', 'monospace'], terminal: ['VT323', 'monospace'], mono: ['"Major Mono Display"', 'monospace'] },
}}
```

### Typography

| Use | Font | Size | Case |
|---|---|---|---|
| Hero / pixel display | Press Start 2P | `text-3xl md:text-5xl` (smaller — pixel fonts feel big) | UPPERCASE |
| Headings | VT323 | `text-4xl md:text-6xl` | as-is |
| Body / terminal | VT323 | `text-xl md:text-2xl` | as-is |
| Stylized labels | Major Mono Display | normal | UPPERCASE |

**Note:** Press Start 2P sangat condensed — pakai size kecil. VT323 longgar — pakai size besar (2x).

### Spacing & shape

- **Border radius: 0** (pixel-style sharp)
- **Borders: 2-4px solid black** untuk pixel button feel
- **Cursor:** Custom pixel cursor (URL ke pixel arrow PNG/SVG)
- **Layout:** OK kalau busy, padded, table-feel

### Shadows

- Pixel shadows: small 2px, standard 4px, large 6px (offset hard, no blur)
- Neon glow shadows untuk highlight: `shadow-glow-pink`, `shadow-glow-cyan`

### Texture & decorations

- **Scanlines overlay** di body (CSS gradient)
- **Sparkle/star** SVG decorations
- **Marquee** banner di hero atau footer
- **Gradient mesh** background sebagai feature section

Scanlines CSS:
```css
body::after {
  content: '';
  position: fixed; inset: 0;
  pointer-events: none;
  background: repeating-linear-gradient(
    0deg,
    rgba(0,0,0,0.05) 0px,
    rgba(0,0,0,0.05) 1px,
    transparent 1px,
    transparent 3px
  );
  z-index: 9999;
}
```

### Motion

- **Marquee** untuk announcement bars
- **Blink** untuk attention text (`animation: blink 1s steps(1) infinite`)
- **Bounce** on hover untuk buttons
- **Sparkle particles** floating
- **Gradient shift** untuk hero background

## Dependencies

```bash
bun add @fontsource/press-start-2p @fontsource/vt323 @fontsource/major-mono-display
```

### Step A — Hapus Geist (sama seperti lainnya)

### Step B — @fontsource imports

```tsx
import '@fontsource/press-start-2p/400.css'
import '@fontsource/vt323/400.css'
import '@fontsource/major-mono-display/400.css'
import './globals.css'
```

### Step C — Base layer

```css
@layer base {
  body {
    background: var(--color-y2k-bg);
    color: var(--color-y2k-ink);
    font-family: var(--font-terminal);
  }
  h1, h2, h3 {
    font-family: var(--font-pixel);
    line-height: 1.2;
  }
  *::selection {
    background: var(--color-y2k-hotpink);
    color: var(--color-y2k-yellow);
  }
}
```

## Component patterns

### Button — pixel chunky
```tsx
<button className="
  bg-y2k-hotpink text-y2k-yellow
  font-pixel text-sm
  px-4 py-3
  border-4 border-y2k-ink
  shadow-pixel
  hover:translate-x-1 hover:translate-y-1 hover:shadow-pixel-sm
  active:shadow-none active:translate-x-2 active:translate-y-2
  transition-all duration-100 ease-linear
">
  CLICK ME
</button>
```

### Button — terminal glow
```tsx
<button className="
  bg-y2k-bg-dark text-y2k-cyan
  font-terminal text-2xl
  px-6 py-2
  border-2 border-y2k-cyan
  shadow-glow-cyan
  hover:bg-y2k-cyan hover:text-y2k-bg-dark
  transition-colors duration-200
">
  &gt;&gt; ENTER &lt;&lt;
</button>
```

### Card — gradient mesh
```tsx
<div className="
  relative p-6 border-4 border-y2k-ink shadow-pixel
  bg-gradient-to-br from-y2k-hotpink via-y2k-yellow to-y2k-cyan
">
  <div className="bg-y2k-bg border-2 border-y2k-ink p-4">
    <div className="font-pixel text-xs mb-2 bg-y2k-ink text-y2k-lime inline-block px-1">
      ★ FEATURE ★
    </div>
    <h3 className="font-pixel text-base mb-2">PIXEL MINT</h3>
    <p className="font-terminal text-xl leading-tight">
      mint your token in 8 bits of glory
    </p>
  </div>
</div>
```

### Hero
```tsx
<section className="px-8 py-12 md:py-20 bg-y2k-bg-dark text-y2k-yellow relative overflow-hidden">
  {/* Marquee */}
  <div className="absolute top-0 left-0 right-0 bg-y2k-hotpink text-y2k-ink border-b-4 border-y2k-ink overflow-hidden">
    <div className="font-pixel text-xs py-2 whitespace-nowrap retro-marquee">
      ★ WELCOME TO THE WEB3 INTERNET ★ EST 2025 ★ MAKE IT WEIRD ★ NEW FEATURES UNLOCKED ★&nbsp;&nbsp;&nbsp;&nbsp;
    </div>
  </div>

  <div className="max-w-5xl mx-auto pt-16">
    <div className="inline-block bg-y2k-lime text-y2k-ink font-pixel text-xs px-2 py-1 mb-4 border-2 border-y2k-ink shadow-pixel-sm">
      ✨ NEW! ✨
    </div>
    <h1 className="font-pixel text-2xl md:text-5xl leading-[1.4] mb-6">
      <span className="text-y2k-hotpink">PIXEL</span>{" "}
      <span className="text-y2k-cyan">MINT</span><br/>
      <span className="text-y2k-yellow">DOT</span>{" "}
      <span className="text-y2k-lime">EXE</span>
    </h1>
    <p className="font-terminal text-2xl md:text-3xl max-w-2xl mb-8 text-y2k-silver">
      mint your nft using buttons that look like windows 98.
      blink. <span className="retro-blink">_</span>
    </p>
    <div className="flex flex-wrap gap-4">
      <button className="bg-y2k-hotpink text-y2k-yellow font-pixel text-sm px-4 py-3 border-4 border-y2k-yellow shadow-pixel hover:translate-x-1 hover:translate-y-1 hover:shadow-pixel-sm transition-all duration-100">
        MINT NOW
      </button>
      <button className="bg-transparent text-y2k-cyan font-terminal text-2xl px-6 py-2 border-2 border-y2k-cyan shadow-glow-cyan hover:bg-y2k-cyan hover:text-y2k-bg-dark transition-colors duration-200">
        &gt;&gt; HOW IT WORKS &lt;&lt;
      </button>
    </div>
  </div>

  {/* Sparkle decorations */}
  <div className="absolute top-20 right-12 text-y2k-yellow text-4xl retro-spin">✦</div>
  <div className="absolute bottom-12 left-12 text-y2k-cyan text-3xl retro-spin">✧</div>
  <div className="absolute top-40 left-1/3 text-y2k-hotpink text-2xl retro-spin" style={{ animationDelay: '0.5s' }}>★</div>
</section>
```

### Nav
```tsx
<nav className="bg-y2k-cyan border-b-4 border-y2k-ink px-6 py-3 flex items-center justify-between">
  <div className="font-pixel text-sm text-y2k-ink">
    [<span className="bg-y2k-hotpink text-y2k-yellow px-1 mx-1">PIXEL.MINT</span>]
  </div>
  <div className="flex items-center gap-2">
    {['HOME', 'MINT', 'STAKE', 'WTF'].map(l => (
      <a key={l} className="font-pixel text-xs px-2 py-1 border-2 border-y2k-ink hover:bg-y2k-yellow transition-colors cursor-pointer">
        {l}
      </a>
    ))}
    <button className="font-pixel text-xs bg-y2k-hotpink text-y2k-yellow px-2 py-1 border-2 border-y2k-ink shadow-pixel-sm hover:translate-x-0.5 hover:translate-y-0.5 hover:shadow-none transition-all">
      0xCONNECT
    </button>
  </div>
</nav>
```

### Visitor counter (footer accent)
```tsx
<div className="font-terminal text-2xl text-y2k-lime bg-y2k-ink inline-block px-3 py-1 border-2 border-y2k-lime">
  VISITORS: <span className="text-y2k-yellow">0042069</span>
</div>
```

### Stat card
```tsx
<div className="bg-y2k-yellow text-y2k-ink border-4 border-y2k-ink shadow-pixel p-4">
  <div className="font-pixel text-xs mb-2">TVL</div>
  <div className="font-pixel text-2xl mb-1">$1.2M</div>
  <div className="font-terminal text-xl text-y2k-purple">
    ▲ +12% TODAY
  </div>
</div>
```

### Footer
```tsx
<footer className="bg-y2k-ink text-y2k-lime px-8 py-12 mt-auto border-t-4 border-y2k-hotpink">
  <div className="max-w-5xl mx-auto text-center">
    <div className="font-pixel text-sm mb-6">
      <span className="text-y2k-hotpink">★</span>{" "}
      BEST VIEWED IN <span className="text-y2k-yellow">METAMASK 11.0+</span>{" "}
      <span className="text-y2k-hotpink">★</span>
    </div>
    <div className="font-terminal text-2xl mb-4">
      © 1999-2025 PIXEL.MINT • <span className="retro-blink">▌</span>
    </div>
    <div className="font-terminal text-2xl text-y2k-cyan bg-y2k-bg-dark inline-block px-3 py-1 border-2 border-y2k-cyan">
      VISITORS: <span className="text-y2k-yellow">0042069</span>
    </div>
    <div className="mt-6 flex justify-center gap-2 text-2xl">
      <span className="text-y2k-hotpink retro-spin">★</span>
      <span className="text-y2k-cyan retro-spin">✦</span>
      <span className="text-y2k-yellow retro-spin">✧</span>
    </div>
  </div>
</footer>
```

## Animation patterns

### Marquee
```css
@keyframes retro-marquee {
  0% { transform: translateX(0%); }
  100% { transform: translateX(-50%); }
}
.retro-marquee {
  animation: retro-marquee 20s linear infinite;
}
```

### Blink
```css
@keyframes retro-blink {
  0%, 50% { opacity: 1; }
  51%, 100% { opacity: 0; }
}
.retro-blink {
  animation: retro-blink 1s steps(1) infinite;
}
```

### Spin (decorations)
```css
@keyframes retro-spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}
.retro-spin {
  animation: retro-spin 4s linear infinite;
  display: inline-block;
}
```

### Hover bounce
```css
.retro-bounce:hover {
  animation: retro-bounce 0.5s ease-in-out;
}
@keyframes retro-bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-8px); }
}
```

## Do

- ✅ Pixel fonts (Press Start 2P) untuk display, VT323 untuk body
- ✅ 3-4 warna saturated sekaligus (chaos = good)
- ✅ Hard pixel shadows + glow shadows untuk neon
- ✅ Marquee, blink, sparkle decorations
- ✅ Visitor counter, "Best viewed in X" footer cliche
- ✅ Scanlines overlay
- ✅ Custom pixel cursor (optional)
- ✅ Asterisks (★ ✦ ✧) sebagai decoration
- ✅ ALL CAPS dengan suffix .EXE atau /[BRACKETS]

## Don't

- ❌ NO modern clean fonts (Inter, Geist, SF Pro)
- ❌ NO muted/pastel-only palette
- ❌ NO smooth animations berlebihan (kecuali marquee linear)
- ❌ NO border-radius
- ❌ NO whitespace minimalism (Y2K = packed)
- ❌ NO subtle shadows (must be hard)
- ❌ NO professional B2B copy

## References

Inspirasi:
- bratdiet.com (Brat album site)
- spacejam.com (1996 original) — still up!
- yamsisland.com (Tyler, the Creator's IGOR site)
- bobross.com
- early MySpace, Geocities archives

Tooling:
- Inline SVG sparkles
- CSS-only marquee, blink, spin
- Cursor URL ke pixel arrow

Anti-examples:
- linear.app — minimal modern (opposite)
- apple.com — too refined
