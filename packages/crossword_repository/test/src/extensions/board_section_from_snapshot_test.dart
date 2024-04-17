// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossword_repository/src/extensions/board_section_from_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';

class _MockQuerySnapshot<T> extends Mock implements QuerySnapshot<T> {}

class _MockQueryDocumentSnapshot<T> extends Mock
    implements QueryDocumentSnapshot<T> {}

void main() {
  const word = Word(
    id: '1',
    position: Point(0, 1),
    axis: Axis.horizontal,
    answer: 'answer',
    length: 6,
    clue: 'clue',
  );
  const boardSection1 = BoardSection(
    id: 'id',
    position: Point(1, 1),
    size: 9,
    words: [
      word,
    ],
    borderWords: [],
  );

  group('BoardSectionFromSnapshot', () {
    test('returns list of BoardSections from snapshot', () {
      final doc = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
      final query = _MockQuerySnapshot<Map<String, dynamic>>();

      when(() => query.docs).thenReturn([doc]);
      when(() => doc.id).thenReturn('id');
      when(doc.data).thenReturn(boardSection1.toJson());

      expect(query.toBoardSectionList(), equals([boardSection1]));
    });
  });
}
