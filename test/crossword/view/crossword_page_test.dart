// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/about/view/about_view.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword/view/word_focused_view.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends Mock implements CrosswordBloc {}

class _FakeBoardSection extends Fake implements BoardSection {
  @override
  List<Word> get words => [];
}

extension on WidgetTester {
  Future<void> pumpCrosswordView(CrosswordBloc bloc) {
    return pumpApp(
      BlocProvider.value(
        value: bloc,
        child: CrosswordView(),
      ),
    );
  }
}

void main() {
  group('CrosswordPage', () {
    testWidgets('renders CrosswordView', (tester) async {
      await tester.pumpRoute(CrosswordPage.route());
      await tester.pump();

      expect(find.byType(CrosswordView), findsOneWidget);
    });
  });

  group('CrosswordView', () {
    late CrosswordBloc bloc;

    setUp(() {
      bloc = _MockCrosswordBloc();

      whenListen(
        bloc,
        Stream.fromIterable(const <CrosswordState>[]),
        initialState: const CrosswordInitial(),
      );
    });

    testWidgets('shows the game intro page dialog', (tester) async {
      when(() => bloc.state).thenReturn(const CrosswordInitial());

      await tester.pumpCrosswordView(bloc);
      await tester.pump();
      expect(find.byType(GameIntroPage), findsOneWidget);
    });

    testWidgets('renders loading when is initial', (tester) async {
      when(() => bloc.state).thenReturn(const CrosswordInitial());

      await tester.pumpCrosswordView(bloc);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error when is error', (tester) async {
      when(() => bloc.state).thenReturn(const CrosswordError(''));

      await tester.pumpCrosswordView(bloc);
      expect(find.text('Error loading crossword'), findsOneWidget);
    });

    testWidgets('renders game when is loaded', (tester) async {
      when(() => bloc.state).thenReturn(
        CrosswordLoaded(
          sectionSize: 40,
          sections: {
            (0, 0): _FakeBoardSection(),
          },
        ),
      );

      await tester.pumpCrosswordView(bloc);
      expect(find.byType(GameWidget<CrosswordGame>), findsOneWidget);
    });

    testWidgets('renders WordFocusedView when is loaded', (tester) async {
      when(() => bloc.state).thenReturn(
        CrosswordLoaded(
          sectionSize: 40,
          sections: {
            (0, 0): _FakeBoardSection(),
          },
        ),
      );
      await tester.pumpCrosswordView(bloc);

      expect(find.byType(WordFocusedView), findsOneWidget);
    });

    testWidgets(
      'displays AboutButton when status is CrosswordLoaded',
      (tester) async {
        when(() => bloc.state).thenReturn(
          CrosswordLoaded(
            sectionSize: 40,
          ),
        );

        await tester.pumpCrosswordView(bloc);

        expect(find.byType(AboutButton), findsOneWidget);
      },
    );

    testWidgets(
      'can zoom in',
      (tester) async {
        when(() => bloc.state).thenReturn(
          CrosswordLoaded(
            sectionSize: 40,
          ),
        );

        await tester.pumpCrosswordView(bloc);

        final crosswordViewState = tester.state<LoadedBoardViewState>(
          find.byType(LoadedBoardView),
        );
        await crosswordViewState.game.loaded;

        await tester.tap(find.byKey(LoadedBoardView.zoomInKey));

        expect(
          crosswordViewState.game.camera.viewfinder.zoom,
          greaterThan(1),
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'can zoom out',
      (tester) async {
        when(() => bloc.state).thenReturn(
          CrosswordLoaded(
            sectionSize: 40,
          ),
        );

        await tester.pumpCrosswordView(bloc);
        final crosswordViewState = tester.state<LoadedBoardViewState>(
          find.byType(LoadedBoardView),
        );
        await crosswordViewState.game.loaded;

        await tester.tap(find.byKey(LoadedBoardView.zoomOutKey));

        expect(
          crosswordViewState.game.camera.viewfinder.zoom,
          lessThan(1),
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    group('AboutButton', () {
      late Widget widget;

      setUp(() {
        widget = BlocProvider.value(
          value: bloc,
          child: AboutButton(),
        );
      });

      testWidgets(
        'displays question_mark_rounded icon',
        (tester) async {
          when(() => bloc.state).thenReturn(
            CrosswordLoaded(
              sectionSize: 40,
            ),
          );

          await tester.pumpApp(widget);

          expect(find.byIcon(Icons.question_mark_rounded), findsOneWidget);
        },
      );

      testWidgets(
        'displays AboutView when button is pressed',
        (tester) async {
          when(() => bloc.state).thenReturn(
            CrosswordLoaded(
              sectionSize: 40,
            ),
          );

          await tester.pumpApp(widget);

          await tester.tap(find.byIcon(Icons.question_mark_rounded));

          await tester.pumpAndSettle();

          expect(find.byType(AboutView), findsOneWidget);
        },
      );
    });
  });
}
