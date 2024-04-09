part of 'section_component.dart';

extension CharacterResolver on SectionComponent {
  bool _isCharacterSolvedByNeighbour(Rect sectionRectangle, int x, int y) {
    var charSolved = false;
    final offset = Vector2(
      x * CrosswordGame.cellSize.toDouble(),
      y * CrosswordGame.cellSize.toDouble(),
    );

    if (!sectionRectangle.contains(offset.toOffset())) {
      charSolved = _isCharSolved(x, y);
    }

    if (!charSolved) {
      charSolved = _isCharSolvedBis(x, y);
    }

    return charSolved;
  }

  // If character in out of section rectangle and solved by neighbour's word
  bool _isCharSolved(int x, int y) {
    final wordsToCheck = <Word>[];
    final rightNeighbour = gameRef.state.sections[(index.$1 + 1, index.$2)];
    final topRightNeighbour =
        gameRef.state.sections[(index.$1 + 1, index.$2 - 1)];
    final bottomNeighbour = gameRef.state.sections[(index.$1, index.$2 + 1)];
    final bottomLeftNeighbour =
        gameRef.state.sections[(index.$1 - 1, index.$2 + 1)];

    if (rightNeighbour != null) {
      wordsToCheck.addAll(rightNeighbour.words.solvedWords());
    }
    if (topRightNeighbour != null) {
      wordsToCheck.addAll(topRightNeighbour.words.solvedWords());
    }
    if (bottomNeighbour != null) {
      wordsToCheck.addAll(bottomNeighbour.words.solvedWords());
    }
    if (bottomLeftNeighbour != null) {
      wordsToCheck.addAll(bottomLeftNeighbour.words.solvedWords());
    }

    for (var i = 0; i < wordsToCheck.length; i++) {
      final word = wordsToCheck[i];

      final characters = word.answer.toUpperCase().characters;
      for (var c = 0; c < characters.length; c++) {
        final charPosition = word.getCharactersPosition(c);

        print(charPosition);
        if (charPosition.x == x && charPosition.y == y) {
          return true;
        }
      }
    }
    return false;
  }

  // If character is in section rectangle and solved by border word
  bool _isCharSolvedBis(int x, int y) {
    final wordsToCheck = <Word>[];

    final leftNeighbour = gameRef.state.sections[(index.$1 - 1, index.$2)];
    final topNeighbour = gameRef.state.sections[(index.$1, index.$2 - 1)];

    if (leftNeighbour != null) {
      wordsToCheck.addAll(leftNeighbour.words.solvedWords());
    }
    if (topNeighbour != null) {
      wordsToCheck.addAll(topNeighbour.words.solvedWords());
    }

    for (var i = 0; i < wordsToCheck.length; i++) {
      final word = wordsToCheck[i];

      final characters = word.answer.toUpperCase().characters;
      for (var c = 0; c < characters.length; c++) {
        final charPosition = word.getCharactersPosition(c);

        if (charPosition.x == x && charPosition.y == y) {
          return true;
        }
      }
    }
    return false;
  }
}
