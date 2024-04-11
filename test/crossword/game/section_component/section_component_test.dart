// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordBloc extends Mock implements CrosswordBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const sectionSize = 400;

  group('SectionComponent', () {
    late CrosswordBloc bloc;
    late StreamController<CrosswordState> stateStreamController;
    final defaultState = CrosswordState(
      sectionSize: sectionSize,
    );

    setUp(() {
      bloc = _MockCrosswordBloc();
      stateStreamController = StreamController<CrosswordState>.broadcast();
      whenListen(
        bloc,
        stateStreamController.stream,
        initialState: defaultState,
      );
    });

    void setUpStreamController({CrosswordState? state}) {
      whenListen(
        bloc,
        stateStreamController.stream,
        initialState: state ?? defaultState,
      );
    }

    void setUpInitialState(CrosswordState state) {
      when(() => bloc.state).thenReturn(state);
    }

    CrosswordGame createGame({bool? showDebugOverlay}) => CrosswordGame(
          bloc,
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
          position: const Point(0, 0),
          axis: Axis.vertical,
          answer: 'Flutter',
          clue: '',
          solvedTimestamp: null,
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
                    position: const Point(0, 0),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    clue: '',
                    solvedTimestamp: null,
                  ),
                  Word(
                    position: const Point(0, 0),
                    axis: Axis.horizontal,
                    answer: 'Firebase',
                    clue: '',
                    solvedTimestamp: null,
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
                    position: const Point(0, 0),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    clue: '',
                    solvedTimestamp: 1,
                  ),
                  Word(
                    position: const Point(0, 0),
                    axis: Axis.horizontal,
                    answer: 'Firebase',
                    clue: '',
                    solvedTimestamp: null,
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
          spriteBatch?.sources.any((element) => element.left != 2080),
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
                    position: const Point(0, 0),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    clue: '',
                    solvedTimestamp: null,
                  ),
                  Word(
                    position: const Point(0, 0),
                    axis: Axis.horizontal,
                    answer: 'Firebase',
                    clue: '',
                    solvedTimestamp: null,
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
          () => bloc.add(
            const BoardSectionRequested((100, 100)),
          ),
        ).called(1);
      },
    );
  });
}
