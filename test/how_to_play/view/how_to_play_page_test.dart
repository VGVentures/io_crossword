// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/game_intro/bloc/game_intro_bloc.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class _MockGameIntroBloc extends MockBloc<GameIntroEvent, GameIntroState>
    implements GameIntroBloc {}

void main() {
  group('$HowToPlayPage', () {
    late GameIntroBloc gameIntroBloc;
    late Widget widget;

    setUp(() {
      gameIntroBloc = _MockGameIntroBloc();
      widget = BlocProvider.value(
        value: gameIntroBloc,
        child: HowToPlayPage(),
      );
    });

    testWidgets('displays a $HowToPlayView', (tester) async {
      when(() => gameIntroBloc.state).thenReturn(GameIntroState());

      await tester.pumpApp(widget);

      expect(find.byType(HowToPlayView), findsOneWidget);
    });
  });

  group('$HowToPlayView', () {
    late GameIntroBloc gameIntroBloc;
    late Widget widget;

    setUp(() {
      gameIntroBloc = _MockGameIntroBloc();
      widget = BlocProvider.value(
        value: gameIntroBloc,
        child: HowToPlayView(),
      );
    });

    testWidgets('completes flow when button is pressed', (tester) async {
      final flowController = FlowController(GameIntroStatus.howToPlay);
      addTearDown(flowController.dispose);

      when(() => gameIntroBloc.state).thenReturn(GameIntroState());

      await tester.pumpApp(
        BlocProvider.value(
          value: gameIntroBloc,
          child: FlowBuilder<GameIntroStatus>(
            controller: flowController,
            onGeneratePages: (_, __) => [
              const MaterialPage(child: HowToPlayView()),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();

      expect(flowController.completed, isTrue);
    });

    group('displays', () {
      for (final status in GameIntroPlayerCreationStatus.values.toList()
        ..remove(GameIntroPlayerCreationStatus.inProgress)) {
        testWidgets('an $OutlinedButton with $status', (tester) async {
          when(() => gameIntroBloc.state)
              .thenReturn(GameIntroState(status: status));

          await tester.pumpApp(widget);

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

          await tester.pumpApp(widget);

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );
    });
  });
}
