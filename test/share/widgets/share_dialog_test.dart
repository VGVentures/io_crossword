// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/share/widgets/share_dialog.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ShareDialog', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpApp(
        ShareDialog(
          title: 'title',
          content: const Text('test'),
        ),
      );

      expect(find.text('title'), findsOneWidget);
    });

    testWidgets('renders content', (tester) async {
      await tester.pumpApp(
        ShareDialog(
          title: 'title',
          content: const Text('test'),
        ),
      );

      expect(find.text('test'), findsOneWidget);
    });
  });
}
