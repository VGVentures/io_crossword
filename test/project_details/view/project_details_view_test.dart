import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/project_details/project_details.dart';
import 'package:io_crossword/widget/widget.dart';
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
  group('ProjectDetailsView', () {
    group('renders', () {
      testWidgets('a $ProjectDetailsLargeView when layout is large',
          (tester) async {
        await tester.pumpApp(
          layout: IoLayoutData.large,
          const ProjectDetailsView(),
        );

        expect(find.byType(ProjectDetailsLargeView), findsOneWidget);
      });

      testWidgets('a $ProjectDetailsSmallView when layout is small',
          (tester) async {
        await tester.pumpApp(
          layout: IoLayoutData.small,
          const ProjectDetailsView(),
        );

        expect(find.byType(ProjectDetailsSmallView), findsOneWidget);
      });
    });

    group('ProjectDetailsContent', () {
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

      testWidgets(
        'renders HowMade',
        (tester) async {
          await tester.pumpApp(const ProjectDetailsContent());

          expect(find.byType(HowMade), findsOneWidget);
        },
      );
    });
  });
}
