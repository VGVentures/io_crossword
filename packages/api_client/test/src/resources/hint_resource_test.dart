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

    group('getHint', () {
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
        when(() => response.body).thenReturn(jsonEncode(hint.toJson()));

        await resource.getHint(
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

      test('returns the hint when succeeds ', () async {
        final hint = Hint(
          question: 'is it a question?',
          response: HintResponse.yes,
        );
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(hint.toJson()));

        final result = await resource.getHint(
          wordId: 'wordId',
          question: 'is it a question?',
        );

        expect(result, equals(hint));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          resource.getHint(wordId: 'wordId', question: 'question'),
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
          resource.getHint(wordId: 'wordId', question: 'question'),
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
  });
}
