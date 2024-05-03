// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockAnimationController extends Mock implements AnimationController {}

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

    testWidgets('moves child when word controller notifies', (tester) async {
      final textKey = GlobalKey();
      final controller = IoWordInputController();
      final animationController = _MockAnimationController();

      when(() => animationController.forward(from: 0)).thenAnswer(
        (_) => TickerFuture.complete(),
      );
      when(() => animationController.value).thenReturn(1);

      await tester.pumpWidget(
        MaterialApp(
          home: Shakable(
            controller: controller,
            animationController: animationController,
            shakeDuration: Duration(milliseconds: 500),
            child: Text(
              'shakableChild',
              key: textKey,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      controller.notifyListeners();

      await tester.pump();

      verify(() => animationController.forward(from: 0)).called(1);
    });
  });
}
