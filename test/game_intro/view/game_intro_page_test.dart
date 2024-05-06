// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/game_intro/bloc/game_intro_bloc.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/initials/view/initials_page.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/loading/loading.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword/welcome/view/welcome_page.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockGameIntroBloc extends MockBloc<GameIntroEvent, GameIntroState>
    implements GameIntroBloc {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

class _MockLoadingCubit extends MockCubit<LoadingState>
    implements LoadingCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameIntroPage', () {
    testWidgets('renders GameIntroView', (tester) async {
      await tester.pumpApp(GameIntroPage());

      expect(find.byType(GameIntroView), findsOneWidget);
    });
  });

  group('GameIntroView', () {
    late GameIntroBloc gameIntroBloc;
    late PlayerBloc playerBloc;
    late LoadingCubit loadingCubit;
    late Widget widget;

    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));

      Flame.images = Images(prefix: '');
      await Flame.images.loadAll([
        ...Mascots.dash.teamMascot.loadableAssets(),
        ...Mascots.android.teamMascot.loadableAssets(),
        ...Mascots.dino.teamMascot.loadableAssets(),
        ...Mascots.sparky.teamMascot.loadableAssets(),
      ]);
    });

    setUp(() {
      gameIntroBloc = _MockGameIntroBloc();
      playerBloc = _MockPlayerBloc();
      loadingCubit = _MockLoadingCubit();

      when(() => loadingCubit.load()).thenAnswer((_) async => {});
      when(() => loadingCubit.state).thenReturn(
        LoadingState(
          status: LoadingStatus.loaded,
          assetsCount: 1,
          loaded: 1,
        ),
      );

      widget = BlocProvider.value(
        value: gameIntroBloc,
        child: GameIntroView(),
      );
    });

    testWidgets(
      'renders the $LoadingPage by default',
      (tester) async {
        when(() => gameIntroBloc.state).thenReturn(GameIntroState());

        await tester.pumpApp(widget);

        expect(find.byType(LoadingPage), findsOneWidget);
      },
    );

    testWidgets(
      'renders the $WelcomePage with the state is welcome',
      (tester) async {
        when(() => gameIntroBloc.state).thenReturn(GameIntroState());

        final flowController =
            FlowController<GameIntroStatus>(GameIntroStatus.welcome);
        addTearDown(flowController.dispose);

        await tester.pumpApp(
          BlocProvider.value(
            value: gameIntroBloc,
            child: GameIntroView(
              flowController: flowController,
            ),
          ),
        );

        expect(find.byType(WelcomePage), findsOneWidget);
      },
    );

    testWidgets(
      'renders the $TeamSelectionPage when the status is teamSelection',
      (tester) async {
        when(() => gameIntroBloc.state).thenReturn(GameIntroState());

        final flowController =
            FlowController<GameIntroStatus>(GameIntroStatus.teamSelection);
        addTearDown(flowController.dispose);

        await tester.pumpApp(
          BlocProvider.value(
            value: gameIntroBloc,
            child: GameIntroView(
              flowController: flowController,
            ),
          ),
        );

        expect(find.byType(TeamSelectionPage), findsOneWidget);
      },
    );

    testWidgets(
      'renders the $InitialsPage when the status is enterInitials',
      (tester) async {
        when(() => gameIntroBloc.state).thenReturn(GameIntroState());

        final flowController =
            FlowController<GameIntroStatus>(GameIntroStatus.enterInitials);
        addTearDown(flowController.dispose);

        await tester.pumpApp(
          BlocProvider.value(
            value: gameIntroBloc,
            child: GameIntroView(
              flowController: flowController,
            ),
          ),
        );

        expect(find.byType(InitialsPage), findsOneWidget);
      },
    );

    testWidgets(
      'renders the $HowToPlayPage when the status is howToPlay',
      (tester) async {
        when(() => gameIntroBloc.state).thenReturn(GameIntroState());
        when(() => playerBloc.state)
            .thenReturn(PlayerState(mascot: Mascots.dash));

        final flowController =
            FlowController<GameIntroStatus>(GameIntroStatus.howToPlay);
        addTearDown(flowController.dispose);

        await tester.pumpApp(
          BlocProvider.value(
            value: gameIntroBloc,
            child: GameIntroView(
              flowController: flowController,
            ),
          ),
          playerBloc: playerBloc,
        );

        expect(find.byType(HowToPlayPage), findsOneWidget);
      },
    );

    testWidgets(
      'calls GameIntroPlayerCreated when completed FlowBuilder',
      (tester) async {
        final flowController =
            FlowController<GameIntroStatus>(GameIntroStatus.enterInitials);
        addTearDown(flowController.dispose);

        when(() => gameIntroBloc.state).thenReturn(GameIntroState());

        when(() => playerBloc.state).thenReturn(
          PlayerState(
            mascot: Mascots.sparky,
            player: Player.empty.copyWith(
              initials: 'ABC',
              mascot: Mascots.sparky,
            ),
          ),
        );

        await tester.pumpApp(
          playerBloc: playerBloc,
          BlocProvider.value(
            value: gameIntroBloc,
            child: GameIntroView(flowController: flowController),
          ),
        );

        flowController.complete();

        await tester.pump();
        await tester.pump(const Duration(seconds: 5));

        verify(
          () => gameIntroBloc.add(
            GameIntroPlayerCreated(
              initials: 'ABC',
              mascot: Mascots.sparky,
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'navigates to CrosswordPage '
      'when GameIntroPlayerCreationStatus.success',
      (tester) async {
        whenListen(
          gameIntroBloc,
          Stream.value(
            GameIntroState(
              status: GameIntroPlayerCreationStatus.success,
            ),
          ),
          initialState: GameIntroState(),
        );

        when(() => playerBloc.state).thenReturn(
          PlayerState(mascot: Mascots.dash),
        );

        await tester.pumpApp(
          widget,
          playerBloc: playerBloc,
          loadingCubit: loadingCubit,
        );

        await tester.pump();
        await tester.pump();

        expect(find.byType(CrosswordPage), findsOneWidget);
      },
    );

    testWidgets(
      'navigates to CrosswordPage '
      'when ${GameIntroPlayerCreationStatus.failure}',
      (tester) async {
        whenListen(
          gameIntroBloc,
          Stream.value(
            GameIntroState(
              status: GameIntroPlayerCreationStatus.failure,
            ),
          ),
          initialState: GameIntroState(),
        );

        await tester.pumpApp(
          widget,
        );

        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(l10n.errorPromptText), findsOneWidget);
      },
    );
  });
}
