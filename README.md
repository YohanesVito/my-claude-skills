# my-claude-skills

Custom skills untuk [Claude Code](https://www.anthropic.com/claude-code) — fokus akselerasi workflow hackathon Web3 & frontend dengan gaya yang nggak mainstream.

## Skills

| Skill | Untuk apa |
|---|---|
| [`new-hackathon-project`](./new-hackathon-project) | Scaffold project hackathon Web3: GitHub org + 3 repo (sc/be/fe) dengan Foundry, Next.js + Bun |
| [`web-design-style`](./web-design-style) | Apply gaya design non-mainstream (retro, grunge, neo-brutalism, awwwards-motion) ke FE |

## Install

Kalau `~/.claude/skills/` kamu kosong:

```bash
git clone https://github.com/YohanesVito/my-claude-skills.git ~/.claude/skills
```

Kalau sudah ada skill lain di sana, copy per folder:

```bash
git clone https://github.com/YohanesVito/my-claude-skills.git /tmp/my-claude-skills
cp -r /tmp/my-claude-skills/new-hackathon-project ~/.claude/skills/
cp -r /tmp/my-claude-skills/web-design-style ~/.claude/skills/
```

Skill aktif di session Claude Code berikutnya.

## Cara trigger

Natural chat:
- **new-hackathon-project**: *"bikin project hackathon baru, namanya X"*
- **web-design-style**: *"apply neo-brutalism"*, *"pakai gaya retro 90s"*, *"make it awwwards-level"*

CLI-style (skip batched questions):
- `/new-hackathon-project Mantle Risk Gate base-sepolia,arbitrum-sepolia`
- `/web-design-style retro-90s theme-only`
- `/web-design-style https://bratdiet.com full-page`

## Override

Skill ini suggestive, bukan mandatory. Bypass dengan tambah *"tanpa skill"* atau *"manual aja"* di prompt.

## Eksplorasi lebih lanjut

Lihat [`REFERENCES.md`](./REFERENCES.md) untuk daftar skill/repo external (Trail of Bits, max-taylor, forefy, dst.) — dilengkapi panduan kapan pakai repo mereka instead of bikin sendiri di sini.

## License

MIT
