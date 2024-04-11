// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/about/view/about_view.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

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

      UrlLauncherPlatform.instance = urlLauncher;

      when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => true);
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
      'calls launchUrl when tapped on open source code',
      (tester) async {
        await tester.pumpApp(AboutProjectDetails());

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              find.tapTextSpan(
                widget,
                l10n.openSourceCode,
              ),
        );

        await tester.tap(finder);

        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            'https://github.com/VGVentures/io_crossword',
            any(),
          ),
        );
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
            any(),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'displays error snack bar when cannot launch Google I/O url',
      (tester) async {
        when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => false);

        await tester.pumpApp(AboutProjectDetails());

        await tester.tap(find.text('Google I/O', findRichText: true));

        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(l10n.couldNotOpenUrl), findsOneWidget);
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
      'calls launchUrl when tapped on privacy policy',
      (tester) async {
        await tester.pumpApp(AboutProjectDetails());

        await tester.tap(find.text(l10n.privacyPolicy, findRichText: true));

        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            'https://policies.google.com/privacy',
            any(),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'displays error snack bar when cannot launch privacy policy url',
      (tester) async {
        when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => false);

        await tester.pumpApp(AboutProjectDetails());

        await tester.tap(find.text(l10n.privacyPolicy, findRichText: true));

        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(l10n.couldNotOpenUrl), findsOneWidget);
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
      'displays error snack bar when cannot launch terms of service url',
      (tester) async {
        when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => false);

        await tester.pumpApp(AboutProjectDetails());

        await tester.tap(find.text(l10n.termsOfService, findRichText: true));

        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(l10n.couldNotOpenUrl), findsOneWidget);
      },
    );

    testWidgets(
      'calls launchUrl when tapped on terms of service',
      (tester) async {
        await tester.pumpApp(AboutProjectDetails());

        await tester.tap(find.text(l10n.termsOfService, findRichText: true));

        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            'https://policies.google.com/terms',
            any(),
          ),
        ).called(1);
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

    testWidgets(
      'displays error snack bar when cannot launch faqs',
      (tester) async {
        when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => false);

        await tester.pumpApp(AboutProjectDetails());

        await tester.tap(find.text(l10n.termsOfService, findRichText: true));

        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(l10n.couldNotOpenUrl), findsOneWidget);
      },
    );

    testWidgets(
      'calls launchUrl when tapped on faqs',
      (tester) async {
        await tester.pumpApp(AboutProjectDetails());

        await tester.tap(find.text(l10n.faqs, findRichText: true));

        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            'https://flutter.dev/crossword',
            any(),
          ),
        ).called(1);
      },
    );
  });
}
