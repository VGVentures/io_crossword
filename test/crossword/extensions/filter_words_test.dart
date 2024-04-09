import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/extensions/filter_words.dart';

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

    group('solvedWords', () {
      test('returns list with only solved words', () {
        expect(
          words.solvedWords(),
          equals([
            solvedWord,
            solvedWord,
          ]),
        );
      });
    });

    group('unsolvedWords', () {
      test('returns list with only unsolved words', () {
        expect(
          words.unsolvedWords(),
          equals([
            unsolvedWord,
            unsolvedWord,
          ]),
        );
      });
    });
  });
}
