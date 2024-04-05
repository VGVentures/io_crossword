import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

void main() {
  group('ResponsiveLayout', () {
    testWidgets('displays a large layout', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(IoCrosswordBreakpoints.medium, 800),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const smallKey = Key('__small__');
      const largeKey = Key('__large__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(key: smallKey),
          large: (_, __) => const SizedBox(key: largeKey),
        ),
      );

      expect(find.byKey(largeKey), findsOneWidget);
      expect(find.byKey(smallKey), findsNothing);
    });

    testWidgets('displays a small layout', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(IoCrosswordBreakpoints.medium, 1200),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const smallKey = Key('__small__');
      const largeKey = Key('__large__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(key: smallKey),
          large: (_, __) => const SizedBox(key: largeKey),
        ),
      );

      expect(find.byKey(largeKey), findsNothing);
      expect(find.byKey(smallKey), findsOneWidget);
    });

    testWidgets('displays child when available (large)', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(IoCrosswordBreakpoints.medium, 800),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const smallKey = Key('__small__');
      const largeKey = Key('__large__');
      const childKey = Key('__child__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox(key: smallKey, child: child),
          large: (_, child) => SizedBox(key: largeKey, child: child),
          child: const SizedBox(key: childKey),
        ),
      );

      expect(find.byKey(largeKey), findsOneWidget);
      expect(find.byKey(smallKey), findsNothing);
      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('displays child when available (small)', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(IoCrosswordBreakpoints.medium - 1, 800),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const smallKey = Key('__small__');
      const largeKey = Key('__large__');
      const childKey = Key('__child__');
      await Future.microtask(() {});

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox(key: smallKey, child: child),
          large: (_, child) => SizedBox(key: largeKey, child: child),
          child: const SizedBox(key: childKey),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(largeKey), findsNothing);
      expect(find.byKey(smallKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
