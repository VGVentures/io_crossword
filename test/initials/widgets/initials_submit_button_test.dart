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

    testWidgets('displays localized enter text', (tester) async {
      late final AppLocalizations l10n;

      await tester.pumpSubject(
        Builder(
          builder: (context) {
            l10n = context.l10n;
            return InitialsSubmitButton(onPressed: () {});
          },
        ),
      );

      expect(find.text(l10n.enter), findsOneWidget);
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
