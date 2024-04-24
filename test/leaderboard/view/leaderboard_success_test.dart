// ignore_for_file: prefer_const_constructors

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:io_crossword/leaderboard/view/leaderboard_page.dart';
import 'package:io_crossword/player/bloc/player_bloc.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockLeaderboardBloc extends MockBloc<LeaderboardEvent, LeaderboardState>
    implements LeaderboardBloc {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

void main() {
  group('LeaderboardSuccess', () {
    late LeaderboardBloc leaderboardBloc;
    late PlayerBloc playerBloc;
    late Widget widget;
    const user = User(id: 'user-id');

    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      leaderboardBloc = _MockLeaderboardBloc();
      playerBloc = _MockPlayerBloc();

      widget = MultiBlocProvider(
        providers: [
          BlocProvider<LeaderboardBloc>(
            create: (_) => leaderboardBloc,
          ),
          BlocProvider<PlayerBloc>(
            create: (context) => playerBloc,
          ),
        ],
        child: LeaderboardSuccess(),
      );
    });

    testWidgets(
      'displays rank title',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());
        when(() => playerBloc.state).thenReturn(PlayerState());

        await tester.pumpApp(widget);

        expect(find.text(l10n.rank), findsOneWidget);
      },
    );

    testWidgets(
      'displays streak title',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());
        when(() => playerBloc.state).thenReturn(PlayerState());

        await tester.pumpApp(widget);

        expect(find.text(l10n.streak), findsOneWidget);
      },
    );

    testWidgets(
      'displays score title',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());
        when(() => playerBloc.state).thenReturn(PlayerState());

        await tester.pumpApp(widget);

        expect(find.text(l10n.score), findsOneWidget);
      },
    );

    testWidgets(
      'renders CurrentPlayerNotTopRank',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());
        when(() => playerBloc.state).thenReturn(PlayerState());

        await tester.pumpApp(widget);

        expect(find.byType(CurrentPlayerNotTopRank), findsOneWidget);
      },
    );

    testWidgets(
      'renders CurrentUserPosition with one CurrentUserPosition '
      'with the user in the top 10',
      (tester) async {
        final currentPlayer = Player(
          id: user.id,
          initials: 'BBB',
          score: 500,
          streak: 2,
          mascot: Mascots.android,
        );

        when(() => leaderboardBloc.state).thenReturn(
          LeaderboardState(
            players: List.generate(
              9,
              (index) => Player(
                id: '',
                initials: 'AAA',
                score: 50,
                streak: 2,
                mascot: Mascots.dash,
              ),
            )..insert(2, currentPlayer),
          ),
        );
        when(() => playerBloc.state).thenReturn(
          PlayerState(
            rank: 3,
            player: currentPlayer,
          ),
        );

        await tester.pumpApp(
          widget,
          user: user,
        );

        expect(find.byType(UserLeaderboardRanking), findsNWidgets(10));
        expect(find.byType(CurrentUserPosition), findsOneWidget);
      },
    );

    testWidgets(
      'displays rank position based on number of players',
      (tester) async {
        const numberOfPlayers = 10;

        when(() => leaderboardBloc.state).thenReturn(
          LeaderboardState(
            players: List.generate(
              numberOfPlayers,
              (index) => Player(
                id: '',
                initials: 'AAA',
                score: 50,
                streak: 20,
                mascot: Mascots.dash,
              ),
            ),
          ),
        );
        when(() => playerBloc.state).thenReturn(PlayerState());

        await tester.pumpApp(
          widget,
          user: user,
        );

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
        when(() => playerBloc.state).thenReturn(PlayerState());

        await tester.pumpApp(widget);

        expect(find.text(l10n.playAgain), findsNothing);
        expect(find.byIcon(Icons.gamepad), findsNothing);
      },
    );

    testWidgets(
      'displays playAgain and icon in button',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());
        when(() => playerBloc.state).thenReturn(PlayerState());

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
        when(() => playerBloc.state).thenReturn(PlayerState());

        await tester.pumpApp(
          widget,
          navigator: mockNavigator,
        );

        await tester.tap(find.text(l10n.playAgain));

        verify(mockNavigator.pop).called(1);
      },
    );

    group('CurrentPlayerNotTopRank', () {
      setUp(() {
        widget = BlocProvider<PlayerBloc>(
          create: (_) => playerBloc,
          child: CurrentPlayerNotTopRank(),
        );
      });

      for (var i = 1; i <= 10; i++) {
        testWidgets(
          'does not render CurrentUserPosition with player in $i position',
          (tester) async {
            final player = Player(
              id: '1234',
              initials: 'AAA',
              score: 50,
              streak: 2,
              mascot: Mascots.dash,
            );

            when(() => playerBloc.state).thenReturn(
              PlayerState(
                player: player,
                rank: i,
              ),
            );

            await tester.pumpApp(widget);

            expect(find.byType(CurrentUserPosition), findsNothing);
          },
        );
      }

      testWidgets(
        'renders CurrentUserPosition with the players information',
        (tester) async {
          final player = Player(
            id: '1234',
            initials: 'AAA',
            score: 50,
            streak: 2,
            mascot: Mascots.dash,
          );

          when(() => playerBloc.state).thenReturn(
            PlayerState(
              player: player,
              rank: 11,
            ),
          );

          await tester.pumpApp(widget);

          expect(find.byType(CurrentUserPosition), findsOneWidget);
          expect(
            tester
                .widget<CurrentUserPosition>(find.byType(CurrentUserPosition))
                .player,
            equals(player),
          );
        },
      );

      testWidgets(
        'renders CurrentUserPosition with ranking',
        (tester) async {
          when(() => playerBloc.state).thenReturn(
            PlayerState(
              rank: 50,
            ),
          );

          await tester.pumpApp(widget);

          expect(
            tester
                .widget<CurrentUserPosition>(find.byType(CurrentUserPosition))
                .rank,
            equals(50),
          );
        },
      );
    });
  });

  group('CurrentUserPosition', () {
    late AppLocalizations l10n;
    const player = Player(
      id: '123',
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
    const player = Player(
      id: '123',
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
        const player = Player(
          id: '123',
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
          final player = Player(
            id: '123',
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
