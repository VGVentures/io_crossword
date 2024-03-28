// ignore_for_file: prefer_const_constructors, subtype_of_sealed_class

import 'package:board_info_repository/board_info_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class _MockCollectionReference<T> extends Mock
    implements CollectionReference<T> {}

class _MockQuerySnapshot<T> extends Mock implements QuerySnapshot<T> {}

class _MockQueryDocumentSnapshot<T> extends Mock
    implements QueryDocumentSnapshot<T> {}

void main() {
  group('BoardInfoRepository', () {
    late _MockFirebaseFirestore firestore;
    late CollectionReference<Map<String, dynamic>> collection;
    late BoardInfoRepository boardInfoRepository;

    setUp(() {
      firestore = _MockFirebaseFirestore();
      collection = _MockCollectionReference();

      when(() => firestore.collection('boardInfo')).thenReturn(collection);

      boardInfoRepository = BoardInfoRepository(firestore: firestore);
    });

    void mockQueryResult(dynamic value) {
      final doc = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
      final query = _MockQuerySnapshot<Map<String, dynamic>>();
      when(
        () => collection.where('type', isEqualTo: 'total_words_count'),
      ).thenReturn(collection);
      when(
        () => collection.where('type', isEqualTo: 'solved_words_count'),
      ).thenReturn(collection);
      when(
        () => collection.where('type', isEqualTo: 'render_mode_limit'),
      ).thenReturn(collection);
      when(
        () => collection.where('type', isEqualTo: 'section_size'),
      ).thenReturn(collection);

      when(collection.get).thenAnswer((_) async => query);
      when(() => query.docs).thenReturn([doc]);
      when(doc.data).thenReturn({'value': value});
    }

    test('can be instantiated', () {
      expect(
        BoardInfoRepository(firestore: firestore),
        isNotNull,
      );
    });

    group('getTotalWordsCount', () {
      test('returns total words count from firebase', () async {
        mockQueryResult(123000);
        final result = await boardInfoRepository.getTotalWordsCount();
        expect(result, equals(123000));
      });

      test('throws BoardInfoException when fetching the info fails', () {
        when(
          () => collection.where('type', isEqualTo: 'total_words_count'),
        ).thenThrow(Exception('oops'));
        expect(
          () => boardInfoRepository.getTotalWordsCount(),
          throwsA(isA<BoardInfoException>()),
        );
      });
    });

    group('getSolvedWordsCount', () {
      test('returns solved words count from firebase', () async {
        mockQueryResult(66000);
        final result = await boardInfoRepository.getSolvedWordsCount();
        expect(result, equals(66000));
      });

      test('throws BoardInfoException when fetching the info fails', () {
        when(
          () => collection.where('type', isEqualTo: 'solved_words_count'),
        ).thenThrow(Exception('oops'));
        expect(
          () => boardInfoRepository.getSolvedWordsCount(),
          throwsA(isA<BoardInfoException>()),
        );
      });
    });

    group('getSectionSize', () {
      test('returns the section size value from firebase', () async {
        mockQueryResult(20);
        final result = await boardInfoRepository.getSectionSize();
        expect(result, equals(20));
      });

      test('throws BoardInfoException when fetching the info fails', () {
        when(
          () => collection.where('type', isEqualTo: 'section_size'),
        ).thenThrow(Exception('oops'));
        expect(
          () => boardInfoRepository.getSectionSize(),
          throwsA(isA<BoardInfoException>()),
        );
      });
    });

    group('getZoomLimit', () {
      test('returns render mode limit from firebase', () async {
        mockQueryResult(0.6);
        final result = await boardInfoRepository.getZoomLimit();
        expect(result, equals(0.6));
      });

      test('throws BoardInfoException when fetching the info fails', () {
        when(
          () => collection.where('type', isEqualTo: 'zoom_limit'),
        ).thenThrow(Exception('oops'));
        expect(
          () => boardInfoRepository.getZoomLimit(),
          throwsA(isA<BoardInfoException>()),
        );
      });
    });
  });

  group('BoardInfoException', () {
    test('can be instantiated', () {
      expect(
        BoardInfoException(Exception('oops'), StackTrace.empty),
        isNotNull,
      );
    });

    test('has a string representation', () {
      final exception = BoardInfoException(Exception('oops'), StackTrace.empty);
      expect(exception.toString(), equals('Exception: oops'));
    });
  });
}
