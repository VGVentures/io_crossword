// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/music/music.dart';
import 'package:io_crossword/settings/settings.dart';
import 'package:io_crossword/welcome/welcome.dart';
import 'package:io_crossword/widget/io_scaffold.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../helpers/helpers.dart';

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  group('IoScaffold', () {
    testWidgets('renders $IoAppBar', (tester) async {
      await tester.pumpApp(IoScaffold(child: Placeholder()));
      expect(find.byType(IoAppBar), findsOneWidget);
    });

    testWidgets('renders title', (tester) async {
      await tester.pumpApp(
        IoScaffold(
          title: Text('title'),
          child: Placeholder(),
        ),
      );
      expect(find.text('title'), findsOneWidget);
    });

    testWidgets('renders bottom', (tester) async {
      await tester.pumpApp(
        IoScaffold(
          bottom: WelcomeHeaderImage(),
          child: Placeholder(),
        ),
      );
      expect(find.byType(WelcomeHeaderImage), findsOneWidget);
    });

    testWidgets('renders $MuteButton', (tester) async {
      await tester.pumpApp(IoScaffold(child: Placeholder()));

      expect(find.byType(MuteButton), findsOneWidget);
    });

    testWidgets('renders $EndDrawerButton', (tester) async {
      await tester.pumpApp(IoScaffold(child: Placeholder()));

      expect(find.byType(EndDrawerButton), findsOneWidget);
    });
  });
}
