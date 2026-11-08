# AccessWatch: demo for the judges

AccessWatch shows who the January 2026 flood in Gaza Province, Mozambique, cut off from
clinics, markets and shelters, and how a team could reach them. Everything runs on the phone
from a data bundle built from the analysis notebook, so it also works offline.

Figures below are from the current bundle (`accesswatch_mobile/assets/bundle/`, notebook build
accuracy-v6). The app reads them from the bundle at run time; if the notebook is re-run, the app
changes with it and these figures should be re-read from the screens.

## Before you start

- Install the APK (`accesswatch_mobile/build/app/outputs/flutter-apk/app-release.apk`), or run
  `flutter run -d chrome` from `accesswatch_mobile/`.
- Accept the safety message once on the first launch, so the demo opens straight on Home.
- A network connection is needed only for the map background. Everything else works offline.
- In a debug build (`flutter run`), a long press on the map sets a test position for the Care tab.
  Release builds do not have this.

## Script (about 3 minutes)

**0:00 Home (20 s).** "This is the January 2026 Chokwe flood, seen by NISAR radar. The data is a
snapshot from the NISAR scene of 17 January 2026, and the app says how old it is. Eight pockets
of people are cut off or hard to reach, about 13,000 people by a population model, with 26 km²
of new flood." Point at the warning banners: "Every caveat in the data is shown, not hidden."

**0:20 Map (50 s).** Open the Map. "Blue is the flood, shaded by estimated depth class. Red and
amber areas are the pockets." Tap the P01 label: the mission sheet opens. Tap the warnings chip
to show the four data warnings. Turn on Compare: "Green is where our map and the official
Copernicus EMS map agree, red only ours, blue only EMS. And this sentence matters: our map was
calibrated on this EMS map, so the 0.80 agreement is not an independent check." Turn Compare
off. In Layers, turn on the physics-only map: "This one was made without EMS. It is more
cautious and finds less flood."

**1:10 Missions (40 s).** "The pockets ranked by people, lost services and how hard they are to
reach." Open P01: service access, safest and shortest route, and the ground checklist. Tap Share
alert: "The alert is written by the app from the data, in English or Portuguese." Back on the
list, drag the People slider: "The weights are a choice, not science. One pocket, P01, holds 98%
of the people, so it stays on top; the sliders reorder the rest."

**1:50 Care (40 s).** "Where can someone reach a clinic?" Use my location (or a debug test
position). "It checks if this spot is in the flood, the estimated depth, the nearest flooded road,
and routes by car, high-clearance truck or on foot, never through deep water. If no road route
exists, it says a boat is needed instead of drawing a line." Tap Show on map for one route.

**2:30 Info (30 s).** "Data and trust: dates, every warning, known issues in the data, how well
the map agrees with EMS and why that agreement is not independent, the limits in plain words, and
the sources." Switch to Português to show the second language. Close with the safety line: "This
app supports decisions. It is not an emergency service. If you are in danger, call your local
emergency number."

## Limits to state out loud

- **BETA data.** The NISAR scenes are beta products, not yet fully calibrated. Treat results as
  preliminary.
- **Assumed depot.** The aid depot is assumed by the team (Hospital Rural de Chokwe), not a
  confirmed depot. Routes and priority depend on it and are illustrative.
- **Calibrated to this event.** The flood map is a classifier calibrated on the Copernicus EMS
  map for this event (spatial cross-validation IoU 0.82, against 0.68 for the threshold map). Its
  agreement with EMS is not an independent check, and it must be retrained for another flood.
- **Depth is estimated.** Radar shows where water is, not how deep. Depth classes (shallow,
  medium, deep) come from a surface model and are a guide, not measurements.
- Population is a modelled estimate, not a census. Bridges cannot be checked from space. The EMS
  image was taken 35 hours after the NISAR scene. Always verify on the ground.

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
`tools/bundle/quality.py`, to `QualityFlag` in the app and to both ARB files.
