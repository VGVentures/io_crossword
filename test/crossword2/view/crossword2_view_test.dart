import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword2/crossword2.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$Crossword2View', () {
    testWidgets('pumps successfully', (tester) async {
      await tester.pumpApp(const Crossword2View());
      expect(find.byType(Crossword2View), findsOneWidget);
    });
  });
}
