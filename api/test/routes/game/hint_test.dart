// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:hint_repository/hint_repository.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:mocktail/mocktail.dart' hide Answer;
import 'package:test/test.dart';

import '../../../routes/game/hint.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockHintRepository extends Mock implements HintRepository {}

class _MockUri extends Mock implements Uri {}

void main() {
  group('/game/hint', () {
    late RequestContext requestContext;
    late Request request;
    late CrosswordRepository crosswordRepository;
    late HintRepository hintRepository;
    late AuthenticatedUser user;

    setUp(() {
      requestContext = _MockRequestContext();
      request = _MockRequest();
      crosswordRepository = _MockCrosswordRepository();
      hintRepository = _MockHintRepository();
      user = AuthenticatedUser('userId');

      when(() => requestContext.request).thenReturn(request);
      when(() => requestContext.read<CrosswordRepository>())
          .thenReturn(crosswordRepository);
      when(() => requestContext.read<HintRepository>())
          .thenReturn(hintRepository);
      when(() => requestContext.read<AuthenticatedUser>()).thenReturn(user);
    });

    group('other http methods', () {
      const allowedMethods = [HttpMethod.post, HttpMethod.get];
      final notAllowedMethods = HttpMethod.values.where(
        (e) => !allowedMethods.contains(e),
      );

      for (final method in notAllowedMethods) {
        test('are not allowed: $method', () async {
          when(() => request.method).thenReturn(method);
          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.methodNotAllowed);
        });
      }
    });

    group('POST', () {
      setUp(() {
        when(() => request.method).thenReturn(HttpMethod.post);
      });

      test(
        'returns Response with a hint and saves it to the hint repository',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {'wordId': 'wordId', 'question': 'question'},
          );
          when(
            () => crosswordRepository.findAnswerById('wordId'),
          ).thenAnswer(
            (_) async {
              return Answer(
                id: 'wordId',
                answer: 'answer',
                section: Point(1, 1),
              );
            },
          );
          when(
            () => hintRepository.getPreviousHints(
              userId: 'userId',
              wordId: 'wordId',
            ),
          ).thenAnswer((_) async => []);
          when(
            () => hintRepository.generateHint(
              wordAnswer: 'answer',
              question: 'question',
              previousHints: [],
            ),
          ).thenAnswer(
            (_) async => Hint(question: 'question', response: HintResponse.no),
          );
          when(
            () => hintRepository.saveHints(
              userId: 'userId',
              wordId: 'wordId',
              hints: [Hint(question: 'question', response: HintResponse.no)],
            ),
          ).thenAnswer((_) async {});

          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.ok);
          expect(
            await response.json(),
            equals({'question': 'question', 'response': 'no'}),
          );
          verify(
            () => hintRepository.saveHints(
              userId: 'userId',
              wordId: 'wordId',
              hints: [Hint(question: 'question', response: HintResponse.no)],
            ),
          ).called(1);
        },
      );

      test(
        'returns internal server error response when generating hint fails',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {'wordId': 'wordId', 'question': 'question'},
          );
          when(
            () => crosswordRepository.findAnswerById('wordId'),
          ).thenAnswer(
            (_) async {
              return Answer(
                id: 'wordId',
                answer: 'answer',
                section: Point(1, 1),
              );
            },
          );
          when(
            () => hintRepository.getPreviousHints(
              userId: 'userId',
              wordId: 'wordId',
            ),
          ).thenAnswer((_) async => []);
          when(
            () => hintRepository.generateHint(
              wordAnswer: 'answer',
              question: 'question',
              previousHints: [],
            ),
          ).thenThrow(HintException('Oops', StackTrace.empty));

          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.internalServerError);
          expect(await response.body(), contains('Oops'));
        },
      );

      test(
        'returns forbidden response when max hints reached for word',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {'wordId': 'wordId', 'question': 'question'},
          );
          when(
            () => crosswordRepository.findAnswerById('wordId'),
          ).thenAnswer(
            (_) async {
              return Answer(
                id: 'wordId',
                answer: 'answer',
                section: Point(1, 1),
              );
            },
          );
          final hint = Hint(question: 'question', response: HintResponse.yes);
          when(
            () => hintRepository.getPreviousHints(
              userId: 'userId',
              wordId: 'wordId',
            ),
          ).thenAnswer((_) async => List.filled(10, hint));

          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.forbidden);
          expect(
            await response.body(),
            equals('Max hints reached for word wordId'),
          );
        },
      );

      test(
        'returns not found response when word not found for id',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {'wordId': 'wordId', 'question': 'question'},
          );
          when(
            () => crosswordRepository.findAnswerById('wordId'),
          ).thenAnswer((_) async => null);

          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.notFound);
          expect(
            await response.body(),
            equals('Word not found for id wordId'),
          );
        },
      );

      test(
        'returns bad request response when word id not provided',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {'question': 'question'},
          );

          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.badRequest);
        },
      );

      test(
        'returns bad request response when question not provided',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {'wordId': 'theWordId'},
          );

          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.badRequest);
        },
      );
    });

    group('GET', () {
      late Uri uri;

      setUp(() {
        uri = _MockUri();
        when(() => request.method).thenReturn(HttpMethod.get);
        when(() => request.uri).thenReturn(uri);
      });

      test(
        'returns Response with a list of hints',
        () async {
          final hintList = [
            Hint(question: 'question1', response: HintResponse.yes),
            Hint(question: 'question2', response: HintResponse.notApplicable),
            Hint(question: 'question3', response: HintResponse.no),
          ];
          when(() => uri.queryParameters).thenReturn({'wordId': 'wordId'});
          when(
            () => hintRepository.getPreviousHints(
              userId: 'userId',
              wordId: 'wordId',
            ),
          ).thenAnswer((_) async => hintList);

          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.ok);
          expect(
            await response.json(),
            equals({
              'hints': [
                {'question': 'question1', 'response': 'yes'},
                {'question': 'question2', 'response': 'notApplicable'},
                {'question': 'question3', 'response': 'no'},
              ],
            }),
          );
        },
      );

      test(
        'returns internal server error response when getting hints fails',
        () async {
          when(() => uri.queryParameters).thenReturn({'wordId': 'wordId'});
          when(
            () => hintRepository.getPreviousHints(
              userId: 'userId',
              wordId: 'wordId',
            ),
          ).thenThrow(HintException('Oops', StackTrace.empty));

          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.internalServerError);
          expect(await response.body(), contains('Oops'));
        },
      );

      test(
        'returns bad request response when word id not provided',
        () async {
          when(() => uri.queryParameters).thenReturn({});

          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.badRequest);
        },
      );
    });
  });
}
