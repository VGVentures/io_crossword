// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockShareResource extends Mock implements ShareResource {}

void main() {
  group('$ShareScorePage', () {
    testWidgets(
      'renders ScoreInformation',
      (tester) async {
        await tester.pumpApp(ShareScorePage());

        expect(find.byType(ScoreInformation), findsOneWidget);
      },
    );

    testWidgets(
      'renders PlayerInitials',
      (tester) async {
        await tester.pumpApp(ShareScorePage());

        expect(find.byType(PlayerInitials), findsOneWidget);
      },
    );

    group('showModal', () {
      late ShareResource shareResource;

      setUp(() {
        shareResource = _MockShareResource();
      });

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
        'uses correct facebook url',
        (tester) async {
          when(() => shareResource.facebookShareBaseUrl())
              .thenReturn('https://facebook');
          when(() => shareResource.twitterShareBaseUrl())
              .thenReturn('https://twitter');
          when(() => shareResource.linkedinShareBaseUrl())
              .thenReturn('https://linkedin');

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
            shareResource: shareResource,
          );

          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();

          expect(
            tester
                .widget<ShareDialog>(find.byType(ShareDialog))
                .facebookShareUrl,
            equals('https://facebook'),
          );
        },
      );

      testWidgets(
        'uses correct twitter url',
        (tester) async {
          when(() => shareResource.facebookShareBaseUrl())
              .thenReturn('https://facebook');
          when(() => shareResource.twitterShareBaseUrl())
              .thenReturn('https://twitter');
          when(() => shareResource.linkedinShareBaseUrl())
              .thenReturn('https://linkedin');

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
            shareResource: shareResource,
          );

          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();

          expect(
            tester
                .widget<ShareDialog>(find.byType(ShareDialog))
                .twitterShareUrl,
            equals('https://twitter'),
          );
        },
      );

      testWidgets(
        'uses correct linkedin url',
        (tester) async {
          when(() => shareResource.facebookShareBaseUrl())
              .thenReturn('https://facebook');
          when(() => shareResource.twitterShareBaseUrl())
              .thenReturn('https://twitter');
          when(() => shareResource.linkedinShareBaseUrl())
              .thenReturn('https://linkedin');

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
            shareResource: shareResource,
          );

          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();

          expect(
            tester
                .widget<ShareDialog>(find.byType(ShareDialog))
                .linkedInShareUrl,
            equals('https://linkedin'),
          );
        },
      );
    });
  });
}
