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
      'can tap a word',
      createGame,
      (game) async {
        final state = CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 400,
          sections: {
            (2, 2): BoardSection(
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

        final targetSection = game.world.children
            .whereType<SectionComponent>()
            .where((element) => element.index == (2, 2))
            .first;

        final event = _MockTapUpEvent();
        // Find the correct coordinate to trigger the selection
        when(() => event.localPosition).thenReturn(Vector2.all(0));

        targetSection.children.whereType<SectionTapController>().first.onTapUp(
              event,
            );
      },
    );

    test(
        'throws ArgumentError when accessing the state in the wrong '
        'status', () {
      mockState(const CrosswordInitial());
      final game = createGame();

      expect(() => game.state, throwsArgumentError);
    });

    testWithGame(
      'remove sections that are not visible when paning',
      () {
        const state = CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '',
              position: Point(2, 2),
              size: 400,
              words: [],
              borderWords: [],
            ),
          },
        );
        mockState(state);
        return createGame();
      },
      (game) async {
        await game.ready();
        final currentSections =
            game.world.children.whereType<SectionComponent>();

        final subjectComponent =
            currentSections.firstWhere((element) => element.index == (2, 2));

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
