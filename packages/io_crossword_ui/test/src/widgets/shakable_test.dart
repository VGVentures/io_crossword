// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

void main() {
  group('$Shakable', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Shakable(
            shakeDuration: Duration(milliseconds: 500),
            child: Text('shakableChild'),
          ),
        ),
      );
      expect(find.text('shakableChild'), findsOneWidget);
    });

    testWidgets('moves child when shake is called', (tester) async {
      final textKey = GlobalKey();
      final shakeKey = GlobalKey<ShakableState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Shakable(
            key: shakeKey,
            shakeDuration: Duration(milliseconds: 500),
            child: Text(
              'shakableChild',
              key: textKey,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final initialRenderBox =
          textKey.currentContext?.findRenderObject() as RenderBox?;
      final initialPosition = initialRenderBox?.localToGlobal(Offset.zero);

      shakeKey.currentState?.shake();

      await tester.pump(Duration(milliseconds: 100));

      final nextRenderBox =
          textKey.currentContext?.findRenderObject() as RenderBox?;
      final nextPosition = nextRenderBox?.localToGlobal(Offset.zero);

      expect(initialPosition, isNot(nextPosition));
    });
  });
}
