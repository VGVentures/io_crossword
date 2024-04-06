import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:io_crossword/l10n/l10n.dart';

void main() {
  group('$InitialsPage', () {
    testWidgets('displays an $InitialsView', (tester) async {
      await tester.pumpSubject(const InitialsPage());

      expect(find.byType(InitialsView), findsOneWidget);
    });
  });

  group('$InitialsView', () {
    group('displays', () {
      testWidgets('a placeholder', (tester) async {
        await tester.pumpSubject(const InitialsView());

        expect(find.byType(Placeholder), findsOneWidget);
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
