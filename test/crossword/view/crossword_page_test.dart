// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/drawer/view/crossword_drawer.dart';
import 'package:io_crossword/music/widget/mute_button.dart';
import 'package:io_crossword/word_focused/word_focused.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
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
        initialState: const CrosswordState(),
      );
    });

    testWidgets('renders IoAppBar', (tester) async {
      when(() => bloc.state).thenReturn(const CrosswordState());

      await tester.pumpCrosswordView(bloc);
      expect(find.byType(IoAppBar), findsOneWidget);
    });

    testWidgets('renders $MuteButton', (tester) async {
      when(() => bloc.state).thenReturn(CrosswordState());

      await tester.pumpCrosswordView(bloc);

      expect(find.byType(MuteButton), findsOneWidget);
    });

    testWidgets('renders $DrawerButton', (tester) async {
      when(() => bloc.state).thenReturn(CrosswordState());

      await tester.pumpCrosswordView(bloc);

      expect(find.byType(DrawerButton), findsOneWidget);
    });

    testWidgets('opens $CrosswordDrawer when $DrawerButton is tapped',
        (tester) async {
      when(() => bloc.state).thenReturn(CrosswordState());

      await tester.pumpCrosswordView(bloc);

      await tester.tap(find.byType(DrawerButton));

      await tester.pump();

      expect(find.byType(CrosswordDrawer), findsOneWidget);
    });

    testWidgets(
        'renders CircularProgressIndicator with ${CrosswordStatus.initial}',
        (tester) async {
      when(() => bloc.state).thenReturn(const CrosswordState());

      await tester.pumpCrosswordView(bloc);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders $ErrorView with ${CrosswordStatus.failure}',
        (tester) async {
      when(() => bloc.state).thenReturn(
        const CrosswordState(
          status: CrosswordStatus.failure,
        ),
      );

      await tester.pumpCrosswordView(bloc);

      expect(find.byType(ErrorView), findsOneWidget);
    });

    testWidgets('renders game with ${CrosswordStatus.success}', (tester) async {
      when(() => bloc.state).thenReturn(
        CrosswordState(
          status: CrosswordStatus.success,
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
      'renders WordFocusedDesktopPage when is loaded with desktop size',
      (tester) async {
        tester.setDisplaySize(Size(IoCrosswordBreakpoints.medium, 800));
        when(() => bloc.state).thenReturn(
          CrosswordState(
            status: CrosswordStatus.success,
            sectionSize: 40,
            sections: {
              (0, 0): _FakeBoardSection(),
            },
          ),
        );

        await tester.pumpCrosswordView(bloc);

        expect(find.byType(WordFocusedDesktopPage), findsOneWidget);
      },
    );

    testWidgets(
      'does not render WordFocusedDesktopPage when is loaded with mobile size',
      (tester) async {
        tester.setDisplaySize(Size(IoCrosswordBreakpoints.medium - 1, 800));
        when(() => bloc.state).thenReturn(
          CrosswordState(
            status: CrosswordStatus.success,
            sectionSize: 40,
            sections: {
              (0, 0): _FakeBoardSection(),
            },
          ),
        );

        await tester.pumpCrosswordView(bloc);

        expect(find.byType(WordFocusedDesktopPage), findsNothing);
      },
    );

    testWidgets(
      'renders WordFocusedMobilePage when game is loaded with mobile size',
      (tester) async {
        tester.setDisplaySize(Size(IoCrosswordBreakpoints.medium - 1, 800));
        when(() => bloc.state).thenReturn(
          CrosswordState(
            status: CrosswordStatus.success,
            sectionSize: 40,
            sections: {
              (0, 0): _FakeBoardSection(),
            },
          ),
        );

        await tester.pumpCrosswordView(bloc);

        expect(find.byType(WordFocusedMobilePage), findsOneWidget);
      },
    );

    testWidgets(
      'does not render WordFocusedMobilePage when game is loaded with '
      'desktop size',
      (tester) async {
        tester.setDisplaySize(Size(IoCrosswordBreakpoints.medium, 800));
        when(() => bloc.state).thenReturn(
          CrosswordState(
            status: CrosswordStatus.success,
            sectionSize: 40,
            sections: {
              (0, 0): _FakeBoardSection(),
            },
          ),
        );

        await tester.pumpCrosswordView(bloc);

        expect(find.byType(WordFocusedMobilePage), findsNothing);
      },
    );

    testWidgets(
      'can zoom in',
      (tester) async {
        when(() => bloc.state).thenReturn(
          CrosswordState(
            status: CrosswordStatus.success,
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
          CrosswordState(
            status: CrosswordStatus.success,
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
