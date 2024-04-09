import 'package:game_domain/game_domain.dart';

extension UnsolvedWords on List<Word> {
  Iterable<Word> unsolvedWords() {
    return where((word) => word.solvedTimestamp == null);
  }

  Iterable<Word> solvedWords() {
    return where((word) => word.solvedTimestamp != null);
  }
}
