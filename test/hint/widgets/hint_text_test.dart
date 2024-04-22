// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$HintText', () {
    group('renders', () {
      testWidgets(
        'the Gemini icon',
        (tester) async {
          await tester.pumpApp(HintText(text: 'Ask Gemini'));

          expect(find.byIcon(IoIcons.gemini), findsOneWidget);
        },
      );

      testWidgets(
        'the provided text with the Gemini gradient',
        (tester) async {
          await tester.pumpApp(HintText(text: 'Ask Gemini'));

          expect(find.text('Ask Gemini'), findsOneWidget);
          expect(find.byType(GeminiGradient), findsAtLeast(1));
        },
      );
    });
  });
}
