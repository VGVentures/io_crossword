// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/board_status/board_status.dart';
import 'package:io_crossword/bottom_bar/bottom_bar.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/drawer/drawer.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/random_word_selection/random_word_selection.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
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

class _FakeUnsolvedWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Flame.images = Images(prefix: '');
    await Flame.images.loadAll([
      ...Mascot.dash.teamMascot.loadableHowToPlayDesktopAssets(),
      ...Mascot.dash.teamMascot.loadableHowToPlayMobileAssets(),
      ...Mascot.android.teamMascot.loadableHowToPlayDesktopAssets(),
      ...Mascot.android.teamMascot.loadableHowToPlayMobileAssets(),
      ...Mascot.dino.teamMascot.loadableHowToPlayDesktopAssets(),
      ...Mascot.dino.teamMascot.loadableHowToPlayMobileAssets(),
      ...Mascot.sparky.teamMascot.loadableHowToPlayDesktopAssets(),
      ...Mascot.sparky.teamMascot.loadableHowToPlayMobileAssets(),
    ]);
  });

  group('$CrosswordPage', () {
    testWidgets('route builds a $CrosswordPage', (tester) async {
      final playerBloc = _MockPlayerBloc();
      when(() => playerBloc.state).thenReturn(PlayerState());

      await tester.pumpRoute(
        playerBloc: playerBloc,
        CrosswordPage.route(),
      );
      await tester.pump();

      expect(find.byType(CrosswordPage), findsOneWidget);
    });

    testWidgets('renders $CrosswordView', (tester) async {
      await tester.pumpSubject(CrosswordPage());

      expect(find.byType(CrosswordView), findsOneWidget);
    });
  });

  group('$CrosswordView', () {
    late CrosswordBloc crosswordBloc;
    late PlayerBloc playerBloc;

    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();
      when(() => crosswordBloc.state).thenReturn(
        CrosswordState(
          status: CrosswordStatus.success,
          sectionSize: 40,
        ),
      );

      playerBloc = _MockPlayerBloc();
      when(() => playerBloc.state).thenReturn(
        const PlayerState(
          status: PlayerStatus.playing,
        ),
      );
    });

    group('when RandomWordSelectionStatus is', () {
      final word = _FakeUnsolvedWord();
      final section = BoardSection(
        id: '',
        position: Point(1, 1),
        words: [word],
      );

      setUp(() {
        when(() => crosswordBloc.state).thenReturn(const CrosswordState());
      });

      testWidgets(
        'success, adds $WordSelected event',
        (tester) async {
          final randomWordSelectionBloc = _MockRandomWordSelectionBloc();
          whenListen(
            randomWordSelectionBloc,
            Stream.value(
              RandomWordSelectionState(
                status: RandomWordSelectionStatus.success,
                randomWord: word,
                sectionPosition: (1, 1),
              ),
            ),
            initialState: RandomWordSelectionState(),
          );
          final wordSelectionBloc = _MockWordSelectionBloc();

          await tester.pumpSubject(
            CrosswordView(),
            wordSelectionBloc: wordSelectionBloc,
            crosswordBloc: crosswordBloc,
            randomWordSelectionBloc: randomWordSelectionBloc,
          );

          verify(
            () => wordSelectionBloc.add(
              WordSelected(
                selectedWord: SelectedWord(section: (1, 1), word: word),
              ),
            ),
          ).called(1);
        },
      );

      testWidgets(
        'notFound, adds $WordSelected event',
        (tester) async {
          final randomWordSelectionBloc = _MockRandomWordSelectionBloc();
          whenListen(
            randomWordSelectionBloc,
            Stream.value(
              RandomWordSelectionState(
                status: RandomWordSelectionStatus.notFound,
                randomWord: word,
                sectionPosition: (1, 0),
              ),
            ),
            initialState: RandomWordSelectionState(),
          );
          final wordSelectionBloc = _MockWordSelectionBloc();

          await tester.pumpSubject(
            CrosswordView(),
            wordSelectionBloc: wordSelectionBloc,
            crosswordBloc: crosswordBloc,
            randomWordSelectionBloc: randomWordSelectionBloc,
          );

          verify(
            () => wordSelectionBloc.add(
              WordSelected(
                selectedWord: SelectedWord(section: (1, 0), word: word),
              ),
            ),
          ).called(1);
        },
      );

      testWidgets(
        'initialSuccess, adds $CrosswordSectionsLoaded event',
        (tester) async {
          when(() => crosswordBloc.state).thenReturn(
            const CrosswordState(status: CrosswordStatus.success),
          );

          whenListen(
            crosswordBloc,
            Stream.value(CrosswordState(status: CrosswordStatus.success)),
            initialState: CrosswordState(),
          );

          final wordSelectionBloc = _MockWordSelectionBloc();
          final randomWordSelectionBloc = _MockRandomWordSelectionBloc();

          whenListen(
            randomWordSelectionBloc,
            Stream.value(
              RandomWordSelectionState(
                status: RandomWordSelectionStatus.initialSuccess,
                randomWord: word,
                sectionPosition: (1, 1),
              ),
            ),
            initialState: RandomWordSelectionState(),
          );

          await tester.pumpSubject(
            CrosswordView(),
            wordSelectionBloc: wordSelectionBloc,
            crosswordBloc: crosswordBloc,
            randomWordSelectionBloc: randomWordSelectionBloc,
          );

          final initialWord =
              SelectedWord(section: (1, 1), word: section.words.first);

          verify(() => crosswordBloc.add(CrosswordSectionsLoaded(initialWord)))
              .called(1);
        },
      );

      testWidgets(
        'initialNotFound, adds $CrosswordSectionsLoaded event',
        (tester) async {
          when(() => crosswordBloc.state).thenReturn(
            const CrosswordState(status: CrosswordStatus.success),
          );

          whenListen(
            crosswordBloc,
            Stream.value(CrosswordState(status: CrosswordStatus.success)),
            initialState: CrosswordState(),
          );

          final wordSelectionBloc = _MockWordSelectionBloc();
          final randomWordSelectionBloc = _MockRandomWordSelectionBloc();

          whenListen(
            randomWordSelectionBloc,
            Stream.value(
              RandomWordSelectionState(
                status: RandomWordSelectionStatus.initialNotFound,
                randomWord: word,
                sectionPosition: (1, 0),
              ),
            ),
            initialState: RandomWordSelectionState(),
          );

          await tester.pumpSubject(
            CrosswordView(),
            wordSelectionBloc: wordSelectionBloc,
            crosswordBloc: crosswordBloc,
            randomWordSelectionBloc: randomWordSelectionBloc,
          );

          final initialWord =
              SelectedWord(section: (1, 0), word: section.words.first);

          verify(() => crosswordBloc.add(CrosswordSectionsLoaded(initialWord)))
              .called(1);
        },
      );
    });

    testWidgets('when success, adds initial RandomWordRequested',
        (tester) async {
      when(() => crosswordBloc.state).thenReturn(
        const CrosswordState(
          status: CrosswordStatus.success,
        ),
      );

      whenListen(
        crosswordBloc,
        Stream.fromIterable(
          [
            CrosswordState(
              status: CrosswordStatus.success,
            ),
          ],
        ),
        initialState: CrosswordState(),
      );

      final wordSelectionBloc = _MockWordSelectionBloc();
      final randomWordSelectionBloc = _MockRandomWordSelectionBloc();

      when(() => randomWordSelectionBloc.state).thenReturn(
        const RandomWordSelectionState(),
      );

      await tester.pumpSubject(
        CrosswordView(),
        wordSelectionBloc: wordSelectionBloc,
        crosswordBloc: crosswordBloc,
        randomWordSelectionBloc: randomWordSelectionBloc,
      );

      verify(
        () => randomWordSelectionBloc
            .add(const RandomWordRequested(isInitial: true)),
      ).called(1);
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

    group('renders $ErrorView', () {
      testWidgets('with ${CrosswordStatus.failure}', (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          const CrosswordState(
            status: CrosswordStatus.failure,
          ),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
          playerBloc: playerBloc,
        );

        expect(find.byType(ErrorView), findsOneWidget);
      });

      testWidgets('with ${PlayerStatus.failure}', (tester) async {
        when(() => playerBloc.state).thenReturn(
          const PlayerState(status: PlayerStatus.failure),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
          playerBloc: playerBloc,
        );

        expect(find.byType(ErrorView), findsOneWidget);
      });
    });

    group('$CrosswordPlayingView', () {
      testWidgets(
          '''renders when crossword status is ${CrosswordStatus.ready} and player status is ${PlayerStatus.playing}''',
          (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          const CrosswordState(status: CrosswordStatus.ready),
        );
        when(() => playerBloc.state).thenReturn(
          const PlayerState(status: PlayerStatus.playing),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
          playerBloc: playerBloc,
        );

        expect(find.byType(CrosswordPlayingView), findsOneWidget);
      });

      for (final crosswordStatus in CrosswordStatus.values.toSet()
        ..remove(CrosswordStatus.ready)) {
        testWidgets(
          '''does not render $CrosswordPlayingView when status is $crosswordStatus''',
          (tester) async {
            when(() => crosswordBloc.state).thenReturn(
              CrosswordState(status: crosswordStatus),
            );

            await tester.pumpSubject(
              CrosswordView(),
              crosswordBloc: crosswordBloc,
              playerBloc: playerBloc,
            );

            expect(find.byType(CrosswordPlayingView), findsNothing);
          },
        );
      }
    });

    for (final layout in IoLayoutData.values) {
      testWidgets(
          'verify MascotDropped is called when dropIn animation '
          'completes with $layout', (tester) async {
        await tester.runAsync(() async {
          when(() => crosswordBloc.state).thenReturn(
            const CrosswordState(
              status: CrosswordStatus.ready,
            ),
          );

          await tester.pumpSubject(
            CrosswordView(),
            crosswordBloc: crosswordBloc,
            playerBloc: playerBloc,
            layout: layout,
          );

          final spriteAnimationList = tester.widget<SpriteAnimationList>(
            find.byType(SpriteAnimationList),
          );

          await Future<void>.delayed(Duration(seconds: 3));
          await tester.pump(Duration(seconds: 3));

          final controller = spriteAnimationList.controller;

          await Future<void>.delayed(Duration(seconds: 3));
          await tester.pump(Duration(seconds: 3));

          controller.animationDataList.last.spriteAnimationTicker.setToLast();

          await controller
              .animationDataList.last.spriteAnimationTicker.completed;

          await tester.pump(Duration(seconds: 3));

          verify(() => crosswordBloc.add(MascotDropped())).called(1);
        });
      });
    }

    group('gameReset', () {
      testWidgets(
          'renders $BoardResetView when boardStatus '
          'is resetInProgress', (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          const CrosswordState(
            status: CrosswordStatus.ready,
            boardStatus: BoardStatus.resetInProgress,
          ),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

        expect(find.byType(BoardResetView), findsOneWidget);
      });

      testWidgets(
          'verify WordUnselected is added when boardStatus '
          'is BoardResetInProgress', (tester) async {
        final wordSelectionBloc = _MockWordSelectionBloc();
        final boardStatusBloc = _MockBoardStatusBloc();

        whenListen(
          boardStatusBloc,
          Stream.fromIterable(
            [
              BoardStatusResetInProgress(),
            ],
          ),
          initialState: BoardStatusInitial(),
        );

        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
          wordSelectionBloc: wordSelectionBloc,
          boardStatusBloc: boardStatusBloc,
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
            status: CrosswordStatus.ready,
            boardStatus: BoardStatus.resetInProgress,
            mascotVisible: false,
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
          'verify that BoardStatusResumed is added when '
          'keep playing button is pressed', (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          const CrosswordState(
            status: CrosswordStatus.ready,
            boardStatus: BoardStatus.resetInProgress,
            mascotVisible: false,
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
    BoardStatusBloc? boardStatusBloc,
    IoLayoutData? layout = IoLayoutData.small,
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
