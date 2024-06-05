// ignore_for_file: prefer_const_constructors, subtype_of_sealed_class

import 'dart:math';

import 'package:board_info_repository/board_info_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
        () => collection.where('type', isEqualTo: 'zoom_limit'),
      ).thenReturn(collection);
      when(
        () => collection.where('type', isEqualTo: 'section_size'),
      ).thenReturn(collection);
      when(
        () => collection.where('type', isEqualTo: 'bottom_right'),
      ).thenReturn(collection);

      when(collection.get).thenAnswer((_) async => query);
      when(collection.snapshots).thenAnswer((_) => Stream.value(query));
      when(() => query.docs).thenReturn([doc]);
      when(doc.data).thenReturn({'value': value});
    }

    void mockZoomLimit({dynamic mobile, dynamic desktop}) {
      final doc = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
      final query = _MockQuerySnapshot<Map<String, dynamic>>();
      when(
        () => collection.where('type', isEqualTo: 'zoom_limit'),
      ).thenReturn(collection);

      when(collection.get).thenAnswer((_) async => query);
      when(() => query.docs).thenReturn([doc]);
      when(doc.data).thenReturn({'mobile': mobile, 'desktop': desktop});
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
        final result = boardInfoRepository.getTotalWordsCount();
        expect(result, emits(123000));
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
        final result = boardInfoRepository.getSolvedWordsCount();
        expect(result, emits(66000));
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
      test('returns render limit for desktop from firebase', () async {
        final repository = BoardInfoRepository(
          firestore: firestore,
          targetPlatform: TargetPlatform.windows,
        );
        mockZoomLimit(mobile: 0.6, desktop: 0.2);

        final result = await repository.getZoomLimit();

        expect(result, equals(0.2));
      });

      test('returns render limit for mobile from firebase', () async {
        final repository = BoardInfoRepository(
          firestore: firestore,
          targetPlatform: TargetPlatform.iOS,
        );
        mockZoomLimit(mobile: 0.6, desktop: 0.2);

        final result = await repository.getZoomLimit();

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

    group('getBottomRight', () {
      test("returns bottom right section's position from firebase", () async {
        mockQueryResult('16,16');
        final result = await boardInfoRepository.getBottomRight();
        expect(result, equals(Point(16, 16)));
      });

      test('throws BoardInfoException when fetching the info fails', () {
        when(
          () => collection.where('type', isEqualTo: 'bottom_right'),
        ).thenThrow(Exception('oops'));
        expect(
          () => boardInfoRepository.getBottomRight(),
          throwsA(isA<BoardInfoException>()),
        );
      });
    });

    group('isHintsEnabled', () {
      test('returns hints enabled status from firebase', () {
        final doc = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
        final query = _MockQuerySnapshot<Map<String, dynamic>>();
        when(
          () => collection.where('type', isEqualTo: 'is_hints_enabled'),
        ).thenReturn(collection);
        when(collection.snapshots).thenAnswer((_) => Stream.value(query));
        when(() => query.docs).thenReturn([doc]);
        when(doc.data).thenReturn({'value': true});

        final result = boardInfoRepository.isHintsEnabled();
        expect(result, emits(true));
      });
    });

    group('getGameStatus', () {
      test('returns inProgress GameStatus from firebase', () async {
        final doc = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
        final query = _MockQuerySnapshot<Map<String, dynamic>>();
        when(
          () => collection.where('type', isEqualTo: 'game_status'),
        ).thenReturn(collection);
        when(collection.snapshots).thenAnswer((_) => Stream.value(query));
        when(() => query.docs).thenReturn([doc]);
        when(doc.data).thenReturn({'value': 'in_progress'});

        final result = boardInfoRepository.getGameStatus();
        expect(result, emits(GameStatus.inProgress));
      });

      test('returns resetInProgress GameStatus from firebase', () async {
        final doc = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
        final query = _MockQuerySnapshot<Map<String, dynamic>>();
        when(
          () => collection.where('type', isEqualTo: 'game_status'),
        ).thenReturn(collection);
        when(collection.snapshots).thenAnswer((_) => Stream.value(query));
        when(() => query.docs).thenReturn([doc]);
        when(doc.data).thenReturn({'value': 'reset_in_progress'});

        final result = boardInfoRepository.getGameStatus();
        expect(result, emits(GameStatus.resetInProgress));
      });

      test(
          'returns inProgress GameStatus from firebase '
          'when status is unknown', () async {
        final doc = _MockQueryDocumentSnapshot<Map<String, dynamic>>();
        final query = _MockQuerySnapshot<Map<String, dynamic>>();
        when(
          () => collection.where('type', isEqualTo: 'game_status'),
        ).thenReturn(collection);
        when(collection.snapshots).thenAnswer((_) => Stream.value(query));
        when(() => query.docs).thenReturn([doc]);
        when(doc.data).thenReturn({'value': 'unknown'});

        final result = boardInfoRepository.getGameStatus();
        expect(result, emits(GameStatus.inProgress));
      });

      test('throws BoardInfoException when fetching the info fails', () {
        when(
          () => collection.where('type', isEqualTo: 'game_status'),
        ).thenThrow(Exception('oops'));

        expect(
          () => boardInfoRepository.getGameStatus(),
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
