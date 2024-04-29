// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/game_intro/bloc/game_intro_bloc.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockGameIntroBloc extends MockBloc<GameIntroEvent, GameIntroState>
    implements GameIntroBloc {}

class _MockHowToPlayCubit extends MockCubit<int> implements HowToPlayCubit {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Flame.images = Images(prefix: '');
    await Flame.images.loadAll([
      Mascots.dash.teamMascot.lookUpAnimation.keyName,
      Mascots.android.teamMascot.lookUpAnimation.keyName,
      Mascots.dino.teamMascot.lookUpAnimation.keyName,
      Mascots.sparky.teamMascot.lookUpAnimation.keyName,
    ]);
  });

  group('$HowToPlayPage', () {
    late GameIntroBloc gameIntroBloc;
    late PlayerBloc playerBloc;

    setUp(() {
      gameIntroBloc = _MockGameIntroBloc();
      playerBloc = _MockPlayerBloc();
    });

    testWidgets('displays a $HowToPlayView', (tester) async {
      when(() => gameIntroBloc.state).thenReturn(GameIntroState());
      when(() => playerBloc.state)
          .thenReturn(PlayerState(mascot: Mascots.dash));

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: gameIntroBloc,
            ),
            BlocProvider.value(
              value: playerBloc,
            ),
          ],
          child: HowToPlayPage(),
        ),
        layout: IoLayoutData.small,
      );

      expect(find.byType(HowToPlayView), findsOneWidget);
    });
  });

  group('$HowToPlayView', () {
    late GameIntroBloc gameIntroBloc;
    late HowToPlayCubit howToPlayCubit;
    late PlayerBloc playerBloc;
    late Widget widget;

    setUp(() {
      gameIntroBloc = _MockGameIntroBloc();
      howToPlayCubit = _MockHowToPlayCubit();
      playerBloc = _MockPlayerBloc();

      when(() => howToPlayCubit.state).thenReturn(0);

      when(() => playerBloc.state)
          .thenReturn(PlayerState(mascot: Mascots.dash));

      widget = MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: gameIntroBloc,
          ),
          BlocProvider.value(
            value: howToPlayCubit,
          ),
          BlocProvider.value(
            value: playerBloc,
          ),
        ],
        child: HowToPlayView(),
      );
    });

    for (final layout in IoLayoutData.values) {
      testWidgets('displays IoAppBar with $layout', (tester) async {
        when(() => gameIntroBloc.state).thenReturn(
          GameIntroState(
            status: GameIntroPlayerCreationStatus.inProgress,
          ),
        );

        await tester.pumpApp(
          widget,
          layout: layout,
        );

        expect(find.byType(IoAppBar), findsOneWidget);
      });
    }

    for (final layout in IoLayoutData.values) {
      testWidgets('completes flow when button is pressed', (tester) async {
        final flowController = FlowController(GameIntroStatus.howToPlay);
        addTearDown(flowController.dispose);

        when(() => gameIntroBloc.state).thenReturn(GameIntroState());

        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: gameIntroBloc,
              ),
              BlocProvider.value(
                value: howToPlayCubit,
              ),
              BlocProvider.value(
                value: playerBloc,
              ),
            ],
            child: FlowBuilder<GameIntroStatus>(
              controller: flowController,
              onGeneratePages: (_, __) => [
                const MaterialPage(child: HowToPlayView()),
              ],
            ),
          ),
          layout: layout,
        );

        await tester.tap(find.byType(OutlinedButton));
        await tester.pumpAndSettle();

        expect(flowController.completed, isTrue);
      });
      
      testWidgets('completes flow when done button is pressed', (tester) async {
        final flowController = FlowController(GameIntroStatus.howToPlay);
        final l10n = await AppLocalizations.delegate.load(Locale('en'));
        addTearDown(flowController.dispose);

        when(() => gameIntroBloc.state).thenReturn(GameIntroState());
        when(() => howToPlayCubit.state).thenReturn(4);
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: gameIntroBloc,
              ),
              BlocProvider.value(
                value: howToPlayCubit,
              ),
              BlocProvider.value(
                value: playerBloc,
              ),
            ],
            child: FlowBuilder<GameIntroStatus>(
              controller: flowController,
              onGeneratePages: (_, __) => [
                const MaterialPage(child: HowToPlayView()),
              ],
            ),
          ),
          layout: layout,
        );

        await tester.tap(find.text(l10n.doneButtonLabel));
        await tester.pumpAndSettle();

        expect(flowController.completed, isTrue);
      });
    }

    group('displays', () {
      for (final status in GameIntroPlayerCreationStatus.values.toList()
        ..remove(GameIntroPlayerCreationStatus.inProgress)) {
        testWidgets(
            'an $OutlinedButton with $status'
            'when small layout', (tester) async {
          when(() => gameIntroBloc.state)
              .thenReturn(GameIntroState(status: status));

          await tester.pumpApp(
            widget,
            layout: IoLayoutData.small,
          );

          expect(find.byType(OutlinedButton), findsOneWidget);
        });
      }

      for (final status in GameIntroPlayerCreationStatus.values.toList()
        ..remove(GameIntroPlayerCreationStatus.inProgress)) {
        testWidgets(
            'an $OutlinedButton with $status'
            'when large layout', (tester) async {
          when(() => gameIntroBloc.state)
              .thenReturn(GameIntroState(status: status));

          await tester.pumpApp(
            widget,
            layout: IoLayoutData.large,
          );

          expect(find.byType(OutlinedButton), findsOneWidget);
        });
      }

      testWidgets('localized playNow text', (tester) async {
        late final AppLocalizations l10n;

        when(() => gameIntroBloc.state).thenReturn(GameIntroState());

        await tester.pumpApp(
          Builder(
            builder: (context) {
              l10n = context.l10n;
              return widget;
            },
          ),
          layout: IoLayoutData.small,
        );

        expect(find.text(l10n.playNow), findsOneWidget);
      });

      testWidgets(
        'an $CircularProgressIndicator '
        'with ${GameIntroPlayerCreationStatus.inProgress}',
        (tester) async {
          when(() => gameIntroBloc.state).thenReturn(
            GameIntroState(
              status: GameIntroPlayerCreationStatus.inProgress,
            ),
          );

          await tester.pumpApp(
            widget,
            layout: IoLayoutData.small,
          );

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );

      for (final mascot in Mascots.values) {
        testWidgets('renders LookUp animation for each mascot', (tester) async {
          when(() => playerBloc.state).thenReturn(PlayerState(mascot: mascot));

          when(() => gameIntroBloc.state).thenReturn(GameIntroState());

          await tester.pumpApp(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: gameIntroBloc,
                ),
                BlocProvider.value(
                  value: howToPlayCubit,
                ),
                BlocProvider.value(
                  value: playerBloc,
                ),
              ],
              child: HowToPlayView(),
            ),
            layout: IoLayoutData.small,
          );

          final widget = find.byType(LookUp).evaluate().single.widget as LookUp;

          expect(
            widget.mascot,
            equals(mascot),
          );
        });
      }
    });
  });
}
