import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('$HowToPlayPage', () {
    testWidgets('displays a $HowToPlayView', (tester) async {
      await tester.pumpApp(const HowToPlayPage());

      expect(find.byType(HowToPlayView), findsOneWidget);
    });
  });

  group('$HowToPlayView', () {
    testWidgets('completes flow when button is pressed', (tester) async {
      final flowController = FlowController(GameIntroStatus.howToPlay);
      addTearDown(flowController.dispose);

      await tester.pumpApp(
        FlowBuilder<GameIntroStatus>(
          controller: flowController,
          onGeneratePages: (_, __) => [
            const MaterialPage(child: HowToPlayPage()),
          ],
        ),
      );

      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();

      expect(flowController.completed, isTrue);
    });

    group('displays', () {
      testWidgets('an $OutlinedButton', (tester) async {
        await tester.pumpApp(const HowToPlayView());

        expect(find.byType(OutlinedButton), findsOneWidget);
      });

      testWidgets('localized playNow text', (tester) async {
        late final AppLocalizations l10n;

        await tester.pumpApp(
          Builder(
            builder: (context) {
              l10n = context.l10n;
              return const HowToPlayView();
            },
          ),
        );

        expect(find.text(l10n.playNow), findsOneWidget);
      });
    });
  });
}
