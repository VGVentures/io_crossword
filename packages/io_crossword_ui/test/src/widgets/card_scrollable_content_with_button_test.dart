// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('CardScrollableContentWithButton', () {
    testWidgets('renders a child', (tester) async {
      await tester.pumpApp(
        CardScrollableContentWithButton(
          buttonLabel: 'buttonLabel',
          onPressed: () {},
          child: Text('child'),
        ),
      );

      expect(find.text('child'), findsOneWidget);
    });

    testWidgets('renders a big child', (tester) async {
      await tester.pumpApp(
        CardScrollableContentWithButton(
          buttonLabel: 'buttonLabel',
          onPressed: () {},
          child: SizedBox(
            height: 1000,
            child: Text('child'),
          ),
        ),
      );

      expect(find.text('child'), findsOneWidget);
    });

    testWidgets('renders button', (tester) async {
      await tester.pumpApp(
        CardScrollableContentWithButton(
          buttonLabel: 'buttonLabel',
          onPressed: () {},
          child: const SizedBox(),
        ),
      );

      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('buttonLabel'), findsOneWidget);
    });
  });
}
