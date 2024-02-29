import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/app/app.dart';

void main() {
  group('App', () {
    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.byType(AppView), findsOneWidget);
    });
  });
}
