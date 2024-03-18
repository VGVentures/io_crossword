import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpApp(
        PrimaryButton(
          onPressed: () {},
          label: 'Label',
        ),
      );

      expect(find.text('Label'), findsOneWidget);
    });

    testWidgets('tapping triggers onPressed', (tester) async {
      var value = 0;
      await tester.pumpApp(
        PrimaryButton(
          onPressed: () {
            value++;
          },
          label: 'Label',
        ),
      );

      await tester.tap(find.byType(PrimaryButton));

      expect(value, 1);
    });
  });
}
