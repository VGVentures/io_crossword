import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../../test_tag.dart';

void main() {
  group('$IoPhysicalModel', () {
    testWidgets('renders successfully', (tester) async {
      await tester.pumpWidget(
        Theme(
          data: IoCrosswordTheme().themeData,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: IoPhysicalModel(child: SizedBox()),
          ),
        ),
      );
      expect(find.byType(IoPhysicalModel), findsOneWidget);
    });

    group('renders as expected', () {
      Uri goldenKey(String name) =>
          Uri.parse('goldens/io_physical_model/io_physical_model__$name.png');

      testWidgets(
        'with default theme',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(200, 150));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoCrosswordTheme().themeData;

          await tester.pumpWidget(
            _GoldenSubject(
              themeData: themeData.copyWith(
                cardTheme: themeData.io.cardTheme.elevated,
              ),
              child: const IoPhysicalModel(
                child: Card(
                  child: SizedBox.square(dimension: 100),
                ),
              ),
            ),
          );

          await expectLater(
            find.byType(IoPhysicalModel),
            matchesGoldenFile(goldenKey('default')),
          );
        },
      );

      testWidgets(
        'with Android theme',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(200, 150));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoAndroidTheme().themeData;

          await tester.pumpWidget(
            _GoldenSubject(
              themeData: themeData.copyWith(
                cardTheme: themeData.io.cardTheme.elevated,
              ),
              child: const IoPhysicalModel(
                child: Card(
                  child: SizedBox.square(dimension: 100),
                ),
              ),
            ),
          );

          await expectLater(
            find.byType(IoPhysicalModel),
            matchesGoldenFile(goldenKey('android')),
          );
        },
      );

      testWidgets(
        'with Chrome theme',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(200, 150));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoChromeTheme().themeData;

          await tester.pumpWidget(
            _GoldenSubject(
              themeData: themeData.copyWith(
                cardTheme: themeData.io.cardTheme.elevated,
              ),
              child: const IoPhysicalModel(
                child: Card(
                  child: SizedBox.square(dimension: 100),
                ),
              ),
            ),
          );

          await expectLater(
            find.byType(IoPhysicalModel),
            matchesGoldenFile(goldenKey('chrome')),
          );
        },
      );

      testWidgets(
        'with Firebase theme',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(200, 150));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoFirebaseTheme().themeData;

          await tester.pumpWidget(
            _GoldenSubject(
              themeData: themeData.copyWith(
                cardTheme: themeData.io.cardTheme.elevated,
              ),
              child: const IoPhysicalModel(
                child: Card(
                  child: SizedBox.square(dimension: 100),
                ),
              ),
            ),
          );

          await expectLater(
            find.byType(IoPhysicalModel),
            matchesGoldenFile(goldenKey('firebase')),
          );
        },
      );

      testWidgets(
        'with Flutter theme',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(200, 150));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoFlutterTheme().themeData;

          await tester.pumpWidget(
            _GoldenSubject(
              themeData: themeData.copyWith(
                cardTheme: themeData.io.cardTheme.elevated,
              ),
              child: const IoPhysicalModel(
                child: Card(
                  child: SizedBox.square(dimension: 100),
                ),
              ),
            ),
          );

          await expectLater(
            find.byType(IoPhysicalModel),
            matchesGoldenFile(goldenKey('flutter')),
          );
        },
      );
    });
  });

  group('$IoPhysicalModelStyle', () {
    test('lerps', () {
      final from = IoPhysicalModelStyle(
        elevation: 1,
        border: Border.all(color: const Color(0xFF00FF00)),
        borderRadius: const BorderRadius.all(Radius.circular(1)),
        gradient: const LinearGradient(
          colors: [Color(0xFF00FF00), Color(0xFF00FF00)],
        ),
      );
      final to = IoPhysicalModelStyle(
        elevation: 2,
        border: Border.all(color: const Color(0xFF0000FF)),
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        gradient: const LinearGradient(
          colors: [Color(0xFF0000FF), Color(0xFF0000FF)],
        ),
      );

      final lerp = from.lerp(to, 0.5);

      expect(lerp.elevation, 1.5);

      expect(lerp.border, isNot(from.border));
      expect(lerp.border, isNot(to.border));
      expect(lerp.border.top.color, const Color(0xFF007F7F));

      expect(lerp.gradient, isNot(from.gradient));
      expect(lerp.gradient, isNot(to.gradient));
      expect(lerp.gradient.colors.first, const Color(0xFF007F7F));

      expect(lerp.borderRadius, isNot(from.borderRadius));
      expect(lerp.borderRadius, isNot(to.borderRadius));
      expect(lerp.borderRadius.topLeft.x, 1.5);
    });
  });
}

class _GoldenSubject extends StatelessWidget {
  const _GoldenSubject({
    required this.themeData,
    required this.child,
  });

  final ThemeData themeData;

  final IoPhysicalModel child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeData,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: themeData.colorScheme.surface,
          child: Center(child: child),
        ),
      ),
    );
  }
}
