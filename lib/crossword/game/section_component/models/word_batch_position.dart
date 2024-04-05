// Represents the position of a word in the spriteBatch
class WordBatchPosition {
  const WordBatchPosition(this.startIndex, this.endIndex);

  // Sprite batch index for the first letter of a word
  final int startIndex;

  // Sprite batch index for the last letter of a word
  final int endIndex;

  int get length => endIndex - startIndex;
}
