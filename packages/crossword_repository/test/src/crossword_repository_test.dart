// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

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
      size: 10,
      words: [
        word,
      ],
      borderWords: const [],
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
          crosswordRepository.watchSections(),
          emits([boardSection1]),
        );
      });
    });

    group('watchSection', () {
      test('returns the requested section', () async {
        expect(
          crosswordRepository.watchSection('id'),
          emits(boardSection1),
        );
      });
    });

    group('addSection', () {
      test('returns the requested section', () async {
        final section = BoardSection(
          id: 'id2',
          position: Point(1, 1),
          size: 10,
          words: [
            word,
          ],
          borderWords: const [],
        );
        await crosswordRepository.addSection(section);
        expect(
          crosswordRepository.watchSections(),
          emits([boardSection1, section]),
        );
      });
    });
  });
}
