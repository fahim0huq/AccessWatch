// The base map's required credit.
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

final _osmCopyright = Uri.parse('https://www.openstreetmap.org/copyright');

/// Required credit for the base map; it links to the OSM copyright page.
class OsmAttribution extends StatelessWidget {
  const OsmAttribution({super.key});

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: () => launchUrl(_osmCopyright),
          child: Container(
            color: AppColors.surface.withValues(alpha: 0.9),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: Text(AppLocalizations.of(context)!.osmAttribution,
                style: const TextStyle(color: AppColors.ink, fontSize: 12)),
          ),
        ),
      );
}
