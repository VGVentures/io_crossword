// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart' hide WordSelected;
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/drawer/drawer.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/music/widget/mute_button.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/random_word_selection/bloc/random_word_selection_bloc.dart';
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

class _FakeUnsolvedWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Flame.images = Images(prefix: '');
    await Flame.images.loadAll([
      ...Mascots.dash.teamMascot.loadableAssets(),
      ...Mascots.android.teamMascot.loadableAssets(),
      ...Mascots.dino.teamMascot.loadableAssets(),
      ...Mascots.sparky.teamMascot.loadableAssets(),
    ]);
  });

  group('$CrosswordPage', () {
    testWidgets('renders $CrosswordView', (tester) async {
      await tester.pumpSubject(CrosswordPage());

      expect(find.byType(CrosswordView), findsOneWidget);
    });
  });

  group('$CrosswordView', () {
    late CrosswordBloc crosswordBloc;

    setUp(() {
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

      testWidgets('success, adds $BoardSectionRequested event', (tester) async {
        when(() => crosswordBloc.state).thenReturn(const CrosswordState());
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
        'dropIn animation is displayed when SpriteAnimationList is tapped',
        (tester) async {
      await tester.pumpSubject(
        CrosswordView(),
        crosswordBloc: crosswordBloc,
      );

      await tester.tap(find.byType(SpriteAnimationList));

      final mascotAnimation = tester.widget<MascotAnimation>(
        find.byType(MascotAnimation),
      );

      final spriteAnimationList = tester.widget<SpriteAnimationList>(
        find.byType(SpriteAnimationList),
      );

      await tester.tap(find.byType(SpriteAnimationList));

      expect(
        spriteAnimationList.controller.currentAnimationId,
        equals(mascotAnimation.mascot.teamMascot.dropInAnimation.path),
      );
    });

    testWidgets(
        'verify MascotDropped is called with dropIn animation completes',
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpSubject(
          CrosswordView(),
          crosswordBloc: crosswordBloc,
        );

        await tester.tap(find.byType(SpriteAnimationList));

        await tester.pump();

        final spriteAnimationList = tester.widget<SpriteAnimationList>(
          find.byType(SpriteAnimationList),
        );

        await Future<void>.delayed(Duration(seconds: 3));

        await tester.pump();

        final controller = spriteAnimationList.controller;

        controller.animationDataList[1].spriteAnimationTicker.setToLast();

        await controller.animationDataList[1].spriteAnimationTicker.completed;

        verify(() => crosswordBloc.add(const MascotDropped())).called(1);
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
        ],
        child: child,
      ),
    );
  }
}
