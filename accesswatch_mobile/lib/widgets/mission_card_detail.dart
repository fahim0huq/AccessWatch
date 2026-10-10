import 'package:flutter/material.dart';
import '../models/demo_data.dart';
import '../theme/app_theme.dart';

class MissionCardDetail extends StatelessWidget {
  final Pocket pocket;
  final Function(Pocket)? onViewOnMap;

  const MissionCardDetail({
    super.key,
    required this.pocket,
    this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle & Top Navigation Bar
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 8),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded, size: 14, color: AppColors.accent),
                      label: const Text(
                        'Back',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (onViewOnMap != null)
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          onViewOnMap!(pocket);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.background,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.my_location_rounded, size: 15),
                        label: const Text(
                          'VIEW ON MAP',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // Scrollable Content Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section: Rank, Name, Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          '#${pocket.rank.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: pocket.status == 'CUT OFF'
                                  ? AppColors.highRisk.withValues(alpha: 0.15)
                                  : AppColors.warning.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              pocket.status,
                              style: TextStyle(
                                color: pocket.status == 'CUT OFF' ? AppColors.highRisk : AppColors.warning,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  pocket.accessMode == 'BOAT'
                                      ? Icons.directions_boat
                                      : pocket.accessMode == 'HIGH-CLEARANCE TRUCK'
                                          ? Icons.local_shipping
                                          : pocket.accessMode == 'ON FOOT'
                                              ? Icons.directions_walk
                                              : Icons.directions_car,
                                  size: 14,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  pocket.accessMode,
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    pocket.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Population Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ESTIMATED POPULATION',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${pocket.population}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Range ${pocket.popRange[0]}–${pocket.popRange[1]}',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Services Lost Section
                  const Text(
                    'SERVICES LOST',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: pocket.servicesLost.map((srv) {
                      return Chip(
                        avatar: const Icon(Icons.close_rounded, size: 14, color: AppColors.highRisk),
                        label: Text('$srv CUT OFF'),
                        backgroundColor: AppColors.highRisk.withValues(alpha: 0.1),
                        side: BorderSide(color: AppColors.highRisk.withValues(alpha: 0.3)),
                        labelStyle: const TextStyle(
                          color: AppColors.highRisk,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Why Flagged Section
                  const Text(
                    'WHY FLAGGED',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pocket.whyFlagged,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Recommended Access & Equipment Checklist
                  const Text(
                    'RECOMMENDED ACCESS & EQUIPMENT',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: pocket.recommendedEquipment.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.accent),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Dedicated WATER DEPTH Section
                  const Text(
                    'WATER DEPTH',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: pocket.depthClass == DepthClass.deep
                            ? AppColors.floodDeep
                            : pocket.depthClass == DepthClass.medium
                                ? AppColors.floodMedium
                                : AppColors.floodShallow,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'ESTIMATED MAXIMUM DEPTH',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: pocket.depthClass == DepthClass.deep
                                    ? AppColors.floodDeep.withValues(alpha: 0.2)
                                    : pocket.depthClass == DepthClass.medium
                                        ? AppColors.floodMedium.withValues(alpha: 0.2)
                                        : AppColors.floodShallow.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                pocket.depthClass.label,
                                style: TextStyle(
                                  color: pocket.depthClass == DepthClass.deep
                                      ? AppColors.floodDeep
                                      : pocket.depthClass == DepthClass.medium
                                          ? AppColors.floodMedium
                                          : AppColors.floodShallow,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${pocket.maxEstimatedDepthMeters.toStringAsFixed(2)} m',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Visual Depth Bar Indicator
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Stack(
                            children: [
                              Container(
                                height: 10,
                                color: AppColors.surface,
                              ),
                              FractionallySizedBox(
                                widthFactor: (pocket.maxEstimatedDepthMeters / 2.0).clamp(0.1, 1.0),
                                child: Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.floodShallow,
                                        if (pocket.maxEstimatedDepthMeters >= 0.3) AppColors.floodMedium,
                                        if (pocket.maxEstimatedDepthMeters >= 0.8) AppColors.floodDeep,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.warning),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Estimated depth — verify on the ground.',
                                style: TextStyle(
                                  color: AppColors.warning.withValues(alpha: 0.9),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Route Comparison Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ROUTE COMPARISON',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const Text(
                        'Shortest ≠ Safest',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Comparison Table Container
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        // Table Header
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'METRIC',
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'SHORTEST',
                                style: TextStyle(
                                  color: AppColors.highRisk.withValues(alpha: 0.9),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'SAFEST ★',
                                style: TextStyle(
                                  color: AppColors.safestRoute,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: AppColors.border, height: 16),

                        // Row: Distance
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text('Distance', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('${pocket.routes.shortest.distanceKm} km', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('${pocket.routes.safest.distanceKm} km', style: const TextStyle(color: AppColors.safestRoute, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Row: ETA
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text('ETA', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('${pocket.routes.shortest.durationMin} min', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('${pocket.routes.safest.durationMin} min', style: const TextStyle(color: AppColors.safestRoute, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Row: Max depth
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text('Max Depth', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${pocket.routes.shortest.estimatedMaxDepthMeters.toStringAsFixed(2)} m',
                                style: const TextStyle(color: AppColors.highRisk, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${pocket.routes.safest.estimatedMaxDepthMeters.toStringAsFixed(2)} m',
                                style: const TextStyle(color: AppColors.safestRoute, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Row: Depth Class
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text('Depth Level', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                pocket.routes.shortest.depthClass.label,
                                style: const TextStyle(color: AppColors.highRisk, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                pocket.routes.safest.depthClass.label,
                                style: const TextStyle(color: AppColors.safestRoute, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Row: Risk
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text('Access Risk', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.highRisk.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  pocket.routes.shortest.risk,
                                  style: const TextStyle(color: AppColors.highRisk, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.safestRoute.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  pocket.routes.safest.risk,
                                  style: const TextStyle(color: AppColors.safestRoute, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'The shortest route is not necessarily the safest route.',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confidence Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ANALYSIS CONFIDENCE',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        pocket.confidence,
                        style: TextStyle(
                          color: pocket.confidence == 'HIGH' ? AppColors.accent : AppColors.warning,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ground Verification Warning
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Depth is an estimate. Verify on the ground.',
                            style: TextStyle(
                              color: AppColors.warning,
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Sticky Bottom Action Bar
          if (onViewOnMap != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onViewOnMap!(pocket);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_rounded, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'FOCUS & VIEW ON MAP',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
