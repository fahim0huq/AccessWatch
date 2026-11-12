# AccessWatch: demo for the judges

AccessWatch shows who the January 2026 flood in Gaza Province, Mozambique, cut off from
clinics, markets and shelters, and how a team could reach them. It is made for volunteers and
community helpers: one floating bar (Map, Who needs help, Watch, Find care, About), plain words, big
buttons, and every technical detail one tap deeper. Everything runs on the phone from a data bundle built from the analysis notebook, so it
also works offline.

Figures below are from the current bundle (`accesswatch_mobile/assets/bundle/`, notebook build
accuracy-v6). The app reads them from the bundle at run time; if the notebook is re-run, the app
changes with it and these figures should be re-read from the screens.

## Before you start

- Install the APK (`accesswatch_mobile/build/app/outputs/flutter-apk/app-release.apk`), or run
  `flutter run -d chrome` from `accesswatch_mobile/`.
- Tap "I understand" on the first screen once. A five-step tour follows (the summary card, the
  layer chips, Who needs help, the Watching pill, Find care); walk through it or tap Skip. It is
  shown only once; About > "Take the tour again" replays it, which is a good opening on stage.
- A network connection is needed only for the map background. Everything else works offline.
- Find care has a "Try a sample spot in Chókwè" button that works in every build, so you do not
  need GPS on stage. It always says "Sample location, not your position".

## Script (about 3½ minutes)

**0:00 Map (40 s).** "This is the January 2026 flood around Chókwè, seen by NISAR radar. Blue is
the flood. Orange areas need a boat; teal areas a high-clearance vehicle can reach." Point at the
pill on top, "Watching: Chókwè and Guija, Mozambique · January 2026", and at the card: "8 areas cut
off or hard to reach, about 13,100 people near Chókwè and Guija." Point at the chip row: "Flood and
Areas are on; tap a chip to add routes, clinics, markets or shelters." Tap Routes, then Clinics.
Tap the round Layers button: a half-height sheet of big tiles over the map, with the more
technical layers (water depth, flooded roads, all roads, the EMS comparison, the physics-only map)
and a Reset. Close it. Tap the full-screen button (top right): the pill, the card and the bar go
away; zoom, Fit to the flood area and the scale bar appear. Tap the area 1 pill: a small card with
its name, people and "Needs a boat". Tap the exit button (top left): same view, same layers.

**0:40 Watch an area (40 s).** Tap the round Watch button in the middle of the bar. "Here you pick
what to follow." Say plainly: "Right now only one event has satellite data: the January 2026
Mozambique flood, with radar scenes of 5 and 17 January. Live events are the roadmap: the list
below says so, and nothing in it is invented." Point at "Cyclone flooding": "Radar shows water,
not wind, so this is about flooding from cyclones, never tracking the storm." Tap "Select an area
on the map", drag a box somewhere away from Chókwè: "No satellite data for this area yet", with a
button to the event that has data. Draw one over the flood instead: "Watch this area".

**1:20 Who needs help (40 s).** Tap Who needs help. "The areas in order, most urgent at the top, the first
one in violet." Tap the "Vehicle (high-clearance) 4" pill: "These need a high-clearance vehicle,
never an ordinary car." Tap All again, then "Share an alert for a team" and choose Boat teams:
"One alert for all four boat areas, in rank order, with people, how to get in and how deep the
water is, written by the app in English or Portuguese, and you see it before it is sent." Close it.

**2:00 One area (35 s).** Open area 1: "West of Guija (1), 12,853 people by a population model. It
needs a boat: about 0.56 km by water, on a 5.62 km route." Point at the water card: "Along the
safest route, water about 0.7 m deep on average, up to about 1.6 m. That is an estimate from a
30 m terrain model, a guide and not a measurement." Point at the lost services and "Check 5
bridges first", then tap "Check on the ground first": "A checklist for the team; ticks stay on the
phone."

**2:35 Find care (25 s).** "Someone asks: where can I get care?" Tap Find care, then "Try a sample
spot in Chókwè". "It names the nearest clinic and says, for a car, a high-clearance truck and
someone on foot, whether a road route exists, never through deep water. Where the data cannot give
a fair time, it shows the distance only and says why."

**3:00 About (30 s).** Tap About in the bar. "The first card is the honest summary, written from
the data's own warning flags: the radar scenes are beta, the aid depot is assumed, the official
comparison map was picked by product order, and our flood map was calibrated on that official map,
so agreeing with it is not an independent check." Switch to Português for a moment. Close with the
line at the bottom: "This app supports decisions. It is not an emergency service. If you are in
danger, call your local emergency number."

## Limits to state out loud

- **One event only.** Only the January 2026 Mozambique flood has data. Watch an area makes no
  network calls; live floods and flooding from cyclones are the roadmap, not a feature yet.

- **BETA data.** The NISAR scenes are beta products, not yet fully calibrated. Treat results as
  preliminary.
- **Assumed depot.** The aid depot is assumed by the team (Hospital Rural de Chókwè), not a
  confirmed depot. Routes and priority depend on it and are illustrative.
- **Calibrated to this event.** The flood map is a classifier calibrated on the Copernicus EMS
  map for this event (spatial cross-validation IoU 0.82, against 0.68 for the threshold map). Its
  agreement with EMS is not an independent check, and it must be retrained for another flood.
- **Depth is estimated.** Radar shows where water is, not how deep. Depth classes (shallow,
  medium, deep) and the average depth on the way in come from a 30 m terrain model and are a
  guide, not measurements.
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
