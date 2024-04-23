// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(Locale('en'));
  });

  group('$EndGameContent', () {
    testWidgets('displays thanksForContributing', (tester) async {
      await tester.pumpApp(EndGameContent());

      expect(find.text(l10n.thanksForContributing), findsOneWidget);
    });

    testWidgets('displays EndGameHowMade', (tester) async {
      await tester.pumpApp(EndGameContent());

      expect(find.byType(EndGameHowMade), findsOneWidget);
    });

    testWidgets('displays PlayerInitials', (tester) async {
      await tester.pumpApp(EndGameContent());

      expect(find.byType(PlayerInitials), findsOneWidget);
    });

    testWidgets('displays ScoreInformation', (tester) async {
      await tester.pumpApp(EndGameContent());

      expect(find.byType(ScoreInformation), findsOneWidget);
    });
  });

  group('$ActionButtonsEndGame', () {
    testWidgets('displays share', (tester) async {
      await tester.pumpApp(ActionButtonsEndGame());

      expect(find.text(l10n.share), findsOneWidget);
    });

    testWidgets('displays playAgain', (tester) async {
      await tester.pumpApp(ActionButtonsEndGame());

      expect(find.text(l10n.playAgain), findsOneWidget);
    });

    testWidgets('displays claimBadgeContributing', (tester) async {
      await tester.pumpApp(ActionButtonsEndGame());

      expect(find.text(l10n.claimBadgeContributing), findsOneWidget);
    });

    testWidgets('displays developerProfile', (tester) async {
      await tester.pumpApp(ActionButtonsEndGame());

      expect(find.text(l10n.developerProfile), findsOneWidget);
    });
  });

  group('$EndGameHowMade', () {
    late UrlLauncherPlatform urlLauncher;

    setUpAll(() {
      registerFallbackValue(_FakeLaunchOptions());
    });

    setUp(() {
      urlLauncher = _MockUrlLauncherPlatform();

      UrlLauncherPlatform.instance = urlLauncher;

      when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => true);
      when(() => urlLauncher.launchUrl(any(), any()))
          .thenAnswer((_) async => true);
    });

    testWidgets(
      'displays information how made and open source',
      (tester) async {
        await tester.pumpApp(EndGameHowMade());

        final text =
            '${l10n.learn} ${l10n.howMade} ${l10n.and} ${l10n.openSourceCode}.';

        expect(find.text(text, findRichText: true), findsOneWidget);
      },
    );

    testWidgets(
      'calls launchUrl when tapped on open source code',
      (tester) async {
        await tester.pumpApp(EndGameHowMade());

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              find.tapTextSpan(
                widget,
                l10n.openSourceCode,
              ),
        );

        await tester.tap(finder);

        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            'https://github.com/VGVentures/io_crossword',
            any(),
          ),
        );
      },
    );
  });
}