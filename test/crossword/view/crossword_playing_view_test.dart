import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/board_status/board_status.dart';
import 'package:io_crossword/bottom_bar/bottom_bar.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/random_word_selection/random_word_selection.dart';
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

class _MockRandomWordSelectionBloc
    extends MockBloc<RandomWordSelectionEvent, RandomWordSelectionState>
    implements RandomWordSelectionBloc {}

class _MockBoardStatusBloc extends MockBloc<BoardStatusEvent, BoardStatusState>
    implements BoardStatusBloc {}

void main() {
  group('$CrosswordPlayingView', () {
    testWidgets('pumps successfully', (tester) async {
      await tester.pumpSubject(const CrosswordPlayingView());

      expect(find.byType(CrosswordPlayingView), findsOneWidget);
    });

    group('renders', () {
      testWidgets('a $CrosswordBoardView', (tester) async {
        await tester.pumpSubject(const CrosswordPlayingView());

        expect(find.byType(CrosswordBoardView), findsOneWidget);
      });

      testWidgets('a $WordSelectionPage', (tester) async {
        await tester.pumpSubject(const CrosswordPlayingView());

        expect(find.byType(WordSelectionPage), findsOneWidget);
      });

      testWidgets('a $BottomBar', (tester) async {
        await tester.pumpSubject(const CrosswordPlayingView());

        expect(find.byType(BottomBar), findsOneWidget);
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    Widget child, {
    CrosswordBloc? crosswordBloc,
    PlayerBloc? playerBloc,
    WordSelectionBloc? wordSelectionBloc,
    RandomWordSelectionBloc? randomWordSelectionBloc,
    BoardStatusBloc? boardStatusBloc,
    IoLayoutData? layout = IoLayoutData.small,
  }) {
    final bloc = crosswordBloc ?? _MockCrosswordBloc();
    if (crosswordBloc == null) {
      when(() => bloc.state).thenReturn(const CrosswordState());
    }

    final playerBlocUpdate = playerBloc ?? _MockPlayerBloc();
    if (playerBloc == null) {
      when(() => playerBlocUpdate.state)
          .thenReturn(const PlayerState(mascot: Mascots.dash));
    }

    final wordSelectionBlocUpdate =
        wordSelectionBloc ?? _MockWordSelectionBloc();
    if (wordSelectionBloc == null) {
      when(() => wordSelectionBlocUpdate.state).thenReturn(
        const WordSelectionState.initial(),
      );
    }

    final randomWordSelectionBlocUpdate =
        randomWordSelectionBloc ?? _MockRandomWordSelectionBloc();
    if (randomWordSelectionBloc == null) {
      when(() => randomWordSelectionBlocUpdate.state).thenReturn(
        const RandomWordSelectionState(),
      );
    }

    final boardStatusBlocUpdate = boardStatusBloc ?? _MockBoardStatusBloc();
    if (boardStatusBloc == null) {
      when(() => boardStatusBlocUpdate.state).thenReturn(
        const BoardStatusInitial(),
      );
    }

    return pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<CrosswordBloc>(
            create: (_) => bloc,
          ),
          BlocProvider.value(
            value: playerBlocUpdate,
          ),
          BlocProvider<WordSelectionBloc>(
            create: (_) => wordSelectionBlocUpdate,
          ),
          BlocProvider<RandomWordSelectionBloc>(
            create: (_) => randomWordSelectionBlocUpdate,
          ),
          BlocProvider<BoardStatusBloc>(
            create: (_) => boardStatusBlocUpdate,
          ),
        ],
        child: child,
      ),
      layout: layout,
    );
  }
}
