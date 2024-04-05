import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/welcome/welcome.dart';

void main() {
  group('$WelcomePage', () {
    testWidgets('displays a $WelcomeView', (tester) async {
      await tester.pumpSubject(const _Subject(child: WelcomePage()));

      expect(find.byType(WelcomeView), findsOneWidget);
    });
  });

  group('$WelcomeView', () {
    testWidgets('displays a $ChallengeProgress', (tester) async {
      await tester.pumpSubject(const _Subject(child: WelcomeView()));

      expect(find.byType(ChallengeProgress), findsOneWidget);
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
