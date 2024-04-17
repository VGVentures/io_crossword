import 'package:crossword_repository/crossword_repository.dart';
import 'package:test/test.dart';

void main() {
  group('CrosswordRepositoryException', () {
    test('can be converted to a string', () {
      final exception = CrosswordRepositoryException(
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
