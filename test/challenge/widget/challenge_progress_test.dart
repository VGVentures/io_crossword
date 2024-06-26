// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/challenge/challenge.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

void main() {
  group('$ChallengeProgress', () {
    group('displays', () {
      group('IoLinearProgressIndicator', () {
        testWidgets(
          'successfully',
          (tester) async {
            await tester.pumpSubject(
              const ChallengeProgress(solvedWords: 0, totalWords: 10),
            );

            expect(find.byType(ChallengeProgress), findsOneWidget);
          },
        );

        testWidgets(
          'with value 0 when no words are solved',
          (tester) async {
            await tester.pumpSubject(
              const ChallengeProgress(solvedWords: 0, totalWords: 1),
            );

            expect(
              tester
                  .widget<IoLinearProgressIndicator>(
                    find.byType(IoLinearProgressIndicator),
                  )
                  .value,
              equals(0),
            );
          },
        );

        testWidgets(
          'with value 0 when total words is 0',
          (tester) async {
            await tester.pumpSubject(
              const ChallengeProgress(solvedWords: 1, totalWords: 0),
            );

            expect(
              tester
                  .widget<IoLinearProgressIndicator>(
                    find.byType(IoLinearProgressIndicator),
                  )
                  .value,
              equals(0),
            );
          },
        );

        testWidgets(
          'with value 0.5 when no half the words are solved',
          (tester) async {
            await tester.pumpSubject(
              const ChallengeProgress(solvedWords: 1, totalWords: 2),
            );

            expect(
              tester
                  .widget<IoLinearProgressIndicator>(
                    find.byType(IoLinearProgressIndicator),
                  )
                  .value,
              equals(0.5),
            );
          },
        );
      });

      testWidgets(
        'countdownToCompletion',
        (tester) async {
          late final AppLocalizations l10n;

          await tester.pumpSubject(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const ChallengeProgress(solvedWords: 0, totalWords: 1);
              },
            ),
          );

          expect(find.text(l10n.countdownToCompletion), findsOneWidget);
        },
      );

      testWidgets(
        'displays words solved and total words',
        (tester) async {
          await tester.pumpSubject(
            const ChallengeProgress(solvedWords: 10500, totalWords: 50400),
          );

          await tester.pumpAndSettle();

          final solvedWordFinder = find.byKey(ChallengeProgress.solvedWordsKey);
          expect(solvedWordFinder, findsOne);

          final solvedWord = tester.widget<Text>(solvedWordFinder).data;
          expect(solvedWord, equals('10,500'));

          final totalWordFinder = find.byKey(ChallengeProgress.totalWordsKey);
          expect(totalWordFinder, findsOne);

          final totalWord = tester.widget<Text>(totalWordFinder).data;
          expect(totalWord, equals('50,400'));
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
    final themeData = IoCrosswordTheme().themeData;

    return Localizations(
      delegates: AppLocalizations.localizationsDelegates,
      locale: const Locale('en'),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Theme(data: themeData, child: Material(child: child)),
      ),
    );
  }
}
