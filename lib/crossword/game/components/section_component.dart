import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';

class SectionComponent extends PositionComponent
    with HasGameRef<CrosswordGame> {
  SectionComponent({
    required this.index,
    super.key,
  });

  final (int, int) index;

  late StreamSubscription<CrosswordState> _subscription;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final boardSection = gameRef.state.sections[index];
    if (boardSection != null) {
      _loadBoardSection(boardSection);
    } else {
      _subscription = gameRef.bloc.stream.listen((state) {
        if (state is CrosswordLoaded) {
          final boardSection = state.sections[index];
          if (boardSection != null) {
            _subscription.cancel();
            _loadBoardSection(boardSection);
          }
        }
      });

      gameRef.bloc.add(
        BoardSectionRequested(index),
      );
    }
  }

  void _loadBoardSection(BoardSection section) {
    final spriteBatch = SpriteBatch(gameRef.lettersSprite);

    print(section.position);
    final sectionPosition = Vector2(
      (index.$1 * gameRef.sectionSize).toDouble(),
      (index.$2 * gameRef.sectionSize).toDouble(),
    );

    for (var i = 0; i < section.words.length; i++) {
      final word = section.words[i];

      final wordCharacters = word.answer.toUpperCase().characters;

      for (var c = 0; c < wordCharacters.length; c++) {
        final char = wordCharacters.elementAt(c);
        final charIndex = char.codeUnitAt(0) - 65;
        final rect = Rect.fromLTWH(
          (charIndex * CrosswordGame.cellSize).toDouble(),
          0,
          CrosswordGame.cellSize.toDouble(),
          CrosswordGame.cellSize.toDouble(),
        );

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
        );
      }
    }

    add(SpriteBatchComponent(spriteBatch: spriteBatch));
  }
}
