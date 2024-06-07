// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/project_details/project_details.dart';
import 'package:io_crossword/share/share.dart';
import 'package:io_crossword/widget/widget.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

class _MockAudioController extends Mock implements AudioController {}

class _MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  late AppLocalizations l10n;
  late AudioController audioController;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(Locale('en'));
  });

  setUp(() {
    audioController = _MockAudioController();
  });

  group('$EndGameContent', () {
    testWidgets('displays thanksForContributing', (tester) async {
      await tester.pumpApp(SingleChildScrollView(child: EndGameContent()));

      expect(find.text(l10n.thanksForContributing), findsOneWidget);
    });

    testWidgets('displays HowMadeAndJoinCompetition', (tester) async {
      await tester.pumpApp(SingleChildScrollView(child: EndGameContent()));

      expect(find.byType(HowMadeAndJoinCompetition), findsOneWidget);
    });

    testWidgets('displays EndGameImage', (tester) async {
      await tester.pumpApp(SingleChildScrollView(child: EndGameContent()));

      expect(find.byType(EndGameImage), findsOneWidget);
    });

    testWidgets('displays PlayerInitials', (tester) async {
      await tester.pumpApp(SingleChildScrollView(child: EndGameContent()));

      expect(find.byType(PlayerInitials), findsOneWidget);
    });

    testWidgets('displays ScoreInformation', (tester) async {
      await tester.pumpApp(SingleChildScrollView(child: EndGameContent()));

      expect(find.byType(ScoreInformation), findsOneWidget);
    });
  });

  group('$ActionButtonsEndGame', () {
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

    testWidgets('displays share', (tester) async {
      await tester.pumpApp(ActionButtonsEndGame());

      expect(find.text(l10n.share), findsOneWidget);
    });

    testWidgets('displays ShareScorePage when share is tapped', (tester) async {
      await tester.pumpApp(
        ActionButtonsEndGame(),
      );

      await tester.tap(find.text(l10n.share));

      await tester.pumpAndSettle();

      expect(find.byType(ShareScorePage), findsOneWidget);
    });

    testWidgets('displays playAgain', (tester) async {
      await tester.pumpApp(ActionButtonsEndGame());

      expect(find.text(l10n.playAgain), findsOneWidget);
    });

    testWidgets('plays ${Assets.music.startButton1} when playAgain tapped',
        (tester) async {
      final navigator = MockNavigator();
      when(navigator.canPop).thenReturn(true);
      when(() => navigator.pushReplacement<void, void>(any())).thenAnswer(
        (_) async {},
      );

      await tester.pumpApp(
        audioController: audioController,
        navigator: navigator,
        ActionButtonsEndGame(),
      );

      await tester.tap(find.text(l10n.playAgain));

      await tester.pumpAndSettle();
      verify(
        () => audioController.playSfx(Assets.music.startButton1),
      ).called(1);
    });

    testWidgets(
      'navigates to $CrosswordPage when playAgain tapped',
      (tester) async {
        final navigator = MockNavigator();
        when(navigator.canPop).thenReturn(true);
        when(() => navigator.pushReplacement<void, void>(any())).thenAnswer(
          (_) async {},
        );

        await tester.pumpApp(
          navigator: navigator,
          ActionButtonsEndGame(),
        );

        await tester.tap(find.text(l10n.playAgain));
        await tester.pumpAndSettle();

        verify(
          () => navigator.pushReplacement<void, void>(
            any(
              that: isRoute(
                whereName: equals(CrosswordPage.routeName),
              ),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets('displays claimBadgeContributing', (tester) async {
      await tester.pumpApp(ActionButtonsEndGame());

      expect(find.text(l10n.claimBadgeContributing), findsOneWidget);
    });

    testWidgets('displays claim badge', (tester) async {
      await tester.pumpApp(ActionButtonsEndGame());

      expect(find.text(l10n.claimBadge), findsOneWidget);
    });

    testWidgets(
      'opens new tab to claim badge when tapped',
      (tester) async {
        await tester.pumpApp(ActionButtonsEndGame());

        await tester.tap(find.text(l10n.claimBadge));
        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            ProjectDetailsLinks.claimBadge,
            any(),
          ),
        );
      },
    );
  });

  group('$EndGameImage', () {
    late PlayerBloc playerBloc;

    setUp(() {
      playerBloc = _MockPlayerBloc();
    });

    testWidgets('displays endGameDash image with ${Mascot.dash}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascot.dash)),
      );

      await tester.pumpApp(
        EndGameImage(),
        playerBloc: playerBloc,
      );

      expect(
        (tester.widget<Image>(find.byType(Image)).image as AssetImage)
            .assetName,
        equals('assets/images/end_game_dash.png'),
      );
    });

    testWidgets('displays endGameDash image with ${Mascot.dino}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascot.dino)),
      );

      await tester.pumpApp(
        EndGameImage(),
        playerBloc: playerBloc,
      );

      await tester.pumpApp(EndGameImage());

      expect(
        (tester.widget<Image>(find.byType(Image)).image as AssetImage)
            .assetName,
        equals('assets/images/end_game_dino.png'),
      );
    });

    testWidgets('displays endGameDash image with ${Mascot.sparky}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascot.sparky)),
      );

      await tester.pumpApp(
        EndGameImage(),
        playerBloc: playerBloc,
      );

      await tester.pumpApp(EndGameImage());

      expect(
        (tester.widget<Image>(find.byType(Image)).image as AssetImage)
            .assetName,
        equals('assets/images/end_game_sparky.png'),
      );
    });

    testWidgets('displays endGameDash image with ${Mascot.android}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascot.android)),
      );

      await tester.pumpApp(
        EndGameImage(),
        playerBloc: playerBloc,
      );

      await tester.pumpApp(EndGameImage());

      expect(
        (tester.widget<Image>(find.byType(Image)).image as AssetImage)
            .assetName,
        equals('assets/images/end_game_android.png'),
      );
    });
  });
}
