import 'package:backend_admin/app/app.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

void main() {
  group('App', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(
        App(crosswordRepository: _MockCrosswordRepository()),
      );
      expect(find.byType(App), findsOneWidget);
    });
  });
}
