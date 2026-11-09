# AccessWatch: demo for the judges

AccessWatch shows who the January 2026 flood in Gaza Province, Mozambique, cut off from
clinics, markets and shelters, and how a team could reach them. It is made for volunteers and
community helpers: three tabs, plain words, big buttons, and every technical detail one tap
deeper. Everything runs on the phone from a data bundle built from the analysis notebook, so it
also works offline.

Figures below are from the current bundle (`accesswatch_mobile/assets/bundle/`, notebook build
accuracy-v6). The app reads them from the bundle at run time; if the notebook is re-run, the app
changes with it and these figures should be re-read from the screens.

## Before you start

- Install the APK (`accesswatch_mobile/build/app/outputs/flutter-apk/app-release.apk`), or run
  `flutter run -d chrome` from `accesswatch_mobile/`.
- Tap "I understand" on the first screen once, so the demo opens straight on the Map.
- A network connection is needed only for the map background. Everything else works offline.
- Find care has a "Try a sample spot in Chókwè" button that works in every build, so you do not
  need GPS on stage. It always says "Sample location, not your position".

## Script (about 3 minutes)

**0:00 Map (40 s).** "This is the January 2026 flood around Chókwè, seen by NISAR radar. Blue is
the flood. Orange areas need a boat; teal areas a high-clearance truck can reach." Point at the
card: "8 areas cut off, about 13,100 people near Chókwè and Guija." Point at the small line under
the button: "Preliminary data, snapshot of 17 January 2026. Every caveat is one tap away." Tap
the pill numbered 1: the short sheet shows the area, its people and "Needs a boat".

**0:40 Help first (40 s).** Tap "See who needs help first". "The areas in order, most urgent at
the top." Point at the Boat 4 / Truck 4 chips, then tap Open on area 1: "West of Guija, 12,853
people by a population model. It needs a boat: about 0.56 km by water after about 5 km by road.
It lost its clinic, market and shelter, which used to be 5 to 9 minutes away." Point at the safest
route: "Check 5 bridges first." Tap Share alert: "The alert is written by the app from the data,
in English or Portuguese, and you see it before it is sent." Close it. Tap "Check on the ground
first": "A checklist for the team; ticks stay on the phone."

**1:20 Find care (40 s).** "Someone asks: where can I get care?" Tap "Try a sample spot in
Chókwè". "It names the nearest clinic and says, for a car, a high-clearance truck and someone on
foot, whether a road route exists, never through deep water. If none does, it says a boat is
needed instead of drawing a line." Tap "Show the route on the map".

**2:00 About this data (60 s).** Tap the round "?". "The first card is the honest summary,
written from the data's own warning flags: the radar scenes are beta, the aid depot is assumed,
the official comparison map was picked by product order, and our flood map was calibrated on that
official map." Open "How well it matches the official map": "Agreement 0.80, and this sentence
matters: it is not an independent check." Open Advanced: "The priority weights are a choice, not
science. One area holds 98% of the people, so it stays on top. The sliders move the truck areas
against the small boat areas, and cannot reorder the three tied boat areas." Back on About,
switch to Português to show the second language. Close with the line at the bottom: "This app
supports decisions. It is not an emergency service. If you are in danger, call your local
emergency number."

## Limits to state out loud

- **BETA data.** The NISAR scenes are beta products, not yet fully calibrated. Treat results as
  preliminary.
- **Assumed depot.** The aid depot is assumed by the team (Hospital Rural de Chókwè), not a
  confirmed depot. Routes and priority depend on it and are illustrative.
- **Calibrated to this event.** The flood map is a classifier calibrated on the Copernicus EMS
  map for this event (spatial cross-validation IoU 0.82, against 0.68 for the threshold map). Its
  agreement with EMS is not an independent check, and it must be retrained for another flood.
- **Depth is estimated.** Radar shows where water is, not how deep. Depth classes (shallow,
  medium, deep) come from a surface model and are a guide, not measurements.
- Population is a modelled estimate, not a census. Bridges cannot be checked from space. The EMS
  image was taken later than the NISAR scene (the gap is recorded in the data and shown in About,
  under How the flood map was made). Always verify on the ground.

## Rebuild the bundle after re-running the notebook

1. Put the new notebook outputs in `data_sample/notebook_outputs/` and the Copernicus EMS product
   `EMSR857_AOI01_DEL_PRODUCT_v1.zip` in `Data/EMSR857_products/` (git-ignored).
2. Create a Python environment and install the builder's libraries:

   ```bash
   python -m venv .venv
   ```

   ```bash
   .venv/Scripts/python -m pip install -r tools/requirements.txt
   ```

3. Build and test the bundle. Every check is a gate: on any failure the old bundle is kept.

   ```bash
   .venv/Scripts/python tools/build_bundle.py
   ```

   ```bash
   .venv/Scripts/python tools/test_bundle.py
   ```

4. Check the app against the new bundle, from `accesswatch_mobile/`:

   ```bash
   flutter analyze
   ```

   ```bash
   flutter test
   ```

5. Build the APK. Run `flutter clean` first whenever a package was added, or the build can miss
   a plugin.

   ```bash
   flutter clean
   ```

   ```bash
   flutter build apk --release
   ```

The field dictionary for every output and bundle file is `docs/SCHEMA.md`. If the notebook adds a
new quality flag, the builder stops and names it: add it to `KNOWN_FLAGS` in
`tools/bundle/quality.py`, to `QualityFlag` in the app and to both ARB files (including its plain
sentence for the top of About).
