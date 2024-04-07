import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

void main() {
  group('$InitialsSubmitButton', () {
    testWidgets('renders successfully', (tester) async {
      await tester.pumpSubject(InitialsSubmitButton(onPressed: () {}));
      expect(find.byType(InitialsSubmitButton), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var calls = 0;

      await tester.pumpSubject(
        InitialsSubmitButton(
          onPressed: () {
            calls++;
          },
        ),
      );

      await tester.tap(find.byType(OutlinedButton));
      expect(
        calls,
        equals(1),
        reason: 'onPressed should be called once when the button is tapped',
      );
    });

    group('when layout is small', () {
      testWidgets('renders text as bodySmall', (tester) async {
        final themeData = IoCrosswordTheme().themeData;
        final textStyle = themeData.textTheme.bodySmall!.copyWith(
          inherit: false,
        );

        await tester.pumpSubject(
          layout: IoLayoutData.small,
          themeData: themeData.copyWith(
            textTheme: themeData.textTheme.copyWith(
              bodySmall: textStyle,
            ),
          ),
          InitialsSubmitButton(onPressed: () {}),
        );

        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style, equals(textStyle));
      });
    });

    group('when layout is large', () {
      testWidgets('renders text as bodyMedium', (tester) async {
        final themeData = IoCrosswordTheme().themeData;
        final textStyle = themeData.textTheme.bodySmall!.copyWith(
          inherit: false,
        );

        await tester.pumpSubject(
          layout: IoLayoutData.large,
          themeData: themeData.copyWith(
            textTheme: themeData.textTheme.copyWith(
              bodyMedium: textStyle,
            ),
          ),
          InitialsSubmitButton(onPressed: () {}),
        );

        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style, equals(textStyle));
      });
    });
  });
}

extension on WidgetTester {
  /// Pumps the test subject with all its required ancestors.
  Future<void> pumpSubject(
    Widget child, {
    ThemeData? themeData,
    IoLayoutData? layout,
  }) =>
      pumpWidget(
        _Subject(
          themeData: themeData,
          layout: layout,
          child: child,
        ),
      );
}

class _Subject extends StatelessWidget {
  const _Subject({
    required this.child,
    this.themeData,
    this.layout,
  });

  final IoLayoutData? layout;

  final ThemeData? themeData;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeData = this.themeData ?? ThemeData();

    return Localizations(
      delegates: AppLocalizations.localizationsDelegates,
      locale: const Locale('en'),
      child: IoLayout(
        data: layout ?? IoLayoutData.small,
        child: Theme(
          data: themeData,
          child: child,
        ),
      ),
    );
  }
}
