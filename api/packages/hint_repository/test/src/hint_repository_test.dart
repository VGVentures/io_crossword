// ignore_for_file: prefer_const_constructors
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:hint_repository/hint_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

class _MockGenerativeModelWrapper extends Mock
    implements GenerativeModelWrapper {}

void main() {
  group('HintRepository', () {
    late DbClient dbClient;
    late GenerativeModelWrapper generativeModelWrapper;
    late HintRepository hintRepository;

    setUpAll(() {
      registerFallbackValue(DbEntityRecord(id: ''));
    });

    setUp(() {
      dbClient = _MockDbClient();
      generativeModelWrapper = _MockGenerativeModelWrapper();
      hintRepository = HintRepository(
        dbClient: dbClient,
        generativeModelWrapper: generativeModelWrapper,
      );
    });

    test('can be instantiated', () {
      expect(
        HintRepository(
          dbClient: dbClient,
          generativeModelWrapper: generativeModelWrapper,
        ),
        isNotNull,
      );
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
        when(() => generativeModelWrapper.generateTextContent(any()))
            .thenAnswer((_) async => 'yes');
        final hint = await hintRepository.generateHint(
          wordAnswer: 'answer',
          question: 'question',
          previousHints: [Hint(question: 'is it?', response: HintResponse.no)],
        );

        expect(
          hint,
          equals(Hint(question: 'question', response: HintResponse.yes)),
        );
      });

      test(
        'returns a hint with notApplicable when the response is not parsed '
        'correctly',
        () async {
          when(() => generativeModelWrapper.generateTextContent(any()))
              .thenAnswer((_) async => 'bla bla bla');
          final hint = await hintRepository.generateHint(
            wordAnswer: 'answer',
            question: 'question',
            previousHints: [],
          );

          expect(
            hint,
            equals(
              Hint(
                question: 'question',
                response: HintResponse.notApplicable,
              ),
            ),
          );
        },
      );

      test('throws a HintException when an error occurs', () async {
        when(() => generativeModelWrapper.generateTextContent(any()))
            .thenThrow(Exception());

        expect(
          () => hintRepository.generateHint(
            wordAnswer: 'answer',
            question: 'question',
            previousHints: [],
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
            Hint(question: 'question', response: HintResponse.yes),
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
              ),
            ],
          ),
          throwsA(isA<HintException>()),
        );
      });
    });
  });
}
