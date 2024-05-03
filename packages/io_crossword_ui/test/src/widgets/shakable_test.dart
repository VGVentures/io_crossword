// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockController extends Mock implements AnimationController {}

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
      final controller = _MockController();
      when(() => controller.forward(from: 0)).thenAnswer(
        (_) => TickerFuture.complete(),
      );
      when(() => controller.value).thenReturn(1);
      await tester.pumpWidget(
        MaterialApp(
          home: Shakable(
            key: shakeKey,
            shakeDuration: Duration(milliseconds: 500),
            controller: controller,
            child: Text(
              'shakableChild',
              key: textKey,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      shakeKey.currentState?.shake();

      await tester.pump();

      verify(() => controller.forward(from: 0)).called(1);
    });
  });
}
