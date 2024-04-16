// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/leaderboard/view/leaderboard_page.dart';
import 'package:io_crossword/player/player.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

void main() {
  group('PlayerRankingInformation', () {
    late PlayerBloc playerBloc;
    late Widget widget;

    setUp(() {
      playerBloc = _MockPlayerBloc();
      widget = BlocProvider(
        create: (_) => playerBloc,
        child: PlayerRankingInformation(),
      );
    });

    testWidgets(
      'renders $SegmentedButton',
      (tester) async {
        when(() => playerBloc.state).thenReturn(
          PlayerState(),
        );

        await tester.pumpApp(widget);

        expect(find.byType(SegmentedButton), findsOneWidget);
      },
    );

    testWidgets(
      'displays rank',
      (tester) async {
        when(() => playerBloc.state).thenReturn(
          PlayerState(
            rank: 50,
          ),
        );

        await tester.pumpApp(widget);

        expect(find.text('50'), findsOneWidget);
      },
    );

    testWidgets(
      'displays score',
      (tester) async {
        when(() => playerBloc.state).thenReturn(
          PlayerState(
            player: Player(
              id: 'userId',
              initials: 'ABC',
              score: 200,
              streak: 10,
              mascot: Mascots.sparky,
            ),
            rank: 50,
          ),
        );

        await tester.pumpApp(widget);

        expect(find.text('200'), findsOneWidget);
      },
    );

    testWidgets(
      'displays streak',
      (tester) async {
        when(() => playerBloc.state).thenReturn(
          PlayerState(
            player: Player(
              id: 'userId',
              initials: 'ABC',
              score: 200,
              streak: 10,
              mascot: Mascots.sparky,
            ),
            rank: 50,
          ),
        );

        await tester.pumpApp(widget);

        expect(find.text('10'), findsOneWidget);
      },
    );

    testWidgets(
      'displays LeaderboardPage when tapped',
      (tester) async {
        when(() => playerBloc.state).thenReturn(
          PlayerState(
            player: Player(
              id: 'userId',
              initials: 'ABC',
              score: 200,
              streak: 10,
              mascot: Mascots.sparky,
            ),
            rank: 50,
          ),
        );

        await tester.pumpApp(widget);

        await tester.tap(find.byType(SegmentedButton));

        await tester.pumpAndSettle();

        expect(find.byType(LeaderboardPage), findsOneWidget);
      },
    );
  });
}
