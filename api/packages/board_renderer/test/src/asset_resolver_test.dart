import 'dart:typed_data';

import 'package:board_renderer/board_renderer.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('AssetResolver', () {
    test('returns the image from the response', () {
      final resolver = HttpAssetResolver(
        get: (uri) async {
          return http.Response.bytes(Uint8List(0), 200);
        },
      );

      expect(resolver.resolveWordImage(), completion(isA<Uint8List>()));
    });

    test('returns the font from the response', () {
      final resolver = HttpAssetResolver(
        get: (uri) async {
          return http.Response.bytes(Uint8List(0), 200);
        },
      );

      expect(resolver.resolveFont(), completion(isA<Uint8List>()));
    });

    test('throws an AssetResolutionFailure when the response is not 200', () {
      final resolver = HttpAssetResolver(
        get: (uri) async {
          return http.Response.bytes(Uint8List(0), 404);
        },
      );

      expect(
        resolver.resolveWordImage(),
        throwsA(isA<AssetResolutionFailure>()),
      );
    });
  });
}
