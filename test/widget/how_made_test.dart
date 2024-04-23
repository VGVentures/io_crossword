// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
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
  group('$HowMade', () {
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
      'displays information how made and open source',
      (tester) async {
        await tester.pumpApp(HowMade());

        final text =
            '${l10n.learn} ${l10n.howMade} ${l10n.and} ${l10n.openSourceCode}.';

        expect(find.text(text, findRichText: true), findsOneWidget);
      },
    );

    testWidgets(
      'calls launchUrl when tapped on open source code',
      (tester) async {
        await tester.pumpApp(HowMade());

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
  });
}
