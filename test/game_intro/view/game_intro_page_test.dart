// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/bloc/crossword_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/initials/view/initials_page.dart';
import 'package:io_crossword/welcome/view/welcome_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockGameIntroBloc extends MockBloc<GameIntroEvent, GameIntroState>
    implements GameIntroBloc {}

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

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
      'renders the $MascotSelectionView when the status is mascotSelection',
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
      'renders the $InitialsPage when the status is initialsInput',
      (tester) async {
        when(() => gameIntroBloc.state).thenReturn(
          const GameIntroState(status: GameIntroStatus.initialsInput),
        );
        await tester.pumpApp(child);

        expect(find.byType(InitialsPage), findsOneWidget);
      },
    );

    testWidgets(
      'pops the navigator when completed',
      (tester) async {
        const state = GameIntroState(status: GameIntroStatus.initialsInput);
        whenListen(
          gameIntroBloc,
          Stream.value(state),
          initialState: const GameIntroState(
            status: GameIntroStatus.initialsInput,
          ),
        );

        final flowController = FlowController<GameIntroState>(state);

        final leaderboardResource = _MockLeaderboardResource();
        when(
          () => leaderboardResource.createScore(
            initials: 'AAA',
            mascot: Mascots.dash,
          ),
        ).thenAnswer((_) => Future.value());

        await tester.pumpApp(
          leaderboardResource: leaderboardResource,
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: gameIntroBloc),
              BlocProvider.value(value: crosswordBloc),
            ],
            child: GameIntroView(flowController: flowController),
          ),
        );

        flowController.complete();

        await tester.pump();
        await tester.pump(const Duration(seconds: 5));

        expect(find.byType(GameIntroView), findsNothing);
      },
    );
  });
}
