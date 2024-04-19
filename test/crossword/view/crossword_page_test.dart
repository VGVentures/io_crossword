// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/drawer/drawer.dart';
import 'package:io_crossword/music/widget/mute_button.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

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
      Flame.images = Images(prefix: '');
      crosswordBloc = _MockCrosswordBloc();
    });

    testWidgets('renders $IoAppBar', (tester) async {
      await tester.pumpSubject(CrosswordView());
      expect(find.byType(IoAppBar), findsOneWidget);
    });

    testWidgets('renders $PlayerRankingInformation', (tester) async {
      await tester.pumpSubject(CrosswordView());
      expect(find.byType(PlayerRankingInformation), findsOneWidget);
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
      'renders $WordSelectionPage when loaded',
      (tester) async {
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

        expect(find.byType(WordSelectionPage), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    Widget child, {
    CrosswordBloc? crosswordBloc,
    PlayerBloc? playerBloc,
  }) {
    final bloc = crosswordBloc ?? _MockCrosswordBloc();
    if (crosswordBloc == null) {
      when(() => bloc.state).thenReturn(const CrosswordState());
    }

    final playerBlocUpdate = playerBloc ?? _MockPlayerBloc();
    if (playerBloc == null) {
      when(() => playerBlocUpdate.state).thenReturn(const PlayerState());
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
          BlocProvider<PlayerBloc>(
            create: (_) => playerBlocUpdate,
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
