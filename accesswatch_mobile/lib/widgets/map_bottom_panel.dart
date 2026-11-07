// Lower panel: SAR pipeline button + horizontal pocket selector chips.
import 'package:flutter/material.dart';
import '../models/demo_data.dart';
import '../theme/app_theme.dart';
import 'analysis_progress_modal.dart';

class MapBottomPanel extends StatelessWidget {
  final List<Pocket> pockets;
  final String selectedPocketId;
  final void Function(Pocket) onSelectPocket;
  final VoidCallback onAnalysisComplete;

  const MapBottomPanel({
    super.key,
    required this.pockets,
    required this.selectedPocketId,
    required this.onSelectPocket,
    required this.onAnalysisComplete,
  });

  void _runAnalysis(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AnalysisProgressModal(onComplete: onAnalysisComplete),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => _runAnalysis(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, size: 20),
                  SizedBox(width: 8),
                  Text('RUN SAR PIPELINE ANALYSIS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ISOLATED COMMUNITIES', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                Text('${pockets.length} Ranked Pockets', style: const TextStyle(color: AppColors.accent, fontSize: 11, fontFamily: 'monospace')),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pockets.length,
                itemBuilder: (context, index) {
                  final p = pockets[index];
                  final isSelected = p.id == selectedPocketId;
                  return GestureDetector(
                    onTap: () => onSelectPocket(p),
                    child: Container(
                      width: 135,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accent.withValues(alpha: 0.15) : AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? AppColors.accent : AppColors.border, width: isSelected ? 1.5 : 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('#${p.rank.toString().padLeft(2, '0')}', style: TextStyle(color: isSelected ? AppColors.accent : Colors.white, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                              Text(p.accessMode, style: const TextStyle(color: AppColors.warning, fontSize: 9, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Text(p.name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('${p.population} people', style: const TextStyle(color: AppColors.textMuted, fontSize: 10, fontFamily: 'monospace')),
                        ],
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

