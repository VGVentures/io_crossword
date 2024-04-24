// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/share/widgets/share_dialog.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  group('ShareDialog', () {
    late UrlLauncherPlatform urlLauncher;

    setUpAll(() async {
      registerFallbackValue(_FakeLaunchOptions());
    });

    setUp(() {
      urlLauncher = _MockUrlLauncherPlatform();

      UrlLauncherPlatform.instance = urlLauncher;

      when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => true);
      when(() => urlLauncher.launchUrl(any(), any()))
          .thenAnswer((_) async => true);
    });

    testWidgets('renders title', (tester) async {
      await tester.pumpApp(
        ShareDialog(
          title: 'title',
          content: const Text('test'),
          twitterShareUrl: 'https://twitter',
          linkedInShareUrl: 'https://linkedin',
          facebookShareUrl: 'https://facebook',
        ),
      );

      expect(find.text('title'), findsOneWidget);
    });

    testWidgets('renders content', (tester) async {
      await tester.pumpApp(
        ShareDialog(
          title: 'title',
          content: const Text('test'),
          twitterShareUrl: 'https://twitter',
          linkedInShareUrl: 'https://linkedin',
          facebookShareUrl: 'https://facebook',
        ),
      );

      expect(find.text('test'), findsOneWidget);
    });

    testWidgets('launches linkedIn url when linkedin icon is tapped',
        (tester) async {
      await tester.pumpApp(
        ShareDialog(
          title: 'title',
          content: const Text('test'),
          twitterShareUrl: 'https://twitter',
          linkedInShareUrl: 'https://linkedin',
          facebookShareUrl: 'https://facebook',
        ),
      );

      await tester.tap(find.byIcon(IoIcons.linkedin));

      verify(
        () => urlLauncher.launchUrl(
          'https://linkedin',
          any(),
        ),
      ).called(1);
    });

    testWidgets('launches twitter url when twitter icon is tapped',
        (tester) async {
      await tester.pumpApp(
        ShareDialog(
          title: 'title',
          content: const Text('test'),
          twitterShareUrl: 'https://twitter',
          linkedInShareUrl: 'https://linkedin',
          facebookShareUrl: 'https://facebook',
        ),
      );

      await tester.tap(find.byIcon(IoIcons.twitter));

      verify(
        () => urlLauncher.launchUrl(
          'https://twitter',
          any(),
        ),
      ).called(1);
    });

    testWidgets('launches facebook url when facebook icon is tapped',
        (tester) async {
      await tester.pumpApp(
        ShareDialog(
          title: 'title',
          content: const Text('test'),
          twitterShareUrl: 'https://twitter',
          linkedInShareUrl: 'https://linkedin',
          facebookShareUrl: 'https://facebook',
        ),
      );

      await tester.tap(find.byIcon(IoIcons.facebook));

      verify(
        () => urlLauncher.launchUrl(
          'https://facebook',
          any(),
        ),
      ).called(1);
    });
  });
}
