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
  final sections = getTestSections();
  final sectionSize = sections.first.size;

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

      final state = CrosswordLoaded(
        sectionSize: sectionSize,
        sections: const {},
      );
      mockState(state);
    });

    CrosswordGame createGame() => CrosswordGame(bloc);

    testWithGame(
      'loads',
      createGame,
      (game) async {
        final state = CrosswordLoaded(
          sectionSize: sectionSize,
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
          sectionSize: sectionSize,
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
        sectionSize: sectionSize,
        sections: {
          for (final section in sections)
            (section.position.x, section.position.y): section,
        },
        selectedWord: const WordSelection(
          section: (0, 0),
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

          final targetSection =
              game.world.children.whereType<SectionComponent>().first;

          final boardSection = sections.firstWhere(
            (element) =>
                element.position.x == targetSection.index.$1 &&
                element.position.y == targetSection.index.$2,
          );
          final targetWord = boardSection.words.first;

          stateController.add(
            state.copyWith(
              selectedWord: WordSelection(
                section: targetSection.index,
                wordId: targetWord.id,
              ),
            ),
          );

          await Future.microtask(() {});

          expect(targetSection.lastSelectedWord, equals(targetWord.id));
          expect(
            targetSection.lastSelectedSection,
            equals(targetSection.index),
          );
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
          sectionSize: sectionSize,
          sections: {
            for (final section in sections)
              (section.position.x, section.position.y): section,
          },
        );
        mockState(state);
        await game.ready();
        final currentSections =
            game.world.children.whereType<SectionComponent>();

        final subjectComponent = currentSections.reduce(
          (value, element) =>
              value.index.$1 < element.index.$1 ? value : element,
        );

        final removed = subjectComponent.removed;
        game
          ..onPanUpdate(
            DragUpdateInfo.fromDetails(
              game,
              DragUpdateDetails(
                globalPosition: Offset.zero,
                localPosition: Offset.zero,
                delta: Offset(-sections.first.size * state.width * 1.5, 30),
              ),
            ),
          )
          ..update(0);

        final newCurrentSections =
            game.world.children.whereType<SectionComponent>();

        expect(removed, completes);
        expect(newCurrentSections.contains(subjectComponent), isFalse);
      },
    );
  });
}
