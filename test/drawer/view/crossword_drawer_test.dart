// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/drawer/view/crossword_drawer.dart';

import '../../helpers/helpers.dart';

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
  });
}
