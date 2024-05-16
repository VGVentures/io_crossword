// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../helpers/helpers.dart';

class _BottomWidget extends StatelessWidget implements PreferredSizeWidget {
  const _BottomWidget();

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }

  @override
  Size get preferredSize => Size(200, 100);
}

void main() {
  group('IoAppBar', () {
    testWidgets(
      'preferredSize',
      (tester) async {
        expect(
          IoAppBar(
            crossword: 'Crossword',
            actions: (_) => SizedBox(),
            title: Text('Title'),
          ).preferredSize,
          equals(Size(double.infinity, 80)),
        );
      },
    );

    testWidgets(
      'preferredSize height increments with bottom widget',
      (tester) async {
        expect(
          IoAppBar(
            crossword: 'Crossword',
            actions: (_) => SizedBox(),
            bottom: _BottomWidget(),
            title: Text('Title'),
          ).preferredSize,
          equals(Size(double.infinity, 180)),
        );
      },
    );

    testWidgets(
      'does not render crossword with small layout',
      (tester) async {
        await tester.pumpApp(
          IoAppBar(
            crossword: 'Crossword',
            actions: (_) => SizedBox(),
            title: Text('Title'),
          ),
          layout: IoLayoutData.small,
        );

        expect(find.text('Crossword'), findsNothing);
      },
    );

    testWidgets(
      'render crossword with small layout if title is null',
      (tester) async {
        await tester.pumpSubject(
          IoAppBar(
            crossword: 'Crossword',
            actions: (_) => SizedBox(),
            title: null,
          ),
          layout: IoLayoutData.small,
        );

        expect(find.text('Crossword'), findsOneWidget);
      },
    );

    testWidgets(
      'renders crossword with large layout',
      (tester) async {
        await tester.pumpSubject(
          IoAppBar(
            crossword: 'Crossword',
            actions: (_) => SizedBox(),
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
          await tester.pumpSubject(
            IoAppBar(
              crossword: 'Crossword',
              actions: (_) => SizedBox(),
              title: Text('Title'),
            ),
            layout: layout,
          );

          expect(find.text('Title'), findsOneWidget);
        },
      );
    }

    for (final layout in IoLayoutData.values) {
      testWidgets(
        'renders bottom widget with $layout',
        (tester) async {
          await tester.pumpSubject(
            IoAppBar(
              crossword: 'Crossword',
              actions: (_) => SizedBox(),
              title: Text('Title'),
              bottom: _BottomWidget(),
            ),
            layout: layout,
          );

          expect(find.byType(_BottomWidget), findsOneWidget);
        },
      );
    }

    testWidgets(
      'display actions based on large layout',
      (tester) async {
        await tester.pumpSubject(
          IoAppBar(
            crossword: 'Crossword',
            actions: (context) {
              final layout = IoLayout.of(context);

              return switch (layout) {
                IoLayoutData.small => Text('Small'),
                IoLayoutData.large => Text('Large'),
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
        await tester.pumpSubject(
          IoAppBar(
            crossword: 'Crossword',
            actions: (context) {
              final layout = IoLayout.of(context);

              return switch (layout) {
                IoLayoutData.small => Text('Small'),
                IoLayoutData.large => Text('Large'),
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

extension on WidgetTester {
  /// Pumps the test subject with all its required ancestors.
  Future<void> pumpSubject(
    Widget child, {
    IoLayoutData layout = IoLayoutData.small,
  }) {
    final themeData = IoCrosswordTheme().themeData;

    return pumpApp(
      Theme(data: themeData, child: child),
      layout: layout,
    );
  }
}
