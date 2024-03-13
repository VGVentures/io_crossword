// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossword_repository/src/extensions/board_section_from_snapshot.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockQuerySnapshot<T> extends Mock implements QuerySnapshot<T> {}

class _MockQueryDocumentSnapshot<T> extends Mock
    implements QueryDocumentSnapshot<T> {}

void main() {
  final word = Word(
    position: const Point(0, 1),
    axis: Axis.horizontal,
    answer: 'answer',
    clue: 'clue',
    hints: const ['hint'],
    solvedTimestamp: null,
  );
  final boardSection1 = BoardSection(
    id: 'id',
    position: const Point(1, 1),
    size: 9,
    words: [
      word,
    ],
    borderWords: const [],
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
