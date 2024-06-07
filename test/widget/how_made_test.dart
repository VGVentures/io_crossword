// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/widget/widget.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../helpers/helpers.dart';

class _MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  group('$HowItWasMade', () {
    late UrlLauncherPlatform urlLauncher;

    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
      registerFallbackValue(_FakeLaunchOptions());
    });

    setUp(() {
      urlLauncher = _MockUrlLauncherPlatform();

      UrlLauncherPlatform.instance = urlLauncher;

      when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => true);
      when(() => urlLauncher.launchUrl(any(), any()))
          .thenAnswer((_) async => true);
    });

    testWidgets(
      'displays information how made and join the gemini dev competition',
      (tester) async {
        await tester.pumpApp(HowItWasMade());

        final text =
            '${l10n.learnHowThe} ${l10n.ioCrossword} ${l10n.wasMade}.\n'
            '${l10n.joinThe} ${l10n.geminiCompetition}.';

        expect(find.text(text, findRichText: true), findsOneWidget);
      },
    );

    testWidgets(
      'calls launchUrl when tapped on I/O Crossword',
      (tester) async {
        await tester.pumpApp(HowItWasMade());

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              find.tapTextSpan(
                widget,
                l10n.ioCrossword,
              ),
        );

        await tester.tap(finder);

        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            'https://developers.google.com/learn/pathways',
            any(),
          ),
        );
      },
    );

    testWidgets(
      'calls launchUrl when tapped on gemini dev competition',
      (tester) async {
        await tester.pumpApp(HowItWasMade());

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              find.tapTextSpan(widget, l10n.geminiCompetition),
        );

        await tester.tap(finder);
        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            'https://ai.google.dev/competition',
            any(),
          ),
        );
      },
    );

    testWidgets(
      'displays error snack bar when cannot launch how made',
      (tester) async {
        when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => false);

        await tester.pumpApp(HowItWasMade());

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is RichText && find.tapTextSpan(widget, l10n.ioCrossword),
        );

        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(l10n.couldNotOpenUrl), findsOneWidget);
      },
    );
  });
}
