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
  const sectionSize = 40;

  group('CharacterResolver', () {
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

    void setUpInitialState(CrosswordState state) {
      when(() => bloc.state).thenReturn(state);
    }

    CrosswordGame createGame({bool? showDebugOverlay}) => CrosswordGame(
          bloc,
          showDebugOverlay: showDebugOverlay,
        );

    testWithGame(
      'build unsolved word with letters solved by crossing word'
      ' from left neighbour',
      createGame,
      (game) async {
        setUpInitialState(
          CrosswordState(
            sectionSize: sectionSize,
            sections: {
              (0, 0): BoardSection(
                id: '',
                position: const Point(0, 0),
                size: sectionSize,
                words: [
                  Word(
                    position: const Point(0, 0),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    clue: '',
                    solvedTimestamp: null,
                  ),
                ],
                borderWords: const [],
              ),
              (-1, 0): BoardSection(
                id: '',
                position: const Point(99, 100),
                size: sectionSize,
                words: [
                  Word(
                    position: const Point(-3, 1),
                    axis: Axis.horizontal,
                    answer: 'Fail',
                    clue: '',
                    solvedTimestamp: 1,
                  ),
                ],
                borderWords: const [],
              ),
            },
          ),
        );
        final component1 = SectionComponent(index: (0, 0));
        final component2 = SectionComponent(index: (-1, 0));
        await game.world.ensureAdd(component1);
        await game.world.ensureAdd(component2);

        final spriteBatchComponent =
            component1.firstChild<SpriteBatchComponent>();
        expect(spriteBatchComponent, isNotNull);

        final spriteBatch = spriteBatchComponent?.spriteBatch;
        expect(spriteBatch, isNotNull);
        // 15 because Flutter has 7 letters and Firebase has 8

        final solvedCharacter = spriteBatch?.sources.elementAt(1);
        expect(solvedCharacter, isNotNull);
        expect(solvedCharacter?.left, isNot(2080));
      },
    );

    testWithGame(
      'build unsolved word with letters solved by crossing word'
      ' from top neighbour',
      createGame,
      (game) async {
        setUpInitialState(
          CrosswordState(
            sectionSize: sectionSize,
            sections: {
              (0, 0): BoardSection(
                id: '',
                position: const Point(0, 0),
                size: sectionSize,
                words: [
                  Word(
                    position: const Point(0, 0),
                    axis: Axis.horizontal,
                    answer: 'Flutter',
                    clue: '',
                    solvedTimestamp: null,
                  ),
                ],
                borderWords: const [],
              ),
              (0, -1): BoardSection(
                id: '',
                position: const Point(0, -1),
                size: sectionSize,
                words: [
                  Word(
                    position: const Point(1, -3),
                    axis: Axis.vertical,
                    answer: 'Fail',
                    clue: '',
                    solvedTimestamp: 1,
                  ),
                ],
                borderWords: const [],
              ),
            },
          ),
        );
        final component1 = SectionComponent(index: (0, 0));
        final component2 = SectionComponent(index: (0, -1));
        await game.world.ensureAdd(component1);
        await game.world.ensureAdd(component2);

        final spriteBatchComponent =
            component1.firstChild<SpriteBatchComponent>();
        expect(spriteBatchComponent, isNotNull);

        final spriteBatch = spriteBatchComponent?.spriteBatch;
        expect(spriteBatch, isNotNull);
        // 15 because Flutter has 7 letters and Firebase has 8

        final solvedCharacter = spriteBatch?.sources.elementAt(1);
        expect(solvedCharacter, isNotNull);
        expect(solvedCharacter?.left, isNot(2080));
      },
    );

    testWithGame(
      'build unsolved word with letters solved by crossing word'
      ' from bottom left neighbour',
      createGame,
      (game) async {
        setUpInitialState(
          CrosswordState(
            sectionSize: sectionSize,
            sections: {
              (0, -1): BoardSection(
                id: '',
                position: const Point(0, -1),
                size: sectionSize,
                words: [
                  Word(
                    position: const Point(1, -3),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    clue: '',
                    solvedTimestamp: null,
                  ),
                ],
                borderWords: const [],
              ),
              (-1, 0): BoardSection(
                id: '',
                position: const Point(-1, 0),
                size: sectionSize,
                words: [
                  Word(
                    position: const Point(-3, 1),
                    axis: Axis.horizontal,
                    answer: 'Paint',
                    clue: '',
                    solvedTimestamp: 1,
                  ),
                ],
                borderWords: const [],
              ),
            },
          ),
        );
        final component1 = SectionComponent(index: (0, -1));
        final component2 = SectionComponent(index: (-1, 0));
        await game.world.ensureAddAll([component1, component2]);

        final spriteBatchComponent =
            component1.firstChild<SpriteBatchComponent>();
        expect(spriteBatchComponent, isNotNull);

        final spriteBatch = spriteBatchComponent?.spriteBatch;
        expect(spriteBatch, isNotNull);
        // 15 because Flutter has 7 letters and Firebase has 8

        final solvedCharacter = spriteBatch?.sources.elementAt(4);
        expect(solvedCharacter, isNotNull);
        expect(solvedCharacter?.left, isNot(2080));
      },
    );

    testWithGame(
      'build unsolved word with letters solved by crossing word'
      ' from top right neighbour',
      createGame,
      (game) async {
        setUpInitialState(
          CrosswordState(
            sectionSize: sectionSize,
            sections: {
              (0, -1): BoardSection(
                id: '',
                position: const Point(0, -1),
                size: sectionSize,
                words: [
                  Word(
                    position: const Point(1, -3),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    clue: '',
                    solvedTimestamp: 1,
                  ),
                ],
                borderWords: const [],
              ),
              (-1, 0): BoardSection(
                id: '',
                position: const Point(-1, 0),
                size: sectionSize,
                words: [
                  Word(
                    position: const Point(-3, 1),
                    axis: Axis.horizontal,
                    answer: 'Paint',
                    clue: '',
                    solvedTimestamp: null,
                  ),
                ],
                borderWords: const [],
              ),
            },
          ),
        );
        final component1 = SectionComponent(index: (0, -1));
        final component2 = SectionComponent(index: (-1, 0));
        await game.world.ensureAddAll([component1, component2]);

        final spriteBatchComponent =
            component2.firstChild<SpriteBatchComponent>();
        expect(spriteBatchComponent, isNotNull);

        final spriteBatch = spriteBatchComponent?.spriteBatch;
        expect(spriteBatch, isNotNull);
        // 15 because Flutter has 7 letters and Firebase has 8

        final solvedCharacter = spriteBatch?.sources.elementAt(4);
        expect(solvedCharacter, isNotNull);
        expect(solvedCharacter?.left, isNot(2080));
      },
    );
  });
}
