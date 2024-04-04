import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/helpers.dart';

class _MockCrosswordBloc extends Mock implements CrosswordBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final sections = getTestSections();
  final sectionSize = sections.first.size;

  group('SectionKeyboardHandler', () {
    late CrosswordBloc bloc;
    late StreamController<CrosswordState> stateController;
    final state = CrosswordLoaded(
      sectionSize: sectionSize,
      sections: {
        for (final section in sections)
          (section.position.x, section.position.y): section,
      },
    );

    setUp(() {
      bloc = _MockCrosswordBloc();
      stateController = StreamController<CrosswordState>.broadcast();
      whenListen(
        bloc,
        stateController.stream,
        initialState: state,
      );
    });

    CrosswordGame createGame({
      bool? showDebugOverlay,
    }) =>
        CrosswordGame(bloc, showDebugOverlay: showDebugOverlay);

    testWithGame(
      'can enter characters',
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
      'add AnswerUpdated event when user enters all the letters',
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

        final buffer = StringBuffer();
        for (var i = 0; i < targetWord.answer.length; i++) {
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
        verify(() => bloc.add(AnswerUpdated(buffer.toString()))).called(1);
      },
    );
  });
}
