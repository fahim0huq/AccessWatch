import 'package:flutter/material.dart';

import '../widgets/quality_banners.dart';
import 'map_screen.dart';

/// The Map tab: warning banners above the map.
class MapTab extends StatelessWidget {
  const MapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SafeArea(
          bottom: false,
          child: QualityBanners(padding: EdgeInsets.fromLTRB(8, 8, 8, 0)),
        ),
        Expanded(
          child: MediaQuery.removePadding(context: context, removeTop: true, child: const MapScreen()),
        ),
      ],
    );
  }
}
