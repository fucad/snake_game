# GEMINI.md — Gemini CLI Project Guide

This project uses `AGENTS.md` as the primary cross-tool AI guide.
Read that file first — it contains everything needed to contribute.

> `AGENTS.md` → project summary, stack, folder structure, rules, commands

For Claude Code-specific details (contribution patterns, prompt templates,
architecture deep-dive), see `CLAUDE.md`.

---

## Quick Reference

```bash
flutter pub get   # install dependencies
flutter test      # run tests
dart analyze lib/ # check for errors
```

**The one rule:** `lib/game/logic/` and `lib/progression/` are pure Dart —
no Flutter or Flame imports allowed in those directories.

**Balance tuning:** edit `lib/balance/*.dart` only — no logic changes needed.

**Design tokens:** always use `AppColors.*`, `AppTextStyles.*`,
`AppDimensions.*` — never raw values.
