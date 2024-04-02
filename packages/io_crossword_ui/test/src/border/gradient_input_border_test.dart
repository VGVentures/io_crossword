import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('GradientInputBorder', () {
    const gradient = LinearGradient(colors: [Colors.red, Colors.blue]);

    test('transitions from an OutlineInputBorder', () {
      const border = GradientInputBorder(gradient: gradient);

      const outlineBorder = OutlineInputBorder();

      expect(border.lerpFrom(outlineBorder, 1), isA<GradientInputBorder>());
    });

    test('completes transition from any ShapeBorder', () {
      const border = GradientInputBorder(gradient: gradient);

      const underlinedBorder = UnderlineInputBorder();

      expect(border.lerpFrom(underlinedBorder, 1), isNull);
    });

    testWidgets(
      'paints the border without a gap for the label',
      (tester) async {
        await tester.pumpApp(
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Label',
              // Makes the label not be embedded in the border.
              floatingLabelBehavior: FloatingLabelBehavior.never,
              enabledBorder: GradientInputBorder(gradient: gradient),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
      },
    );

    testWidgets(
      'paints the border with a gap for the label',
      (tester) async {
        await tester.pumpApp(
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Label',
              // Makes the label be embedded in the border.
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: GradientInputBorder(gradient: gradient),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
      },
    );

    testWidgets(
      'paints the border correctly with radius zero',
      (tester) async {
        await tester.pumpApp(
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Label',
              // Makes the label be embedded in the border.
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: GradientInputBorder(
                borderRadius: BorderRadius.zero,
                gradient: gradient,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
      },
    );
  });
}
