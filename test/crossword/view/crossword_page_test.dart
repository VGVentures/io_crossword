// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword/view/word_focused_view.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../../helpers/set_display_size.dart';

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

class _FakeWord extends Fake implements Word {
  @override
  String get id => 'id';

  @override
  String get clue => 'clue';

  @override
  Axis get axis => Axis.horizontal;
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

    testWidgets(
        'renders WordFocusedView when'
        ' is loaded with desktop size', (tester) async {
      tester.setDisplaySize(const Size(IoCrosswordBreakpoints.medium, 800));
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
        'does not render WordFocusedView when'
        ' is loaded with mobile size', (tester) async {
      tester.setDisplaySize(const Size(IoCrosswordBreakpoints.small, 800));
      when(() => bloc.state).thenReturn(
        CrosswordLoaded(
          sectionSize: 40,
          sections: {
            (0, 0): _FakeBoardSection(),
          },
        ),
      );

      await tester.pumpCrosswordView(bloc);

      expect(find.byType(WordFocusedView), findsNothing);
    });

    testWidgets(
        'renders WordFocusedMobileView when selects a word in mobile size',
        (tester) async {
      tester.setDisplaySize(const Size(IoCrosswordBreakpoints.small, 800));
      final initialState = CrosswordLoaded(
        sectionSize: 40,
        sections: {
          (0, 0): _FakeBoardSection(),
        },
      );
      whenListen(
        bloc,
        Stream.value(
          initialState.copyWith(
            selectedWord: WordSelection(section: (1, 1), word: _FakeWord()),
          ),
        ),
        initialState: initialState,
      );

      await tester.pumpCrosswordView(bloc);
      await tester.pump();
      expect(find.byType(WordFocusedMobileView), findsOneWidget);
    });

    testWidgets('renders WordFocusedMobileView and pops when tapping cancel',
        (tester) async {
      tester.setDisplaySize(const Size(IoCrosswordBreakpoints.small, 800));
      final initialState = CrosswordLoaded(
        sectionSize: 40,
        sections: {
          (0, 0): _FakeBoardSection(),
        },
      );
      whenListen(
        bloc,
        Stream.value(
          initialState.copyWith(
            selectedWord: WordSelection(section: (1, 1), word: _FakeWord()),
          ),
        ),
        initialState: initialState,
      );

      await tester.pumpCrosswordView(bloc);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();
      expect(find.byType(WordFocusedMobileView), findsNothing);
      verify(() => bloc.add(const WordUnselected())).called(1);
    });

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
  });
}
