import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationException', () {
    group('toString', () {
      test('returns error as string', () {
        expect(
          AuthenticationException(Exception('error'), StackTrace.empty)
              .toString(),
          'Exception: error',
        );
      });
    });
  });
}
