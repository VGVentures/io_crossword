// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/share/share.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../../helpers/helpers.dart';

class _FakeWord extends Fake implements Word {
  @override
  String? get answer => 'answer';

  @override
  String get clue => 'clue';

  @override
  int get length => 5;
}

void main() {
  group('$ShareWordPage', () {
    testWidgets(
      'renders correctly',
      (tester) async {
        final word = _FakeWord();
        await tester.pumpApp(
          ShareWordPage(word: word),
        );

        expect(find.byType(IoWord), findsOneWidget);
        expect(find.text(word.clue), findsOneWidget);
      },
    );

    testWidgets(
      'showModal opens the $ShareWordPage in a $ShareDialog',
      (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => ShareWordPage.showModal(
                    context,
                    _FakeWord(),
                  ),
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
