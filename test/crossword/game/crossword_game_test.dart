// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame/debug.dart';
import 'package:flame/events.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword/extensions/extensions.dart';
import 'package:io_crossword/word_selection/word_selection.dart'
    hide WordSelected;
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends Mock implements CrosswordBloc {}

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockTapUpEvent extends Mock implements TapUpEvent {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final sections = getTestSections();
  final sectionSize = sections.first.size;

  group('CrosswordGame', () {
    late CrosswordBloc crosswordBloc;
    late WordSelectionBloc wordSelectionBloc;

    void mockState(CrosswordState state) {
      whenListen(
        crosswordBloc,
        Stream.value(state),
        initialState: state,
      );
    }

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();
      wordSelectionBloc = _MockWordSelectionBloc();

      final state = CrosswordState(
        sectionSize: sectionSize,
      );
      mockState(state);
    });

    CrosswordGame createGame({
      bool? showDebugOverlay,
    }) =>
        CrosswordGame(
          crosswordBloc: crosswordBloc,
          wordSelectionBloc: wordSelectionBloc,
          showDebugOverlay: showDebugOverlay,
        );

    testWithGame(
      'loads',
      createGame,
      (game) async {
        final state = CrosswordState(
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
      'adds debug components when debugOverlay is true',
      () => createGame(showDebugOverlay: true),
      (game) async {
        final state = CrosswordState(
          sectionSize: sectionSize,
          sections: {
            for (final section in sections)
              (section.position.x, section.position.y): section,
          },
        );
        mockState(state);

        await game.ready();
        expect(game.descendants().whereType<FpsComponent>(), isNotEmpty);
        expect(game.descendants().whereType<FpsTextComponent>(), isNotNull);
        expect(
          game
              .descendants()
              .whereType<ChildCounterComponent<SectionComponent>>(),
          isNotNull,
        );
      },
    );

    testWithGame(
      'can tap words and adapts camera position for mobile',
      createGame,
      (game) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        addTearDown(() {
          debugDefaultTargetPlatformOverride = null;
        });

        final state = CrosswordState(
          sectionSize: sectionSize,
          sections: {
            for (final section in sections)
              (section.position.x, section.position.y): section,
          },
        );

        mockState(state);

        await game.ready();

        final targetSection =
            game.world.children.whereType<SectionComponent>().first;

        final targetBoardSection = sections.firstWhere(
          (element) =>
              element.position.x == targetSection.index.$1 &&
              element.position.y == targetSection.index.$2,
        );
        final targetWord = targetBoardSection.words.first;
        final targetAbsolutePosition =
            targetWord.position * CrosswordGame.cellSize -
                (targetBoardSection.position *
                    CrosswordGame.cellSize *
                    sectionSize);

        final targetCenter = Vector2(
          targetWord.position.x * CrosswordGame.cellSize.toDouble() +
              targetWord.width / 2,
          targetWord.position.y * CrosswordGame.cellSize.toDouble() +
              targetWord.height / 2,
        );
        final wordRect = Rect.fromLTWH(
          (targetWord.position.x * CrosswordGame.cellSize).toDouble(),
          (targetWord.position.y * CrosswordGame.cellSize).toDouble(),
          targetWord.width.toDouble(),
          targetWord.height.toDouble(),
        );

        final event = _MockTapUpEvent();
        when(() => event.localPosition).thenReturn(
          Vector2(
            targetAbsolutePosition.x.toDouble(),
            targetAbsolutePosition.y.toDouble(),
          ),
        );

        targetSection.children.whereType<SectionTapController>().first.onTapUp(
              event,
            );

        game.update(2);

        expect(
          game.camera.viewfinder.position,
          equals(targetCenter),
        );
        expect(
          game.camera.visibleWorldRect.contains(wordRect.center),
          isTrue,
        );
        verify(
          () => crosswordBloc.add(
            WordSelected(
              targetSection.index,
              targetWord,
            ),
          ),
        ).called(1);
      },
    );

    testWithGame(
      'can tap words and adapts camera position for desktop',
      createGame,
      (game) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() {
          debugDefaultTargetPlatformOverride = null;
        });

        final state = CrosswordState(
          sectionSize: sectionSize,
          sections: {
            for (final section in sections)
              (section.position.x, section.position.y): section,
          },
        );

        mockState(state);

        await game.ready();

        final targetSection =
            game.world.children.whereType<SectionComponent>().first;

        final targetBoardSection = sections.firstWhere(
          (element) =>
              element.position.x == targetSection.index.$1 &&
              element.position.y == targetSection.index.$2,
        );
        final targetWord = targetBoardSection.words.first;
        final targetAbsolutePosition =
            targetWord.position * CrosswordGame.cellSize -
                (targetBoardSection.position *
                    CrosswordGame.cellSize *
                    sectionSize);

        final targetCenter = Vector2(
          targetWord.position.x * CrosswordGame.cellSize.toDouble() +
              targetWord.width / 2,
          targetWord.position.y * CrosswordGame.cellSize.toDouble() +
              targetWord.height / 2,
        ).translated(
          game.camera.visibleWorldRect.size.width *
              WordSelectionLargeView.widthRatio /
              2,
          0,
        );
        final wordRect = Rect.fromLTWH(
          (targetWord.position.x * CrosswordGame.cellSize).toDouble(),
          (targetWord.position.y * CrosswordGame.cellSize).toDouble(),
          targetWord.width.toDouble(),
          targetWord.height.toDouble(),
        );

        final event = _MockTapUpEvent();
        when(() => event.localPosition).thenReturn(
          Vector2(
            targetAbsolutePosition.x.toDouble(),
            targetAbsolutePosition.y.toDouble(),
          ),
        );

        targetSection.children.whereType<SectionTapController>().first.onTapUp(
              event,
            );

        game.update(2);

        expect(
          game.camera.viewfinder.position,
          equals(targetCenter),
        );
        expect(
          game.camera.visibleWorldRect.contains(wordRect.center),
          isTrue,
        );
        verify(
          () => crosswordBloc.add(
            WordSelected(
              targetSection.index,
              targetWord,
            ),
          ),
        ).called(1);
      },
    );

    group('highlights word', () {
      late StreamController<CrosswordState> stateController;
      final state = CrosswordState(
        sectionSize: sectionSize,
        sections: {
          for (final section in sections)
            (section.position.x, section.position.y): section,
        },
      );

      setUp(() {
        stateController = StreamController<CrosswordState>.broadcast();
        whenListen(
          crosswordBloc,
          stateController.stream,
          initialState: state,
        );
      });

      testWithGame(
        'works on vertical word',
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
          final targetWord = boardSection.words.firstWhere(
            (element) => element.axis == Axis.vertical,
          );

          stateController.add(
            state.copyWith(
              selectedWord: WordSelection(
                section: targetSection.index,
                word: targetWord,
              ),
            ),
          );

          await Future.microtask(() {});

          expect(targetSection.lastSelectedWordId, equals(targetWord.id));
          expect(
            targetSection.lastSelectedSection,
            equals(targetSection.index),
          );
        },
      );

      testWithGame(
        'works on horizontal word',
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
          final targetWord = boardSection.words.firstWhere(
            (element) => element.axis == Axis.horizontal,
          );

          stateController.add(
            state.copyWith(
              selectedWord: WordSelection(
                section: targetSection.index,
                word: targetWord,
              ),
            ),
          );

          await Future.microtask(() {});

          expect(targetSection.lastSelectedWordId, equals(targetWord.id));
          expect(
            targetSection.lastSelectedSection,
            equals(targetSection.index),
          );
        },
      );

      testWithGame(
        'changes selected word',
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
          final targetWord1 = boardSection.words.firstWhere(
            (element) => element.axis == Axis.horizontal,
          );
          final targetWord2 = boardSection.words.firstWhere(
            (element) => element.axis == Axis.vertical,
          );

          stateController.add(
            state.copyWith(
              selectedWord: WordSelection(
                section: targetSection.index,
                word: targetWord1,
              ),
            ),
          );

          await Future.microtask(() {});

          expect(targetSection.lastSelectedWordId, equals(targetWord1.id));
          expect(
            targetSection.lastSelectedSection,
            equals(targetSection.index),
          );

          stateController.add(
            state.copyWith(
              selectedWord: WordSelection(
                section: targetSection.index,
                word: targetWord2,
              ),
            ),
          );

          await Future.microtask(() {});

          expect(targetSection.lastSelectedWordId, equals(targetWord2.id));
          expect(
            targetSection.lastSelectedSection,
            equals(targetSection.index),
          );
        },
      );

      testWithGame(
        'adds KeyboardListener component',
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
                word: targetWord,
              ),
            ),
          );

          await game.ready();
          final listeners =
              targetSection.children.whereType<SectionKeyboardHandler>();
          expect(listeners.length, equals(1));
          expect(listeners.first.wordIndex.id, targetWord.id);
        },
      );

      testWithGame(
        'adds KeyboardListener component and keeps only one listener when'
        ' changing selected word',
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
                word: targetWord,
              ),
            ),
          );

          await game.ready();

          final listeners =
              targetSection.children.whereType<SectionKeyboardHandler>();
          expect(listeners.length, equals(1));
          expect(listeners.first.wordIndex.id, targetWord.id);

          final targetWord2 = boardSection.words.elementAt(1);

          stateController.add(
            state.copyWith(
              selectedWord: WordSelection(
                section: targetSection.index,
                word: targetWord2,
              ),
            ),
          );

          await game.ready();

          final newListeners =
              targetSection.children.whereType<SectionKeyboardHandler>();
          expect(newListeners.length, equals(1));
          expect(newListeners.first.wordIndex.id, targetWord2.id);
        },
      );
    });

    testWithGame(
      'remove sections that are not visible when panning',
      createGame,
      (game) async {
        final state = CrosswordState(
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
                delta: Offset(
                  -sections.first.size * CrosswordGame.cellSize.toDouble(),
                  30,
                ),
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

    testWithGame(
      'can zoom in',
      createGame,
      (game) async {
        const state = CrosswordState(
          sectionSize: 400,
        );
        mockState(state);

        await game.ready();
        game.zoomIn();
        expect(game.camera.viewfinder.zoom, 1.05);
      },
    );

    testWithGame(
      'can zoom out',
      createGame,
      (game) async {
        const state = CrosswordState(
          sectionSize: 400,
        );
        mockState(state);

        await game.ready();
        game.zoomOut();
        expect(game.camera.viewfinder.zoom, .95);
      },
    );

    testWithGame(
      'cannot zoom out more than 0.05',
      createGame,
      (game) async {
        const state = CrosswordState(
          sectionSize: 400,
        );
        mockState(state);

        await game.ready();
        for (var i = 0; i < 100; i++) {
          game.zoomOut();
        }
        expect(game.camera.viewfinder.zoom, greaterThan(0));
      },
    );
  });
}
