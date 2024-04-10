// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_focused/word_focused.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../../helpers/helpers.dart';

class _FakeWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => null;

  @override
  String get id => 'id';

  @override
  String get answer => 'answer';
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

    testWidgets('renders top bar', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(SuccessTopBar), findsOneWidget);
    });

    testWidgets('renders $IoPlayerAlias', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(IoPlayerAlias), findsOneWidget);
    });

    testWidgets('renders success stats', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(SuccessStats), findsOneWidget);
    });

    testWidgets('renders keep playing button', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(KeepPlayingButton), findsOneWidget);
    });

    testWidgets('renders claim badge button', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(ClaimBadgeButton), findsOneWidget);
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

    testWidgets('renders top bar', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(SuccessTopBar), findsOneWidget);
    });

    testWidgets('renders $IoPlayerAlias', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(IoPlayerAlias), findsOneWidget);
    });

    testWidgets('renders success stats', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(SuccessStats), findsOneWidget);
    });

    testWidgets('renders keep playing button', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(KeepPlayingButton), findsOneWidget);
    });

    testWidgets('renders claim badge button', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(ClaimBadgeButton), findsOneWidget);
    });
  });

  group('SuccessTopBar', () {});

  group('KeepPlayingButton', () {});

  group('ClaimBadgeButton', () {});
}
