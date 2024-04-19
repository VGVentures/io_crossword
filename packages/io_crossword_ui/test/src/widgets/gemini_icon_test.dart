// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('$GeminiIcon', () {
    testWidgets('renders the gemini icon data', (tester) async {
      await tester.pumpApp(GeminiIcon());

      expect(find.byIcon(IoIcons.gemini), findsOneWidget);
    });

    testWidgets('renders the gemini gradient', (tester) async {
      await tester.pumpApp(GeminiIcon());

      expect(find.byType(GeminiGradient), findsOneWidget);
    });

    testWidgets('supports changing the size', (tester) async {
      await tester.pumpApp(GeminiIcon(size: 20));

      final icon = tester.widget<Icon>(find.byType(Icon));

      expect(icon.size, equals(20));
    });
  });
}
