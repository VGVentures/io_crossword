// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/about/view/about_view.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('AboutView', () {
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    testWidgets('renders AboutView', (tester) async {
      await tester.pumpRoute(AboutView.route());
      await tester.pump();

      expect(find.byType(AboutView), findsOneWidget);
    });

    testWidgets(
      'renders IoCrosswordCard',
      (tester) async {
        await tester.pumpApp(AboutView());

        expect(find.byType(IoCrosswordCard), findsOneWidget);
      },
    );

    testWidgets(
      'displays aboutCrossword title',
      (tester) async {
        await tester.pumpApp(AboutView());

        expect(find.text(l10n.aboutCrossword), findsOneWidget);
      },
    );

    testWidgets(
      'renders CloseButton',
      (tester) async {
        await tester.pumpApp(AboutView());

        expect(find.byType(CloseButton), findsOneWidget);
      },
    );

    testWidgets(
      'displays tab titles',
      (tester) async {
        await tester.pumpApp(AboutView());

        expect(find.text(l10n.howToPlay), findsOneWidget);
        expect(find.text(l10n.projectDetails), findsOneWidget);
      },
    );

    testWidgets(
      'renders AboutHowToPlayContent first tab view content',
      (tester) async {
        await tester.pumpApp(AboutView());

        expect(find.byType(AboutHowToPlayContent), findsOneWidget);
      },
    );

    testWidgets(
      'does not render AboutProjectDetails second tab view content',
      (tester) async {
        await tester.pumpApp(AboutView());

        expect(find.byType(AboutProjectDetails), findsNothing);
      },
    );

    testWidgets(
      'render AboutProjectDetails when projectDetails TabBar is tapped '
      'to view the second tab content',
      (tester) async {
        await tester.pumpApp(AboutView());

        await tester.tap(find.text(l10n.projectDetails));

        await tester.pumpAndSettle();

        expect(find.byType(AboutProjectDetails), findsOneWidget);
      },
    );

    testWidgets(
      'renders AboutProjectDetails with second TabBar pressed '
      'and renders AboutHowToPlayContent with first TabBar pressed',
      (tester) async {
        await tester.pumpApp(AboutView());

        await tester.tap(find.text(l10n.projectDetails));

        await tester.pumpAndSettle();

        expect(find.byType(AboutProjectDetails), findsOneWidget);

        await tester.tap(find.text(l10n.howToPlay));

        await tester.pumpAndSettle();

        expect(find.byType(AboutHowToPlayContent), findsOneWidget);
      },
    );
  });
}
