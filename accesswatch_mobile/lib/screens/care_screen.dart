import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../state/care_state.dart';
import '../theme/app_theme.dart';
import '../widgets/beta_badge.dart';
import '../widgets/care/care_common.dart';
import '../widgets/care/clinic_list.dart';
import '../widgets/care/my_spot_card.dart';
import '../widgets/care/route_cards.dart';
import '../widgets/location_prompt.dart';

/// Clinics, the user's spot and routes to care.
class CareScreen extends ConsumerStatefulWidget {
  const CareScreen({super.key});

  @override
  ConsumerState<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends ConsumerState<CareScreen> with ShowsLocation {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final usable = ref.watch(mySpotProvider)?.usable ?? false;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(child: Text(l.careTitle, style: careSectionStyle.copyWith(fontSize: 12))),
                const BetaBadge(),
              ],
            ),
            const SizedBox(height: 4),
            Text(l.careSubtitle, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            const MySpotCard(),
            if (usable) const RouteCards(),
            const ClinicList(),
            Text(l.appDisclaimer, style: careMutedStyle.copyWith(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
