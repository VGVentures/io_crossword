// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('CrosswordRepository', () {
    final word = Word(
      position: Point(0, 1),
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
      size: 9,
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

    group('watchSections', () {
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

    group('watchSectionsFromPositions', () {
      final section = BoardSection(
        id: 'id2',
        position: Point(0, 1),
        size: 10,
        words: [
          word,
        ],
        borderWords: const [],
      );

      setUp(() async {
        await firebaseFirestore
            .collection(sectionsCollection)
            .doc(section.id)
            .set(section.toJson());
      });

      test('returns the requested sections depending on position', () {
        expect(
          crosswordRepository.watchSectionsFromPositions([Point(0, 1)]),
          emits([section]),
        );
      });
    });
  });
}
