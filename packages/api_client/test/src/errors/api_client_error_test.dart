import 'package:api_client/src/errors/api_client_error.dart';
import 'package:test/test.dart';

void main() {
  group('ApiClientError', () {
    test('toString returns the cause', () {
      expect(
        ApiClientError('Ops', StackTrace.fromString('stackTrace')).toString(),
        equals('''
cause: Ops
stackTrace: stackTrace
'''),
      );
    });
  });
}
