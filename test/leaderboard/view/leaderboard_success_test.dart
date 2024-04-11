// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:io_crossword/leaderboard/view/leaderboard_page.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockLeaderboardBloc extends MockBloc<LeaderboardEvent, LeaderboardState>
    implements LeaderboardBloc {}

void main() {
  group('LeaderboardSuccess', () {
    late LeaderboardBloc leaderboardBloc;
    late Widget widget;

    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      leaderboardBloc = _MockLeaderboardBloc();

      widget = BlocProvider<LeaderboardBloc>(
        create: (_) => leaderboardBloc,
        child: LeaderboardSuccess(),
      );
    });

    testWidgets(
      'displays rank title',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());

        await tester.pumpApp(widget);

        expect(find.text(l10n.rank), findsOneWidget);
      },
    );

    testWidgets(
      'displays streak title',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());

        await tester.pumpApp(widget);

        expect(find.text(l10n.streak), findsOneWidget);
      },
    );

    testWidgets(
      'displays score title',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());

        await tester.pumpApp(widget);

        expect(find.text(l10n.score), findsOneWidget);
      },
    );

    testWidgets(
      'renders UserLeaderboardRanking',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(
          LeaderboardState(
            players: List.generate(
              10,
              (index) => LeaderboardPlayer(
                userId: '',
                initials: 'AAA',
                score: 50,
                streak: 2,
                mascot: Mascots.dash,
              ),
            ),
          ),
        );

        await tester.pumpApp(widget);

        expect(find.byType(UserLeaderboardRanking), findsNWidgets(10));
      },
    );

    testWidgets(
      'displays rank positions based on number of players',
      (tester) async {
        const numberOfPlayers = 10;

        when(() => leaderboardBloc.state).thenReturn(
          LeaderboardState(
            players: List.generate(
              numberOfPlayers,
              (index) => LeaderboardPlayer(
                userId: '',
                initials: 'AAA',
                score: 50,
                streak: 20,
                mascot: Mascots.dash,
              ),
            ),
          ),
        );

        await tester.pumpApp(widget);

        for (var i = 1; i <= numberOfPlayers; i++) {
          expect(find.text(i.toString()), findsOneWidget);
        }
      },
    );

    testWidgets(
      'does not display playAgain and icon on big screen',
      (tester) async {
        tester.view.physicalSize = Size(IoCrosswordBreakpoints.medium * 3, 600);

        addTearDown(tester.view.resetPhysicalSize);

        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());

        await tester.pumpApp(widget);

        expect(find.text(l10n.playAgain), findsNothing);
        expect(find.byIcon(Icons.gamepad), findsNothing);
      },
    );

    testWidgets(
      'displays playAgain and icon in button',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());

        await tester.pumpApp(widget);

        expect(find.text(l10n.playAgain), findsOneWidget);
        expect(find.byIcon(Icons.gamepad), findsOneWidget);
      },
    );

    testWidgets(
      'pops the screen when playAgain is tapped',
      (tester) async {
        final mockNavigator = MockNavigator();

        when(mockNavigator.canPop).thenReturn(true);

        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());

        await tester.pumpApp(
          widget,
          navigator: mockNavigator,
        );

        await tester.tap(find.text(l10n.playAgain));

        verify(mockNavigator.pop).called(1);
      },
    );
  });

  group('CurrentUserPosition', () {
    late AppLocalizations l10n;
    const player = LeaderboardPlayer(
      userId: '123',
      initials: 'ABC',
      score: 200,
      streak: 2,
      mascot: Mascots.dash,
    );

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    testWidgets(
      'displays you',
      (tester) async {
        await tester.pumpApp(CurrentUserPosition(player: player, rank: 4));

        expect(find.text('${l10n.you}:'), findsOneWidget);
      },
    );

    testWidgets(
      'renders UserLeaderboardRanking',
      (tester) async {
        await tester.pumpApp(CurrentUserPosition(player: player, rank: 4));

        expect(find.byType(UserLeaderboardRanking), findsOneWidget);

        final userRankingWidget = tester.widget<UserLeaderboardRanking>(
          find.byType(UserLeaderboardRanking),
        );

        expect(userRankingWidget.rank, equals(4));
        expect(userRankingWidget.player, equals(player));
      },
    );
  });

  group('UserLeaderboardRanking', () {
    const player = LeaderboardPlayer(
      userId: '123',
      initials: 'ABC',
      score: 200,
      streak: 25,
      mascot: Mascots.dash,
    );

    testWidgets(
      'displays streak',
      (tester) async {
        await tester.pumpApp(CurrentUserPosition(player: player, rank: 7));

        expect(find.text('25'), findsOneWidget);
      },
    );

    testWidgets(
      'displays rank',
      (tester) async {
        await tester.pumpApp(CurrentUserPosition(player: player, rank: 7));

        expect(find.text('7'), findsOneWidget);
      },
    );

    testWidgets(
      'displays rank with k(1000)',
      (tester) async {
        await tester.pumpApp(CurrentUserPosition(player: player, rank: 7500));

        expect(find.text('7.5K'), findsOneWidget);
      },
    );

    testWidgets(
      'displays score',
      (tester) async {
        await tester.pumpApp(CurrentUserPosition(player: player, rank: 7));

        expect(find.text('7'), findsOneWidget);
      },
    );

    testWidgets(
      'displays score with k(1000)',
      (tester) async {
        const player = LeaderboardPlayer(
          userId: '123',
          initials: 'ABC',
          score: 23700,
          streak: 2,
          mascot: Mascots.dash,
        );

        await tester.pumpApp(CurrentUserPosition(player: player, rank: 4));

        expect(find.text('23.7K'), findsOneWidget);
      },
    );

    testWidgets(
      'displays players initials',
      (tester) async {
        await tester.pumpApp(CurrentUserPosition(player: player, rank: 7));

        expect(find.text('A'), findsOneWidget);
        expect(find.text('B'), findsOneWidget);
        expect(find.text('C'), findsOneWidget);
      },
    );

    for (final mascot in [
      _MascotTester(
        mascot: Mascots.dash,
        color: IoCrosswordColors.flutterBlue,
      ),
      _MascotTester(
        mascot: Mascots.sparky,
        color: IoCrosswordColors.sparkyYellow,
      ),
      _MascotTester(
        mascot: Mascots.dino,
        color: IoCrosswordColors.chromeRed,
      ),
      _MascotTester(
        mascot: Mascots.android,
        color: IoCrosswordColors.androidGreen,
      ),
    ]) {
      testWidgets(
        'displays color for ${mascot.mascot}',
        (tester) async {
          final player = LeaderboardPlayer(
            userId: '123',
            initials: 'ABC',
            score: 23700,
            streak: 2,
            mascot: mascot.mascot,
          );

          await tester.pumpApp(CurrentUserPosition(player: player, rank: 4));

          expect(
            tester.widget<IoWord>(find.byType(IoWord)).style.backgroundColor,
            equals(mascot.color),
          );
        },
      );
    }
  });
}

class _MascotTester {
  const _MascotTester({
    required this.mascot,
    required this.color,
  });

  final Mascots mascot;
  final Color color;
}
