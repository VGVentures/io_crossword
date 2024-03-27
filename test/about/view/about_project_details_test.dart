// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/about/view/about_view.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockUrlLauncherPlatform extends Mock implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  group('AboutProjectDetails', () {
    late UrlLauncherPlatform urlLauncher;
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
      registerFallbackValue(_FakeLaunchOptions());
    });

    setUp(() {
      urlLauncher = _MockUrlLauncherPlatform();

      when(() => urlLauncher.launchUrl(any(), any()))
          .thenAnswer((_) async => true);
    });

    testWidgets(
      'displays initial information how made and open source',
      (tester) async {
        await tester.pumpApp(AboutProjectDetails());

        final text =
            '${l10n.learn} ${l10n.howMade} ${l10n.and} ${l10n.openSourceCode}.';

        expect(find.text(text, findRichText: true), findsOneWidget);
      },
    );

    testWidgets(
      'displays Google I/O text',
      (tester) async {
        await tester.pumpApp(AboutProjectDetails());

        expect(find.text('Google I/O', findRichText: true), findsOneWidget);
      },
    );

    testWidgets(
      'calls launchUrl when tapped on Google I/O',
      (tester) async {
        await tester.pumpApp(AboutProjectDetails());

        await tester.tap(find.text('Google I/O', findRichText: true));

        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            'https://io.google/2024',
            LaunchOptions(mode: PreferredLaunchMode.inAppWebView),
          ),
        );
      },
    );

    testWidgets(
      'displays privacy policy text',
      (tester) async {
        await tester.pumpApp(AboutProjectDetails());

        expect(
          find.text(l10n.privacyPolicy, findRichText: true),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'displays terms of service text',
      (tester) async {
        await tester.pumpApp(AboutProjectDetails());

        expect(
          find.text(l10n.termsOfService, findRichText: true),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'displays faqs text',
      (tester) async {
        await tester.pumpApp(AboutProjectDetails());

        expect(
          find.text(l10n.faqs, findRichText: true),
          findsOneWidget,
        );
      },
    );
  });
}
