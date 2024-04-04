import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' hide Axis, Image;
import 'package:flutter/services.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword/extensions/characters_rectangle.dart';
import 'package:io_crossword/crossword/extensions/extensions.dart';

part 'section_debug.dart';
part 'section_keyboard_handler.dart';
part 'section_tap_controller.dart';

class WordBatchPosition extends Equatable {
  const WordBatchPosition(this.startIndex, this.endIndex);

  // Index of the sprite of the first letter of a word
  final int startIndex;

  // Index of the sprite of the last letter of a word
  final int endIndex;

  int get length => endIndex - startIndex;

  @override
  List<Object?> get props => [startIndex, endIndex];
}

class SectionComponent extends Component with HasGameRef<CrosswordGame> {
  SectionComponent({
    required this.index,
    super.key,
  });

  final (int, int) index;

  SpriteBatchComponent? spriteBatchComponent;
  late Map<String, WordBatchPosition> _wordIndex;
  late final StreamSubscription<CrosswordState> _subscription;

  BoardSection? _boardSection;

  @visibleForTesting
  String? lastSelectedWord;
  @visibleForTesting
  (int, int)? lastSelectedSection;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final state = gameRef.state;

    _subscription = gameRef.bloc.stream.listen(_onNewState);

    lastSelectedWord = state.selectedWord?.word.id;
    lastSelectedSection = state.selectedWord?.section;

    final boardSection = gameRef.state.sections[index];
    if (boardSection != null) {
      _boardSection = boardSection;
      _loadBoardSection();
    } else {
      gameRef.bloc.add(
        BoardSectionRequested(index),
      );
    }

    if (gameRef.showDebugOverlay) {
      await addAll(
        [
          SectionDebugOutline(
            priority: 8,
            position: Vector2(
              index.$1 * gameRef.sectionSize.toDouble(),
              index.$2 * gameRef.sectionSize.toDouble(),
            ),
            size: Vector2.all(gameRef.sectionSize.toDouble()),
          ),
          SectionDebugIndex(
            priority: 10,
            index: index,
            position: Vector2(
              index.$1 * gameRef.sectionSize.toDouble(),
              index.$2 * gameRef.sectionSize.toDouble(),
            ),
          ),
        ],
      );
    }
  }

  @override
  void onRemove() {
    super.onRemove();
    _subscription.cancel();
  }

  void _onNewState(CrosswordState state) {
    if (state is CrosswordLoaded) {
      if (_boardSection == null) {
        final boardSection = state.sections[index];
        if (boardSection != null) {
          _boardSection = boardSection;
          _loadBoardSection();
        }
      } else {
        if (state.sections[index] != null &&
            state.sections[index] != _boardSection) {
          _boardSection = state.sections[index];
          _loadBoardSection();
        }

        final selectedWord = state.selectedWord?.word.id;
        final selectedSection = state.selectedWord?.section;
        if (selectedWord != lastSelectedWord ||
            selectedSection != lastSelectedSection) {
          _updateSelection(
            previousWord: lastSelectedWord,
            newWord: selectedWord,
            previousSection: lastSelectedSection,
            newSection: selectedSection,
          );
        }
        lastSelectedWord = selectedWord;
        lastSelectedSection = selectedSection;
      }
    }
  }

  Vector2 get sectionPosition => Vector2(
        index.$1 * gameRef.sectionSize.toDouble(),
        index.$2 * gameRef.sectionSize.toDouble(),
      );

  void _loadBoardSection() {
    final section = _boardSection;
    if (section == null) {
      return;
    }

    add(
      SectionTapController(
        position: sectionPosition,
        size: Vector2(
          gameRef.sectionSize.toDouble(),
          gameRef.sectionSize.toDouble(),
        ),
      ),
    );

    firstChild<SpriteBatchComponent>()?.removeFromParent();

    final spriteBatch = SpriteBatch(gameRef.lettersSprite);

    _wordIndex = {};

    final color = Colors.white.withOpacity(.2);
    for (var i = 0; i < _boardSection!.words.length; i++) {
      final word = _boardSection!.words[i];

      final wordCharacters = word.answer.toUpperCase().characters;

      final wordIndexStart = spriteBatch.length;
      for (var c = 0; c < wordCharacters.length; c++) {
        late Rect rect;
        if (word.solvedTimestamp != null) {
          // A bug in coverage is preventing this block from being covered
          // coverage:ignore-start
          rect = wordCharacters.getCharacterRectangle(c, word.mascot);
          // coverage:ignore-end
        } else {
          rect = Rect.fromLTWH(
            2080,
            0,
            CrosswordGame.cellSize.toDouble(),
            CrosswordGame.cellSize.toDouble(),
          );
        }

        final x = word.axis == Axis.horizontal
            ? word.position.x + c
            : word.position.x;

        final y =
            word.axis == Axis.vertical ? word.position.y + c : word.position.y;
        final offset = Vector2(
          x * CrosswordGame.cellSize.toDouble(),
          y * CrosswordGame.cellSize.toDouble(),
        );

        spriteBatch.add(
          source: rect,
          offset: offset,
          color: color,
        );
      }
      final wordIndexEnd = spriteBatch.length;
      _wordIndex[word.id] = WordBatchPosition(wordIndexStart, wordIndexEnd);
    }

    add(
      spriteBatchComponent = SpriteBatchComponent(
        spriteBatch: spriteBatch,
        blendMode: BlendMode.srcATop,
      ),
    );
  }

  void _updateSelection({
    String? previousWord,
    String? newWord,
    (int, int)? previousSection,
    (int, int)? newSection,
  }) {
    final indexes = <(String, Color, WordBatchPosition)>[];
    if (previousSection == index &&
        previousWord != null &&
        _wordIndex.containsKey(previousWord)) {
      indexes.add(
        (
          previousWord,
          Colors.white.withOpacity(.2),
          _wordIndex[previousWord]!,
        ),
      );
    }

    children.whereType<SectionKeyboardHandler>().forEach(
          (e) => e.resetAndRemove(),
        );
    if (newSection == index &&
        newWord != null &&
        _wordIndex.containsKey(newWord)) {
      final newIndex = (
        newWord,
        Colors.white,
        _wordIndex[newWord]!,
      );
      add(SectionKeyboardHandler(newIndex));
      indexes.add(newIndex);
    }

    for (final index in indexes) {
      for (var i = index.$3.startIndex; i < index.$3.endIndex; i++) {
        spriteBatchComponent?.spriteBatch?.replace(
          i,
          color: index.$2,
        );
      }
    }
  }
}
