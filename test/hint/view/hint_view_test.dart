// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/hint/view/hint_view.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('GeminiTextField', () {
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    testWidgets('displays type hint', (tester) async {
      await tester.pumpApp(GeminiTextField());

      expect(find.text(l10n.type), findsOneWidget);
    });

    testWidgets('displays gemini icon', (tester) async {
      await tester.pumpApp(GeminiTextField());

      expect(find.byIcon(IoIcons.gemini), findsOneWidget);
    });

    testWidgets('displays send icon', (tester) async {
      await tester.pumpApp(GeminiTextField());

      expect(find.byIcon(Icons.send), findsOneWidget);
    });
  });
}
