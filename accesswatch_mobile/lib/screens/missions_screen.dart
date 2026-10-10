import 'package:flutter/material.dart';
import '../models/demo_data.dart';
import '../theme/app_theme.dart';
import '../widgets/demo_badge.dart';
import '../widgets/mission_card_detail.dart';

class MissionsScreen extends StatefulWidget {
  final Function(Pocket)? onViewOnMap;

  const MissionsScreen({super.key, this.onViewOnMap});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  String _selectedFilter = 'ALL';
  final String _sortBy = 'PRIORITY';

  void _showMissionCardSheet(Pocket pocket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (context, scrollController) {
          return MissionCardDetail(
            pocket: pocket,
            onViewOnMap: widget.onViewOnMap,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter Pockets
    List<Pocket> filteredPockets = DEMO_DATA.pockets.where((p) {
      if (_selectedFilter == 'ALL') return true;
      if (_selectedFilter == 'BOAT') return p.accessMode == 'BOAT';
      if (_selectedFilter == 'TRUCK') return p.accessMode == 'HIGH-CLEARANCE TRUCK';
      if (_selectedFilter == 'VEHICLE') return p.accessMode == 'VEHICLE';
      if (_selectedFilter == 'ON FOOT') return p.accessMode == 'ON FOOT';
      return true;
    }).toList();

    // Sort Pockets
    if (_sortBy == 'POPULATION') {
      filteredPockets.sort((a, b) => b.population.compareTo(a.population));
    } else {
      filteredPockets.sort((a, b) => a.rank.compareTo(b.rank));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'RESPONSE MISSIONS',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${filteredPockets.length} Isolated Communities',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const DemoBadge(compact: true),
                ],
              ),
            ),

            // Filter Chips Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: ['ALL', 'BOAT', 'TRUCK', 'VEHICLE', 'ON FOOT'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedFilter = filter);
                      },
                      selectedColor: AppColors.accent,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.background : AppColors.text,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                      side: const BorderSide(color: AppColors.border),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),

            // Missions List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filteredPockets.length,
                itemBuilder: (context, index) {
                  final p = filteredPockets[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: AppColors.surface,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _showMissionCardSheet(p),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Row: Rank & Badges
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '#${p.rank.toString().padLeft(2, '0')}',
                                        style: const TextStyle(
                                          color: AppColors.accent,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      p.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: AppColors.textMuted.withValues(alpha: 0.6),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Stats Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${p.population} people estimated',
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: p.status == 'CUT OFF'
                                        ? AppColors.highRisk.withValues(alpha: 0.15)
                                        : AppColors.warning.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    p.status,
                                    style: TextStyle(
                                      color: p.status == 'CUT OFF' ? AppColors.highRisk : AppColors.warning,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Access Mode & Services Lost Tags
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    p.accessMode,
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Lost: ${p.servicesLost.join(', ')}',
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
