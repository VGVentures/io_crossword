// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('ErrorView', () {
    testWidgets('displays title', (tester) async {
      final themeData = IoCrosswordTheme().themeData;
      await tester.pumpApp(
        Theme(
          data: themeData,
          child: ErrorView(
            title: 'title',
          ),
        ),
      );

      expect(find.text('title'), findsOneWidget);
    });

    testWidgets('OutlinedButton not visible', (tester) async {
      final themeData = IoCrosswordTheme().themeData;
      await tester.pumpApp(
        Theme(
          data: themeData,
          child: ErrorView(
            title: 'error',
          ),
        ),
      );

      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('OutlinedButton visible', (tester) async {
      final themeData = IoCrosswordTheme().themeData;
      await tester.pumpApp(
        Theme(
          data: themeData,
          child: ErrorView(
            title: 'error',
            buttonTitle: 'buttonTitle',
          ),
        ),
      );

      expect(find.text('buttonTitle'), findsOneWidget);
    });

    testWidgets('OutlinedButton visible and can be pressed', (tester) async {
      var pressed = false;
      final themeData = IoCrosswordTheme().themeData;
      await tester.pumpApp(
        Theme(
          data: themeData,
          child: ErrorView(
            title: 'error',
            buttonTitle: 'buttonTitle',
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('buttonTitle'));

      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });
  });
}
