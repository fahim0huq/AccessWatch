# AccessWatch outputs - field dictionary

Event: `mozambique_flood_2026` | NISAR before 2026-01-05 / after 2026-01-17 | term `HHHH`
Rasters: GeoTIFF in EPSG:32736 at 20 m. Vectors: GeoJSON in EPSG:4326. Web overlays: PNG in EPSG:4326 (bounds in `web/overlay_bounds.json`).

## Rasters (`flood/`)
| file | values |
|---|---|
| `flood_mask.tif` | 1 = new flood (permanent water excluded), 0 = none |
| `flood_veg_candidates.tif` | 1 = flooded-vegetation / urban candidate; part of `flood_mask.tif` only if `include_flooded_vegetation` was on |
| `depth.tif` | estimated depth in metres inside the flood, NaN elsewhere (an ESTIMATE) |
| `depth_class.tif` | 0 dry, 1 shallow (<0.3 m), 2 medium (<0.8 m), 3 deep, 4 unknown |
| `depth_confidence.tif` | 0 not flooded, 1 low, 2 medium, 3 high |

## `pockets/pockets.geojson` (Polygon per cut-off pocket)
`pocket_id` P01.. | `rank` 1 = go first | `priority_score` = pop_norm x service_loss_norm x difficulty_norm (each 0-1; the app may re-weight them) |
`population` ESTIMATED people | `status` `cut_off` (needs boat) or `difficult` (truck / on foot) |
`access_mode` `normal_vehicle` / `high_clearance_truck` / `on_foot` / `boat` | `boat_leg_km` length of the water leg |
`clinic_access`, `market_access`, `shelter_access`, `aid_depot_access`: `yes` / `difficult` / `no` / `n/a` |
`lost_services`, `limited_services` comma separated (`aid_depot_link` = the link to the depot) |
`risk_level` low / medium / high (worst condition on the safest route) | `max_depth_class` on the safest route |
`confidence` high / medium / low (weakest blocking road) | `stability` and `mode_stability` 0-1 = share of sensitivity scenarios in which the pocket / its access mode survives | `worst_case_mode` = most demanding access mode in any scenario (prepare it as a fallback) |
`route_shortest_*`, `route_safest_*` distance (km) and time (min) | `lon`, `lat` representative point.

## `routes/routes.geojson` (LineString, two per pocket)
`pocket_id`, `rank`, `route_type` `shortest` (dry network, ignores the flood) or `safest` (lowest risk cost inside the chosen access mode) |
`access_mode` | `distance_km`, `estimated_time_min` | `max_depth_class`, `km_shallow`, `km_medium`, `km_deep` | `uncertain_bridges` | `risk_score` (km-equivalents), `risk_level`.

## `network/road_conditions.geojson` (LineString, one per road piece of at most 100 m)
`edge_id`, `orig_eid`, `road_type`, `name`, `length_m` | `depth_class` 0-3 (+ `depth_class_name`), `max_depth_m`, `flooded`, `flooded_frac`, `depth_confidence` |
`is_bridge`, `bridge_uncertain` (bridge or ford near flood water: verify on the ground) | `access_normal_vehicle`, `access_high_clearance`, `access_foot` | `travel_time_min`, `risk_cost`.

## `mission_cards.json`
`cards[]` sorted by rank: `title`, `location`, `population`, `access_status`, `access_mode`, `boat_leg_km`, `lost_services[]`, `service_access{}`, `routes{safest, shortest}`, `risk_level`, `confidence`, `stability`, `worst_case_mode`, `verify_notes[]`, `priority_terms{}`, `summary`, `alert_text` (short text for field teams).

## Limits
- NISAR gives flood extent only; depth is an estimate (FwDET-style from a 30 m surface model) - classes are indicative.
- L-band thresholds detect open water well; flooded vegetation and built-up areas may be missed.
- OSM completeness: 99.0% of buildings are within 150 m of a mapped road; 2 disconnected road fragments were ignored.
- Population is WorldPop-style population raster - a modelled estimate, not a census.
- The boat route follows flooded roads; real water routes can differ. Bridges cannot be assessed from space.
- All depth / vehicle thresholds are adjustable defaults - confirm them with local responders and always verify on the ground.
