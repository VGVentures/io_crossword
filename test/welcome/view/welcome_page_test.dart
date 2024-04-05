import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/welcome/welcome.dart';

void main() {
  group('$WelcomePage', () {
    testWidgets('displays a $WelcomeView', (tester) async {
      await tester.pumpSubject(const WelcomePage());

      expect(find.byType(WelcomeView), findsOneWidget);
    });
  });

  group('$WelcomeView', () {
    group('displays', () {
      testWidgets('a $ChallengeProgress', (tester) async {
        await tester.pumpSubject(const WelcomeView());
        expect(find.byType(ChallengeProgress), findsOneWidget);
      });

      testWidgets('a $WelcomeHeaderImage', (tester) async {
        await tester.pumpSubject(const WelcomeView());
        expect(find.byType(WelcomeHeaderImage), findsOneWidget);
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
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: child,
    );
  }
}
