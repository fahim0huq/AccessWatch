import 'package:flutter/material.dart';
import '../models/demo_data.dart';
import '../theme/app_theme.dart';
import '../widgets/demo_badge.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const HomeScreen({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: App Title & DEMO DATA Badge
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.radar_rounded, color: AppColors.accent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'ACCESSWATCH',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  DemoBadge(compact: true),
                ],
              ),
              const SizedBox(height: 14),

              // Hero Headline & Subtitle
              const Text(
                'Find who is cut off.\nReach them safely.',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Turn flood observations into clear humanitarian access decisions.',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12.5,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 14),

              // Home Map Preview Card
              Expanded(
                flex: 5,
                child: GestureDetector(
                  onTap: () => onNavigateToTab(1),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.35)),
                      image: const DecorationImage(
                        image: AssetImage('assets/maps/map_bright.jpg'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.1),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.background.withValues(alpha: 0.88),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.topRight,
                            child: RadarViewBadge(),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.safestRoute,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Licungo Basin Flood Sector 4',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Tap to open full pannable GIS map',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Compact KPI Bar (2 Columns)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.highRisk.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.warning_amber_rounded, color: AppColors.highRisk, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${DEMO_DATA.kpis['isolatedPockets']} Pockets',
                                style: const TextStyle(
                                  color: AppColors.text,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const Text(
                                'Road links cut off',
                                style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 32, color: AppColors.border),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.water_drop_rounded, color: AppColors.floodMedium, size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'WATER DEPTH',
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                      children: [
                                        Text('14 SHAL', style: TextStyle(color: AppColors.floodShallow, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                                        const Text(' · ', style: TextStyle(color: AppColors.textMuted, fontSize: 9)),
                                        Text('9 MED', style: TextStyle(color: AppColors.floodMedium, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                                        const Text(' · ', style: TextStyle(color: AppColors.textMuted, fontSize: 9)),
                                        Text('5 DEEP', style: TextStyle(color: AppColors.floodDeep, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // TWO TOP PRIORITY ACTION CARDS
              // Action 1: MISSION CONTROL
              Expanded(
                flex: 4,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => onNavigateToTab(1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.accent.withValues(alpha: 0.4), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.map_rounded, color: AppColors.accent, size: 22),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MISSION CONTROL',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Explore flood & access situation',
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.accent, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Action 2: MISSION CARDS
              Expanded(
                flex: 4,
                child: Material(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => onNavigateToTab(2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.accentSecondary.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.assignment_rounded, color: AppColors.accentSecondary, size: 22),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MISSION CARDS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'View response briefs for 8 isolated communities',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
