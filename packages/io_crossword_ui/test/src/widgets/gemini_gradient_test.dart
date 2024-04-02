// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('$GeminiGradient', () {
    testWidgets('renders ShaderMask', (tester) async {
      await tester.pumpApp(
        GeminiGradient(
          child: Text('Gemini gradient'),
        ),
      );

      expect(find.byType(ShaderMask), findsOneWidget);
    });

    testWidgets('displays child', (tester) async {
      await tester.pumpApp(
        GeminiGradient(
          child: Text('Gemini gradient'),
        ),
      );

      expect(find.text('Gemini gradient'), findsOneWidget);
    });
  });
}
