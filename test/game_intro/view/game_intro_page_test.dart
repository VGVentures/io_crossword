// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/bloc/crossword_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/welcome/view/welcome_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockGameIntroBloc extends MockBloc<GameIntroEvent, GameIntroState>
    implements GameIntroBloc {}

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

void main() {
  group('GameIntroPage', () {
    testWidgets('renders GameIntroView', (tester) async {
      await tester.pumpApp(GameIntroPage());

      expect(find.byType(GameIntroView), findsOneWidget);
    });
  });

  group('GameIntroView', () {
    late CrosswordBloc crosswordBloc;
    late GameIntroBloc gameIntroBloc;
    late Widget child;

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();
      gameIntroBloc = _MockGameIntroBloc();

      child = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: gameIntroBloc),
          BlocProvider.value(value: crosswordBloc),
        ],
        child: const GameIntroView(),
      );
    });

    testWidgets(
      'renders the $WelcomePage with the default state',
      (tester) async {
        when(() => gameIntroBloc.state).thenReturn(
          const GameIntroState(),
        );
        await tester.pumpApp(child);

        expect(find.byType(WelcomePage), findsOneWidget);
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
      'adds MascotSelected event to the crossword bloc when the mascot '
      'is selected',
      (tester) async {
        whenListen(
          gameIntroBloc,
          Stream.value(
            GameIntroState(
              status: GameIntroStatus.initialsInput,
              selectedMascot: Mascots.android,
            ),
          ),
          initialState: GameIntroState(status: GameIntroStatus.mascotSelection),
        );
        await tester.pumpApp(child);
        verify(() => crosswordBloc.add(MascotSelected(Mascots.android)))
            .called(1);
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
      'saves the initials when the intro is completed',
      (tester) async {
        whenListen(
          gameIntroBloc,
          Stream.value(
            GameIntroState(
              status: GameIntroStatus.initialsInput,
              isIntroCompleted: true,
              initialsStatus: InitialsFormStatus.success,
              initials: ['I', 'I', 'O'],
            ),
          ),
          initialState: GameIntroState(
            status: GameIntroStatus.initialsInput,
          ),
        );
        await tester.pumpApp(child);

        verify(() => crosswordBloc.add(InitialsSelected(['I', 'I', 'O'])))
            .called(1);
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

        await tester.pump();
        await tester.pump(const Duration(seconds: 5));
        expect(find.byType(GameIntroView), findsNothing);
      },
    );
  });
}
