// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/player/bloc/player_bloc.dart';
import 'package:io_crossword/streak/streak.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

void main() {
  group('$CrosswordBackdrop', () {
    late WordSelectionBloc wordSelectionBloc;
    late CrosswordLayoutData layoutData;
    late PlayerBloc playerBloc;

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();

      playerBloc = _MockPlayerBloc();

      layoutData = CrosswordLayoutData.fromConfiguration(
        configuration: const CrosswordConfiguration(
          bottomRight: (40, 40),
          chunkSize: 20,
        ),
        cellSize: const Size.square(20),
      );
    });

    testWidgets('pumps successfully', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: wordSelectionBloc,
          child: CrosswordLayoutScope(
            data: layoutData,
            child: const CrosswordBackdrop(),
          ),
        ),
      );

      expect(find.byType(CrosswordBackdrop), findsOneWidget);
    });

    testWidgets('emits $WordUnselected when tapped', (tester) async {
      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(status: WordSelectionStatus.solving),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: wordSelectionBloc,
          child: CrosswordLayoutScope(
            data: layoutData,
            child: const CrosswordBackdrop(),
          ),
        ),
      );

      await tester.tap(find.byType(CrosswordBackdrop));

      verify(() => wordSelectionBloc.add(const WordUnselected())).called(1);
    });

    testWidgets(
        'does not emit $WordUnselected when tapped '
        'with player streak at 1 and word solving in progress', (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(streak: 1)),
      );
      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(status: WordSelectionStatus.solving),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: wordSelectionBloc,
          child: CrosswordLayoutScope(
            data: layoutData,
            child: const CrosswordBackdrop(),
          ),
        ),
        playerBloc: playerBloc,
      );

      await tester.tap(find.byType(CrosswordBackdrop));

      verifyNever(() => wordSelectionBloc.add(const WordUnselected()));
    });

    testWidgets(
        'displays StreakAtRiskView when tapped '
        'with player streak at 1 and word solving in progress', (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(streak: 1)),
      );
      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(status: WordSelectionStatus.solving),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: wordSelectionBloc,
          child: CrosswordLayoutScope(
            data: layoutData,
            child: const CrosswordBackdrop(),
          ),
        ),
        playerBloc: playerBloc,
      );

      await tester.tap(find.byType(CrosswordBackdrop));

      await tester.pumpAndSettle();

      expect(find.byType(StreakAtRiskView), findsOneWidget);
    });
  });
}
