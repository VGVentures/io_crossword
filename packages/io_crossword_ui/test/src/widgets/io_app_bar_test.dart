// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('IoAppBar', () {
    testWidgets(
      'does not render crossword with small layout',
      (tester) async {
        await tester.pumpApp(
          IoAppBar(
            crossword: 'Crossword',
            actions: (_) => [],
            title: Text('Title'),
          ),
          layout: IoLayoutData.small,
        );

        expect(find.text('Crossword'), findsNothing);
      },
    );

    testWidgets(
      'does not render crossword with large layout',
      (tester) async {
        await tester.pumpApp(
          IoAppBar(
            crossword: 'Crossword',
            actions: (_) => [],
            title: Text('Title'),
          ),
          layout: IoLayoutData.large,
        );

        expect(find.text('Crossword'), findsOneWidget);
      },
    );

    for (final layout in IoLayoutData.values) {
      testWidgets(
        'renders title with $layout',
        (tester) async {
          await tester.pumpApp(
            IoAppBar(
              crossword: 'Crossword',
              actions: (_) => [],
              title: Text('Title'),
            ),
            layout: layout,
          );

          expect(find.text('Title'), findsOneWidget);
        },
      );
    }

    testWidgets(
      'display actions based on large layout',
      (tester) async {
        await tester.pumpApp(
          IoAppBar(
            crossword: 'Crossword',
            actions: (layout) {
              return switch (layout) {
                IoLayoutData.small => [Text('Small')],
                IoLayoutData.large => [Text('Large')],
              };
            },
            title: Text('Title'),
          ),
          layout: IoLayoutData.large,
        );

        expect(find.text('Large'), findsOneWidget);
        expect(find.text('Small'), findsNothing);
      },
    );

    testWidgets(
      'display actions based on large layout',
      (tester) async {
        await tester.pumpApp(
          IoAppBar(
            crossword: 'Crossword',
            actions: (layout) {
              return switch (layout) {
                IoLayoutData.small => [Text('Small')],
                IoLayoutData.large => [Text('Large')],
              };
            },
            title: Text('Title'),
          ),
          layout: IoLayoutData.small,
        );

        expect(find.text('Small'), findsOneWidget);
        expect(find.text('Large'), findsNothing);
      },
    );
  });
}
