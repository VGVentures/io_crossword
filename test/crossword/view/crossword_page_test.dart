// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/bottom_bar/bottom_bar.dart';
import 'package:io_crossword/crossword/crossword.dart'
    hide WordSelected, WordUnselected;
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/drawer/drawer.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/l10n/l10n.dart';
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

class _FakeUnsolvedWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => null;
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

    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      Flame.images = Images(prefix: '');
      crosswordBloc = _MockCrosswordBloc();
      when(() => crosswordBloc.state).thenReturn(
        CrosswordState(
          status: CrosswordStatus.success,
          sectionSize: 40,
        ),
      );
    });

    group('when RandomWordSelectionStatus is', () {
      final word = _FakeUnsolvedWord();
      final section = BoardSection(
        id: '',
        position: Point(1, 1),
        size: 10,
        words: [word],
        borderWords: const [],
      );

      setUp(() {
        when(() => crosswordBloc.state).thenReturn(const CrosswordState());
      });

      testWidgets('success, adds $BoardSectionRequested event', (tester) async {
        final randomWordSelectionBloc = _MockRandomWordSelectionBloc();
        whenListen(
          randomWordSelectionBloc,
          Stream.fromIterable([
            RandomWordSelectionState(
              status: RandomWordSelectionStatus.success,
              uncompletedSection: section,
            ),
          ]),
          initialState: RandomWordSelectionState(),
        );
        final wordSelectionBloc = _MockWordSelectionBloc();

        await tester.pumpSubject(
          CrosswordView(),
          wordSelectionBloc: wordSelectionBloc,
          crosswordBloc: crosswordBloc,
          randomWordSelectionBloc: randomWordSelectionBloc,
        );

        await tester.pump();
        verify(() => crosswordBloc.add(BoardSectionRequested((1, 1))))
            .called(1);
        verify(
          () => wordSelectionBloc.add(
            WordSelected(
              selectedWord: SelectedWord(section: (1, 1), word: word),
            ),
          ),
        ).called(1);
      });

      testWidgets('loading, opens $RandomWordLoadingDialog', (tester) async {
        final randomWordSelectionBloc = _MockRandomWordSelectionBloc();
        whenListen(
          randomWordSelectionBloc,
          Stream.fromIterable([
            RandomWordSelectionState(
              status: RandomWordSelectionStatus.loading,
            ),
          ]),
          initialState: RandomWordSelectionState(),
        );
        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
          randomWordSelectionBloc: randomWordSelectionBloc,
        );
        await tester.pump();
        expect(find.byType(RandomWordLoadingDialog), findsOneWidget);
      });

      testWidgets('failure, opens error dialog', (tester) async {
        final randomWordSelectionBloc = _MockRandomWordSelectionBloc();
        whenListen(
          randomWordSelectionBloc,
          Stream.fromIterable([
            RandomWordSelectionState(
              status: RandomWordSelectionStatus.loading,
            ),
            RandomWordSelectionState(
              status: RandomWordSelectionStatus.failure,
            ),
          ]),
          initialState: RandomWordSelectionState(),
        );
        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
          randomWordSelectionBloc: randomWordSelectionBloc,
        );
        await tester.pump();
        expect(find.text(l10n.findRandomWordError), findsOneWidget);
      });
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

    testWidgets('renders $Crossword2View with ${CrosswordStatus.success}',
        (tester) async {
      await tester.pumpSubject(
        crosswordBloc: crosswordBloc,
        CrosswordView(),
      );

      expect(find.byType(Crossword2View), findsOneWidget);
    });

    testWidgets(
      'renders $WordSelectionPage when loaded',
      (tester) async {
        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

        expect(find.byType(WordSelectionPage), findsOneWidget);
      },
    );

    testWidgets(
      'renders $BottomBar',
      (tester) async {
        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

        expect(find.byType(BottomBar), findsOneWidget);
      },
    );

    group('gameReset', () {
      testWidgets(
          'renders $ResetDialogContent when boardStatus '
          'is resetInProgress', (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          const CrosswordState(
            status: CrosswordStatus.success,
            boardStatus: BoardStatus.resetInProgress,
          ),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

        expect(find.byType(ResetDialogContent), findsOneWidget);
      });

      testWidgets(
          'verify WordUnselected is added when gameStatus is resetInProgress',
          (tester) async {
        final wordSelectionBloc = _MockWordSelectionBloc();

        whenListen(
          crosswordBloc,
          Stream.fromIterable(
            [
              CrosswordState(gameStatus: GameStatus.resetInProgress),
            ],
          ),
          initialState: CrosswordState(),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
          wordSelectionBloc: wordSelectionBloc,
        );

        verify(() => wordSelectionBloc.add(const WordUnselected())).called(1);
      });

      testWidgets(
          'bottomBar is not rendered when boardStatus is resetInProgress',
          (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          const CrosswordState(
            status: CrosswordStatus.success,
            boardStatus: BoardStatus.resetInProgress,
          ),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

        expect(find.byType(BottomBar), findsNothing);
      });

      testWidgets('exit button opens EndGameCheck dialog when pressed',
          (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          const CrosswordState(
            status: CrosswordStatus.success,
            boardStatus: BoardStatus.resetInProgress,
          ),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

        await tester.tap(find.text(l10n.exitButtonLabel));
        await tester.pump();

        expect(find.byType(EndGameCheck), findsOneWidget);
      });

      testWidgets(
          'keep playing button does nothing when pressed when '
          'gameStatus is resetInProgress', (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          const CrosswordState(
            status: CrosswordStatus.success,
            gameStatus: GameStatus.resetInProgress,
            boardStatus: BoardStatus.resetInProgress,
          ),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text(l10n.keepPlayingButtonLabel),
          warnIfMissed: false,
        );

        verifyNever(() => crosswordBloc.add(BoardStatusResumed()));
      });

      testWidgets(
          'verify that BoardStatusResumed is added when '
          'keep playing button is pressed', (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          const CrosswordState(
            status: CrosswordStatus.success,
            boardStatus: BoardStatus.resetInProgress,
          ),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

        await tester.tap(find.text(l10n.keepPlayingButtonLabel));

        verify(() => crosswordBloc.add(BoardStatusResumed())).called(1);
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
  }) {
    final bloc = crosswordBloc ?? _MockCrosswordBloc();
    if (crosswordBloc == null) {
      when(() => bloc.state).thenReturn(const CrosswordState());
    }

    final playerBlocUpdate = playerBloc ?? _MockPlayerBloc();
    if (playerBloc == null) {
      when(() => playerBlocUpdate.state).thenReturn(const PlayerState());
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
            create: (_) => wordSelectionBlocUpdate,
          ),
          BlocProvider<RandomWordSelectionBloc>(
            create: (_) => randomWordSelectionBlocUpdate,
          ),
        ],
        child: child,
      ),
    );
  }
}
