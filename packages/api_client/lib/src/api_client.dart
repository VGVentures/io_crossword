import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;

/// {@template api_client_error}
/// Error throw when accessing api failed.
///
/// Check [cause] and [stackTrace] for specific details.
/// {@endtemplate}
class ApiClientError implements Exception {
  /// {@macro api_client_error}
  ApiClientError(this.cause, this.stackTrace);

  /// Error cause.
  final dynamic cause;

  /// The stack trace of the error.
  final StackTrace stackTrace;

  @override
  String toString() {
    return cause.toString();
  }
}

/// Definition of a post call used by this client.
typedef PostCall = Future<http.Response> Function(
  Uri, {
  Object? body,
  Map<String, String>? headers,
});

/// Definition of a patch call used by this client.
typedef PatchCall = Future<http.Response> Function(
  Uri, {
  Object? body,
  Map<String, String>? headers,
});

/// Definition of a put call used by this client.
typedef PutCall = Future<http.Response> Function(
  Uri, {
  Object? body,
  Map<String, String>? headers,
});

/// Definition of a get call used by this client.
typedef GetCall = Future<http.Response> Function(
  Uri, {
  Map<String, String>? headers,
});

/// {@template api_client}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  ApiClient({
    required String baseUrl,
    required Stream<String?> idTokenStream,
    required Future<String?> Function() refreshIdToken,
    required Stream<String?> appCheckTokenStream,
    String? appCheckToken,
    PostCall postCall = http.post,
    PutCall putCall = http.put,
    PatchCall patchCall = http.patch,
    GetCall getCall = http.get,
  })  : _base = Uri.parse(baseUrl),
        _post = postCall,
        _put = putCall,
        _patch = patchCall,
        _get = getCall,
        _appCheckToken = appCheckToken,
        _refreshIdToken = refreshIdToken {
    _idTokenSubscription = idTokenStream.listen((idToken) {
      _idToken = idToken;
    });
    _appCheckTokenSubscription = appCheckTokenStream.listen((appCheckToken) {
      _appCheckToken = appCheckToken;
    });
  }

  final Uri _base;
  final PostCall _post;
  final PostCall _put;
  final PatchCall _patch;
  final GetCall _get;
  final Future<String?> Function() _refreshIdToken;

  late final StreamSubscription<String?> _idTokenSubscription;
  late final StreamSubscription<String?> _appCheckTokenSubscription;
  String? _idToken;
  String? _appCheckToken;

  Map<String, String> get _headers => {
        if (_idToken != null) 'Authorization': 'Bearer $_idToken',
        if (_appCheckToken != null) 'X-Firebase-AppCheck': _appCheckToken!,
      };

  Future<http.Response> _handleUnauthorized(
    Future<http.Response> Function() sendRequest,
  ) async {
    final response = await sendRequest();

    if (response.statusCode == HttpStatus.unauthorized) {
      _idToken = await _refreshIdToken();
      return sendRequest();
    }
    return response;
  }

  /// Dispose of resources used by this client.
  Future<void> dispose() async {
    await _idTokenSubscription.cancel();
    await _appCheckTokenSubscription.cancel();
  }

  /// Sends a POST request to the specified [path] with the given [body].
  Future<http.Response> post(
    String path, {
    Object? body,
    Map<String, String>? queryParameters,
  }) async {
    return _handleUnauthorized(() async {
      final response = await _post(
        _base.replace(
          path: path,
          queryParameters: queryParameters,
        ),
        body: body,
        headers: _headers..addContentTypeJson(),
      );

      return response.decrypted;
    });
  }

  /// Sends a PATCH request to the specified [path] with the given [body].
  Future<http.Response> patch(
    String path, {
    Object? body,
    Map<String, String>? queryParameters,
  }) async {
    return _handleUnauthorized(() async {
      final response = await _patch(
        _base.replace(
          path: path,
          queryParameters: queryParameters,
        ),
        body: body,
        headers: _headers..addContentTypeJson(),
      );

      return response.decrypted;
    });
  }

  /// Sends a PUT request to the specified [path] with the given [body].
  Future<http.Response> put(
    String path, {
    Object? body,
  }) async {
    return _handleUnauthorized(() async {
      final response = await _put(
        _base.replace(path: path),
        body: body,
        headers: _headers..addContentTypeJson(),
      );

      return response.decrypted;
    });
  }

  /// Sends a GET request to the specified [path].
  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    return _handleUnauthorized(() async {
      final response = await _get(
        _base.replace(
          path: path,
          queryParameters: queryParameters,
        ),
        headers: _headers,
      );

      return response.decrypted;
    });
  }

  /// Sends a GET request to the specified public [path].
  Future<http.Response> getPublic(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    return _handleUnauthorized(() async {
      final response = await _get(
        _base.replace(
          path: path,
          queryParameters: queryParameters,
        ),
        headers: _headers,
      );

      return response;
    });
  }
}

extension on http.Response {
  http.Response get decrypted {
    if (body.isEmpty) return this;

    final key = Key.fromUtf8(_encryptionKey);
    final iv = IV.fromUtf8(_encryptionIV);

    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter.decrypt64(body, iv: iv);

    return http.Response(
      jsonDecode(decrypted).toString(),
      statusCode,
      headers: headers,
      isRedirect: isRedirect,
      persistentConnection: persistentConnection,
      reasonPhrase: reasonPhrase,
      request: request,
    );
  }

  String get _encryptionKey {
    const value = String.fromEnvironment(
      'ENCRYPTION_KEY',
      // Default value is set at 32 characters to match required length of
      // AES key. The default value can then be used for testing purposes.
      defaultValue: 'encryption_key_not_set_123456789',
    );
    return value;
  }

  String get _encryptionIV {
    const value = String.fromEnvironment(
      'ENCRYPTION_IV',
      // Default value is set at 116 characters to match required length of
      // IV key. The default value can then be used for testing purposes.
      defaultValue: 'iv_not_set_12345',
    );
    return value;
  }
}

extension on Map<String, String> {
  void addContentTypeJson() {
    addAll({HttpHeaders.contentTypeHeader: ContentType.json.value});
  }
}
