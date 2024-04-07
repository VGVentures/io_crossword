import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

void main() {
  group('$InitialsPage', () {
    testWidgets('displays an $InitialsView', (tester) async {
      await tester.pumpSubject(const InitialsPage());

      expect(find.byType(InitialsView), findsOneWidget);
    });
  });

  group('$InitialsView', () {
    testWidgets(
      'does nothing when $InitialsSubmitButton is pressed',
      (tester) async {
        await tester.pumpSubject(const InitialsPage());

        final submitButtonFinder = find.byType(InitialsSubmitButton);
        await tester.ensureVisible(submitButtonFinder);
        await tester.pumpAndSettle();

        await tester.tap(submitButtonFinder);
        await tester.pumpAndSettle();

        expect(
          find.byType(InitialsPage),
          findsOneWidget,
          reason: 'No navigation occurs when the button is pressed.',
        );
      },
    );

    group('displays', () {
      testWidgets('a $IoWordInput of length 3', (tester) async {
        await tester.pumpSubject(const InitialsView());

        final ioWordInputFinder = find.byType(IoWordInput);
        expect(ioWordInputFinder, findsOneWidget);

        final ioWordInput = tester.widget<IoWordInput>(ioWordInputFinder);
        expect(
          ioWordInput.length,
          equals(3),
          reason: 'The initials should have a length of 3',
        );
      });

      testWidgets('a $InitialsSubmitButton', (tester) async {
        await tester.pumpSubject(const InitialsView());

        expect(find.byType(InitialsSubmitButton), findsOneWidget);
      });

      testWidgets('a localized enterInitials text', (tester) async {
        late final AppLocalizations l10n;
        await tester.pumpSubject(
          Builder(
            builder: (context) {
              l10n = context.l10n;
              return const InitialsView();
            },
          ),
        );

        expect(find.text(l10n.enterInitials), findsOneWidget);
      });
    });
  });
}

extension on WidgetTester {
  /// Pumps the test subject with all its required ancestors.
  Future<void> pumpSubject(Widget child) => pumpWidget(_Subject(child: child));
}

class _Subject extends StatelessWidget {
  const _Subject({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Localizations(
      delegates: AppLocalizations.localizationsDelegates,
      locale: const Locale('en'),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(child: child),
      ),
    );
  }
}
