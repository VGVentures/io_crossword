// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/streak/streak.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

void main() {
  group('$StreakAtRiskView', () {
    late AppLocalizations l10n;
    late LeaderboardResource leaderboardResource;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      leaderboardResource = _MockLeaderboardResource();
    });

    group('check', () {
      late WordSelectionBloc wordSelectionBloc;
      late PlayerBloc playerBloc;

      setUp(() {
        wordSelectionBloc = _MockWordSelectionBloc();
        playerBloc = _MockPlayerBloc();
      });

      for (final status in WordSelectionStatus.values) {
        testWidgets(
          'calls onLeave when players streak is 0 with $status',
          (tester) async {
            var onLeave = false;

            when(() => playerBloc.state).thenReturn(PlayerState());
            when(() => wordSelectionBloc.state)
                .thenReturn(WordSelectionState(status: status));

            await tester.pumpStreakDialogCheck(
              playerBloc: playerBloc,
              wordSelectionBloc: wordSelectionBloc,
              onLeave: () {
                onLeave = true;
              },
            );

            await tester.tapStreakRisk();

            expect(onLeave, isTrue);
          },
        );
      }

      for (final status in WordSelectionStatus.values) {
        testWidgets(
          'does not display StreakAtRiskView when players streak '
          'is 0 with $status',
          (tester) async {
            when(() => playerBloc.state).thenReturn(PlayerState());
            when(() => wordSelectionBloc.state)
                .thenReturn(WordSelectionState(status: status));

            await tester.pumpStreakDialogCheck(
              playerBloc: playerBloc,
              wordSelectionBloc: wordSelectionBloc,
              onLeave: () {},
            );

            await tester.tapStreakRisk();

            expect(find.byType(StreakAtRiskView), findsNothing);
          },
        );
      }

      for (final status in [
        WordSelectionStatus.empty,
        WordSelectionStatus.preSolving,
        WordSelectionStatus.solved,
      ]) {
        testWidgets(
          'calls onLeave when players streak is not 0 with $status',
          (tester) async {
            var onLeave = false;

            when(() => playerBloc.state).thenReturn(
              PlayerState(player: Player.empty.copyWith(streak: 1)),
            );
            when(() => wordSelectionBloc.state)
                .thenReturn(WordSelectionState(status: status));

            await tester.pumpStreakDialogCheck(
              playerBloc: playerBloc,
              wordSelectionBloc: wordSelectionBloc,
              onLeave: () {
                onLeave = true;
              },
            );

            await tester.tapStreakRisk();

            expect(onLeave, isTrue);
          },
        );
      }

      for (final status in [
        WordSelectionStatus.empty,
        WordSelectionStatus.preSolving,
        WordSelectionStatus.solved,
      ]) {
        testWidgets(
          'does not display StreakAtRiskView when players '
          'streak is not 0 with $status',
          (tester) async {
            when(() => playerBloc.state).thenReturn(
              PlayerState(player: Player.empty.copyWith(streak: 1)),
            );
            when(() => wordSelectionBloc.state)
                .thenReturn(WordSelectionState(status: status));

            await tester.pumpStreakDialogCheck(
              playerBloc: playerBloc,
              wordSelectionBloc: wordSelectionBloc,
              onLeave: () {},
            );

            await tester.tapStreakRisk();

            expect(find.byType(StreakAtRiskView), findsNothing);
          },
        );
      }

      for (final status in [
        WordSelectionStatus.validating,
        WordSelectionStatus.incorrect,
        WordSelectionStatus.failure,
        WordSelectionStatus.solving,
      ]) {
        testWidgets(
          'does not call onLeave when players streak is not 0 with $status',
          (tester) async {
            var onLeave = false;

            when(() => playerBloc.state).thenReturn(
              PlayerState(player: Player.empty.copyWith(streak: 1)),
            );
            when(() => wordSelectionBloc.state)
                .thenReturn(WordSelectionState(status: status));

            await tester.pumpStreakDialogCheck(
              playerBloc: playerBloc,
              wordSelectionBloc: wordSelectionBloc,
              onLeave: () {
                onLeave = true;
              },
            );

            await tester.tapStreakRisk();

            await tester.pumpAndSettle();

            expect(onLeave, isFalse);
          },
        );
      }

      for (final status in [
        WordSelectionStatus.validating,
        WordSelectionStatus.incorrect,
        WordSelectionStatus.failure,
        WordSelectionStatus.solving,
      ]) {
        testWidgets(
          'renders StreakAtRiskView when players streak is not 0 with $status',
          (tester) async {
            when(() => playerBloc.state).thenReturn(
              PlayerState(player: Player.empty.copyWith(streak: 1)),
            );
            when(() => wordSelectionBloc.state)
                .thenReturn(WordSelectionState(status: status));

            await tester.pumpStreakDialogCheck(
              playerBloc: playerBloc,
              wordSelectionBloc: wordSelectionBloc,
              onLeave: () {},
            );

            await tester.tapStreakRisk();

            await tester.pumpAndSettle();

            expect(find.byType(StreakAtRiskView), findsOneWidget);
          },
        );
      }
    });

    testWidgets(
      'renders $IoPhysicalModel',
      (tester) async {
        await tester.pumpApp(
          StreakAtRiskView(
            onLeave: () {},
          ),
        );

        expect(find.byType(IoPhysicalModel), findsOneWidget);
      },
    );

    testWidgets(
      'renders $CloseButton',
      (tester) async {
        await tester.pumpApp(
          StreakAtRiskView(
            onLeave: () {},
          ),
        );

        expect(find.byType(CloseButton), findsOneWidget);
      },
    );

    testWidgets(
      'displays streakAtRiskMessage',
      (tester) async {
        await tester.pumpApp(
          StreakAtRiskView(
            onLeave: () {},
          ),
        );

        expect(find.text(l10n.streakAtRiskMessage), findsOneWidget);
      },
    );

    testWidgets(
      'displays continuationConfirmation',
      (tester) async {
        await tester.pumpApp(
          StreakAtRiskView(
            onLeave: () {},
          ),
        );

        expect(find.text(l10n.streakAtRiskMessage), findsOneWidget);
      },
    );

    testWidgets(
      'renders $LeaveButton',
      (tester) async {
        await tester.pumpApp(
          StreakAtRiskView(
            onLeave: () {},
          ),
        );

        expect(find.byType(LeaveButton), findsOneWidget);
      },
    );

    testWidgets(
      'calls pop when $LeaveButton is tapped',
      (tester) async {
        final mockNavigator = MockNavigator();

        when(mockNavigator.canPop).thenReturn(true);
        when(leaderboardResource.resetStreak).thenAnswer((_) async {});

        await tester.pumpApp(
          StreakAtRiskView(
            onLeave: () {},
          ),
          navigator: mockNavigator,
          leaderboardResource: leaderboardResource,
        );

        await tester.tap(find.byType(LeaveButton));

        await tester.pumpAndSettle();

        verify(mockNavigator.pop).called(1);
      },
    );

    testWidgets(
      'calls resetStreak when $LeaveButton is tapped',
      (tester) async {
        final mockNavigator = MockNavigator();

        when(mockNavigator.canPop).thenReturn(true);
        when(leaderboardResource.resetStreak).thenAnswer((_) async {});

        await tester.pumpApp(
          StreakAtRiskView(
            onLeave: () {},
          ),
          navigator: mockNavigator,
          leaderboardResource: leaderboardResource,
        );

        await tester.tap(find.byType(LeaveButton));

        await tester.pumpAndSettle();

        verify(leaderboardResource.resetStreak).called(1);
      },
    );

    testWidgets(
      'calls onLeave when $LeaveButton is tapped',
      (tester) async {
        var onLeave = false;

        final mockNavigator = MockNavigator();

        when(mockNavigator.canPop).thenReturn(true);
        when(leaderboardResource.resetStreak).thenAnswer((_) async {});

        await tester.pumpApp(
          StreakAtRiskView(
            onLeave: () {
              onLeave = true;
            },
          ),
          navigator: mockNavigator,
          leaderboardResource: leaderboardResource,
        );

        await tester.tap(find.byType(LeaveButton));

        await tester.pumpAndSettle();

        expect(onLeave, isTrue);
      },
    );

    testWidgets(
      'does not call onLeave when onLeave is not pressed',
      (tester) async {
        var onLeave = false;

        await tester.pumpApp(
          StreakAtRiskView(
            onLeave: () {
              onLeave = true;
            },
          ),
        );

        expect(onLeave, isFalse);
      },
    );

    testWidgets(
      'renders $SolveItButton',
      (tester) async {
        await tester.pumpApp(
          StreakAtRiskView(
            onLeave: () {},
          ),
        );

        expect(find.byType(SolveItButton), findsOneWidget);
      },
    );

    testWidgets(
      'calls pop when $SolveItButton is tapped',
      (tester) async {
        final mockNavigator = MockNavigator();

        when(mockNavigator.canPop).thenReturn(true);

        await tester.pumpApp(
          StreakAtRiskView(
            onLeave: () {},
          ),
          navigator: mockNavigator,
        );

        await tester.tap(find.byType(SolveItButton));

        await tester.pumpAndSettle();

        verify(mockNavigator.pop).called(1);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpStreakDialogCheck({
    required PlayerBloc playerBloc,
    required WordSelectionBloc wordSelectionBloc,
    required VoidCallback onLeave,
  }) async {
    return pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: playerBloc),
          BlocProvider.value(value: wordSelectionBloc),
        ],
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                StreakAtRiskView.check(
                  context,
                  onLeave: onLeave,
                );
              },
              child: Text('button'),
            );
          },
        ),
      ),
    );
  }

  Future<void> tapStreakRisk() async {
    await tap(find.text('button'));
  }
}
