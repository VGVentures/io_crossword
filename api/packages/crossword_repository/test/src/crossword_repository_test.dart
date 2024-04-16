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
        answer: 'flutter',
        length: 7,
        clue: '',
      );

      setUp(() {
        final record = _MockDbEntityRecord();
        when(() => record.id).thenReturn('id');
        when(() => record.data).thenReturn(
          {
            'position': {'x': 1, 'y': 1},
            'size': 300,
            'words': [
              {'id': '1', ...word.toJson()},
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

        when(
          () => dbClient.update(
            sectionsCollection,
            any(that: isA<DbEntityRecord>()),
          ),
        ).thenAnswer((_) async {});

        final answersRecord = _MockDbEntityRecord();
        when(() => answersRecord.id).thenReturn('id1');
        when(() => answersRecord.data).thenReturn({'answer': 'flutter'});
        when(
          () => dbClient.getById(answersCollection, 'id1'),
        ).thenAnswer((_) async => answersRecord);

        repository = CrosswordRepository(dbClient: dbClient);
      });

      test('answerWord returns true if answer is correct', () async {
        final time = DateTime.now();
        final clock = Clock.fixed(time);
        await withClock(clock, () async {
          final valid =
              await repository.answerWord(1, 1, '1', Mascots.dino, 'flutter');
          expect(valid, isTrue);
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
              'words': [
                word
                    .copyWith(
                      solvedTimestamp: time.millisecondsSinceEpoch,
                      mascot: Mascots.dino,
                    )
                    .toJson(),
              ],
              'borderWords': <String>[],
              'snapshotUrl': null,
            },
          );
        });
      });

      test('answerWord returns false if answer is incorrect', () async {
        final valid =
            await repository.answerWord(1, 1, '1', Mascots.dino, 'android');
        expect(valid, isFalse);
      });

      test('answerWord returns false if section does not exist', () async {
        when(
          () => dbClient.find(
            sectionsCollection,
            {'position.x': 0, 'position.y': 0},
          ),
        ).thenAnswer((_) async => []);

        final valid =
            await repository.answerWord(0, 0, '1', Mascots.dino, 'flutter');
        expect(valid, isFalse);
      });

      test('answerWord returns false if word is not in section', () async {
        final valid =
            await repository.answerWord(1, 1, 'fake', Mascots.dino, 'flutter');
        expect(valid, isFalse);
      });
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
