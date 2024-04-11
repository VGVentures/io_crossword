// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/share/view/share_score_page.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ShareScorePage', () {
    testWidgets(
      'renders correctly',
      (tester) async {
        await tester.pumpApp(ShareScorePage());

        expect(find.byType(IoCrosswordCard), findsOneWidget);
      },
    );

    testWidgets(
      'showModal opens the ShareScorePage',
      (tester) async {
        // Build the test widget
        await tester.pumpApp(
          Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => ShareScorePage.showModal(context),
                  child: Text('Show ShareScorePage'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(ShareScorePage), findsOneWidget);
      },
    );
  });
}
