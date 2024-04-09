import 'package:api_client/api_client.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/about/about.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/initials/view/initials_page.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword/welcome/view/welcome_page.dart';

class GameIntroPage extends StatelessWidget {
  const GameIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameIntroBloc(),
      child: const GameIntroView(),
    );
  }
}

class GameIntroView extends StatelessWidget {
  const GameIntroView({
    super.key,
    @visibleForTesting FlowController<GameIntroState>? flowController,
  }) : _flowController = flowController;

  final FlowController<GameIntroState>? _flowController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameIntroBloc, GameIntroState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == GameIntroStatus.initialsInput) {
          context
              .read<CrosswordBloc>()
              .add(MascotSelected(state.selectedMascot));
        }
      },
      child: Material(
        child: FlowBuilder<GameIntroState>(
          controller: _flowController,
          state: _flowController == null
              ? context.select((GameIntroBloc bloc) => bloc.state)
              : null,
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
            AboutView.showModal(context);
          },
        ),
      ),
    );
  }
}

List<Page<void>> onGenerateGameIntroPages(
  GameIntroState state,
  List<Page<void>> pages,
) {
  return switch (state.status) {
    GameIntroStatus.welcome => [WelcomePage.page()],
    GameIntroStatus.mascotSelection => [TeamSelectionPage.page()],
    GameIntroStatus.initialsInput => [InitialsPage.page()],
  };
}
