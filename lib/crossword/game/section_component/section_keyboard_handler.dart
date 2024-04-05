part of 'section_component.dart';

class SectionKeyboardHandler extends PositionComponent
    with KeyboardHandler, ParentIsA<SectionComponent> {
  SectionKeyboardHandler(
    this.wordIndex, {
    super.position,
  });

  final WordIndex wordIndex;
  String word = '';

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyRepeatEvent || event is KeyUpEvent) return false;

    final batchPosition = wordIndex.batchPosition;
    final hasMaxLength = word.length == batchPosition.length;

    if (event.character != null && !hasMaxLength) {
      word += event.character!;
    }

    var backspacePressed = false;
    if (event.logicalKey == LogicalKeyboardKey.backspace && word.isNotEmpty) {
      word = word.substring(0, word.length - 1);
      backspacePressed = true;
    }

    final wordCharacters = word.toUpperCase().characters;

    for (var c = 0; c < wordCharacters.length; c++) {
      final mascot = parent.gameRef.state.mascot;
      final rect = wordCharacters.getCharacterRectangle(c, mascot);

      if (rect !=
          parent.spriteBatchComponent?.spriteBatch?.sources
              .elementAt(batchPosition.startIndex + c)) {
        parent.spriteBatchComponent?.spriteBatch?.replace(
          batchPosition.startIndex + c,
          source: rect,
        );
      }
    }
    if (backspacePressed) {
      parent.spriteBatchComponent?.spriteBatch?.replace(
        batchPosition.startIndex + wordCharacters.length,
        source: Rect.fromLTWH(
          2080,
          0,
          CrosswordGame.cellSize.toDouble(),
          CrosswordGame.cellSize.toDouble(),
        ),
      );
    }
    if (word.length == batchPosition.length) {
      parent.gameRef.bloc.add(AnswerUpdated(word));
    }
    return false;
  }

  void resetAndRemove() {
    final batchPosition = wordIndex.batchPosition;

    for (var c = batchPosition.startIndex; c < batchPosition.endIndex; c++) {
      parent.spriteBatchComponent?.spriteBatch?.replace(
        c,
        source: Rect.fromLTWH(
          2080,
          0,
          CrosswordGame.cellSize.toDouble(),
          CrosswordGame.cellSize.toDouble(),
        ),
      );
    }
    removeFromParent();
  }
}
