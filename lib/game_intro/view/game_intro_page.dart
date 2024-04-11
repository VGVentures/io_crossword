import 'package:api_client/api_client.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/about/about.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/initials/view/initials_page.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword/welcome/welcome.dart';

class GameIntroPage extends StatelessWidget {
  const GameIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GameIntroView();
  }
}

enum GameIntroStatus {
  welcome,
  teamSelection,
  enterInitials,
  howToPlay,
}

class GameIntroView extends StatelessWidget {
  const GameIntroView({
    super.key,
    @visibleForTesting FlowController<GameIntroStatus>? flowController,
  }) : _flowController = flowController;

  final FlowController<GameIntroStatus>? _flowController;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FlowBuilder<GameIntroStatus>(
        controller: _flowController,
        state: _flowController == null ? GameIntroStatus.welcome : null,
        onGeneratePages: onGenerateGameIntroPages,
        onComplete: (state) {
          // coverage:ignore-start
          // TODO(alestiago): Handle this creation.
          // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6422014818
          context.read<LeaderboardResource>().createScore(
                initials: 'AAA',
                mascot: Mascots.dash,
              );
          // coverage:ignore-end

          Navigator.of(context).pushReplacement(CrosswordPage.route());
        },
      ),
    );
  }
}

List<Page<void>> onGenerateGameIntroPages(
  GameIntroStatus state,
  List<Page<void>> pages,
) {
  return switch (state) {
    GameIntroStatus.welcome => [WelcomePage.page()],
    GameIntroStatus.teamSelection => [TeamSelectionPage.page()],
    GameIntroStatus.enterInitials => [InitialsPage.page()],
    GameIntroStatus.howToPlay => [HowToPlayPage.page()],
  };
}
