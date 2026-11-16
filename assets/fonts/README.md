# Fonts

Nunito, bundled (SIL Open Font License 1.1 — see `OFL.txt`). Bundling keeps
the app 100% offline: no runtime font fetching.

Files (registered in `pubspec.yaml` under `fonts:`):
`Nunito-Regular.ttf` (400), `Nunito-SemiBold.ttf` (600),
`Nunito-Bold.ttf` (700), `Nunito-ExtraBold.ttf` (800).

They were instanced from Google Fonts' variable font
(`github.com/google/fonts/ofl/nunito/Nunito[wght].ttf`):

```sh
pip install fonttools
fonttools varLib.instancer 'Nunito[wght].ttf' wght=700 --static -o Nunito-Bold.ttf
```

Why Nunito: rounded terminals — friendly, clean, legible at small sizes.
