// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

const _collection = 'leaderboard';

void main() {
  group('LeaderboardRepository', () {
    late FirebaseFirestore firestore;
    late LeaderboardRepository leaderboardRepository;

    setUp(() {
      firestore = _MockFirebaseFirestore();
      leaderboardRepository = LeaderboardRepository(
        firestore: firestore,
      );
    });

    test('can be instantiated', () {
      expect(LeaderboardRepository(firestore: firestore), isNotNull);
    });
  });
}
