// How an access mode looks everywhere: tone, icon and plain words.
import 'package:flutter/material.dart';

import '../../data/models/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import 'kit.dart';

Tone modeTone(AccessMode mode) => switch (mode) {
      AccessMode.boat => Tone.boat,
      AccessMode.highClearanceTruck => Tone.truck,
      AccessMode.normalVehicle || AccessMode.onFoot => Tone.reach,
    };

IconData modeIcon(AccessMode mode) => switch (mode) {
      AccessMode.boat => Icons.directions_boat_rounded,
      AccessMode.highClearanceTruck => Icons.local_shipping_rounded,
      AccessMode.onFoot => Icons.directions_walk_rounded,
      AccessMode.normalVehicle => Icons.directions_car_rounded,
    };

String modeWords(AppLocalizations l, AccessMode mode) => switch (mode) {
      AccessMode.boat => l.modeNeedsBoat,
      AccessMode.highClearanceTruck => l.modeTruckCanReach,
      AccessMode.normalVehicle => l.modeCarCanReach,
      AccessMode.onFoot => l.modeFootCanReach,
    };

/// "Needs a boat" with the boat icon, on the boat tint.
class ModeChip extends StatelessWidget {
  final AccessMode mode;

  const ModeChip({super.key, required this.mode});

  @override
  Widget build(BuildContext context) =>
      StatusChip(icon: modeIcon(mode), label: modeWords(AppLocalizations.of(context)!, mode), tone: modeTone(mode));
}

/// The colour an area is drawn with on the map.
Color modeMapColor(AccessMode mode) => modeTone(mode).strong;

/// Legend colours of the map, matching how the layers draw.
const mapFloodColor = AppColors.floodFill;
