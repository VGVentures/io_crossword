// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockResponse extends Mock implements http.Response {}

void main() {
  group('CrosswordResource', () {
    late ApiClient apiClient;
    late http.Response response;
    late CrosswordResource resource;

    setUp(() {
      apiClient = _MockApiClient();
      response = _MockResponse();

      resource = CrosswordResource(apiClient: apiClient);
    });

    group('answerWord', () {
      setUp(() {
        when(
          () => apiClient.post(any(), body: any(named: 'body')),
        ).thenAnswer((_) async => response);
      });

      test('calls correct api endpoint', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode({'points': 10}));

        await resource.answerWord(
          wordId: 'wordId',
          answer: 'correctAnswer',
        );

        verify(
          () => apiClient.post(
            '/game/answer',
            body: jsonEncode({
              'wordId': 'wordId',
              'answer': 'correctAnswer',
            }),
          ),
        ).called(1);
      });

      test('returns the points when succeeds with correct answer', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          jsonEncode({'points': 10}),
        );

        final result = await resource.answerWord(
          wordId: 'wordId',
          answer: 'correctAnswer',
        );
        expect(result, 10);
      });

      test('returns 0 points when succeeds with incorrect answer', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          jsonEncode({'points': 0}),
        );

        final result = await resource.answerWord(
          wordId: 'wordId',
          answer: 'incorrectAnswer',
        );
        expect(result, 0);
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          resource.answerWord(
            wordId: 'wordId',
            answer: 'incorrectAnswer',
          ),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /game/answer returned status 500 with the following response: "Oops"',
              ),
            ),
          ),
        );
      });

      test('throws ApiClientError when response is invalid', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          resource.answerWord(
            wordId: 'wordId',
            answer: 'incorrectAnswer',
          ),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /game/answer returned invalid response: "Oops"',
              ),
            ),
          ),
        );
      });
    });
  });
}
