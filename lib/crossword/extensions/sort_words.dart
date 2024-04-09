import 'package:game_domain/game_domain.dart';

extension SortWords on List<Word> {
  void sortBySolvedTimestamp() {
    sort((a, b) {
      if (a.solvedTimestamp == null && b.solvedTimestamp == null) return 0;
      if (a.solvedTimestamp == null) return -1;
      if (b.solvedTimestamp == null) return 1;
      return a.solvedTimestamp!.compareTo(b.solvedTimestamp!);
    });
  }
}
