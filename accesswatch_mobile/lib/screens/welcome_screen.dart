import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../router.dart';
import '../state/providers.dart';
import '../theme/app_theme.dart';

/// Three intro pages, then the safety message. On first run it must be accepted
/// before the app opens; from Info it can be read again.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _pages = PageController();
  int _page = 0;
  bool _understood = false;

  static const _pageCount = 4;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _next() => _pages.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);

  void _finish() {
    ref.read(safetyAcceptedProvider.notifier).state = true;
    context.canPop() ? context.pop() : context.go(AppRoutes.map);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final accepted = ref.watch(safetyAcceptedProvider);
    final intro = [
      (Icons.radar_rounded, l.introTitle1, l.introBody1),
      (Icons.satellite_alt_rounded, l.introTitle2, l.introBody2),
      (Icons.touch_app_rounded, l.introTitle3, l.introBody3),
    ];
    final onSafety = _page == _pageCount - 1;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pages,
                onPageChanged: (page) => setState(() => _page = page),
                children: [
                  for (final (icon, title, body) in intro) _Page(icon: icon, title: title, body: body),
                  _Page(
                    icon: Icons.health_and_safety_rounded,
                    title: l.safetyTitle,
                    body: l.safetyBody,
                    extra: [
                      Text(l.safetyEmergency,
                          style: const TextStyle(color: AppColors.highRisk, fontSize: 16, fontWeight: FontWeight.w900, height: 1.35)),
                      const SizedBox(height: 16),
                      if (!accepted)
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _understood,
                          activeColor: AppColors.accent,
                          onChanged: (v) => setState(() => _understood = v ?? false),
                          title: Text(l.safetyCheckbox, style: const TextStyle(color: AppColors.text, fontSize: 14)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Semantics(
              label: l.introProgress('${_page + 1}', '$_pageCount'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _pageCount; i++)
                    Container(
                      width: i == _page ? 20 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: i == _page ? AppColors.accent : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: onSafety ? (accepted || _understood ? _finish : null) : _next,
                  child: Text(onSafety ? (accepted ? l.close : l.safetyAccept) : l.introNext),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final IconData icon;
  final String title, body;
  final List<Widget> extra;

  const _Page({required this.icon, required this.title, required this.body, this.extra = const []});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 40, 28, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 48, color: AppColors.accent),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(color: AppColors.ink, fontSize: 24, fontWeight: FontWeight.w900, height: 1.2)),
            const SizedBox(height: 14),
            Text(body, style: const TextStyle(color: AppColors.text, fontSize: 15, height: 1.45)),
            const SizedBox(height: 20),
            ...extra,
          ],
        ),
      );
}
