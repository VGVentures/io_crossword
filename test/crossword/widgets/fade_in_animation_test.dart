// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword/crossword.dart';

void main() {
  group('FadeInAnimation', () {
    test('can be instantiated', () {
      expect(
        FadeInAnimation(
          child: const SizedBox(),
        ),
        isNotNull,
      );
    });

    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FadeInAnimation(
            child: const SizedBox(),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('renders child with opacity 0', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FadeInAnimation(
            child: const SizedBox(),
          ),
        ),
      );

      final fadeTransition =
          tester.widget<FadeTransition>(find.byType(FadeTransition));

      expect(fadeTransition.opacity.value, equals(0));
    });

    testWidgets('renders child with opacity 1 after duration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FadeInAnimation(
            duration: const Duration(milliseconds: 100),
            child: const SizedBox(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final fadeTransition =
          tester.widget<FadeTransition>(find.byType(FadeTransition));

      expect(fadeTransition.opacity.value, equals(1));
    });

    testWidgets('calls onComplete callback with animatin completes',
        (tester) async {
      final completer = Completer<void>();

      await tester.pumpWidget(
        MaterialApp(
          home: FadeInAnimation(
            duration: const Duration(milliseconds: 100),
            onComplete: completer.complete,
            child: const SizedBox(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(completer.isCompleted, isTrue);
    });
  });
}
