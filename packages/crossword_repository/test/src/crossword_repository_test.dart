// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockHttpClient extends Mock {
  Future<http.Response> get(Uri uri, {Map<String, String>? headers});
}

void main() {
  group('CrosswordRepository', () {
    final word = Word(
      position: Point(0, 1),
      axis: Axis.horizontal,
      answer: 'answer',
      clue: 'clue',
      hints: const ['hint'],
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
    const sectionsCollection = 'boardSections';

    late FirebaseFirestore firebaseFirestore;
    late CrosswordRepository crosswordRepository;
    late _MockHttpClient httpClient;

    setUpAll(() {
      registerFallbackValue(Uri.parse('http://localhost'));
    });

    setUp(() async {
      httpClient = _MockHttpClient();
      firebaseFirestore = FakeFirebaseFirestore();
      crosswordRepository = CrosswordRepository(
        db: firebaseFirestore,
        getCall: httpClient.get,
      );

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

    group('watchSection', () {
      test('returns the requested section', () async {
        expect(
          crosswordRepository.watchSection('id'),
          emits(boardSection1),
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

    group('fetchSectionSnapshotBytes', () {
      test('returns response as UInt8List', () async {
        final response = http.Response('image', 200);
        when(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => response);
        expect(
          await crosswordRepository.fetchSectionSnapshotBytes('url'),
          equals(response.bodyBytes),
        );
      });
    });
  });
}
