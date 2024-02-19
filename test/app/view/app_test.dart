import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/app/app.dart';
import 'package:io_crossword/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
