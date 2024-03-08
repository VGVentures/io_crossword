import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_sections.dart';

class _MockCrosswordBloc extends Mock implements CrosswordBloc {}

class _MockTapUpEvent extends Mock implements TapUpEvent {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CrosswordGame', () {
    final sections = getTestSections();
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
          sectionSize: 20,
          sections: {
            for (final section in sections)
              (section.position.x, section.position.y): section,
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
          sectionSize: 20,
          sections: {
            for (final section in sections)
              (section.position.x, section.position.y): section,
          },
        );

        mockState(state);

        await game.ready();

        final targetSection = game.world.children
            .whereType<SectionComponent>()
            .where((element) => element.index == (-1, -1))
            .first;

        final targetBoardSection = sections.firstWhere(
          (element) => element.position.x == -1 && element.position.y == -1,
        );
        final targetWord = targetBoardSection.words.first;
        final targetPosition =
            targetWord.position * 40 - (targetBoardSection.position * 40 * 20);

        final event = _MockTapUpEvent();
        when(() => event.localPosition).thenReturn(
          Vector2(targetPosition.x.toDouble(), targetPosition.y.toDouble()),
        );

        targetSection.children.whereType<SectionTapController>().first.onTapUp(
              event,
            );

        verify(
          () => bloc.add(
            const WordSelected(
              (-1, -1),
              'Point(-7, -2)-Axis.vertical',
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
        sectionSize: 20,
        sections: {
          for (final section in sections)
            (section.position.x, section.position.y): section,
        },
        selectedWord: const WordSelection(
          section: (1, 1),
          wordId: 'Point(-7, -2)-Axis.vertical',
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
              .where((element) => element.index == (-1, 0))
              .first;

          expect(targetSection.lastSelectedWord, 'Point(-7, 6)-Axis.vertical');
          expect(targetSection.lastSelectedSection, (-1, 0));

          stateController.add(
            state.copyWith(
              selectedWord: const WordSelection(
                section: (-1, -1),
                wordId: 'Point(-15, -10)-Axis.vertical',
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
        final state = CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 20,
          sections: {
            for (final section in sections)
              (section.position.x, section.position.y): section,
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
                delta: const Offset(-600, 30),
              ),
            ),
          )
          ..update(0);

        expect(removed, completes);
      },
    );
  });
}
