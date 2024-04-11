// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:api_client/api_client.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/initials/view/initials_page.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword/welcome/view/welcome_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

void main() {
  group('GameIntroPage', () {
    testWidgets('renders GameIntroView', (tester) async {
      await tester.pumpApp(GameIntroPage());

      expect(find.byType(GameIntroView), findsOneWidget);
    });
  });

  group('GameIntroView', () {
    testWidgets(
      'renders the $WelcomePage by default',
      (tester) async {
        await tester.pumpApp(GameIntroView());

        expect(find.byType(WelcomePage), findsOneWidget);
      },
    );

    testWidgets(
      'renders the $WelcomePage with the state is welcome',
      (tester) async {
        final flowController =
            FlowController<GameIntroStatus>(GameIntroStatus.welcome);
        addTearDown(flowController.dispose);

        await tester.pumpApp(
          GameIntroView(
            flowController: flowController,
          ),
        );

        expect(find.byType(WelcomePage), findsOneWidget);
      },
    );

    testWidgets(
      'renders the $TeamSelectionPage when the status is teamSelection',
      (tester) async {
        final flowController =
            FlowController<GameIntroStatus>(GameIntroStatus.teamSelection);
        addTearDown(flowController.dispose);

        await tester.pumpApp(
          GameIntroView(
            flowController: flowController,
          ),
        );

        expect(find.byType(TeamSelectionPage), findsOneWidget);
      },
    );

    testWidgets(
      'renders the $InitialsPage when the status is enterInitials',
      (tester) async {
        final flowController =
            FlowController<GameIntroStatus>(GameIntroStatus.enterInitials);
        addTearDown(flowController.dispose);

        await tester.pumpApp(
          GameIntroView(
            flowController: flowController,
          ),
        );

        expect(find.byType(InitialsPage), findsOneWidget);
      },
    );

    testWidgets(
      'renders the $HowToPlayPage when the status is howToPlay',
      (tester) async {
        final flowController =
            FlowController<GameIntroStatus>(GameIntroStatus.howToPlay);
        addTearDown(flowController.dispose);

        await tester.pumpApp(
          GameIntroView(
            flowController: flowController,
          ),
        );

        expect(find.byType(HowToPlayPage), findsOneWidget);
      },
    );

    testWidgets(
      'pops the navigator when completed',
      (tester) async {
        final flowController =
            FlowController<GameIntroStatus>(GameIntroStatus.enterInitials);
        addTearDown(flowController.dispose);

        final leaderboardResource = _MockLeaderboardResource();
        when(
          () => leaderboardResource.createScore(
            initials: 'AAA',
            mascot: Mascots.dash,
          ),
        ).thenAnswer((_) => Future.value());

        await tester.pumpApp(
          leaderboardResource: leaderboardResource,
          GameIntroView(flowController: flowController),
        );

        flowController.complete();

        await tester.pump();
        await tester.pump(const Duration(seconds: 5));

        expect(find.byType(GameIntroView), findsNothing);
      },
    );
  });
}
