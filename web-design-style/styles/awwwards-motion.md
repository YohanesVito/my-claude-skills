---
name: awwwards-motion
description: Sophisticated, cinematic motion-heavy. Monochromatic + 1 accent, large serif headlines, smooth Lenis scroll, Framer Motion stagger reveals, magnetic cursor, page transitions, generous whitespace, subtle grain. Premium agency feel.
mood: sophisticated, cinematic, premium, smooth, intentional
era: 2024-2026 (Awwwards SOTD winners)
intensity_default: balanced
---

# Awwwards Motion-Heavy

Cocok buat **agency-style portfolio, premium DeFi protocol, sophisticated NFT collection drop**. Bukan untuk hackathon demo cepat — butuh waktu polish. Tapi kalau dapet, judges otomatis bias positive karena "feels expensive".

## Tokens

### Color palette

Awwwards style = **disciplined palette**. Bukan colorful — monochromatic + 1 accent.

| Token | Hex | Use |
|---|---|---|
| `bg` | `#0a0a0a` | Rich black (default), or `#fafaf7` for light |
| `ink` | `#fafafa` | Off-white foreground |
| `muted` | `#71717a` | Body secondary |
| `accent` | `#fb923c` | Sunset orange (swap as project needs) |
| `border` | `rgba(250,250,250,0.1)` | Subtle dividers |

**Rule:** 1 accent color. Itu doang. Sisanya monochromatic.

**Detect Tailwind version first**: `grep tailwindcss package.json`.

#### Tailwind 4 (canonical)

```css
@import "tailwindcss";

@theme {
  --color-aw-bg: #0a0a0a;
  --color-aw-ink: #fafafa;
  --color-aw-muted: #71717a;
  --color-aw-accent: #fb923c;
  --color-aw-border: rgba(250,250,250,0.1);

  --font-display: "Fraunces", serif;
  --font-sans: "Geist", "Inter", sans-serif;
  --font-mono: "Geist Mono", monospace;
}
```

#### Tailwind 3

```ts
theme: { extend: {
  colors: { aw: { bg: '#0a0a0a', ink: '#fafafa', muted: '#71717a', accent: '#fb923c', border: 'rgba(250,250,250,0.1)' } },
  fontFamily: {
    display: ['Fraunces', 'serif'],
    sans: ['Geist', 'Inter', 'sans-serif'],
    mono: ['"Geist Mono"', 'monospace'],
  },
}}
```

### Typography

| Use | Font | Weight | Size | Tracking |
|---|---|---|---|---|
| Display (hero) | Fraunces | 300-400 (light!) | `text-7xl md:text-9xl` | tight `-0.04em` |
| H2 | Fraunces | 300 | `text-5xl md:text-7xl` | tight |
| H3 | Fraunces | 400 | `text-3xl md:text-4xl` | normal |
| Body | Geist | 400 | `text-base md:text-lg` | normal |
| Caption / label | Geist Mono | 400 | `text-xs` | wide `0.1em`, UPPERCASE |

**Note:** **Light weight serif** untuk display itu signature awwwards 2024+. Bukan bold. Editorial feel.

### Spacing & shape

- **Radius**: minimal — `rounded-sm` or none. Sharp but refined.
- **Border**: `1px solid var(--color-aw-border)` (very subtle)
- **Padding**: HUGE — `py-32 md:py-48` untuk section. Whitespace is the style.
- **Max-width**: tight — `max-w-6xl` untuk content. Long-form feels.

### Texture

- **Subtle grain** overlay (less aggressive than grunge)
- **Blurred orb** decorations (radial gradient blobs di background)
- **NO solid color blocks** — everything has depth via gradient

### Motion (THE KEY differentiator)

Heart of this style. Tanpa motion, jadi minimal-boring. Harus:

1. **Lenis smooth scroll** — momentum-based, butter
2. **Stagger reveal** pada section enter (Framer Motion)
3. **Text mask reveal** — kata-per-kata atau letter-by-letter
4. **Magnetic cursor** — buttons "pull" cursor
5. **Page transitions** — overlay slide-in saat route change

Easing standard: `[0.16, 1, 0.3, 1]` (Vercel-style smooth out)

## Dependencies

```bash
bun add framer-motion lenis @fontsource/fraunces @fontsource/geist @fontsource/geist-mono
```

### Step A — KEEP Geist (kebalikan dari style lain)

Untuk style ini, Geist default dari Next.js justru match. Tapi tambah Fraunces untuk display:

```tsx
// Keep Geist setup as default create-next-app generates
// Add Fraunces:
import '@fontsource/fraunces/300.css'
import '@fontsource/fraunces/400.css'
import './globals.css'
```

(Note: skill harus override `--font-sans` di @theme ke Geist explicit, BUKAN hapus.)

### Step B — Lenis smooth scroll setup

`src/components/LenisProvider.tsx`:
```tsx
"use client";
import { ReactLenis } from "lenis/react";
export function LenisProvider({ children }: { children: React.ReactNode }) {
  return (
    <ReactLenis root options={{ lerp: 0.1, duration: 1.2 }}>
      {children}
    </ReactLenis>
  );
}
```

Wrap children in `layout.tsx` body dengan `<LenisProvider>`.

### Step C — Base layer

```css
@layer base {
  html { background: var(--color-aw-bg); }
  body {
    background: var(--color-aw-bg);
    color: var(--color-aw-ink);
    font-family: var(--font-sans);
    /* Subtle grain */
    background-image:
      url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence baseFrequency='0.8' numOctaves='2'/%3E%3CfeColorMatrix values='0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0.04 0'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
  }
  h1, h2, h3 {
    font-family: var(--font-display);
    font-weight: 300;
    letter-spacing: -0.04em;
    line-height: 0.95;
  }
  *::selection {
    background: var(--color-aw-accent);
    color: var(--color-aw-bg);
  }
}
```

## Component patterns

### Button — magnetic
```tsx
"use client";
import { motion, useMotionValue, useSpring } from "framer-motion";
import { useRef } from "react";

export function MagneticButton({ children, className = "" }: { children: React.ReactNode; className?: string }) {
  const ref = useRef<HTMLButtonElement>(null);
  const x = useSpring(useMotionValue(0), { stiffness: 150, damping: 15 });
  const y = useSpring(useMotionValue(0), { stiffness: 150, damping: 15 });

  function onMove(e: React.MouseEvent<HTMLButtonElement>) {
    if (!ref.current) return;
    const rect = ref.current.getBoundingClientRect();
    x.set((e.clientX - rect.left - rect.width / 2) * 0.3);
    y.set((e.clientY - rect.top - rect.height / 2) * 0.3);
  }
  function onLeave() { x.set(0); y.set(0); }

  return (
    <motion.button
      ref={ref}
      onMouseMove={onMove}
      onMouseLeave={onLeave}
      style={{ x, y }}
      className={`group inline-flex items-center gap-3 px-8 py-4 border border-aw-border rounded-full text-aw-ink font-sans text-sm uppercase tracking-widest hover:bg-aw-ink hover:text-aw-bg transition-colors duration-500 ${className}`}
    >
      {children}
      <span className="inline-block transition-transform duration-500 group-hover:translate-x-1">→</span>
    </motion.button>
  );
}
```

### Text reveal — letter-by-letter
```tsx
"use client";
import { motion } from "framer-motion";

export function RevealText({ children }: { children: string }) {
  return (
    <span className="inline-block">
      {children.split("").map((ch, i) => (
        <motion.span
          key={i}
          initial={{ y: "100%", opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: i * 0.03, duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
          className="inline-block"
          style={{ whiteSpace: ch === " " ? "pre" : "normal" }}
        >
          {ch}
        </motion.span>
      ))}
    </span>
  );
}
```

### Hero
```tsx
<section className="min-h-screen flex items-center px-8 md:px-16 relative overflow-hidden">
  {/* Blurred orb decoration */}
  <div className="absolute top-1/4 right-1/4 w-96 h-96 rounded-full bg-aw-accent/20 blur-[120px]" />

  <div className="max-w-6xl mx-auto relative">
    <div className="font-mono text-xs uppercase tracking-widest text-aw-muted mb-8">
      <RevealText>— Studio · Est 2025</RevealText>
    </div>
    <h1 className="font-display text-7xl md:text-9xl leading-[0.9] tracking-tight mb-8">
      <div><RevealText>We build</RevealText></div>
      <div className="italic text-aw-accent"><RevealText>quietly</RevealText></div>
      <div><RevealText>loud things.</RevealText></div>
    </h1>
    <p className="font-sans text-lg md:text-xl text-aw-muted max-w-xl mb-12 leading-relaxed">
      A multidisciplinary studio crafting digital experiences for protocols, founders, and humans with taste.
    </p>
    <MagneticButton>See selected work</MagneticButton>
  </div>
</section>
```

### Section — number + content (editorial)
```tsx
<motion.section
  initial={{ opacity: 0, y: 60 }}
  whileInView={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
  viewport={{ once: true, margin: "-100px" }}
  className="px-8 md:px-16 py-32 md:py-48"
>
  <div className="max-w-6xl mx-auto grid grid-cols-1 md:grid-cols-12 gap-8">
    <div className="md:col-span-3">
      <div className="font-mono text-xs uppercase tracking-widest text-aw-muted">
        01 / Approach
      </div>
    </div>
    <div className="md:col-span-9">
      <h2 className="font-display text-5xl md:text-7xl leading-[0.95] tracking-tight mb-8">
        We don't ship pages.<br/>
        We ship <span className="italic text-aw-accent">moments.</span>
      </h2>
      <p className="font-sans text-lg md:text-xl text-aw-muted leading-relaxed max-w-2xl">
        Every project starts with a question — what should the user feel in the first three seconds? Then we work backward.
      </p>
    </div>
  </div>
</motion.section>
```

### Project card — full bleed
```tsx
<motion.article
  initial={{ opacity: 0 }}
  whileInView={{ opacity: 1 }}
  transition={{ duration: 1 }}
  viewport={{ once: true }}
  className="group cursor-pointer"
>
  <div className="aspect-[16/10] bg-aw-muted/10 overflow-hidden mb-6 relative">
    {/* Image / video here */}
    <div className="absolute inset-0 bg-gradient-to-t from-aw-bg/40 to-transparent" />
  </div>
  <div className="flex items-baseline justify-between">
    <h3 className="font-display text-3xl md:text-4xl font-light tracking-tight">
      Protocol 042 <span className="italic text-aw-accent">— site</span>
    </h3>
    <div className="font-mono text-xs uppercase tracking-widest text-aw-muted">
      2025 · Brand & Web
    </div>
  </div>
</motion.article>
```

### Nav — minimal
```tsx
<nav className="fixed top-0 inset-x-0 z-50 px-8 md:px-16 py-6 flex items-center justify-between mix-blend-difference">
  <div className="font-display text-xl text-aw-ink tracking-tight">
    Studio<span className="text-aw-accent">.</span>
  </div>
  <div className="flex items-center gap-8 font-mono text-xs uppercase tracking-widest">
    {['Work', 'Studio', 'Journal', 'Contact'].map(l => (
      <a key={l} className="text-aw-ink hover:opacity-60 transition-opacity duration-500 cursor-pointer">
        {l}
      </a>
    ))}
  </div>
</nav>
```

### Footer — massive CTA
```tsx
<footer className="px-8 md:px-16 py-32 md:py-48 border-t border-aw-border">
  <div className="max-w-6xl mx-auto">
    <div className="font-mono text-xs uppercase tracking-widest text-aw-muted mb-8">
      04 / Contact
    </div>
    <h2 className="font-display text-6xl md:text-[12rem] leading-[0.85] tracking-tighter mb-16">
      <span className="italic text-aw-accent">let's</span><br/>
      make something.
    </h2>
    <div className="flex flex-wrap gap-8 items-end">
      <MagneticButton>hello@studio.xyz</MagneticButton>
      <div className="font-mono text-xs uppercase tracking-widest text-aw-muted">
        © 2025 — Studio<br/>
        Jakarta / Remote
      </div>
    </div>
  </div>
</footer>
```

## Animation patterns

### Lenis smooth scroll
Already setup in LenisProvider. Lerp 0.1 = smooth butter scroll.

### Framer stagger reveal (sections)
```tsx
<motion.div
  initial={{ opacity: 0, y: 60 }}
  whileInView={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
  viewport={{ once: true, margin: "-100px" }}
>
```

### Letter-by-letter reveal
See `RevealText` component above. Stagger by `i * 0.03s`.

### Magnetic cursor
See `MagneticButton` component. Stiffness 150, damping 15.

### Mix-blend-difference nav (PENTING — gotcha)

Nav text invert ke background via `mix-blend-mode: difference`. **Tapi efeknya cuma visible kalau page punya section dengan bg color yang kontras.** Kalau semua section pakai bg dark sama, nav nggak berubah warna karena ga ada apa-apa untuk di-blend.

**Sertakan minimal 1 section dengan bg `bg-aw-ink` (atau warna kontras lain) di tengah page** supaya efek inversion-nya kelihatan saat user scroll. Pattern umum: dark hero → light "manifesto/quote" section → dark work section → light contact CTA section.

```tsx
{/* Contrast section example — wajib ada minimal 1 per page */}
<section className="bg-aw-ink text-aw-bg px-8 md:px-16 py-32 md:py-48">
  <h2 className="font-display text-5xl md:text-7xl">
    Quietly loud.<br/>
    <span className="italic">Every detail.</span>
  </h2>
</section>
```

### Standard easing
**Always**: `[0.16, 1, 0.3, 1]` (Vercel-style ease-out cubic). Avoid linear, avoid ease-in-out.

## Do

- ✅ **Light-weight serif** for display (font-light 300 atau 400)
- ✅ Generous whitespace — py-32+ untuk section
- ✅ Monochromatic palette + 1 accent
- ✅ Smooth Lenis scroll wajib
- ✅ Stagger reveal pada section enter
- ✅ Magnetic interactive elements
- ✅ Asymmetric grids (12-col, sparse fill)
- ✅ Long-form scrolling (full viewport hero, then sections)
- ✅ Italic untuk emphasis (lebih elegan dari bold)
- ✅ Subtle grain texture
- ✅ Mono untuk caption/label (uppercase wide tracking)

## Don't

- ❌ NO bold heavy display fonts (Archivo Black, Press Start = wrong style)
- ❌ NO multiple bright colors (1 accent only)
- ❌ NO hard shadows
- ❌ NO instant motion (everything is smooth easing)
- ❌ NO cramped layouts (whitespace = the style)
- ❌ NO emoji decorations (too playful for this mood)
- ❌ NO unmotivated motion (every reveal harus serve purpose)
- ❌ NO Lorem ipsum — pakai prose yang "agency-elevated"

## References

Inspirasi (must-study):
- studio.locomotive.ca
- studiothomas.com
- linear.app (motion timing reference)
- vercel.com (typography + motion combo)
- arc.net
- igloo.inc

Awwwards categories to browse:
- https://www.awwwards.com/sites_of_the_day
- https://www.awwwards.com/inspiration/

Tools:
- Framer Motion (motion + AnimatePresence)
- Lenis (smooth scroll)
- gsap (alternative, more powerful timeline-based)
- @studio-freight/lenis (Lenis maintainer)

Anti-examples:
- bratdiet.com (chaotic Y2K — opposite end)
- gumroad.com (brutalist — opposite end)
