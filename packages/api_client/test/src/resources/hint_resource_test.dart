// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockResponse extends Mock implements http.Response {}

void main() {
  group('HintResource', () {
    late ApiClient apiClient;
    late http.Response response;
    late HintResource resource;

    setUp(() {
      apiClient = _MockApiClient();
      response = _MockResponse();
      resource = HintResource(apiClient: apiClient);
    });

    group('generateHint', () {
      setUp(() {
        when(
          () => apiClient.post(any(), body: any(named: 'body')),
        ).thenAnswer((_) async => response);
      });

      test('calls correct api endpoint', () async {
        final hint = Hint(
          question: 'question',
          response: HintResponse.no,
        );
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          jsonEncode({
            'hint': hint.toJson(),
            'maxHints': 4,
          }),
        );

        await resource.generateHint(
          wordId: 'wordId',
          question: 'question',
        );

        verify(
          () => apiClient.post(
            '/game/hint',
            body: jsonEncode({
              'wordId': 'wordId',
              'question': 'question',
            }),
          ),
        ).called(1);
      });

      test('returns the hint and max hints when succeeds', () async {
        final hint = Hint(
          question: 'is it a question?',
          response: HintResponse.yes,
        );
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          jsonEncode({
            'hint': hint.toJson(),
            'maxHints': 4,
          }),
        );

        final result = await resource.generateHint(
          wordId: 'wordId',
          question: 'is it a question?',
        );

        expect(result.$1, equals(hint));
        expect(result.$2, equals(4));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          resource.generateHint(wordId: 'wordId', question: 'question'),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /game/hint returned status 500 with the following response: "Oops"',
              ),
            ),
          ),
        );
      });

      test('throws ApiClientError when response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body)
            .thenReturn('This is not a well formatted hint');

        await expectLater(
          resource.generateHint(wordId: 'wordId', question: 'question'),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /game/hint returned invalid response: '
                '"This is not a well formatted hint"',
              ),
            ),
          ),
        );
      });
    });

    group('getHints', () {
      setUp(() {
        when(
          () => apiClient.get(
            '/game/hint',
            queryParameters: {'wordId': 'wordId'},
          ),
        ).thenAnswer((_) async => response);
      });

      test('calls correct api endpoint', () async {
        final hint = Hint(
          question: 'question',
          response: HintResponse.no,
        );
        final hintList = [hint, hint, hint];
        final responseJson = {
          'hints': hintList.map((e) => e.toJson()).toList(),
          'maxHints': 8,
        };
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(responseJson));

        await resource.getHints(wordId: 'wordId');

        verify(
          () => apiClient.get(
            '/game/hint',
            queryParameters: {'wordId': 'wordId'},
          ),
        ).called(1);
      });

      test('returns the list of hints and max hints when succeeds', () async {
        final hint = Hint(
          question: 'question',
          response: HintResponse.no,
        );
        final hintList = [hint, hint, hint];
        final hintJson = {
          'hints': hintList.map((e) => e.toJson()).toList(),
          'maxHints': 8,
        };
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(hintJson));

        final result = await resource.getHints(wordId: 'wordId');

        expect(result.$1, equals(hintList));
        expect(result.$2, equals(8));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          resource.getHints(wordId: 'wordId'),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /game/hint returned status 500 with the following '
                'response: "Oops"',
              ),
            ),
          ),
        );
      });

      test('throws ApiClientError when response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body)
            .thenReturn('This is not a well formatted hint list');

        await expectLater(
          resource.getHints(wordId: 'wordId'),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET /game/hint returned invalid response: '
                '"This is not a well formatted hint list"',
              ),
            ),
          ),
        );
      });
    });
  });
}
