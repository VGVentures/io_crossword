import 'dart:convert';

import 'package:api_client/src/extensions/response_decryption.dart';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('ResponseDecryption', () {
    test('decrypts correctly', () {
      final key = Key.fromUtf8('encryption_key_not_set_123456789');
      final iv = IV.fromUtf8('iv_not_set_12345');
      final encrypter = Encrypter(AES(key));
      final testJson = {'data': 'test'};
      final encrypted = encrypter.encrypt(jsonEncode(testJson), iv: iv).base64;
      final encryptedResponse = http.Response(encrypted, 200);
      final expectedResponse = http.Response(testJson.toString(), 200);

      expect(encryptedResponse.decrypted.body, equals(expectedResponse.body));
    });
  });
}
