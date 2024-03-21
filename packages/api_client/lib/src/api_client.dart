import 'dart:async';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:http/http.dart' as http;

/// {@template api_client}
/// Client to access the api.
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

  /// {@macro leaderboard_resource}
  late final LeaderboardResource leaderboardResource =
      LeaderboardResource(apiClient: this);

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
