// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/drawer/drawer.dart';
import 'package:io_crossword/music/music.dart';
import 'package:io_crossword/welcome/welcome.dart';
import 'package:io_crossword/widget/io_scaffold.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../helpers/helpers.dart';

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

    testWidgets('opens $CrosswordDrawer when $EndDrawerButton is tapped',
        (tester) async {
      await tester.pumpApp(IoScaffold(child: Placeholder()));

      await tester.tap(find.byType(EndDrawerButton));

      await tester.pump();

      expect(find.byType(CrosswordDrawer), findsOneWidget);
      expect(find.byType(IoScaffold), findsOneWidget);
    });
  });
}
