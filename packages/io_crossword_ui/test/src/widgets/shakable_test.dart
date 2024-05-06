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
  });
}
