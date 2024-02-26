import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;

/// {@template response_encryption}
/// Extension on [http.Response] to decrypt body
/// {@endtemplate}
extension ResponseDecryption on http.Response {
  /// Get [http.Response] with decrypted body
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
