// ignore_for_file: prefer_const_constructors
import 'package:db_client/db_client.dart';
import 'package:dio/dio.dart';
import 'package:game_domain/game_domain.dart';
import 'package:hint_repository/hint_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

class _MockHttpClient extends Mock implements Dio {}

void main() {
  group('HintRepository', () {
    late DbClient dbClient;
    late Dio httpClient;
    late HintRepository hintRepository;

    setUpAll(() {
      registerFallbackValue(DbEntityRecord(id: ''));
      registerFallbackValue(Uri());
    });

    setUp(() {
      dbClient = _MockDbClient();
      httpClient = _MockHttpClient();
      hintRepository = HintRepository(
        dbClient: dbClient,
        httpClient: httpClient,
      );
    });

    test('can be instantiated', () {
      expect(
        HintRepository(
          dbClient: dbClient,
        ),
        isNotNull,
      );
    });

    group('isHintsEnabled', () {
      test('returns the value fetched from the database', () async {
        when(() => dbClient.findBy('boardInfo', 'type', 'is_hints_enabled'))
            .thenAnswer(
          (_) async => [
            DbEntityRecord(
              id: 'isHintsEnabled',
              data: const {
                'type': 'is_hints_enabled',
                'value': true,
              },
            ),
          ],
        );

        final isHintsEnabled = await hintRepository.isHintsEnabled();

        expect(isHintsEnabled, isTrue);
      });

      test('returns false when an error occurs', () async {
        when(() => dbClient.findBy('boardInfo', 'type', 'is_hints_enabled'))
            .thenThrow(Exception());

        final isHintsEnabled = await hintRepository.isHintsEnabled();

        expect(isHintsEnabled, isFalse);
      });
    });

    group('getMaxHints', () {
      test('returns the maximum hints allowed', () async {
        when(() => dbClient.findBy('boardInfo', 'type', 'max_hints'))
            .thenAnswer(
          (_) async => [
            DbEntityRecord(
              id: 'maxHints',
              data: const {
                'type': 'max_hints',
                'value': 5,
              },
            ),
          ],
        );

        final maxHints = await hintRepository.getMaxHints();

        expect(maxHints, 5);
      });

      test('returns the default maximum hints when an error occurs', () async {
        when(() => dbClient.findBy('boardInfo', 'type', 'max_hints'))
            .thenThrow(Exception());

        final maxHints = await hintRepository.getMaxHints();

        expect(maxHints, 10);
      });
    });

    group('generateHint', () {
      test('returns a hint when the response is parsed correctly', () async {
        when(
          () => httpClient.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            data: {
              'result': {'answer': 'yes'},
            },
          ),
        );
        final hint = await hintRepository.generateHint(
          wordAnswer: 'answer',
          question: 'question',
          previousHints: [
            Hint(
              question: 'is it?',
              response: HintResponse.no,
              readableResponse: 'Nope!',
            ),
          ],
          userToken: 'token',
        );

        expect(
          hint,
          isA<Hint>()
              .having(
                (hint) => hint.question,
                'the question field',
                'question',
              )
              .having(
                (hint) => hint.response,
                'the response field',
                HintResponse.yes,
              )
              .having(
                (hint) => hint.readableResponse,
                'the readableResponse field',
                isA<String>(),
              ),
        );
      });

      test(
        'returns a hint with notApplicable when the response is not parsed '
        'correctly',
        () async {
          when(
            () => httpClient.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(),
              data: {
                'result': {'answer': 'random things'},
              },
            ),
          );
          final hint = await hintRepository.generateHint(
            wordAnswer: 'answer',
            question: 'question',
            previousHints: [],
            userToken: 'token',
          );

          expect(
            hint,
            isA<Hint>()
                .having(
                  (hint) => hint.question,
                  'the question field',
                  'question',
                )
                .having(
                  (hint) => hint.response,
                  'the response field',
                  HintResponse.notApplicable,
                )
                .having(
                  (hint) => hint.readableResponse,
                  'the readableResponse field',
                  isA<String>(),
                ),
          );
        },
      );

      test('throws a HintException when an error occurs', () async {
        when(
          () => httpClient.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenThrow(Exception());
        expect(
          () => hintRepository.generateHint(
            wordAnswer: 'answer',
            question: 'question',
            previousHints: [],
            userToken: 'token',
          ),
          throwsA(isA<HintException>()),
        );
      });
    });

    group('getPreviousHints', () {
      test('returns an empty list when no hints are found', () async {
        when(() => dbClient.getById('answers/wordId/hints', 'userId'))
            .thenAnswer((_) async => null);

        final hints = await hintRepository.getPreviousHints(
          userId: 'userId',
          wordId: 'wordId',
        );

        expect(hints, isEmpty);
      });

      test('returns a list of hints', () async {
        when(() => dbClient.getById('answers/wordId/hints', 'userId'))
            .thenAnswer(
          (_) async => DbEntityRecord(
            id: 'userId',
            data: const {
              'hints': [
                {
                  'question': 'question',
                  'response': 'yes',
                  'readableResponse': 'Yes, that is correct!',
                },
              ],
            },
          ),
        );

        final hints = await hintRepository.getPreviousHints(
          userId: 'userId',
          wordId: 'wordId',
        );

        expect(hints, hasLength(1));
        expect(hints.first.question, 'question');
        expect(hints.first.response, HintResponse.yes);
      });

      test('throws a HintException when an error occurs', () async {
        when(() => dbClient.getById(any(), any())).thenThrow(Exception());

        expect(
          () => hintRepository.getPreviousHints(
            userId: 'userId',
            wordId: 'wordId',
          ),
          throwsA(isA<HintException>()),
        );
      });
    });

    group('saveHints', () {
      test('saves the hints', () async {
        when(() => dbClient.set(any(), any())).thenAnswer((_) async {});
        await hintRepository.saveHints(
          userId: 'userId',
          wordId: 'wordId',
          hints: [
            Hint(
              question: 'question',
              response: HintResponse.yes,
              readableResponse: 'Yeah!',
            ),
          ],
        );

        verify(
          () => dbClient.set(
            'answers/wordId/hints',
            DbEntityRecord(
              id: 'userId',
              data: const {
                'hints': [
                  {
                    'question': 'question',
                    'response': 'yes',
                    'readableResponse': 'Yeah!',
                  },
                ],
              },
            ),
          ),
        ).called(1);
      });

      test('throws a HintException when an error occurs', () async {
        when(() => dbClient.set(any(), any())).thenThrow(Exception());

        expect(
          () => hintRepository.saveHints(
            userId: 'userId',
            wordId: 'wordId',
            hints: [
              Hint(
                question: 'question',
                response: HintResponse.yes,
                readableResponse: 'Yeah!',
              ),
            ],
          ),
          throwsA(isA<HintException>()),
        );
      });
    });
  });
}
