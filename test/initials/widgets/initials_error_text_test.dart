import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:io_crossword/l10n/l10n.dart';

void main() {
  group('$InitialsErrorText', () {
    testWidgets('renders successfully', (tester) async {
      await tester.pumpSubject(
        const InitialsErrorText(InitialsInputError.format),
      );

      expect(find.byType(InitialsErrorText), findsOneWidget);
    });

    testWidgets('shows error icon', (tester) async {
      await tester.pumpSubject(
        const InitialsErrorText(InitialsInputError.format),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    group('localizes text', () {
      testWidgets(
        'for format error',
        (tester) async {
          late final AppLocalizations l10n;
          await tester.pumpSubject(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const InitialsErrorText(InitialsInputError.format);
              },
            ),
          );

          final richText = tester.widget<RichText>(find.byType(RichText).first);
          expect(
            richText.text.toPlainText(),
            contains(l10n.initialsErrorMessage),
          );
        },
      );

      testWidgets(
        'for blocklisted error',
        (tester) async {
          late final AppLocalizations l10n;
          await tester.pumpSubject(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const InitialsErrorText(InitialsInputError.blocklisted);
              },
            ),
          );

          final richText = tester.widget<RichText>(find.byType(RichText).first);
          expect(
            richText.text.toPlainText(),
            contains(l10n.initialsBlacklistedMessage),
          );
        },
      );

      testWidgets(
        'for processing error',
        (tester) async {
          late final AppLocalizations l10n;
          await tester.pumpSubject(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const InitialsErrorText(InitialsInputError.processing);
              },
            ),
          );

          final richText = tester.widget<RichText>(find.byType(RichText).first);
          expect(
            richText.text.toPlainText(),
            contains(l10n.initialsSubmissionErrorMessage),
          );
        },
      );
    });
  });
}

extension on WidgetTester {
  /// Pumps the test subject with all its required ancestors.
  Future<void> pumpSubject(
    Widget child, {
    ThemeData? themeData,
  }) =>
      pumpWidget(
        _Subject(
          themeData: themeData,
          child: child,
        ),
      );
}

class _Subject extends StatelessWidget {
  const _Subject({
    required this.child,
    this.themeData,
  });

  final ThemeData? themeData;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Localizations(
        locale: const Locale('en'),
        delegates: AppLocalizations.localizationsDelegates,
        child: Theme(
          data: themeData ?? ThemeData(),
          child: child,
        ),
      ),
    );
  }
}
