import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/extensions/extensions.dart';

class _FakeSolvedWord extends Fake implements Word {
  _FakeSolvedWord();

  @override
  int? get solvedTimestamp => 1;
}

class _FakeUnsolvedWord extends Fake implements Word {
  _FakeUnsolvedWord();

  @override
  int? get solvedTimestamp => null;
}

void main() {
  group('SortWords', () {
    final unsolvedWord = _FakeUnsolvedWord();
    final solvedWord = _FakeSolvedWord();
    final words = [
      unsolvedWord,
      solvedWord,
      unsolvedWord,
      solvedWord,
    ];

    group('sortBySolvedTimestamp', () {
      test('returns list with solved words after unsolved', () {
        expect(
          words..sortBySolvedTimestamp(),
          equals([
            unsolvedWord,
            unsolvedWord,
            solvedWord,
            solvedWord,
          ]),
        );
      });
    });
  });
}
