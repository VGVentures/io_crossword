// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:crossword_repository/crossword_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';

class _MockRandom extends Mock implements Random {}

void main() {
  group('CrosswordRepository', () {
    final word = Word(
      id: '1',
      position: Point(0, 1),
      axis: WordAxis.horizontal,
      answer: 'answer',
      clue: 'clue',
    );
    final boardSection = BoardSection(
      id: 'id',
      position: Point(1, 1),
      words: [word],
    );
    const sectionsCollection = 'boardChunks';

    late FakeFirebaseFirestore firebaseFirestore;
    late CrosswordRepository crosswordRepository;
    late Random rng;

    setUpAll(() {
      registerFallbackValue(Uri.parse('http://localhost'));
    });

    setUp(() async {
      rng = _MockRandom();
      firebaseFirestore = FakeFirebaseFirestore();
      crosswordRepository = CrosswordRepository(
        db: firebaseFirestore,
        rng: rng,
      );
    });

    test('can be instantiated', () {
      expect(
        CrosswordRepository(db: firebaseFirestore),
        isNotNull,
      );
    });

    group('getRandomEmptySection', () {
      const bottomRight = Point(2, 2);

      Future<void> setUpSections({int solveUntil = 0}) async {
        var solvedIndex = 0;
        for (var x = 0; x <= bottomRight.x; x++) {
          for (var y = 0; y <= bottomRight.y; y++) {
            final section = BoardSection(
              id: '$x-$y',
              position: Point(x, y),
              words: [
                word.copyWith(
                  position: Point(x, y),
                  solvedTimestamp: solvedIndex <= solveUntil ? 1 : null,
                ),
              ],
            );

            await firebaseFirestore
                .collection(sectionsCollection)
                .doc(section.id)
                .set(section.toJson());
            solvedIndex++;
          }
        }
      }

      test('returns normally', () async {
        await setUpSections(solveUntil: 1);
        when(() => rng.nextInt(any())).thenReturn(3);

        await expectLater(
          () => crosswordRepository.getRandomUncompletedSection(bottomRight),
          returnsNormally,
        );
      });

      test('returns null if all sections have been solved', () async {
        final totalSections = (bottomRight.x + 1) * (bottomRight.y + 1);
        await setUpSections(solveUntil: totalSections);
        when(() => rng.nextInt(any())).thenReturn(3);

        final pos = await crosswordRepository.getRandomUncompletedSection(
          bottomRight,
        );

        expect(pos, isNull);
      });

      test('returns null if no sections are found', () async {
        final pos = await crosswordRepository.getRandomUncompletedSection(
          bottomRight,
        );

        expect(pos, isNull);
      });
    });

    group('getRandomSection', () {
      const bottomRight = Point(2, 2);

      Future<void> setUpSections() async {
        for (var x = 0; x <= bottomRight.x; x++) {
          for (var y = 0; y <= bottomRight.y; y++) {
            final section = BoardSection(
              id: '$x-$y',
              position: Point(x, y),
              words: [
                word.copyWith(
                  position: Point(x, y),
                  solvedTimestamp: 1,
                ),
              ],
            );

            await firebaseFirestore
                .collection(sectionsCollection)
                .doc(section.id)
                .set(section.toJson());
          }
        }
      }

      test('returns a valid section', () async {
        await setUpSections();
        when(() => rng.nextInt(any())).thenReturn(2);

        final section = await crosswordRepository.getRandomSection();

        expect(
          section,
          isA<BoardSection>()
              .having((s) => s.position, 'position', equals(Point(0, 2))),
        );
      });
    });

    group('watchSection', () {
      setUp(() async {
        await firebaseFirestore
            .collection(sectionsCollection)
            .doc(boardSection.id)
            .set(boardSection.toJson());
      });

      test('returns the requested section', () async {
        expect(
          crosswordRepository.watchSection('id'),
          emits(boardSection),
        );
      });
    });

    group('watchSectionFromPosition', () {
      final section = BoardSection(
        id: 'id2',
        position: Point(0, 1),
        words: [word],
      );

      setUp(() async {
        await firebaseFirestore
            .collection(sectionsCollection)
            .doc(section.id)
            .set(section.toJson());
      });

      test('returns the requested section depending on position', () {
        expect(
          crosswordRepository.watchSectionFromPosition(0, 1),
          emits(section),
        );
      });

      test('returns null if there is no section with the position', () {
        expect(
          crosswordRepository.watchSectionFromPosition(2, 2),
          emits(null),
        );
      });
    });

    group('loadBoardSections', () {
      test('returns all sections', () async {
        final section = BoardSection(
          id: 'id1',
          position: Point(0, 1),
          words: [word],
        );

        final section2 = section.copyWith(id: 'id2');

        await firebaseFirestore
            .collection(sectionsCollection)
            .doc(section.id)
            .set(section.toJson());

        await firebaseFirestore
            .collection(sectionsCollection)
            .doc(section2.id)
            .set(section2.toJson());

        expect(
          crosswordRepository.loadBoardSections(),
          emits(
            [section, section2],
          ),
        );
      });
    });
  });
}
