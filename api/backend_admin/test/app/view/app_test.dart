import 'package:backend_admin/app/app.dart';
import 'package:backend_admin/http_client/http_client.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockHttpClient extends Mock implements HttpClient {}

void main() {
  group('App', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(
        App(
          crosswordRepository: _MockCrosswordRepository(),
          httpClient: _MockHttpClient(),
        ),
      );
      expect(find.byType(App), findsOneWidget);
    });
  });
}
