import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Set<String> _keys(String file) => (jsonDecode(File('lib/l10n/$file').readAsStringSync()) as Map<String, dynamic>)
    .keys
    .where((k) => !k.startsWith('@'))
    .toSet();

void main() {
  test('English and Portuguese ARB files have the same keys', () {
    expect(_keys('app_pt.arb').difference(_keys('app_en.arb')), isEmpty);
    expect(_keys('app_en.arb').difference(_keys('app_pt.arb')), isEmpty);
  });

  test('no notebook number is typed into the warning text', () {
    final en = jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync()) as Map<String, dynamic>;
    expect(en['warnClassifierCalibrated'], contains('{classifierIou}'));
    expect(en['warnValidationProductOrder'], contains('{hours}'));
  });
}
