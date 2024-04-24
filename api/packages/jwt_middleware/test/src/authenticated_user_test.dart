// ignore_for_file: prefer_const_constructors

import 'package:jwt_middleware/src/authenticated_user.dart';
import 'package:test/test.dart';

void main() {
  group('AuthenticatedUser', () {
    test('uses value equality', () {
      final a = AuthenticatedUser('id', 'token');
      final b = AuthenticatedUser('id', 'token');
      final c = AuthenticatedUser('other', 'token');
      final d = AuthenticatedUser('id', 'other token');

      expect(a, b);
      expect(a, isNot(c));
      expect(a, isNot(d));
    });
  });
}
