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
    testWidgets(
      'does nothing when getting started button is pressed',
      (tester) async {
        await tester.pumpSubject(const WelcomeView());

        await tester.tap(find.byType(OutlinedButton));
        await tester.pump();

        expect(
          find.byType(WelcomeView),
          findsOneWidget,
          reason: 'No navigation occurs when the button is pressed.',
        );
      },
    );

    group('displays', () {
      testWidgets('a $ChallengeProgress', (tester) async {
        await tester.pumpSubject(const WelcomeView());
        expect(find.byType(ChallengeProgress), findsOneWidget);
      });

      testWidgets('a $WelcomeHeaderImage', (tester) async {
        await tester.pumpSubject(const WelcomeView());
        expect(find.byType(WelcomeHeaderImage), findsOneWidget);
      });

      testWidgets('a localized welcome text', (tester) async {
        late final AppLocalizations l10n;
        await tester.pumpSubject(
          Builder(
            builder: (context) {
              l10n = context.l10n;
              return const WelcomeView();
            },
          ),
        );

        expect(find.text(l10n.welcome), findsOneWidget);
      });

      testWidgets('a localized welcomeSubtitle text', (tester) async {
        late final AppLocalizations l10n;
        await tester.pumpSubject(
          Builder(
            builder: (context) {
              l10n = context.l10n;
              return const WelcomeView();
            },
          ),
        );

        expect(find.text(l10n.welcomeSubtitle), findsOneWidget);
      });

      testWidgets(
        'an $OutlinedButton with a localized getStarted text',
        (tester) async {
          late final AppLocalizations l10n;
          await tester.pumpSubject(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const WelcomeView();
              },
            ),
          );

          final outlinedButtonFinder = find.byType(OutlinedButton);
          expect(outlinedButtonFinder, findsOneWidget);

          final outlinedButton =
              tester.widget<OutlinedButton>(outlinedButtonFinder);
          expect(
            outlinedButton.child,
            isA<Text>().having((text) => text.data, 'data', l10n.getStarted),
          );
        },
      );
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
