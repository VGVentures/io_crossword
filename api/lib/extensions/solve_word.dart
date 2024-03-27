import 'package:clock/clock.dart';
import 'package:game_domain/game_domain.dart';

/// Extension on Word to copy instance with solved timestamp to now
extension SolveWord on Word {
  /// Copies instance with solved timestamp to now
  Word solveWord() {
    return Word(
      position: position,
      axis: axis,
      answer: answer,
      clue: clue,
      hints: hints,
      solvedTimestamp: clock.now().millisecondsSinceEpoch,
    );
  }
}
