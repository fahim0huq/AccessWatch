import 'package:flutter/material.dart';
import '../models/demo_data.dart';
import '../theme/app_theme.dart';
import '../widgets/demo_badge.dart';
import '../widgets/map_painter.dart';
import '../widgets/mission_card_detail.dart';
import '../widgets/analysis_progress_modal.dart';

class MapScreen extends StatefulWidget {
  final String? initialPocketId;
  final Function(int)? onNavigateToTab;

  const MapScreen({
    super.key,
    this.initialPocketId,
    this.onNavigateToTab,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isBeforeFlood = false;
  late String _selectedPocketId;
  final TransformationController _transformationController = TransformationController();

  Map<String, bool> _layerVisibility = {
    'flood': true,
    'waterDepth': true,
    'roads': true,
    'services': true,
    'pockets': true,
    'routes': true,
  };

  @override
  void initState() {
    super.initState();
    _selectedPocketId = widget.initialPocketId ?? 'pocket-01';
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void focusOnPocket(Pocket pocket) {
    setState(() {
      _selectedPocketId = pocket.id;
    });

    final targetX = (pocket.coordinates.dx / 100) * 1200;
    final targetY = (pocket.coordinates.dy / 100) * 840;

    _transformationController.value = Matrix4.identity()
      ..translate(-targetX + 200, -targetY + 200)
      ..scale(1.65);
  }

  void _onSelectPocket(Pocket pocket) {
    focusOnPocket(pocket);
    _showMissionCardSheet(pocket);
  }

  void _showRoadSegmentDialog(RoadSegment road) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ROAD SEGMENT',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: road.depthClass == DepthClass.deep
                          ? AppColors.floodDeep.withValues(alpha: 0.2)
                          : road.depthClass == DepthClass.medium
                              ? AppColors.floodMedium.withValues(alpha: 0.2)
                              : AppColors.floodShallow.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      road.depthClass.label,
                      style: TextStyle(
                        color: road.depthClass == DepthClass.deep
                            ? AppColors.floodDeep
                            : road.depthClass == DepthClass.medium
                                ? AppColors.floodMedium
                                : AppColors.floodShallow,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                road.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Estimated water depth',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${road.estimatedDepthMeters.toStringAsFixed(2)} m',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      road.depthClass.label,
                      style: TextStyle(
                        color: road.depthClass == DepthClass.deep
                            ? AppColors.floodDeep
                            : road.depthClass == DepthClass.medium
                                ? AppColors.floodMedium
                                : AppColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Estimated — verify on the ground.',
                style: TextStyle(
                  color: AppColors.warning,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('CLOSE', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMissionCardSheet(Pocket pocket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (context, scrollController) {
          return MissionCardDetail(
            pocket: pocket,
            onViewOnMap: (p) {
              focusOnPocket(p);
            },
          );
        },
      ),
    );
  }

  void _showLayersSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          final layers = [
            {'key': 'flood', 'label': 'Flood extent'},
            {'key': 'waterDepth', 'label': 'Water depth'},
            {'key': 'roads', 'label': 'Roads'},
            {'key': 'services', 'label': 'Services'},
            {'key': 'pockets', 'label': 'Communities'},
            {'key': 'routes', 'label': 'Routes'},
          ];

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LAYERS CONTROL',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 12),
                ...layers.map((l) {
                  final key = l['key'] as String;
                  final label = l['label'] as String;
                  return CheckboxListTile(
                    title: Text(
                      label,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    value: _layerVisibility[key] ?? true,
                    activeColor: AppColors.accent,
                    onChanged: (val) {
                      setSheetState(() {
                        _layerVisibility[key] = val ?? true;
                      });
                      setState(() {});
                    },
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  void _runAnalysis() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AnalysisProgressModal(
        onComplete: () {
          setState(() {
            _isBeforeFlood = false;
            _layerVisibility = {
              'flood': true,
              'roads': true,
              'services': true,
              'pockets': true,
              'routes': true,
            };
          });
        },
      ),
    );
  }

  void _zoomIn() {
    final matrix = _transformationController.value.clone();
    matrix.scale(1.3);
    _transformationController.value = matrix;
  }

  void _zoomOut() {
    final matrix = _transformationController.value.clone();
    matrix.scale(0.75);
    _transformationController.value = matrix;
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.radar, color: AppColors.accent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'MISSION CONTROL',
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
                  const DemoBadge(compact: true),
                ],
              ),
            ),

            // Segmented Control: BEFORE FLOOD | AFTER FLOOD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isBeforeFlood = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !_isBeforeFlood ? AppColors.highRisk.withValues(alpha: 0.2) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: !_isBeforeFlood ? AppColors.highRisk.withValues(alpha: 0.5) : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bolt, size: 14, color: !_isBeforeFlood ? AppColors.highRisk : AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                'AFTER FLOOD (SAR)',
                                style: TextStyle(
                                  color: !_isBeforeFlood ? AppColors.highRisk : AppColors.textMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isBeforeFlood = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _isBeforeFlood ? AppColors.warning.withValues(alpha: 0.2) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isBeforeFlood ? AppColors.warning.withValues(alpha: 0.5) : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wb_sunny, size: 14, color: _isBeforeFlood ? AppColors.warning : AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                'BEFORE FLOOD',
                                style: TextStyle(
                                  color: _isBeforeFlood ? AppColors.warning : AppColors.textMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // MAIN INTERACTIVE MAP VIEWPORT (NO BLACK SIDES)
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  InteractiveViewer(
                    transformationController: _transformationController,
                    boundaryMargin: const EdgeInsets.all(400),
                    minScale: 1.0,
                    maxScale: 3.8,
                    child: SizedBox(
                      width: 1200,
                      height: 840,
                      child: Stack(
                        children: [
                          // Base Map Image
                          AnimatedCrossFade(
                            firstChild: Image.asset(
                              'assets/maps/map_bright.jpg',
                              width: 1200,
                              height: 840,
                              fit: BoxFit.cover,
                            ),
                            secondChild: Image.asset(
                              'assets/maps/map_radar_flood.jpg',
                              width: 1200,
                              height: 840,
                              fit: BoxFit.cover,
                            ),
                            crossFadeState: _isBeforeFlood
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 500),
                          ),

                          // GIS CustomPaint Overlay
                          CustomPaint(
                            size: const Size(1200, 840),
                            painter: MapPainter(
                              pockets: DEMO_DATA.pockets,
                              services: DEMO_DATA.services,
                              roads: DEMO_DATA.roads,
                              floodZones: DEMO_DATA.floodZones,
                              selectedPocketId: _selectedPocketId,
                              isBeforeFlood: _isBeforeFlood,
                              layerVisibility: _layerVisibility,
                            ),
                          ),

                          // Interactive Road Segment Taps Overlay
                          if (!_isBeforeFlood && (_layerVisibility['roads'] ?? true))
                            ...DEMO_DATA.roads.map((road) {
                              if (road.points.isEmpty) return const SizedBox.shrink();
                              final midPoint = road.points[road.points.length ~/ 2];
                              final left = (midPoint.dx / 100) * 1200 - 28;
                              final top = (midPoint.dy / 100) * 840 - 12;
                              return Positioned(
                                left: left,
                                top: top,
                                child: GestureDetector(
                                  onTap: () => _showRoadSegmentDialog(road),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: road.depthClass == DepthClass.deep
                                          ? AppColors.floodDeep
                                          : road.depthClass == DepthClass.medium
                                              ? AppColors.floodMedium
                                              : AppColors.floodShallow,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1),
                                      boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4)],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.water,
                                          size: 10,
                                          color: road.depthClass == DepthClass.deep ? Colors.white : Colors.black87,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          '${road.estimatedDepthMeters.toStringAsFixed(2)}m',
                                          style: TextStyle(
                                            color: road.depthClass == DepthClass.deep ? Colors.white : Colors.black87,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),

                  // Floating Map Controls (Zoom In, Zoom Out, Reset, Layers)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          heroTag: 'btnLayers',
                          onPressed: _showLayersSheet,
                          backgroundColor: AppColors.surface,
                          child: const Icon(Icons.layers_rounded, color: AppColors.accent),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: 'btnZoomIn',
                          onPressed: _zoomIn,
                          backgroundColor: AppColors.surface,
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: 'btnZoomOut',
                          onPressed: _zoomOut,
                          backgroundColor: AppColors.surface,
                          child: const Icon(Icons.remove, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: 'btnResetView',
                          onPressed: _resetZoom,
                          backgroundColor: AppColors.surface,
                          child: const Icon(Icons.center_focus_strong, color: AppColors.accent),
                        ),
                      ],
                    ),
                  ),

                  // Floating Radar Label
                  if (!_isBeforeFlood)
                    const Positioned(
                      top: 12,
                      left: 16,
                      child: RadarViewBadge(),
                    ),

                  // Floating Water Depth Map Legend
                  if (!_isBeforeFlood && (_layerVisibility['waterDepth'] ?? true))
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'WATER DEPTH',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.floodShallow,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'SHALLOW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '< 0.3 m',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 10,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.floodMedium,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'MEDIUM',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '0.3–0.8 m',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 10,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.floodDeep,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'DEEP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '> 0.8 m',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 10,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Estimated depth — verify on the ground.',
                              style: TextStyle(
                                color: AppColors.warning,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // LOWER SECTION: Action Button & Priorities List
            Container(
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
                    // Action Trigger Button
                    ElevatedButton(
                      onPressed: _runAnalysis,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.background,
                        minimumSize: const Size(double.infinity, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_rounded, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'RUN SAR PIPELINE ANALYSIS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Top Priorities Title & Pocket Selector Chips
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ISOLATED COMMUNITIES',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                        Text(
                          '${DEMO_DATA.pockets.length} Ranked Pockets',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Pocket Items Horizontal List
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: DEMO_DATA.pockets.length,
                        itemBuilder: (context, index) {
                          final p = DEMO_DATA.pockets[index];
                          final isSelected = p.id == _selectedPocketId;

                          return GestureDetector(
                            onTap: () => _onSelectPocket(p),
                            child: Container(
                              width: 135,
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.accent.withValues(alpha: 0.15) : AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.accent : AppColors.border,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '#${p.rank.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          color: isSelected ? AppColors.accent : Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                      Text(
                                        p.accessMode,
                                        style: const TextStyle(
                                          color: AppColors.warning,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${p.population} people',
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 10,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}
