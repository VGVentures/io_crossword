import 'package:hint_repository/hint_repository.dart';
import 'package:test/test.dart';

void main() {
  group('HintException', () {
    test('can be converted to a string', () {
      final exception = HintException(
        'something is broken',
        StackTrace.fromString('it happened here'),
      );

      expect(
        exception.toString(),
        equals('''
cause: something is broken
stackTrace: it happened here
'''),
      );
    });
  });
}
