// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/loading/loading.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$LoadingProgress', () {
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    testWidgets('displays 100%', (tester) async {
      await tester.pumpApp(const LoadingProgress(progress: 100));

      expect(find.text(l10n.percentage(100)), findsOneWidget);
    });
  });
}
