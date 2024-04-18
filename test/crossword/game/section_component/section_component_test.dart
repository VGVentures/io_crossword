// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:ui' as ui;

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordBloc extends Mock implements CrosswordBloc {}

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

class FakeImage extends Fake implements ui.Image {
  @override
  int get width => 100;

  @override
  int get height => 100;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const sectionSize = 400;

  group('SectionComponent', () {
    late CrosswordBloc crosswordBloc;
    late WordSelectionBloc wordSelectionBloc;
    late PlayerBloc playerBloc;
    late StreamController<CrosswordState> stateStreamController;
    final defaultState = CrosswordState(
      sectionSize: sectionSize,
    );

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();
      playerBloc = _MockPlayerBloc();
      wordSelectionBloc = _MockWordSelectionBloc();
      stateStreamController = StreamController<CrosswordState>.broadcast();
      whenListen(
        crosswordBloc,
        stateStreamController.stream,
        initialState: defaultState,
      );
    });

    void setUpStreamController({CrosswordState? state}) {
      whenListen(
        crosswordBloc,
        stateStreamController.stream,
        initialState: state ?? defaultState,
      );
    }

    void setUpInitialState(CrosswordState state) {
      when(() => crosswordBloc.state).thenReturn(state);
    }

    CrosswordGame createGame({bool? showDebugOverlay}) => CrosswordGame(
          crosswordBloc: crosswordBloc,
          wordSelectionBloc: wordSelectionBloc,
          playerBloc: playerBloc,
          showDebugOverlay: showDebugOverlay,
        );

    testWithGame(
      'loads',
      createGame,
      (game) async {
        await game.world.ensureAdd(SectionComponent(index: (100, 100)));
        expect(
          game.world.children.whereType<SectionComponent>().where(
                (element) => element.index == (100, 100),
              ),
          hasLength(1),
        );
      },
    );

    testWithGame(
      'reloads if section in state is different',
      createGame,
      (game) async {
        final word = Word(
          id: '1',
          position: const Point(0, 0),
          axis: Axis.vertical,
          answer: 'Flutter',
          length: 7,
          clue: '',
        );
        setUpStreamController(
          state: CrosswordState(
            sectionSize: sectionSize,
            sections: {
              (100, 100): BoardSection(
                id: '',
                position: const Point(100, 100),
                size: sectionSize,
                words: [word],
                borderWords: const [],
              ),
            },
          ),
        );
        final section = SectionComponent(index: (100, 100));
        await game.world.ensureAdd(section);

        final initialSection =
            game.world.children.whereType<SectionComponent>().where(
                  (element) => element.index == (100, 100),
                );
        expect(initialSection, hasLength(1));
        final initialSprites = initialSection.first.spriteBatchComponent;

        stateStreamController.add(
          CrosswordState(
            sectionSize: sectionSize,
            sections: {
              (100, 100): BoardSection(
                id: '',
                position: const Point(100, 100),
                size: sectionSize,
                words: [word.copyWith(solvedTimestamp: 1)],
                borderWords: const [],
              ),
            },
          ),
        );

        await game.ready();
        final finalSection =
            game.world.children.whereType<SectionComponent>().where(
                  (element) => element.index == (100, 100),
                );
        expect(
          initialSprites,
          isNot(finalSection.first.spriteBatchComponent),
        );
      },
    );

    testWithGame(
      'adds debug components when the game is showing debug overlay',
      () => createGame(showDebugOverlay: true),
      (game) async {
        final section = SectionComponent(index: (100, 100));
        await game.world.ensureAdd(section);

        expect(section.firstChild<SectionDebugIndex>(), isNotNull);
        expect(section.firstChild<SectionDebugOutline>(), isNotNull);
      },
    );

    testWithGame(
      'automatically build the words when the section is already loaded',
      createGame,
      (game) async {
        setUpInitialState(
          CrosswordState(
            sectionSize: sectionSize,
            sections: {
              (100, 100): BoardSection(
                id: '',
                position: const Point(100, 100),
                size: sectionSize,
                words: [
                  Word(
                    id: '1',
                    position: const Point(0, 0),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    length: 7,
                    clue: '',
                  ),
                  Word(
                    id: '2',
                    position: const Point(0, 0),
                    axis: Axis.horizontal,
                    answer: 'Firebase',
                    length: 8,
                    clue: '',
                  ),
                ],
                borderWords: const [],
              ),
            },
          ),
        );

        final component = SectionComponent(index: (100, 100));
        await game.world.ensureAdd(component);

        final spriteBatchComponent =
            component.firstChild<SpriteBatchComponent>();
        expect(spriteBatchComponent, isNotNull);

        final spriteBatch = spriteBatchComponent?.spriteBatch;
        expect(spriteBatch, isNotNull);
        // 15 because Flutter has 7 letters and Firebase has 8
        expect(spriteBatch?.sources, hasLength(15));
      },
    );

    testWithGame(
      'build the words with letters when the section is already loaded and'
      ' contains word with resolveTimestamp not null',
      createGame,
      (game) async {
        setUpInitialState(
          CrosswordState(
            sectionSize: sectionSize,
            sections: {
              (100, 100): BoardSection(
                id: '',
                position: const Point(100, 100),
                size: sectionSize,
                words: [
                  Word(
                    id: '1',
                    position: const Point(0, 0),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    length: 7,
                    clue: '',
                    solvedTimestamp: 1,
                  ),
                  Word(
                    id: '2',
                    position: const Point(0, 0),
                    axis: Axis.horizontal,
                    answer: 'Firebase',
                    length: 8,
                    clue: '',
                  ),
                ],
                borderWords: const [],
              ),
            },
          ),
        );
        final component = SectionComponent(index: (100, 100));
        await game.world.ensureAdd(component);

        final spriteBatchComponent =
            component.firstChild<SpriteBatchComponent>();
        expect(spriteBatchComponent, isNotNull);

        final spriteBatch = spriteBatchComponent?.spriteBatch;
        expect(spriteBatch, isNotNull);
        // 15 because Flutter has 7 letters and Firebase has 8

        expect(
          spriteBatch?.sources.any((element) => element.left != 1040),
          isTrue,
        );
      },
    );

    testWithGame(
      'loads the section in the component when the state changes and the '
      'section is present',
      createGame,
      (game) async {
        setUpStreamController();
        final component = SectionComponent(index: (100, 100));
        await game.world.ensureAdd(component);

        var spriteBatchComponent = component.firstChild<SpriteBatchComponent>();

        expect(spriteBatchComponent, isNull);
        stateStreamController.add(
          CrosswordState(
            sectionSize: sectionSize,
            sections: {
              (100, 100): BoardSection(
                id: '',
                position: const Point(100, 100),
                size: sectionSize,
                words: [
                  Word(
                    id: '1',
                    position: const Point(0, 0),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    length: 7,
                    clue: '',
                  ),
                  Word(
                    id: '2',
                    position: const Point(0, 0),
                    axis: Axis.horizontal,
                    answer: 'Firebase',
                    length: 8,
                    clue: '',
                  ),
                ],
                borderWords: const [],
              ),
            },
          ),
        );

        await game.ready();

        spriteBatchComponent = component.firstChild<SpriteBatchComponent>();
        expect(spriteBatchComponent, isNotNull);

        final spriteBatch = spriteBatchComponent?.spriteBatch;
        expect(spriteBatch, isNotNull);
        // 15 because Flutter has 7 letters and Firebase has 8
        expect(spriteBatch?.sources, hasLength(15));
      },
    );

    testWithGame(
      'adds a BoardSectionRequested when the section is not loaded yet',
      createGame,
      (game) async {
        await game.world.ensureAdd(SectionComponent(index: (100, 100)));

        verify(
          () => crosswordBloc.add(
            const BoardSectionRequested((100, 100)),
          ),
        ).called(1);
      },
    );
  });
}
