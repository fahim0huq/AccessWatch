# AccessWatch: rules for coding agents (Claude Code, Antigravity)

## Project
Flutter app showing the Jan 2026 Mozambique flood (NISAR + Copernicus EMSR857): flood, depth,
cut-off pockets, ranked missions, clinics, routes, honest data/limits screen.

## Layout
- `accesswatch_mobile/`  the Flutter app (an existing UI prototype that uses hard-coded demo data and
  JPG map backgrounds). KEEP its screens and look; REPLACE demo data and the painter map with real data.
- `data_sample/notebook_outputs/`  final notebook outputs (input to the bundle script). Never edit.
- `docs/SCHEMA.md`  field dictionary of every output file. Never invent fields.
- `tools/`  Python scripts (bundle builder, EMS date helper).
- `Data/` is git-ignored raw working data (EMS zips, caches). Read from it, never commit it.

## Rules
- Flutter, Dart 3, null safety. State: Riverpod. Routing: go_router. Map: flutter_map + latlong2.
- Read docs/SCHEMA.md before every task. Do not invent data fields.
- No numbers from the notebook typed into code. Read everything from the data bundle
  (manifest.json, quality.json), so re-running the notebook updates the app.
- All visible text goes in ARB files (English and Portuguese). The app builds alert text itself.
- Files under 300 lines. Parse big JSON in isolates (compute).
- Before saying a task is done: run `flutter analyze` and `flutter test`; for UI show a Chrome screenshot.
- Never put secrets, tokens or passwords in code or git. Never read or print notebooks (.ipynb).
- Keep one phase per task. End each task with a short walkthrough of what changed.

## Honesty rules (must appear in the app)
- NISAR scenes are BETA. Depth is an estimate (classes, not exact metres). Population is modelled.
- The aid depot is AUTO-SELECTED in the current data: routes and priority are illustrative; the app
  must show this warning whenever the quality flag says so.
- The flood map is a classifier calibrated on the EMSR857 map (spatial-CV IoU 0.82 vs 0.68 for the
  threshold map), so agreement with EMS in Compare mode is not an independent check.
- The app supports decisions and is not an emergency service.
