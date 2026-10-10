import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/demo_badge.dart';

class InfoScreen extends StatefulWidget {
  final bool isPresentationMode;
  final ValueChanged<bool> onTogglePresentationMode;

  const InfoScreen({
    super.key,
    required this.isPresentationMode,
    required this.onTogglePresentationMode,
  });

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SYSTEM & HONESTY BRIEF',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  DemoBadge(compact: true),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                'AccessWatch Mobile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Satellite SAR Flood Access Analysis',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),

              // Presentation Mode Switch Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Presentation Mode',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Enlarge map view & hide UI clutter for screen recording',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: widget.isPresentationMode,
                      onChanged: widget.onTogglePresentationMode,
                      activeThumbColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // How Depth Is Estimated Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'HOW DEPTH IS ESTIMATED',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'For this demonstration, water depth is represented using synthetic depth classes derived from the relationship between the illustrative flood extent and terrain.',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Depth Threshold Table
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Shallow', style: TextStyle(color: AppColors.floodShallow, fontWeight: FontWeight.bold, fontSize: 12)),
                              Text('< 0.3 m', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12)),
                            ],
                          ),
                          Divider(color: AppColors.border, height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Medium', style: TextStyle(color: AppColors.floodMedium, fontWeight: FontWeight.bold, fontSize: 12)),
                              Text('0.3 – 0.8 m', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12)),
                            ],
                          ),
                          Divider(color: AppColors.border, height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Deep', style: TextStyle(color: AppColors.floodDeep, fontWeight: FontWeight.bold, fontSize: 12)),
                              Text('> 0.8 m', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text(
                      'These are illustrative estimates for the prototype and do not represent actual NISAR measurements or hydraulic simulation.',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Depth is an estimate. Verify on the ground.',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Water Depth KPI Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'WATER DEPTH SUMMARY',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                        Text(
                          'Estimated demo values',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '14',
                              style: TextStyle(
                                color: AppColors.floodShallow,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Shallow',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '9',
                              style: TextStyle(
                                color: AppColors.floodMedium,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Medium',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '5',
                              style: TextStyle(
                                color: AppColors.floodDeep,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Deep',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Mandatory Geographic Honesty Disclaimer Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'GEOGRAPHIC HONESTY NOTICE',
                          style: TextStyle(
                            color: AppColors.warning,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Geographic basemap images are provided for visual context. Flood analysis, population estimates, routes, water depth predictions, and response priorities shown in this demonstration application are synthetic demo data.',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Attribution Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DATA SOURCES & ATTRIBUTION',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Intended Satellite Radar Data: NISAR L-band SAR & Sentinel-1 C-band SAR\n'
                      '• Elevation Data: NASADEM / SRTM 30m DEM\n'
                      '• Population Layer Concepts: WorldPop 100m Population Density\n'
                      '• Basemap & Infrastructure: OpenStreetMap contributors\n\n'
                      'Not affiliated with or endorsed by NASA or ISRO.',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11.5,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
