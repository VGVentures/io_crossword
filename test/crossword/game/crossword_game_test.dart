import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordBloc extends Mock implements CrosswordBloc {}

class _MockTapUpEvent extends Mock implements TapUpEvent {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CrosswordGame', () {
    late CrosswordBloc bloc;

    void mockState(CrosswordState state) {
      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );
    }

    setUp(() {
      bloc = _MockCrosswordBloc();

      const state = CrosswordLoaded(
        width: 40,
        height: 40,
        sectionSize: 400,
        sections: {},
      );
      mockState(state);
    });

    CrosswordGame createGame() => CrosswordGame(bloc);

    testWithGame(
      'loads',
      createGame,
      (game) async {
        final state = CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: const Point(2, 2),
              size: 400,
              words: [
                Word(
                  position: const Point(0, 0),
                  axis: Axis.vertical,
                  answer: 'Flutter',
                  clue: '',
                  hints: const [],
                  visible: true,
                  solvedTimestamp: null,
                ),
                Word(
                  position: const Point(2, 2),
                  axis: Axis.horizontal,
                  answer: 'Android',
                  clue: '',
                  hints: const [],
                  visible: false,
                  solvedTimestamp: null,
                ),
              ],
              borderWords: const [],
            ),
          },
        );
        mockState(state);

        await game.ready();
        expect(
          game.world.children.whereType<SectionComponent>(),
          isNotEmpty,
        );
      },
    );

    testWithGame(
      'can tap words',
      createGame,
      (game) async {
        final state = CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: const Point(0, 0),
              size: 400,
              words: [
                Word(
                  position: const Point(0, 0),
                  axis: Axis.vertical,
                  answer: 'Flutter',
                  clue: '',
                  hints: const [],
                  visible: true,
                  solvedTimestamp: null,
                ),
                Word(
                  position: const Point(2, 2),
                  axis: Axis.horizontal,
                  answer: 'Android',
                  clue: '',
                  hints: const [],
                  visible: false,
                  solvedTimestamp: null,
                ),
              ],
              borderWords: const [],
            ),
          },
        );

        mockState(state);

        await game.ready();

        final targetSection = game.world.children
            .whereType<SectionComponent>()
            .where((element) => element.index == (0, 0))
            .first;

        final event = _MockTapUpEvent();
        when(() => event.localPosition).thenReturn(Vector2.all(0));

        targetSection.children.whereType<SectionTapController>().first.onTapUp(
              event,
            );

        verify(
          () => bloc.add(
            const WordSelected(
              (0, 0),
              'Point(0, 0)-Axis.vertical',
            ),
          ),
        ).called(1);
      },
    );

    group('highlighted word', () {
      late StreamController<CrosswordState> stateController;
      final state = CrosswordLoaded(
        width: 40,
        height: 40,
        sectionSize: 400,
        sections: {
          (0, 0): BoardSection(
            id: '1',
            position: const Point(0, 0),
            size: 400,
            words: [
              Word(
                position: const Point(0, 0),
                axis: Axis.vertical,
                answer: 'Flutter',
                clue: '',
                hints: const [],
                visible: true,
                solvedTimestamp: null,
              ),
              Word(
                position: const Point(2, 2),
                axis: Axis.horizontal,
                answer: 'Android',
                clue: '',
                hints: const [],
                visible: false,
                solvedTimestamp: null,
              ),
            ],
            borderWords: const [],
          ),
        },
        selectedWord: const WordSelection(
          section: (0, 0),
          wordId: 'Point(0, 0)-Axis.vertical',
        ),
      );

      setUp(() {
        stateController = StreamController<CrosswordState>.broadcast();
        whenListen(
          bloc,
          stateController.stream,
          initialState: state,
        );
      });

      testWithGame(
        'changes the highlighted word',
        createGame,
        (game) async {
          await game.ready();

          final targetSection = game.world.children
              .whereType<SectionComponent>()
              .where((element) => element.index == (0, 0))
              .first;

          expect(targetSection.lastSelectedWord, 'Point(0, 0)-Axis.vertical');
          expect(targetSection.lastSelectedSection, (0, 0));

          stateController.add(
            state.copyWith(
              selectedWord: const WordSelection(
                section: (0, 0),
                wordId: 'Point(2, 2)-Axis.horizontal',
              ),
            ),
          );

          await Future.microtask(() {});

          expect(targetSection.lastSelectedWord, 'Point(2, 2)-Axis.horizontal');
          expect(targetSection.lastSelectedSection, (0, 0));
        },
      );
    });

    test(
        'throws ArgumentError when accessing the state in the wrong '
        'status', () {
      mockState(const CrosswordInitial());
      final game = createGame();

      expect(() => game.state, throwsArgumentError);
    });

    testWithGame(
      'remove sections that are not visible when panning',
      createGame,
      (game) async {
        const state = CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 300,
          sections: {
            (-1, 0): BoardSection(
              id: '',
              position: Point(-1, 0),
              size: 300,
              words: [],
              borderWords: [],
            ),
            (0, 0): BoardSection(
              id: '',
              position: Point(0, 0),
              size: 300,
              words: [],
              borderWords: [],
            ),
            (1, 0): BoardSection(
              id: '',
              position: Point(1, 0),
              size: 300,
              words: [],
              borderWords: [],
            ),
          },
        );
        mockState(state);
        await game.ready();
        final currentSections =
            game.world.children.whereType<SectionComponent>();

        final subjectComponent =
            currentSections.firstWhere((element) => element.index == (-1, 0));

        final removed = subjectComponent.removed;

        game
          ..onPanUpdate(
            DragUpdateInfo.fromDetails(
              game,
              DragUpdateDetails(
                globalPosition: Offset.zero,
                localPosition: Offset.zero,
                delta: const Offset(2400, 30),
              ),
            ),
          )
          ..update(0);

        expect(removed, completes);
      },
    );
  });
}
