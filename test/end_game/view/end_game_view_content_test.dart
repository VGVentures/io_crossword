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
import 'package:io_crossword/share/share.dart';
import 'package:io_crossword/widget/widget.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

class _MockAudioController extends Mock implements AudioController {}

void main() {
  late AppLocalizations l10n;
  late AudioController audioController;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(Locale('en'));
  });

  late PlayerBloc playerBloc;

  setUp(() {
    playerBloc = _MockPlayerBloc();

    audioController = _MockAudioController();
  });

  group('$EndGameContent', () {
    testWidgets('displays thanksForContributing', (tester) async {
      await tester.pumpApp(SingleChildScrollView(child: EndGameContent()));

      expect(find.text(l10n.thanksForContributing), findsOneWidget);
    });

    testWidgets('displays HowMade', (tester) async {
      await tester.pumpApp(SingleChildScrollView(child: EndGameContent()));

      expect(find.byType(HowMade), findsOneWidget);
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
      final mockNavigator = MockNavigator();

      when(mockNavigator.canPop).thenReturn(true);

      await tester.pumpApp(
        ActionButtonsEndGame(),
        audioController: audioController,
        navigator: mockNavigator,
      );

      await tester.tap(find.text(l10n.playAgain));

      await tester.pumpAndSettle();
      verify(
        () => audioController.playSfx(Assets.music.startButton1),
      ).called(1);
    });

    testWidgets('displays CrosswordPage when playAgain tapped', (tester) async {
      final mockNavigator = MockNavigator();

      when(mockNavigator.canPop).thenReturn(true);
      when(() => mockNavigator.pushReplacement(any())).thenAnswer((_) async {});

      await tester.pumpApp(
        ActionButtonsEndGame(),
        playerBloc: playerBloc,
        navigator: mockNavigator,
      );

      await tester.tap(find.text(l10n.playAgain));

      verify(() => mockNavigator.pushReplacement(CrosswordPage.route()))
          .called(1);
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

  group('$EndGameImage', () {
    testWidgets('displays endGameDash image with ${Mascots.dash}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascots.dash)),
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

    testWidgets('displays endGameDash image with ${Mascots.dino}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascots.dino)),
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

    testWidgets('displays endGameDash image with ${Mascots.sparky}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascots.sparky)),
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

    testWidgets('displays endGameDash image with ${Mascots.android}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascots.android)),
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
