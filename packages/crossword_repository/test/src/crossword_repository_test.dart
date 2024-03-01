// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockDocumentReference<T> extends Mock implements DocumentReference<T> {}

void main() {
  group('CrosswordRepository', () {
    final word = Word(
      id: 'id',
      position: Point(1, 1),
      axis: Axis.horizontal,
      answer: 'answer',
      clue: 'clue',
      hints: const ['hint'],
      visible: true,
      solvedTimestamp: null,
    );
    final boardSection1 = BoardSection(
      id: 'id',
      position: Point(1, 1),
      width: 10,
      height: 10,
      words: [
        word,
      ],
    );
    const sectionsCollection = 'sections';

    late FirebaseFirestore firebaseFirestore;
    late CrosswordRepository crosswordRepository;

    setUp(() async {
      firebaseFirestore = FakeFirebaseFirestore();
      crosswordRepository = CrosswordRepository(db: firebaseFirestore);

      await firebaseFirestore
          .collection(sectionsCollection)
          .doc(boardSection1.id)
          .set(boardSection1.toJson());
    });

    test('can be instantiated', () {
      expect(
        CrosswordRepository(db: firebaseFirestore),
        isNotNull,
      );
    });

    group('getSections', () {
      test('returns all the sections', () {
        expect(
          crosswordRepository.getSections(),
          emits([boardSection1]),
        );
      });
    });

    group('WatchSection', () {
      test('returns the requested section', () async {
        expect(
          crosswordRepository.watchSection('id'),
          emits(boardSection1),
        );
      });
    });
  });
}
