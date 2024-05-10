// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/project_details/project_details.dart';
import 'package:io_crossword/share/share.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$ShareScorePage', () {
    testWidgets(
      'renders ScoreInformation',
      (tester) async {
        await tester.pumpApp(SingleChildScrollView(child: ShareScorePage()));

        expect(find.byType(ScoreInformation), findsOneWidget);
      },
    );

    testWidgets(
      'renders PlayerInitials',
      (tester) async {
        await tester.pumpApp(SingleChildScrollView(child: ShareScorePage()));

        expect(find.byType(PlayerInitials), findsOneWidget);
      },
    );

    group('showModal', () {
      testWidgets(
        'opens the $ShareScorePage in a $ShareDialog',
        (tester) async {
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

          expect(find.byType(ShareDialog), findsOneWidget);
          expect(find.byType(ShareScorePage), findsOneWidget);
        },
      );

      testWidgets(
        'uses correct url',
        (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () => ShareScorePage.showModal(context),
                    child: Text('open share score'),
                  );
                },
              ),
            ),
          );

          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();

          expect(
            tester.widget<ShareDialog>(find.byType(ShareDialog)).url,
            equals(ProjectDetailsLinks.crossword),
          );
        },
      );
    });
  });
}
