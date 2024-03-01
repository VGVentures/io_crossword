import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';

class SectionTapController extends PositionComponent
    with ParentIsA<SectionComponent>, TapCallbacks {
  SectionTapController({
    super.position,
    super.size,
  });

  @override
  void onTapUp(TapUpEvent event) {
    final localPosition = event.localPosition;
    final boardSection = parent._boardSection;

    if (boardSection != null) {
      for (final word in boardSection.words) {
        final wordLength =
            (word.answer.length * CrosswordGame.cellSize).toDouble();
        final wordRect = Rect.fromLTWH(
          (word.position.x * CrosswordGame.cellSize).toDouble(),
          (word.position.y * CrosswordGame.cellSize).toDouble(),
          word.axis == Axis.horizontal
              ? wordLength
              : CrosswordGame.cellSize.toDouble(),
          word.axis == Axis.vertical
              ? wordLength
              : CrosswordGame.cellSize.toDouble(),
        );

        if (wordRect.contains(localPosition.toOffset())) {
          parent.gameRef.bloc.add(
            WordSelected(parent.index, word.id),
          );
        }
      }
    }
  }
}

class SectionComponent extends PositionComponent
    with HasGameRef<CrosswordGame> {
  SectionComponent({
    required this.index,
    super.key,
  });

  final (int, int) index;

  late SpriteBatchComponent? spriteBatchComponent;
  late Map<String, (int, int)> _wordIndex;
  late final StreamSubscription<CrosswordState> _subscription;

  BoardSection? _boardSection;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    _subscription = gameRef.bloc.stream.listen(_onNewState);

    final boardSection = gameRef.state.sections[index];
    if (boardSection != null) {
      _boardSection = boardSection;
      _loadBoardSection(boardSection);
    } else {
      gameRef.bloc.add(
        BoardSectionRequested(index),
      );
    }
  }

  @override
  void onRemove() {
    super.onRemove();
    _subscription.cancel();
  }

  String? _lastSelectedWord;
  void _onNewState(CrosswordState state) {
    if (state is CrosswordLoaded) {
      if (_boardSection == null) {
        final boardSection = state.sections[index];
        if (boardSection != null) {
          _boardSection = boardSection;
          _loadBoardSection(boardSection);
        }
      } else {
        final selectedWord = state.selectedWord?.wordId;
        if (selectedWord != _lastSelectedWord) {
          _updateSelection(
            previousWord: _lastSelectedWord,
            newWord: selectedWord,
          );
          _lastSelectedWord = selectedWord;
        }
      }
    }
  }

  void _updateSelection({
    String? previousWord,
    String? newWord,
  }) {
    final indexes = <(String, Color, (int, int))>[];
    if (previousWord != null && _wordIndex.containsKey(previousWord)) {
      indexes.add(
        (
          previousWord,
          Colors.white.withOpacity(.2),
          _wordIndex[previousWord]!,
        ),
      );
    }

    if (newWord != null && _wordIndex.containsKey(newWord)) {
      indexes.add(
        (
          newWord,
          Colors.white,
          _wordIndex[newWord]!,
        ),
      );
    }

    for (final index in indexes) {
      for (var i = index.$3.$1; i < index.$3.$2; i++) {
        spriteBatchComponent?.spriteBatch?.replace(
          i,
          color: index.$2,
        );
      }
    }
  }

  void _loadBoardSection(BoardSection section) {
    final spriteBatch = SpriteBatch(gameRef.lettersSprite);

    final sectionPosition = Vector2(
      (index.$1 * gameRef.sectionSize).toDouble(),
      (index.$2 * gameRef.sectionSize).toDouble(),
    );

    add(
      SectionTapController(
        position: sectionPosition,
        size: Vector2(
          gameRef.sectionSize.toDouble(),
          gameRef.sectionSize.toDouble(),
        ),
      ),
    );

    _wordIndex = {};

    final color = Colors.white.withOpacity(.2);
    for (var i = 0; i < section.words.length; i++) {
      final word = section.words[i];

      final wordCharacters = word.answer.toUpperCase().characters;

      final wordIndexStart = spriteBatch.length;
      for (var c = 0; c < wordCharacters.length; c++) {
        late Rect rect;
        if (word.visible) {
          final char = wordCharacters.elementAt(c);
          final charIndex = char.codeUnitAt(0) - 65;
          rect = Rect.fromLTWH(
            (charIndex * CrosswordGame.cellSize).toDouble(),
            0,
            CrosswordGame.cellSize.toDouble(),
            CrosswordGame.cellSize.toDouble(),
          );
        } else {
          rect = Rect.fromLTWH(
            1040,
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
        final offset = sectionPosition +
            Vector2(
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
      _wordIndex[word.id] = (wordIndexStart, wordIndexEnd);
    }

    add(
      spriteBatchComponent = SpriteBatchComponent(
        spriteBatch: spriteBatch,
        blendMode: BlendMode.srcATop,
      ),
    );
  }
}
