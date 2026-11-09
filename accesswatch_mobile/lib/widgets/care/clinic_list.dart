import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../state/care_state.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/labels.dart';
import 'care_common.dart';

/// Every clinic with its status from the bundle. With a position, also how each
/// mode reaches it; tapping one makes it the route target.
class ClinicList extends ConsumerWidget {
  const ClinicList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final fmt = Fmt.of(context);
    final bundle = ref.watch(loadedBundleProvider);
    final routes = ref.watch(careRoutesProvider).valueOrNull;
    final target = ref.watch(targetClinicIdProvider);
    return CareCard(
      title: l.allClinicsTitle(fmt.count(bundle.clinics.length)),
      children: [
        for (final clinic in bundle.clinics)
          Material(
            color: clinic.id == target ? AppColors.truckTint : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: routes == null ? null : () => ref.read(targetClinicIdProvider.notifier).state = clinic.id,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                child: Builder(builder: (context) {
                  final (icon, color) = clinicStatusLook(clinic.clinicStatus!);
                  final reach = routes == null
                      ? null
                      : routes.needsBoat(clinic.id)
                          ? l.needsBoatShort
                          : routes.byMode.keys.any((m) => routes.forMode(m, clinic.id)?.route.isAtTarget ?? false)
                              ? l.alreadyHereShort
                              : [
                                  for (final mode in routes.byMode.keys)
                                    if (routes.forMode(mode, clinic.id) case final r?)
                                      '${careModeLabel(l, mode)} ${l.distanceKm(fmt.km(r.route.lengthM / 1000))}',
                                ].join(' · ');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.serviceName(clinic), style: careBodyStyle.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(icon, size: 16, color: color),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(l.clinicStatus(clinic.clinicStatus!, clinic.pocketId),
                                style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      if (reach != null) Text(reach, style: careMutedStyle),
                    ],
                  );
                }),
              ),
            ),
          ),
        const SizedBox(height: 6),
        Text(l.clinicStatusNote, style: careMutedStyle),
        if (bundle.quality.notes.clinicRecordPairsWithin100m > 0) Text(l.clinicDuplicateNote, style: careMutedStyle),
      ],
    );
  }
}
