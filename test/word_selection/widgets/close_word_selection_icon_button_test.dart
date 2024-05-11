// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/streak/streak.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

void main() {
  group('$CloseWordSelectionIconButton', () {
    late CrosswordBloc crosswordBloc;
    late WordSelectionBloc wordSelectionBloc;
    late PlayerBloc playerBloc;

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();
      wordSelectionBloc = _MockWordSelectionBloc();
      playerBloc = _MockPlayerBloc();
    });

    testWidgets('renders $CloseWordSelectionIconButton', (tester) async {
      await tester.pumpApp(const CloseWordSelectionIconButton());

      expect(find.byType(CloseWordSelectionIconButton), findsOneWidget);
    });

    testWidgets('emits $WordUnselected when tapped with player streak at 0',
        (tester) async {
      await tester.pumpApp(
        crosswordBloc: crosswordBloc,
        BlocProvider(
          create: (_) => wordSelectionBloc,
          child: const CloseWordSelectionIconButton(),
        ),
      );

      await tester.tap(find.byType(CloseWordSelectionIconButton));
      await tester.pumpAndSettle();

      verify(() => wordSelectionBloc.add(const WordUnselected())).called(1);
    });

    testWidgets(
        'does not add $WordUnselected when tapped '
        'with player streak at 1 and word solving in progress', (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(streak: 1)),
      );
      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(status: WordSelectionStatus.solving),
      );

      await tester.pumpApp(
        crosswordBloc: crosswordBloc,
        playerBloc: playerBloc,
        BlocProvider(
          create: (_) => wordSelectionBloc,
          child: const CloseWordSelectionIconButton(),
        ),
      );

      await tester.tap(find.byType(CloseWordSelectionIconButton));
      await tester.pumpAndSettle();

      verifyNever(
        () => wordSelectionBloc.add(const WordUnselected()),
      );
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
        crosswordBloc: crosswordBloc,
        playerBloc: playerBloc,
        BlocProvider(
          create: (_) => wordSelectionBloc,
          child: const CloseWordSelectionIconButton(),
        ),
      );

      await tester.tap(find.byType(CloseWordSelectionIconButton));
      await tester.pumpAndSettle();

      expect(find.byType(StreakAtRiskView), findsOneWidget);
    });
  });
}
