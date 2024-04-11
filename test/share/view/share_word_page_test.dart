// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/share/view/share_Word_page.dart';
import 'package:io_crossword/share/widgets/widgets.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../../helpers/helpers.dart';

class _FakeWord extends Fake implements Word {
  @override
  String get answer => 'answer';

  @override
  String get clue => 'clue';
}

void main() {
  group('ShareWordPage', () {
    testWidgets(
      'renders correctly',
      (tester) async {
        await tester.pumpApp(
          ShareWordPage(
            word: _FakeWord(),
          ),
        );

        expect(find.byType(WordInformation), findsOneWidget);
      },
    );

    testWidgets(
      'showModal opens the ShareWordPage in a $ShareDialog',
      (tester) async {
        // Build the test widget
        await tester.pumpApp(
          Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => ShareWordPage.showModal(context),
                  child: Text('Show ShareWordPage'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(ShareDialog), findsOneWidget);
        expect(find.byType(ShareWordPage), findsOneWidget);
      },
    );
  });
}
