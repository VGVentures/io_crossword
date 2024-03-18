import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockGameIntroBloc extends MockBloc<GameIntroEvent, GameIntroState>
    implements GameIntroBloc {}

void main() {
  group('GameIntroPage', () {
    testWidgets('renders GameIntroView', (tester) async {
      await tester.pumpApp(const GameIntroPage());

      expect(find.byType(GameIntroView), findsOneWidget);
    });
  });

  group('GameIntroView', () {
    late GameIntroBloc gameIntroBloc;
    late Widget child;

    setUp(() {
      gameIntroBloc = _MockGameIntroBloc();

      child = BlocProvider.value(
        value: gameIntroBloc,
        child: const GameIntroView(),
      );
    });

    testWidgets(
      'renders the welcome view with the default state',
      (tester) async {
        when(() => gameIntroBloc.state).thenReturn(
          const GameIntroState(),
        );
        await tester.pumpApp(child);

        expect(find.byType(WelcomeView), findsOneWidget);
      },
    );

    testWidgets(
      'renders the mascot selection view when the status is mascotSelection',
      (tester) async {
        when(() => gameIntroBloc.state).thenReturn(
          const GameIntroState(status: GameIntroStatus.mascotSelection),
        );
        await tester.pumpApp(child);

        expect(find.byType(MascotSelectionView), findsOneWidget);
      },
    );

    testWidgets(
      'renders the initials input view when the status is initialsInput',
      (tester) async {
        when(() => gameIntroBloc.state).thenReturn(
          const GameIntroState(status: GameIntroStatus.initialsInput),
        );
        await tester.pumpApp(child);

        expect(find.byType(InitialsInputView), findsOneWidget);
      },
    );

    testWidgets(
      'pops the navigator when the intro is completed',
      (tester) async {
        whenListen(
          gameIntroBloc,
          Stream.value(
            const GameIntroState(isIntroCompleted: true),
          ),
          initialState: const GameIntroState(
            status: GameIntroStatus.initialsInput,
          ),
        );
        await tester.pumpApp(child);
        expect(find.byType(GameIntroView), findsOneWidget);

        await tester.pumpAndSettle();
        expect(find.byType(GameIntroView), findsNothing);
      },
    );
  });
}
