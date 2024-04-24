// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
      axis: Axis.horizontal,
      answer: 'answer',
      length: 6,
      clue: 'clue',
    );
    final boardSection = BoardSection(
      id: 'id',
      position: Point(1, 1),
      size: 9,
      words: [
        word,
      ],
      borderWords: const [],
    );
    const sectionsCollection = 'boardChunks2';

    late FirebaseFirestore firebaseFirestore;
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
      const boardHalfSize = 3;

      Future<void> setUpSections({int solveUntil = 0}) async {
        var solvedIndex = 0;
        for (var x = -boardHalfSize; x < boardHalfSize; x++) {
          for (var y = -boardHalfSize; y < boardHalfSize; y++) {
            final section = boardSection.copyWith(
              id: '${boardSection.id}-$x-$y',
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

      /*

      Tests failing due to unhandled case in fake_cloud_firestore package

      test('returns a random section', () async {
        await setUpSections(solveUntil: 3);
        when(() => rng.nextInt(any())).thenReturn(3);

        final pos = await crosswordRepository.getRandomEmptySection();
        expect(pos, equals(Point(-3, 1)));
      });

      test('returns last section if every others only have solved words',
          () async {
        const totalSections = boardHalfSize * 2 * boardHalfSize * 2;
        await setUpSections(solveUntil: totalSections - 2);
        when(() => rng.nextInt(any())).thenReturn(3);

        final pos = await crosswordRepository.getRandomEmptySection();
        expect(pos, equals(Point(2, 2)));
      });*/

      test('returns null if every sections only have solved words', () async {
        const totalSections = boardHalfSize * 2 * boardHalfSize * 2;
        await setUpSections(solveUntil: totalSections);
        when(() => rng.nextInt(any())).thenReturn(3);

        final pos = await crosswordRepository.getRandomUncompletedSection();
        expect(pos, isNull);
      });

      test('returns null if no section found', () async {
        final pos = await crosswordRepository.getRandomUncompletedSection();
        expect(pos, isNull);
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
  });
}
