// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/drawer/drawer.dart';
import 'package:io_crossword/music/widget/mute_button.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _FakeBoardSection extends Fake implements BoardSection {
  @override
  List<Word> get words => [];
}

void main() {
  group('$CrosswordPage', () {
    testWidgets('renders $CrosswordView', (tester) async {
      await tester.pumpRoute(CrosswordPage.route());
      await tester.pump();

      expect(find.byType(CrosswordView), findsOneWidget);
    });
  });

  group('$CrosswordView', () {
    late CrosswordBloc crosswordBloc;

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();
    });

    testWidgets('renders $IoAppBar', (tester) async {
      await tester.pumpSubject(CrosswordView());
      expect(find.byType(IoAppBar), findsOneWidget);
    });

    testWidgets('renders $MuteButton', (tester) async {
      await tester.pumpSubject(CrosswordView());

      expect(find.byType(MuteButton), findsOneWidget);
    });

    testWidgets('renders $EndDrawerButton', (tester) async {
      await tester.pumpSubject(CrosswordView());

      expect(find.byType(EndDrawerButton), findsOneWidget);
    });

    testWidgets('opens $CrosswordDrawer when $EndDrawerButton is tapped',
        (tester) async {
      await tester.pumpSubject(CrosswordView());

      await tester.tap(find.byType(EndDrawerButton));

      await tester.pump();

      expect(find.byType(CrosswordDrawer), findsOneWidget);
    });

    testWidgets(
        'renders $CircularProgressIndicator with ${CrosswordStatus.initial}',
        (tester) async {
      await tester.pumpSubject(CrosswordView());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders $ErrorView with ${CrosswordStatus.failure}',
        (tester) async {
      when(() => crosswordBloc.state).thenReturn(
        const CrosswordState(
          status: CrosswordStatus.failure,
        ),
      );

      await tester.pumpSubject(
        CrosswordView(),
        crosswordBloc: crosswordBloc,
      );

      expect(find.byType(ErrorView), findsOneWidget);
    });

    testWidgets('renders game with ${CrosswordStatus.success}', (tester) async {
      when(() => crosswordBloc.state).thenReturn(
        CrosswordState(
          status: CrosswordStatus.success,
          sectionSize: 40,
          sections: {
            (0, 0): _FakeBoardSection(),
          },
        ),
      );

      await tester.pumpSubject(
        CrosswordView(),
        crosswordBloc: crosswordBloc,
      );

      expect(find.byType(GameWidget<CrosswordGame>), findsOneWidget);
    });

    testWidgets(
      'renders $WordFocusedDesktopPage when is loaded with desktop size',
      (tester) async {
        tester.setDisplaySize(Size(IoCrosswordBreakpoints.medium, 800));

        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            status: CrosswordStatus.success,
            sectionSize: 40,
            sections: {
              (0, 0): _FakeBoardSection(),
            },
          ),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

        expect(find.byType(WordFocusedDesktopPage), findsOneWidget);
      },
    );

    testWidgets(
      'does not render $WordFocusedDesktopPage when is loaded with mobile size',
      (tester) async {
        tester.setDisplaySize(Size(IoCrosswordBreakpoints.medium - 1, 800));

        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            status: CrosswordStatus.success,
            sectionSize: 40,
            sections: {
              (0, 0): _FakeBoardSection(),
            },
          ),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

        expect(find.byType(WordFocusedDesktopPage), findsNothing);
      },
    );

    testWidgets(
      'renders $WordFocusedMobilePage when game is loaded with mobile size',
      (tester) async {
        tester.setDisplaySize(Size(IoCrosswordBreakpoints.medium - 1, 800));

        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            status: CrosswordStatus.success,
            sectionSize: 40,
            sections: {
              (0, 0): _FakeBoardSection(),
            },
          ),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

        expect(find.byType(WordFocusedMobilePage), findsOneWidget);
      },
    );

    testWidgets(
      'does not render $WordFocusedMobilePage when game is loaded with '
      'desktop size',
      (tester) async {
        tester.setDisplaySize(Size(IoCrosswordBreakpoints.medium, 800));

        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            status: CrosswordStatus.success,
            sectionSize: 40,
            sections: {
              (0, 0): _FakeBoardSection(),
            },
          ),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

        expect(find.byType(WordFocusedMobilePage), findsNothing);
      },
    );

    testWidgets(
      'can zoom in',
      timeout: const Timeout(Duration(seconds: 30)),
      (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            status: CrosswordStatus.success,
            sectionSize: 40,
          ),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

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
    );

    testWidgets(
      'can zoom out',
      timeout: const Timeout(Duration(seconds: 30)),
      (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            status: CrosswordStatus.success,
            sectionSize: 40,
          ),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

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
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    Widget child, {
    CrosswordBloc? crosswordBloc,
  }) {
    final bloc = crosswordBloc ?? _MockCrosswordBloc();
    if (crosswordBloc == null) {
      when(() => bloc.state).thenReturn(const CrosswordState());
    }

    final wordSelectionBloc = _MockWordSelectionBloc();
    when(() => wordSelectionBloc.state).thenReturn(
      const WordSelectionState.initial(),
    );

    return pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<CrosswordBloc>(
            create: (_) => bloc,
          ),
          BlocProvider<WordSelectionBloc>(
            create: (_) => wordSelectionBloc,
          ),
        ],
        child: child,
      ),
    );
  }
}
