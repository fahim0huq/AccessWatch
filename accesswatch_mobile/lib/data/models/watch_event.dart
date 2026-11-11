// An event the Watch screen can list, from the local assets/events/events.json.
// Only events whose data is the bundle have satellite data in this build.

enum EventKind { flood, cycloneFlooding }

EventKind _kind(String v) => switch (v) {
  'flood' => EventKind.flood,
  'cyclone_flooding' => EventKind.cycloneFlooding,
  _ => throw FormatException('unknown event kind: $v'),
};

class WatchEvent {
  final String id;
  final EventKind kind;

  /// True when the event's data is the bundled one (dates and area from its manifest).
  final bool hasBundleData;
  final Map<String, String> names;

  const WatchEvent({required this.id, required this.kind, required this.hasBundleData, required this.names});

  factory WatchEvent.fromJson(Map<String, dynamic> j) => WatchEvent(
    id: j['id'] as String,
    kind: _kind(j['kind'] as String),
    hasBundleData: j['data'] == 'bundle',
    names: (j['name'] as Map<String, dynamic>).cast<String, String>(),
  );

  /// The name in [languageCode], or English.
  String name(String languageCode) => names[languageCode] ?? names['en']!;
}

List<WatchEvent> parseWatchEvents(Map<String, dynamic> json) => [
  for (final e in json['events'] as List) WatchEvent.fromJson(e as Map<String, dynamic>),
];

const _plain = {
  'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'ç': 'c', 'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e', //
  'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', 'ñ': 'n', 'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', //
  'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
};

/// Lower case without accents, so "chokwe" finds "Chókwè".
String plainSearchText(String s) => s.toLowerCase().split('').map((c) => _plain[c] ?? c).join();

/// Events of [kind] whose name, in either language, contains [query].
List<WatchEvent> filterEvents(List<WatchEvent> events, EventKind kind, String query) {
  final q = plainSearchText(query.trim());
  return [
    for (final e in events)
      if (e.kind == kind && (q.isEmpty || e.names.values.any((n) => plainSearchText(n).contains(q)))) e,
  ];
}
