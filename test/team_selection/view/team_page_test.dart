import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/team_selection/team.dart';

void main() {
  group('$TeamSelectionPage', () {
    testWidgets('displays a $TeamSelectionPage', (tester) async {
      await tester.pumpSubject(const TeamSelectionPage());

      expect(find.byType(TeamSelectionPage), findsOneWidget);
    });
  });

  group('$TeamSelectionView', () {
    group('displays', () {
      testWidgets('a placeholder', (tester) async {
        await tester.pumpSubject(const TeamSelectionView());

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