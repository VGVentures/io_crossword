// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/helpers.dart';

class _MockCrosswordBloc extends Mock implements CrosswordBloc {}

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final sections = getTestSections();
  final sectionSize = sections.first.size;

  group('SectionKeyboardHandler', () {
    late CrosswordBloc crosswordBloc;
    late PlayerBloc playerBloc;
    late WordSelectionBloc wordSelectionBloc;
    late StreamController<CrosswordState> stateController;
    final state = CrosswordState(
      sectionSize: sectionSize,
      sections: {
        for (final section in sections)
          (section.position.x, section.position.y): section,
      },
    );

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();
      playerBloc = _MockPlayerBloc();
      wordSelectionBloc = _MockWordSelectionBloc();
      stateController = StreamController<CrosswordState>.broadcast();
      whenListen(
        crosswordBloc,
        stateController.stream,
        initialState: state,
      );
    });

    CrosswordGame createGame({
      bool? showDebugOverlay,
    }) =>
        CrosswordGame(
          wordSelectionBloc: wordSelectionBloc,
          crosswordBloc: crosswordBloc,
          showDebugOverlay: showDebugOverlay,
          playerBloc: playerBloc,
        );

    testWithGame(
      'can enter characters',
      createGame,
      (game) async {
        when(() => playerBloc.state).thenReturn(PlayerState());

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

        listeners.first.onKeyEvent(
          KeyDownEvent(
            logicalKey: LogicalKeyboardKey.keyF,
            physicalKey: PhysicalKeyboardKey.keyF,
            timeStamp: DateTime.now().timeZoneOffset,
            character: 'f',
          ),
          {LogicalKeyboardKey.keyF},
        );
        await game.ready();
        expect(listeners.first.word, equals('f'));
      },
    );

    testWithGame(
      'can remove characters',
      createGame,
      (game) async {
        when(() => playerBloc.state).thenReturn(PlayerState());

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

        listeners.first.onKeyEvent(
          KeyDownEvent(
            logicalKey: LogicalKeyboardKey.keyF,
            physicalKey: PhysicalKeyboardKey.keyF,
            timeStamp: DateTime.now().timeZoneOffset,
            character: 'f',
          ),
          {LogicalKeyboardKey.keyF},
        );
        await game.ready();
        expect(listeners.first.word, equals('f'));

        listeners.first.onKeyEvent(
          KeyDownEvent(
            logicalKey: LogicalKeyboardKey.backspace,
            physicalKey: PhysicalKeyboardKey.backspace,
            timeStamp: DateTime.now().timeZoneOffset,
          ),
          {LogicalKeyboardKey.backspace},
        );
        await game.ready();
        expect(listeners.first.word, equals(''));
      },
    );

    testWithGame(
      'add $WordSolveAttempted event when user enters all the letters',
      createGame,
      (game) async {
        when(() => playerBloc.state).thenReturn(PlayerState());

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

        final buffer = StringBuffer();
        for (var i = 0; i < targetWord.length; i++) {
          listeners.first.onKeyEvent(
            KeyDownEvent(
              logicalKey: LogicalKeyboardKey.keyF,
              physicalKey: PhysicalKeyboardKey.keyF,
              timeStamp: DateTime.now().timeZoneOffset,
              character: 'f',
            ),
            {LogicalKeyboardKey.keyF},
          );
          buffer.write('f');
        }
        await game.ready();

        verify(
          () => wordSelectionBloc
              .add(WordSolveAttempted(answer: buffer.toString())),
        ).called(1);
      },
    );
  });
}
