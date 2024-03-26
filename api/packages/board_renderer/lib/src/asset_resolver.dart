import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// {@template asset_resolution_failure}
/// Exception thrown when a board rendering fails.
/// {@endtemplate}
class AssetResolutionFailure implements Exception {
  /// {@macro asset_resolution_failure}
  const AssetResolutionFailure(this.message);

  /// Message describing the failure.
  final String message;

  @override
  String toString() => '[AssetResolutionFailure]: $message';
}

/// {@template asset_resolver}
/// Resolves assets for the board renderer.
/// {@endtemplate}
mixin AssetResolver {
  /// Resolves the image for the given word.
  Future<Uint8List> resolveWordImage();
}

/// A function that makes a GET request.
typedef GetCall = Future<http.Response> Function(Uri uri);

/// {@template http_asset_resolver}
/// An [AssetResolver] that resolves assets over HTTP.
/// {@endtemplate}
class HttpAssetResolver implements AssetResolver {
  /// {@macro http_asset_resolver}
  const HttpAssetResolver({
    GetCall get = http.get,
  }) : _get = get;

  final GetCall _get;

  @override
  Future<Uint8List> resolveWordImage() {
    const url = 'http://127.0.0.1:8080/assets/letters.png';
    return _getFile(Uri.parse(url));
  }

  Future<Uint8List> _getFile(Uri uri) async {
    final response = await _get(uri);

    if (response.statusCode != 200) {
      throw AssetResolutionFailure('Failed to get image from $uri');
    }

    return response.bodyBytes;
  }
}
