import 'package:board_generator/src/models/data_model.dart';
import 'package:test/test.dart';

void main() {
  const wordList = [
    'winter',
    'spring',
    'summer',
    'autumn',
    'interesting',
    'fascinating',
    'amazing',
    'wonderful',
    'beautiful',
    'gorgeous',
    'stunning',
    'breathtaking',
    'spectacular',
    'magnificent',
    'incredible',
  ];

  test('Empty valid crossword', () {
    final crossword = Crossword(
      (b) => b
        ..candidates.addAll([
          'that',
          'this',
          'with',
          'from',
          'your',
          'have',
          'more',
        ]),
    );

    expect(crossword.acrossWords.isEmpty, equals(true));
    expect(crossword.downWords.isEmpty, equals(true));
    expect(crossword.characters.isEmpty, equals(true));
    expect(crossword.valid, equals(true));
  });

  test('Minimal valid crossword', () {
    final topLeft = Location(
      (b) => b
        ..across = 0
        ..down = 0,
    );

    final crossword = Crossword(
      (b) => b
        ..acrossWords.addAll({topLeft: 'this'})
        ..downWords.addAll({topLeft: 'that'}),
    );

    expect(crossword.acrossWords.isNotEmpty, true);
    expect(crossword.acrossWords.length, 1);
    expect(crossword.downWords.isNotEmpty, true);
    expect(crossword.downWords.length, 1);
    expect(crossword.characters.isNotEmpty, true);
    expect(crossword.characters.length, 7);
    expect(
      crossword.characters[topLeft],
      CrosswordCharacter(
        (b) => b
          ..acrossWord = 'this'
          ..downWord = 'that'
          ..character = 't',
      ),
    );
    expect(crossword.valid, true);
  });

  test('Minimal invalid crossword', () {
    final topLeft = Location(
      (b) => b
        ..across = 0
        ..down = 0,
    );
    final oneDown = topLeft.rebuild((b) => b.down = 1);
    final crossword = Crossword(
      (b) => b..acrossWords.addAll({topLeft: 'this', oneDown: 'that'}),
    );

    expect(crossword.acrossWords.isNotEmpty, true);
    expect(crossword.acrossWords.length, 2);
    expect(crossword.downWords.isEmpty, true);
    expect(crossword.characters.isNotEmpty, true);
    expect(crossword.characters.length, 8);
    expect(crossword.valid, false);
  });

  test('Adding across and down words', () {
    // Empty crossword
    final crossword0 = Crossword();

    expect(crossword0.valid, true);

    final topLeft = Location(
      (b) => b
        ..across = 0
        ..down = 0,
    );

    final crossword1 =
        crossword0.addAcrossWord(location: topLeft, word: 'this');
    if (crossword1 == null) fail("crossword1 shouldn't be null");
    expect(crossword1.valid, true);

    final crossword2 = crossword1.addDownWord(location: topLeft, word: 'that');
    if (crossword2 == null) fail("crossword2 shouldn't be null");
    expect(crossword2.valid, true);
  });

  test('Fail on adding clashing across words', () {
    // Empty crossword
    final crossword0 = Crossword();

    expect(crossword0.valid, true);

    final topLeft = Location(
      (b) => b
        ..across = 0
        ..down = 0,
    );
    final downOne = Location(
      (b) => b
        ..across = 0
        ..down = 1,
    );

    final crossword1 =
        crossword0.addAcrossWord(location: topLeft, word: 'this');
    if (crossword1 == null) fail("crossword1 shouldn't be null");
    expect(crossword1.valid, true);

    final crossword2 =
        crossword1.addAcrossWord(location: topLeft, word: 'that');
    expect(crossword2 == null, true);

    final crossword3 =
        crossword1.addAcrossWord(location: downOne, word: 'other');
    expect(crossword3 == null, true);
  });

  test('Fail on adding clashing down words', () {
    // Empty crossword
    final crossword0 = Crossword();

    expect(crossword0.valid, true);

    final topLeft = Location(
      (b) => b
        ..across = 0
        ..down = 0,
    );
    final acrossOne = Location(
      (b) => b
        ..across = 1
        ..down = 0,
    );

    final crossword1 = crossword0.addDownWord(location: topLeft, word: 'this');
    if (crossword1 == null) fail("crossword1 shouldn't be null");
    expect(crossword1.valid, true);

    final crossword2 = crossword1.addDownWord(location: topLeft, word: 'that');
    expect(crossword2 == null, true);

    final crossword3 =
        crossword1.addDownWord(location: acrossOne, word: 'other');
    expect(crossword3 == null, true);
  });

  test('Crossword generation', () {
    final crossword0 = Crossword(
      (b) => b..candidates.addAll(wordList),
    );

    final crossword1 = crossword0.generate();
    expect(crossword1.valid, true);
    expect(crossword1.acrossWords.length, 1);
    expect(crossword1.candidates.length, crossword0.candidates.length - 1);

    final crossword2 = crossword1.generate();
    expect(crossword2.valid, true);
    expect(crossword2.acrossWords.length, 1);
    expect(crossword2.downWords.length, 1);
    expect(crossword2.candidates.length, crossword1.candidates.length - 1);

    final crossword3 = crossword2.generate();
    expect(crossword3.valid, true);
    expect(crossword3.acrossWords.length + crossword3.downWords.length, 3);
    expect(crossword3.candidates.length, crossword2.candidates.length - 1);

    final crossword4 = crossword3.generate();
    expect(crossword4.valid, true);
    expect(crossword4.acrossWords.length + crossword4.downWords.length, 4);
    expect(crossword4.candidates.length, crossword3.candidates.length - 1);

    final crossword5 = crossword4.generate();
    expect(crossword5.valid, true);
    expect(crossword5.acrossWords.length + crossword5.downWords.length, 5);
    expect(crossword5.candidates.length, crossword4.candidates.length - 1);

    final crossword6 = crossword5.generate();
    expect(crossword6.valid, true);
    expect(crossword6.acrossWords.length + crossword6.downWords.length, 6);
    expect(crossword6.candidates.length, crossword5.candidates.length - 1);

    final crossword7 = crossword6.generate();
    expect(crossword7.valid, true);
    expect(crossword7.acrossWords.length + crossword7.downWords.length, 7);
    expect(crossword7.candidates.length, crossword6.candidates.length - 1);

    final crossword8 = crossword7.generate();
    expect(crossword8.valid, true);
    expect(crossword8.acrossWords.length + crossword8.downWords.length, 8);
    expect(crossword8.candidates.length, crossword7.candidates.length - 1);
  });
}
