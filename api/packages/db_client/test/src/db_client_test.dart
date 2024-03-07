// ignore_for_file: prefer_const_constructors
import 'package:db_client/db_client.dart';
import 'package:firedart/firedart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockFirestore extends Mock implements Firestore {}

class _MockCollectionReference extends Mock implements CollectionReference {}

class _MockDocument extends Mock implements Document {}

class _MockDocumentReference extends Mock implements DocumentReference {}

class _MockQueryReference extends Mock implements QueryReference {}

class _MockPageDocument extends Mock implements Page<Document> {
  _MockPageDocument(this.elements);

  final List<Document> elements;

  @override
  Iterable<T> map<T>(T Function(Document element) f) {
    return elements.map(f);
  }
}

void main() {
  group('DbEntityRecord', () {
    test('supports equality', () {
      expect(
        DbEntityRecord(id: 'A', data: const {'name': 'dash'}),
        equals(DbEntityRecord(id: 'A', data: const {'name': 'dash'})),
      );

      expect(
        DbEntityRecord(id: 'A', data: const {'name': 'dash'}),
        isNot(equals(DbEntityRecord(id: 'B', data: const {'name': 'dash'}))),
      );

      expect(
        DbEntityRecord(id: 'A', data: const {'name': 'dash'}),
        isNot(equals(DbEntityRecord(id: 'A', data: const {'name': 'furn'}))),
      );
    });
  });

  group('DbClient', () {
    test('can be instantiated', () {
      expect(DbClient(firestore: _MockFirestore()), isNotNull);
    });

    test('can be initialized', () {
      expect(DbClient.initialize('A', useEmulator: true), isNotNull);
    });

    test('returns instance anyway if firestore is already initialized', () {
      expect(DbClient.initialize('A', useEmulator: true), isNotNull);
      expect(DbClient.initialize('A', useEmulator: true), isNotNull);
    });

    group('add', () {
      test('insert into firestore', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionReference();

        when(() => firestore.collection('birds')).thenReturn(collection);

        final document = _MockDocument();
        when(() => document.id).thenReturn('id');

        when(() => collection.add(any())).thenAnswer((_) async => document);

        final client = DbClient(firestore: firestore);
        final id = await client.add('birds', {'name': 'Dash'});

        expect(id, equals('id'));
        verify(() => collection.add({'name': 'Dash'})).called(1);
      });

      test('tries 3 times when getting a GrpcError before giving up', () async {
        final firestore = _MockFirestore();

        when(() => firestore.collection('birds')).thenThrow(
          GrpcError.invalidArgument(),
        );

        final client = DbClient(firestore: firestore);
        await expectLater(
          () => client.add('birds', {'name': 'Dash'}),
          throwsA(isA<GrpcError>()),
        );

        verify(() => firestore.collection('birds')).called(3);
      });
    });

    group('set', () {
      test('insert into firestore', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionReference();
        final ref = _MockDocumentReference();

        when(() => firestore.collection('birds')).thenReturn(collection);

        final document = _MockDocument();

        when(() => collection.document(any())).thenAnswer((_) => ref);
        when(() => ref.set(any())).thenAnswer((_) async => document);

        final client = DbClient(firestore: firestore);
        await client.set(
          'birds',
          DbEntityRecord(id: 'id', data: const {'name': 'Dash'}),
        );
        verify(() => firestore.collection('birds')).called(1);
        verify(() => collection.document('id')).called(1);
        verify(() => ref.set({'name': 'Dash'})).called(1);
      });

      test('tries 3 times when getting a GrpcError before giving up', () async {
        final firestore = _MockFirestore();
        when(() => firestore.collection('birds')).thenThrow(
          GrpcError.invalidArgument(),
        );

        final client = DbClient(firestore: firestore);
        await expectLater(
          () => client.set(
            'birds',
            DbEntityRecord(id: 'id', data: const {'name': 'Dash'}),
          ),
          throwsA(
            isA<GrpcError>(),
          ),
        );
        verify(() => firestore.collection('birds')).called(3);
      });
    });

    group('getById', () {
      test('gets an entity in firestore', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionReference();

        when(() => firestore.collection('birds')).thenReturn(collection);

        final documentReference = _MockDocumentReference();
        when(() => documentReference.exists).thenAnswer((_) async => true);

        final document = _MockDocument();
        when(() => document.id).thenReturn('id');
        when(() => document.map).thenReturn({'name': 'Dash'});

        when(() => collection.document('id')).thenReturn(documentReference);
        when(documentReference.get).thenAnswer((_) async => document);

        final client = DbClient(firestore: firestore);
        final record = await client.getById('birds', 'id');

        expect(record, isNotNull);
        expect(record!.id, equals('id'));
        expect(record.data['name'], equals('Dash'));
      });

      test('tries 3 times when getting a GrpcError before giving up', () async {
        final firestore = _MockFirestore();

        when(() => firestore.collection('birds')).thenThrow(
          GrpcError.invalidArgument(),
        );

        final client = DbClient(firestore: firestore);
        await expectLater(
          () => client.getById('birds', 'id'),
          throwsA(
            isA<GrpcError>(),
          ),
        );
        verify(() => firestore.collection('birds')).called(3);
      });

      test("returns null when the entity doesn't exists", () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionReference();

        when(() => firestore.collection('birds')).thenReturn(collection);

        final documentReference = _MockDocumentReference();
        when(() => documentReference.exists).thenAnswer((_) async => false);

        when(() => collection.document('id')).thenReturn(documentReference);

        final client = DbClient(firestore: firestore);
        final map = await client.getById('birds', 'id');

        expect(map, isNull);
      });
    });

    group('update', () {
      test('updates and entity ad firestore', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionReference();
        final reference = _MockDocumentReference();
        when(() => reference.update(any())).thenAnswer((_) async {});

        when(() => firestore.collection('birds')).thenReturn(collection);
        when(() => collection.document('1')).thenReturn(reference);

        final client = DbClient(firestore: firestore);
        await client.update(
          'birds',
          DbEntityRecord(
            id: '1',
            data: const {
              'name': 'Dash',
            },
          ),
        );

        verify(() => reference.update({'name': 'Dash'})).called(1);
      });

      test('tries 3 times when getting a GrpcError before giving up', () async {
        final firestore = _MockFirestore();

        when(() => firestore.collection('birds')).thenThrow(
          GrpcError.invalidArgument(),
        );

        final client = DbClient(firestore: firestore);
        await expectLater(
          () => client.update(
            'birds',
            DbEntityRecord(
              id: '1',
              data: const {
                'name': 'Dash',
              },
            ),
          ),
          throwsA(
            isA<GrpcError>(),
          ),
        );

        verify(() => firestore.collection('birds')).called(3);
      });
    });

    group('findBy', () {
      test('returns the found records', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionReference();
        when(() => firestore.collection('birds')).thenReturn(collection);

        final queryReference = _MockQueryReference();

        when(() => collection.where('type', isEqualTo: 'big'))
            .thenReturn(queryReference);

        when(queryReference.get).thenAnswer((_) async {
          final record1 = _MockDocument();
          when(() => record1.id).thenReturn('1');
          when(() => record1.map).thenReturn({
            'name': 'dash',
          });
          final record2 = _MockDocument();
          when(() => record2.id).thenReturn('2');
          when(() => record2.map).thenReturn({
            'name': 'furn',
          });

          return [
            record1,
            record2,
          ];
        });

        final client = DbClient(firestore: firestore);

        final result = await client.findBy('birds', 'type', 'big');

        expect(result.first.id, equals('1'));
        expect(result.first.data, equals({'name': 'dash'}));

        expect(result.last.id, equals('2'));
        expect(result.last.data, equals({'name': 'furn'}));
      });

      test('tries 3 times when getting a GrpcError before giving up', () async {
        final firestore = _MockFirestore();
        when(() => firestore.collection('birds')).thenThrow(
          GrpcError.invalidArgument(),
        );

        final client = DbClient(firestore: firestore);

        await expectLater(
          () => client.findBy('birds', 'type', 'big'),
          throwsA(
            isA<GrpcError>(),
          ),
        );

        verify(() => firestore.collection('birds')).called(3);
      });

      test('returns empty when no results are returned', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionReference();
        when(() => firestore.collection('birds')).thenReturn(collection);

        final queryReference = _MockQueryReference();

        when(() => collection.where('type', isEqualTo: 'big'))
            .thenReturn(queryReference);

        when(queryReference.get).thenAnswer((_) async => []);

        final client = DbClient(firestore: firestore);

        final result = await client.findBy('birds', 'type', 'big');
        expect(result, isEmpty);
      });
    });

    group('find', () {
      test('returns the found records', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionReference();
        when(() => firestore.collection('birds')).thenReturn(collection);

        final queryReference = _MockQueryReference();

        when(() => collection.where('type', isEqualTo: 'big'))
            .thenReturn(queryReference);
        when(() => queryReference.where('age', isEqualTo: 'old'))
            .thenReturn(queryReference);

        when(queryReference.get).thenAnswer((_) async {
          final record1 = _MockDocument();
          when(() => record1.id).thenReturn('1');
          when(() => record1.map).thenReturn({
            'name': 'dash',
          });
          final record2 = _MockDocument();
          when(() => record2.id).thenReturn('2');
          when(() => record2.map).thenReturn({
            'name': 'furn',
          });

          return [
            record1,
            record2,
          ];
        });

        final client = DbClient(firestore: firestore);

        final result = await client.find(
          'birds',
          {
            'type': 'big',
            'age': 'old',
          },
        );

        expect(result.first.id, equals('1'));
        expect(result.first.data, equals({'name': 'dash'}));

        expect(result.last.id, equals('2'));
        expect(result.last.data, equals({'name': 'furn'}));
      });

      test('tries 3 times when getting a GrpcError before giving up', () async {
        final firestore = _MockFirestore();
        when(() => firestore.collection('birds')).thenThrow(
          GrpcError.invalidArgument(),
        );

        final client = DbClient(firestore: firestore);

        await expectLater(
          () => client.find(
            'birds',
            {
              'type': 'big',
              'age': 'old',
            },
          ),
          throwsA(
            isA<GrpcError>(),
          ),
        );

        verify(() => firestore.collection('birds')).called(3);
      });

      test('returns empty when no results are returned', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionReference();
        when(() => firestore.collection('birds')).thenReturn(collection);

        final queryReference = _MockQueryReference();

        when(() => collection.where('type', isEqualTo: 'big'))
            .thenReturn(queryReference);
        when(() => queryReference.where('age', isEqualTo: 'old'))
            .thenReturn(queryReference);

        when(queryReference.get).thenAnswer((_) async => []);

        final client = DbClient(firestore: firestore);

        final result = await client.find(
          'birds',
          {
            'type': 'big',
            'age': 'old',
          },
        );
        expect(result, isEmpty);
      });
    });

    group('orderBy', () {
      test('returns the found records', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionReference();
        when(() => firestore.collection('birds')).thenReturn(collection);

        final queryReference = _MockQueryReference();

        when(() => collection.orderBy('score', descending: true))
            .thenReturn(queryReference);

        when(() => queryReference.limit(any())).thenReturn(queryReference);

        when(queryReference.get).thenAnswer((_) async {
          final record1 = _MockDocument();
          when(() => record1.id).thenReturn('1');
          when(() => record1.map).thenReturn({
            'score': 1,
          });
          final record2 = _MockDocument();
          when(() => record2.id).thenReturn('2');
          when(() => record2.map).thenReturn({
            'score': 2,
          });

          return [
            record1,
            record2,
          ];
        });

        final client = DbClient(firestore: firestore);

        final result = await client.orderBy('birds', 'score');

        expect(result.first.id, equals('1'));
        expect(result.first.data, equals({'score': 1}));

        expect(result.last.id, equals('2'));
        expect(result.last.data, equals({'score': 2}));
      });

      test('tries 3 times when getting a GrpcError before giving up', () async {
        final firestore = _MockFirestore();
        when(() => firestore.collection('birds')).thenThrow(
          GrpcError.invalidArgument(),
        );

        final client = DbClient(firestore: firestore);
        await expectLater(
          () => client.orderBy('birds', 'score'),
          throwsA(
            isA<GrpcError>(),
          ),
        );

        verify(() => firestore.collection('birds')).called(3);
      });

      test('returns empty when no results are returned', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionReference();
        when(() => firestore.collection('birds')).thenReturn(collection);

        final queryReference = _MockQueryReference();

        when(() => collection.orderBy('score', descending: true))
            .thenReturn(queryReference);

        when(() => queryReference.limit(any())).thenReturn(queryReference);
        when(queryReference.get).thenAnswer((_) async => []);

        final client = DbClient(firestore: firestore);

        final result = await client.orderBy('birds', 'score');
        expect(result, isEmpty);
      });
    });

    group('listAll', () {
      test('lists all of records of an entity', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionReference();
        when(() => firestore.collection('birds')).thenReturn(collection);

        final document1 = _MockDocument();
        when(() => document1.id).thenReturn('1');
        when(() => document1.map).thenReturn({'name': 'dash'});

        final document2 = _MockDocument();
        when(() => document2.id).thenReturn('2');
        when(() => document2.map).thenReturn({'name': 'furn'});

        final page = _MockPageDocument([document1, document2]);
        when(() => page.hasNextPage).thenReturn(false);
        when(() => page.length).thenReturn(2);
        when(() => page.isNotEmpty).thenReturn(true);

        when(collection.get).thenAnswer(
          (_) async => page,
        );

        final client = DbClient(firestore: firestore);
        final result = await client.listAll('birds');
        expect(result.length, equals(2));
        expect(result.first.id, equals('1'));
        expect(result.first.data, equals({'name': 'dash'}));
        expect(result.last.id, equals('2'));
        expect(result.last.data, equals({'name': 'furn'}));
      });

      test('lists all of records of an entity', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollectionReference();
        when(() => firestore.collection('birds')).thenReturn(collection);

        final document1 = _MockDocument();
        when(() => document1.id).thenReturn('1');
        when(() => document1.map).thenReturn({'name': 'dash'});

        final document2 = _MockDocument();
        when(() => document2.id).thenReturn('2');
        when(() => document2.map).thenReturn({'name': 'furn'});

        final page1 = _MockPageDocument([document1]);
        when(() => page1.hasNextPage).thenReturn(true);
        when(() => page1.nextPageToken).thenReturn('1');
        when(() => page1.length).thenReturn(1);
        when(() => page1.isNotEmpty).thenReturn(true);

        when(collection.get).thenAnswer(
          (_) async => page1,
        );

        final page2 = _MockPageDocument([document2]);
        when(() => page2.hasNextPage).thenReturn(false);
        when(() => page2.length).thenReturn(1);
        when(() => page2.isNotEmpty).thenReturn(true);

        when(() => collection.get(nextPageToken: '1')).thenAnswer(
          (_) async => page2,
        );

        final client = DbClient(firestore: firestore);
        final result = await client.listAll('birds');
        expect(result.length, equals(2));
        expect(result.first.id, equals('1'));
        expect(result.first.data, equals({'name': 'dash'}));
        expect(result.last.id, equals('2'));
        expect(result.last.data, equals({'name': 'furn'}));
      });
    });
  });
}
