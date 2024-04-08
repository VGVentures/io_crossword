// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_focused/word_focused.dart';

import '../../helpers/helpers.dart';

class _FakeWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => null;

  @override
  String get id => 'id';
}

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(Locale('en'));
  });

  group('WordSuccessDesktopView', () {
    late Widget widget;

    setUp(() {
      final wordSelection = WordSelection(section: (0, 0), word: _FakeWord());

      widget = WordSuccessDesktopView(wordSelection);
    });

    testWidgets('renders word solved text', (tester) async {
      await tester.pumpApp(widget);

      expect(find.text(l10n.wordSolved), findsOneWidget);
    });
  });

  group('WordSuccessMobileView', () {
    late Widget widget;

    setUp(() {
      final wordSelection = WordSelection(section: (0, 0), word: _FakeWord());

      widget = WordSuccessMobileView(wordSelection);
    });

    testWidgets('renders word solved text', (tester) async {
      await tester.pumpApp(widget);

      expect(find.text(l10n.wordSolved), findsOneWidget);
    });
  });
}
