// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:clock/clock.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

class _MockDbEntityRecord extends Mock implements DbEntityRecord {}

void main() {
  group('CrosswordRepository', () {
    late DbClient dbClient;

    const sectionsCollection = 'boardChunks';
    const answersCollection = 'answers';

    setUpAll(() {
      registerFallbackValue(_MockDbEntityRecord());
    });

    setUp(() {
      dbClient = _MockDbClient();
    });

    test('can be instantiated', () {
      expect(CrosswordRepository(dbClient: _MockDbClient()), isNotNull);
    });

    test('listAllSections returns a list of sections', () async {
      final record = _MockDbEntityRecord();
      when(() => record.id).thenReturn('id');
      when(() => record.data).thenReturn(
        {
          'position': {'x': 1, 'y': 1},
          'size': 300,
          'words': const <dynamic>[],
          'borderWords': const <dynamic>[],
        },
      );
      when(() => dbClient.listAll(sectionsCollection))
          .thenAnswer((_) async => [record]);
      final repository = CrosswordRepository(dbClient: dbClient);
      final sections = await repository.listAllSections();
      expect(sections, [
        BoardSection(
          id: 'id',
          position: Point(1, 1),
          size: 300,
          words: const [],
          borderWords: const [],
        ),
      ]);
    });

    test('findSectionByPosition returns a section', () async {
      final record = _MockDbEntityRecord();
      when(() => record.id).thenReturn('id');
      when(() => record.data).thenReturn(
        {
          'position': {'x': 1, 'y': 1},
          'size': 300,
          'words': const <dynamic>[],
          'borderWords': const <dynamic>[],
        },
      );
      when(
        () => dbClient.find(
          sectionsCollection,
          {
            'position.x': 1,
            'position.y': 1,
          },
        ),
      ).thenAnswer((_) async => [record]);

      final repository = CrosswordRepository(dbClient: dbClient);
      final section = await repository.findSectionByPosition(1, 1);
      expect(
        section,
        BoardSection(
          id: 'id',
          position: Point(1, 1),
          size: 300,
          words: const [],
          borderWords: const [],
        ),
      );
    });

    test('findSectionByPosition returns null when empty', () async {
      when(
        () => dbClient.find(
          sectionsCollection,
          {
            'position.x': 1,
            'position.y': 1,
          },
        ),
      ).thenAnswer((_) async => []);

      final repository = CrosswordRepository(dbClient: dbClient);
      final section = await repository.findSectionByPosition(1, 1);
      expect(section, isNull);
    });

    test('updateSection updates the section in the db', () async {
      when(
        () => dbClient.update(
          sectionsCollection,
          any(that: isA<DbEntityRecord>()),
        ),
      ).thenAnswer((_) async {});
      final repository = CrosswordRepository(dbClient: dbClient);
      final section = BoardSection(
        id: 'id',
        position: Point(1, 1),
        size: 300,
        words: const [],
        borderWords: const [],
      );
      await repository.updateSection(section);
      final captured = verify(
        () => dbClient.update(
          sectionsCollection,
          captureAny(),
        ),
      ).captured.single as DbEntityRecord;

      expect(captured.id, 'id');
      expect(
        captured.data,
        {
          'position': {'x': 1, 'y': 1},
          'size': 300,
          'words': <String>[],
          'borderWords': <String>[],
          'snapshotUrl': null,
        },
      );
    });

    group('answerWord', () {
      late CrosswordRepository repository;
      final word = Word(
        id: '1',
        position: const Point(1, 1),
        axis: Axis.vertical,
        answer: '       ',
        clue: '',
      );

      final word2 = Word(
        id: '2',
        position: const Point(1, 1),
        axis: Axis.horizontal,
        answer: 'b   ',
        clue: '',
      );

      final word3 = Word(
        id: '3',
        position: const Point(1, 1),
        axis: Axis.horizontal,
        answer: 'hap y',
        clue: '',
      );

      setUp(() {
        final record = _MockDbEntityRecord();
        when(() => record.id).thenReturn('1');
        when(() => record.data).thenReturn(
          {
            'position': {'x': 1, 'y': 1},
            'size': 300,
            'words': [
              {'id': '1', ...word.toJson()},
              {'id': '2', ...word2.toJson()},
              {'id': '3', ...word3.toJson()},
            ],
            'borderWords': const <dynamic>[],
          },
        );
        when(
          () => dbClient.find(
            sectionsCollection,
            {'position.x': 1, 'position.y': 1},
          ),
        ).thenAnswer((_) async => [record]);

        final record2 = _MockDbEntityRecord();
        when(() => record2.id).thenReturn('2');
        when(() => record2.data).thenReturn(
          {
            'position': {'x': 1, 'y': 2},
            'size': 300,
            'words': [
              {'id': '2', ...word2.toJson()},
            ],
            'borderWords': const <dynamic>[],
          },
        );
        when(
          () => dbClient.find(
            sectionsCollection,
            {'position.x': 1, 'position.y': 2},
          ),
        ).thenAnswer((_) async => [record2]);

        when(
          () => dbClient.update(
            sectionsCollection,
            any(that: isA<DbEntityRecord>()),
          ),
        ).thenAnswer((_) async {});

        final answersRecord = _MockDbEntityRecord();
        when(() => answersRecord.id).thenReturn('1');
        when(() => answersRecord.data).thenReturn({
          'answer': 'flutter',
          'sections': [
            {'x': 1, 'y': 1},
          ],
          'collidedWords': <Map<String, dynamic>>[
            {
              'wordId': '2',
              'position': 1,
              'character': 'l',
              'sections': [
                {'x': 1, 'y': 1},
                {'x': 1, 'y': 2},
              ],
            }
          ],
        });
        when(
          () => dbClient.getById(answersCollection, '1'),
        ).thenAnswer((_) async => answersRecord);

        final answersRecord2 = _MockDbEntityRecord();
        when(() => answersRecord2.id).thenReturn('2');
        when(() => answersRecord2.data).thenReturn({
          'answer': 'blue',
          'sections': [
            {'x': 1, 'y': 1},
            {'x': 1, 'y': 2},
          ],
          'collidedWords': <Map<String, dynamic>>[
            {
              'wordId': '2',
              'position': 1,
              'character': 'l',
              'sections': [
                {'x': 1, 'y': 1},
              ],
            }
          ],
        });

        when(
          () => dbClient.getById(answersCollection, '2'),
        ).thenAnswer((_) async => answersRecord2);

        repository = CrosswordRepository(dbClient: dbClient);
      });

      test('returns true if answer is correct', () async {
        final time = DateTime.now();
        final clock = Clock.fixed(time);
        await withClock(clock, () async {
          final valid =
              await repository.answerWord('1', Mascots.dino, 'flutter');
          expect(valid, isTrue);

          verify(
            () => dbClient.update(
              sectionsCollection,
              DbEntityRecord(
                id: '2',
                data: {
                  'position': {'x': 1, 'y': 2},
                  'size': 300,
                  'words': [
                    word2.copyWith(answer: 'bl  ').toJson(),
                  ],
                  'borderWords': <String>[],
                  'snapshotUrl': null,
                },
              ),
            ),
          ).called(1);

          verify(
            () => dbClient.update(
              sectionsCollection,
              DbEntityRecord(
                id: '1',
                data: {
                  'position': {'x': 1, 'y': 1},
                  'size': 300,
                  'words': [
                    word3.toJson(),
                    word
                        .copyWith(
                          solvedTimestamp: time.millisecondsSinceEpoch,
                          mascot: Mascots.dino,
                          answer: 'flutter',
                        )
                        .toJson(),
                    word2.copyWith(answer: 'bl  ').toJson(),
                  ],
                  'borderWords': <String>[],
                  'snapshotUrl': null,
                },
              ),
            ),
          ).called(1);
        });
      });

      test('returns false if answer is incorrect', () async {
        final valid = await repository.answerWord('1', Mascots.dino, 'android');
        expect(valid, isFalse);
      });

      test(
        'throws $CrosswordRepositoryException if answer is not found',
        () async {
          when(
            () => dbClient.getById(answersCollection, 'fake'),
          ).thenAnswer((_) async => null);
          expect(
            () => repository.answerWord('fake', Mascots.dino, 'flutter'),
            throwsA(isA<CrosswordRepositoryException>()),
          );
        },
      );

      test(
        'throws $CrosswordRepositoryException if collided word is not found',
        () async {
          final answersRecord = _MockDbEntityRecord();
          when(() => answersRecord.id).thenReturn('3');
          when(() => answersRecord.data).thenReturn({
            'answer': 'happy',
            'sections': [
              {'x': 1, 'y': 1},
            ],
            'collidedWords': <Map<String, dynamic>>[
              {
                'wordId': '6',
                'position': 1,
                'character': 'l',
                'sections': [
                  {'x': 1, 'y': 1},
                  {'x': 1, 'y': 2},
                ],
              }
            ],
          });
          when(
            () => dbClient.getById(answersCollection, '3'),
          ).thenAnswer((_) async => answersRecord);

          expect(
            () => repository.answerWord('3', Mascots.sparky, 'happy'),
            throwsA(isA<CrosswordRepositoryException>()),
          );
        },
      );

      test(
        'throws $CrosswordRepositoryException if section does not exist',
        () async {
          when(
            () => dbClient.find(
              sectionsCollection,
              {'position.x': 1, 'position.y': 1},
            ),
          ).thenAnswer((_) async => []);

          expect(
            () => repository.answerWord('1', Mascots.dino, 'flutter'),
            throwsA(isA<CrosswordRepositoryException>()),
          );
        },
      );

      test(
        'throws $CrosswordRepositoryException if word is not in section',
        () async {
          final answersRecord = _MockDbEntityRecord();
          when(() => answersRecord.id).thenReturn('fake');
          when(() => answersRecord.data).thenReturn({
            'answer': 'flutter',
            'sections': [
              {'x': 1, 'y': 1},
            ],
            'collidedWords': <Map<String, dynamic>>[],
          });
          when(
            () => dbClient.getById(answersCollection, 'fake'),
          ).thenAnswer((_) async => answersRecord);
          expect(
            () => repository.answerWord('fake', Mascots.dino, 'flutter'),
            throwsA(isA<CrosswordRepositoryException>()),
          );
        },
      );
    });

    group('updateSolvedWordsCount', () {
      late CrosswordRepository repository;

      setUp(() {
        repository = CrosswordRepository(dbClient: dbClient);

        when(
          () => dbClient.update(
            sectionsCollection,
            any(),
          ),
        ).thenAnswer((_) async {});
      });

      test('updates the document in the database', () async {
        final record = _MockDbEntityRecord();
        when(() => record.id).thenReturn('id');
        when(() => record.data).thenReturn({'value': 80});
        when(
          () => dbClient.find('boardInfo', {'type': 'solved_words_count'}),
        ).thenAnswer((_) async => [record]);
        when(
          () => dbClient.update('boardInfo', any()),
        ).thenAnswer((_) async {});

        await repository.updateSolvedWordsCount();

        verify(
          () => dbClient.update(
            'boardInfo',
            DbEntityRecord(
              id: 'id',
              data: {'value': 81},
            ),
          ),
        ).called(1);
      });
    });
  });
}
