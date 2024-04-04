part of 'section_component.dart';

class SectionKeyboardHandler extends PositionComponent
    with KeyboardHandler, ParentIsA<SectionComponent> {
  SectionKeyboardHandler(
    this.index, {
    super.position,
  });

  final (String, Color, WordBatchPosition) index;
  String word = '';

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyRepeatEvent || event is KeyUpEvent) return false;

    final wordBatchPosition = index.$3;
    final hasMaxLength = word.length == wordBatchPosition.length;

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
              .elementAt(wordBatchPosition.startIndex + c)) {
        parent.spriteBatchComponent?.spriteBatch?.replace(
          wordBatchPosition.startIndex + c,
          source: rect,
        );
      }
    }
    if (backspacePressed) {
      parent.spriteBatchComponent?.spriteBatch?.replace(
        wordBatchPosition.startIndex + wordCharacters.length,
        source: Rect.fromLTWH(
          2080,
          0,
          CrosswordGame.cellSize.toDouble(),
          CrosswordGame.cellSize.toDouble(),
        ),
      );
    }
    if (word.length == wordBatchPosition.length) {
      parent.gameRef.bloc.add(AnswerUpdated(word));
    }
    return false;
  }

  void resetAndRemove() {
    for (var c = index.$3.startIndex; c < index.$3.endIndex; c++) {
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
