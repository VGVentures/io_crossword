// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:api_client/src/resources/crossword_resource.dart';
import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockResponse extends Mock implements http.Response {}

class _FakeBoardSection extends Fake implements BoardSection {
  @override
  Point<int> get position => Point(0, 0);
}

class _FakeWord extends Fake implements Word {
  @override
  Point<int> get position => Point(0, 0);
}

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

      test('returns true when succeeds with correct answer', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          jsonEncode({'valid': true}),
        );

        final result = await resource.answerWord(
          section: _FakeBoardSection(),
          word: _FakeWord(),
          answer: 'correctAnswer',
        );
        expect(result, isTrue);
      });

      test('returns false when succeeds with incorrect answer', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(
          jsonEncode({'valid': false}),
        );

        final result = await resource.answerWord(
          section: _FakeBoardSection(),
          word: _FakeWord(),
          answer: 'incorrectAnswer',
        );
        expect(result, isFalse);
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Oops');

        await expectLater(
          resource.answerWord(
            section: _FakeBoardSection(),
            word: _FakeWord(),
            answer: 'incorrectAnswer',
          ),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /game/board/sections/{sectionId}/{wordPosition} returned status 500 with the following response: "Oops"',
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
            section: _FakeBoardSection(),
            word: _FakeWord(),
            answer: 'incorrectAnswer',
          ),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'POST /game/board/sections/{sectionId}/{wordPosition} returned invalid response: "Oops"',
              ),
            ),
          ),
        );
      });
    });
  });
}
