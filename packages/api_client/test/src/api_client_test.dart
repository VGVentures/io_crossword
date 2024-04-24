// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockHttpClient extends Mock {
  Future<http.Response> get(Uri uri, {Map<String, String>? headers});
  Future<http.Response> post(
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  });
  Future<http.Response> patch(
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  });
  Future<http.Response> put(
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  });
}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('http://localhost'));
  });

  group('ApiClient', () {
    const baseUrl = 'http://baseurl.com';
    const mockIdToken = 'mockIdToken';
    const mockNewIdToken = 'mockNewIdToken';
    const mockAppCheckToken = 'mockAppCheckToken';

    final testJson = {'data': 'test'};

    final defaultResponse = http.Response(jsonEncode(testJson), 200);
    final expectedResponse = http.Response(jsonEncode(testJson), 200);

    late ApiClient subject;
    late _MockHttpClient httpClient;
    late StreamController<String?> idTokenStreamController;
    late StreamController<String?> appCheckTokenStreamController;

    Future<String?> Function() refreshIdToken = () async => null;

    setUp(() {
      httpClient = _MockHttpClient();

      when(
        () => httpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => defaultResponse);

      when(
        () => httpClient.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => defaultResponse);

      when(
        () => httpClient.patch(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => defaultResponse);

      when(
        () => httpClient.put(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => defaultResponse);

      idTokenStreamController = StreamController.broadcast();
      appCheckTokenStreamController = StreamController.broadcast();

      subject = ApiClient(
        baseUrl: baseUrl,
        getCall: httpClient.get,
        postCall: httpClient.post,
        patchCall: httpClient.patch,
        putCall: httpClient.put,
        idTokenStream: idTokenStreamController.stream,
        refreshIdToken: () => refreshIdToken(),
        appCheckTokenStream: appCheckTokenStreamController.stream,
      );
    });

    test('can be instantiated', () {
      expect(
        ApiClient(
          baseUrl: 'http://localhost',
          idTokenStream: Stream.empty(),
          refreshIdToken: () async => null,
          appCheckTokenStream: Stream.empty(),
        ),
        isNotNull,
      );
    });

    group('dispose', () {
      test('cancels id token stream subscription', () async {
        expect(idTokenStreamController.hasListener, isTrue);
        expect(appCheckTokenStreamController.hasListener, isTrue);

        await subject.dispose();

        expect(idTokenStreamController.hasListener, isFalse);
        expect(appCheckTokenStreamController.hasListener, isFalse);
      });
    });

    group('shareScoreUrl', () {
      test('returns the correct url', () {
        expect(
          subject.shareScoreUrl('id'),
          equals('http://baseurl.com/public/share/score?userId=id'),
        );
      });
    });

    group('shareScoreUrl', () {
      test('returns the correct url', () {
        expect(
          subject.shareWordUrl('id', 'wordId'),
          equals(
            'http://baseurl.com/public/share/word?sectionId=id&wordId=wordId',
          ),
        );
      });
    });

    group('get', () {
      test('returns the response', () async {
        final response = await subject.get('/');

        expect(response.statusCode, equals(expectedResponse.statusCode));
        expect(response.body, equals(expectedResponse.body));
      });

      test('sends the request correctly', () async {
        await subject.get(
          '/path/to/endpoint',
          queryParameters: {
            'param1': 'value1',
            'param2': 'value2',
          },
        );

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/path/to/endpoint?param1=value1&param2=value2'),
            headers: {},
          ),
        ).called(1);
      });

      test('sends the authentication and app check token', () async {
        idTokenStreamController.add(mockIdToken);
        appCheckTokenStreamController.add(mockAppCheckToken);
        await Future.microtask(() {});
        await subject.get('/path/to/endpoint');

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
            },
          ),
        ).called(1);
      });

      test('refreshes the authentication token when needed', () async {
        when(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response('', 401));

        refreshIdToken = () async => mockNewIdToken;

        idTokenStreamController.add(mockIdToken);
        appCheckTokenStreamController.add(mockAppCheckToken);
        await Future.microtask(() {});
        await subject.get('/path/to/endpoint');

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
            },
          ),
        ).called(1);
        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockNewIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
            },
          ),
        ).called(1);
      });
    });

    group('getPublic', () {
      setUp(() {
        when(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => expectedResponse);
      });
      test('returns the response', () async {
        final response = await subject.getPublic('/');

        expect(response.statusCode, equals(expectedResponse.statusCode));
        expect(response.body, equals(expectedResponse.body));
      });

      test('sends the request correctly', () async {
        await subject.getPublic(
          '/path/to/endpoint',
          queryParameters: {
            'param1': 'value1',
            'param2': 'value2',
          },
        );

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/path/to/endpoint?param1=value1&param2=value2'),
            headers: {},
          ),
        ).called(1);
      });

      test('sends the authentication and app check token', () async {
        idTokenStreamController.add(mockIdToken);
        appCheckTokenStreamController.add(mockAppCheckToken);
        await Future.microtask(() {});
        await subject.getPublic('/path/to/endpoint');

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
            },
          ),
        ).called(1);
      });

      test('refreshes the authentication token when needed', () async {
        when(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response('', 401));

        refreshIdToken = () async => mockNewIdToken;

        idTokenStreamController.add(mockIdToken);
        appCheckTokenStreamController.add(mockAppCheckToken);
        await Future.microtask(() {});
        await subject.getPublic('/path/to/endpoint');

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
            },
          ),
        ).called(1);
        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockNewIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
            },
          ),
        ).called(1);
      });
    });

    group('post', () {
      test('returns the response', () async {
        final response = await subject.post('/');

        expect(response.statusCode, equals(expectedResponse.statusCode));
        expect(response.body, equals(expectedResponse.body));
      });

      test('sends the request correctly', () async {
        await subject.post(
          '/path/to/endpoint',
          queryParameters: {'param1': 'value1', 'param2': 'value2'},
          body: 'BODY_CONTENT',
        );

        verify(
          () => httpClient.post(
            Uri.parse('$baseUrl/path/to/endpoint?param1=value1&param2=value2'),
            body: 'BODY_CONTENT',
            headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
          ),
        ).called(1);
      });

      test('sends the authentication and app check token', () async {
        idTokenStreamController.add(mockIdToken);
        appCheckTokenStreamController.add(mockAppCheckToken);
        await Future.microtask(() {});
        await subject.post('/path/to/endpoint');

        verify(
          () => httpClient.post(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
              HttpHeaders.contentTypeHeader: ContentType.json.value,
            },
          ),
        ).called(1);
      });

      test('refreshes the authentication token when needed', () async {
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response('', 401));

        refreshIdToken = () async => mockNewIdToken;

        idTokenStreamController.add(mockIdToken);
        appCheckTokenStreamController.add(mockAppCheckToken);
        await Future.microtask(() {});
        await subject.post('/path/to/endpoint');

        verify(
          () => httpClient.post(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
              HttpHeaders.contentTypeHeader: ContentType.json.value,
            },
          ),
        ).called(1);
        verify(
          () => httpClient.post(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockNewIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
              HttpHeaders.contentTypeHeader: ContentType.json.value,
            },
          ),
        ).called(1);
      });
    });

    group('patch', () {
      test('returns the response', () async {
        final response = await subject.patch('/');

        expect(response.statusCode, equals(expectedResponse.statusCode));
        expect(response.body, equals(expectedResponse.body));
      });

      test('sends the request correctly', () async {
        await subject.patch(
          '/path/to/endpoint',
          queryParameters: {'param1': 'value1', 'param2': 'value2'},
          body: 'BODY_CONTENT',
        );

        verify(
          () => httpClient.patch(
            Uri.parse('$baseUrl/path/to/endpoint?param1=value1&param2=value2'),
            body: 'BODY_CONTENT',
            headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
          ),
        ).called(1);
      });

      test('sends the authentication and app check token', () async {
        idTokenStreamController.add(mockIdToken);
        appCheckTokenStreamController.add(mockAppCheckToken);
        await Future.microtask(() {});
        await subject.patch('/path/to/endpoint');

        verify(
          () => httpClient.patch(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
              HttpHeaders.contentTypeHeader: ContentType.json.value,
            },
          ),
        ).called(1);
      });

      test('refreshes the authentication token when needed', () async {
        when(
          () => httpClient.patch(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response('', 401));

        refreshIdToken = () async => mockNewIdToken;

        idTokenStreamController.add(mockIdToken);
        appCheckTokenStreamController.add(mockAppCheckToken);
        await Future.microtask(() {});
        await subject.patch('/path/to/endpoint');

        verify(
          () => httpClient.patch(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
              HttpHeaders.contentTypeHeader: ContentType.json.value,
            },
          ),
        ).called(1);
        verify(
          () => httpClient.patch(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockNewIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
              HttpHeaders.contentTypeHeader: ContentType.json.value,
            },
          ),
        ).called(1);
      });
    });

    group('put', () {
      test('returns the response', () async {
        final response = await subject.put('/');

        expect(response.statusCode, equals(expectedResponse.statusCode));
        expect(response.body, equals(expectedResponse.body));
      });

      test('sends the request correctly', () async {
        await subject.put(
          '/path/to/endpoint',
          body: 'BODY_CONTENT',
        );

        verify(
          () => httpClient.put(
            Uri.parse('$baseUrl/path/to/endpoint'),
            body: 'BODY_CONTENT',
            headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
          ),
        ).called(1);
      });

      test('sends the authentication and app check token', () async {
        idTokenStreamController.add(mockIdToken);
        appCheckTokenStreamController.add(mockAppCheckToken);
        await Future.microtask(() {});
        await subject.put('/path/to/endpoint');

        verify(
          () => httpClient.put(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
              HttpHeaders.contentTypeHeader: ContentType.json.value,
            },
          ),
        ).called(1);
      });

      test('refreshes the authentication token when needed', () async {
        when(
          () => httpClient.put(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response('', 401));

        refreshIdToken = () async => mockNewIdToken;

        idTokenStreamController.add(mockIdToken);
        appCheckTokenStreamController.add(mockAppCheckToken);
        await Future.microtask(() {});
        await subject.put('/path/to/endpoint');

        verify(
          () => httpClient.put(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
              HttpHeaders.contentTypeHeader: ContentType.json.value,
            },
          ),
        ).called(1);
        verify(
          () => httpClient.put(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockNewIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
              HttpHeaders.contentTypeHeader: ContentType.json.value,
            },
          ),
        ).called(1);
      });
    });
  });
}
