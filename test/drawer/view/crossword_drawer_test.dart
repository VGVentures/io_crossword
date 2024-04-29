// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/drawer/drawer.dart';
import 'package:io_crossword/drawer/view/crossword_drawer.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/project_details/project_details.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _MockHowToPlayCubit extends MockCubit<int> implements HowToPlayCubit {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  group('CrosswordDrawer', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(CrosswordDrawer());

      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('closes when close button is tapped', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();

      await tester.pumpApp(
        Scaffold(
          key: scaffoldKey,
          endDrawer: CrosswordDrawer(),
        ),
      );

      scaffoldKey.currentState!.openEndDrawer();
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsNothing);
    });

    testWidgets(
        'navigates to EndGameCheck when Finish & submit score is tapped',
        (tester) async {
      await tester.pumpApp(CrosswordDrawer());

      await tester.tap(find.text('Finish & submit score'));
      await tester.pumpAndSettle();

      expect(find.byType(EndGameCheck), findsOneWidget);
    });

    testWidgets(
        'navigates to ProjectDetailsView when Project Details is tapped',
        (tester) async {
      await tester.pumpApp(CrosswordDrawer());

      await tester.tap(find.text('Project Details'));
      await tester.pumpAndSettle();

      expect(find.byType(ProjectDetailsView), findsOneWidget);
    });

    testWidgets(
        'navigates to HowToPlay when button is tapped ${IoLayoutData.small}',
        (tester) async {
      final HowToPlayCubit howToPlayCubit = _MockHowToPlayCubit();

      when(() => howToPlayCubit.state).thenReturn(0);
      await tester.pumpApp(
        BlocProvider(
          create: (_) => howToPlayCubit,
          child: CrosswordDrawer(),
        ),
        layout: IoLayoutData.small,
      );

      await tester.tap(find.text('How to play'));
      await tester.pumpAndSettle();

      expect(find.byType(HowToPlayContent), findsOneWidget);
    });

    testWidgets(
        'navigates to HowToPlay when button is tapped ${IoLayoutData.large}',
        (tester) async {
      final HowToPlayCubit howToPlayCubit = _MockHowToPlayCubit();

      when(() => howToPlayCubit.state).thenReturn(0);
      await tester.pumpApp(
        BlocProvider(
          create: (_) => howToPlayCubit,
          child: CrosswordDrawer(),
        ),
        layout: IoLayoutData.large,
      );

      await tester.tap(find.text('How to play'));
      await tester.pumpAndSettle();

      expect(find.byType(HowToPlayContent), findsOneWidget);
    });

    testWidgets('Pops HowToPlay widget when Done is tapped', (tester) async {
      final HowToPlayCubit howToPlayCubit = _MockHowToPlayCubit();
      final l10n = await AppLocalizations.delegate.load(Locale('en'));
      final mockNavigator = MockNavigator();
      when(mockNavigator.canPop).thenReturn(true);
      when(() => howToPlayCubit.state).thenReturn(0);
      await tester.pumpApp(
        BlocProvider(
          create: (_) => howToPlayCubit,
          child: CrosswordDrawer(),
        ),
        navigator: mockNavigator,
      );

      await tester.tap(find.text(l10n.howToPlay));
      await tester.pumpAndSettle();

      for (var i = 0; i < 4; i++) {
        await tester.tap(find.text(l10n.nextButtonLabel));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text(l10n.doneButtonLabel));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('opens new tab when', () {
    late UrlLauncherPlatform urlLauncher;

    setUpAll(() {
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
      'Claim your badge is tapped',
      (tester) async {
        await tester.pumpApp(CrosswordDrawer());

        await tester.tap(find.text('Claim your badge'));
        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            ProjectDetailsLinks.claimBadge,
            any(),
          ),
        );
      },
    );
    testWidgets(
      'Google I/O is tapped',
      (tester) async {
        await tester.pumpApp(CrosswordDrawer());

        await tester.tap(find.text('Google I/O'));
        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            ProjectDetailsLinks.googleIO,
            any(),
          ),
        );
      },
    );
    testWidgets(
      'Explore in AI Studio is tapped',
      (tester) async {
        await tester.pumpApp(CrosswordDrawer());

        await tester.tap(find.text('Explore in AI Studio'));
        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            ProjectDetailsLinks.googleAI,
            any(),
          ),
        );
      },
    );

    testWidgets(
      'Privacy Policy is tapped',
      (tester) async {
        await tester.pumpApp(CrosswordDrawer());
        await tester.dragUntilVisible(
          find.text('Privacy Policy'),
          find.byType(CrosswordDrawer),
          Offset(0, -50),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Privacy Policy'));
        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            ProjectDetailsLinks.privacyPolicy,
            any(),
          ),
        );
      },
    );

    testWidgets(
      'Terms of Service is tapped',
      (tester) async {
        await tester.pumpApp(CrosswordDrawer());
        await tester.dragUntilVisible(
          find.text('Terms of Service'),
          find.byType(CrosswordDrawer),
          Offset(0, -50),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Terms of Service'));
        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            ProjectDetailsLinks.termsOfService,
            any(),
          ),
        );
      },
    );

    testWidgets(
      'FAQs is tapped',
      (tester) async {
        await tester.pumpApp(CrosswordDrawer());
        await tester.dragUntilVisible(
          find.text('FAQs'),
          find.byType(CrosswordDrawer),
          Offset(0, -50),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('FAQs'));
        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(
            ProjectDetailsLinks.faqs,
            any(),
          ),
        );
      },
    );
  });
}
