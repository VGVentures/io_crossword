import 'package:api_client/api_client.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/game_intro/bloc/game_intro_bloc.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/initials/view/initials_page.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/loading/loading.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword/welcome/welcome.dart';

class GameIntroPage extends StatelessWidget {
  const GameIntroPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const GameIntroPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameIntroBloc>(
      create: (_) => GameIntroBloc(
        leaderboardResource: context.read<LeaderboardResource>(),
      ),
      child: const GameIntroView(),
    );
  }
}

enum GameIntroStatus {
  loading,
  welcome,
  teamSelection,
  enterInitials,
  howToPlay,
}

@visibleForTesting
class GameIntroView extends StatelessWidget {
  @visibleForTesting
  const GameIntroView({
    super.key,
    @visibleForTesting FlowController<GameIntroStatus>? flowController,
  }) : _flowController = flowController;

  final FlowController<GameIntroStatus>? _flowController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final loadingStatus = context.read<LoadingCubit>().state.status;

    return BlocListener<GameIntroBloc, GameIntroState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case GameIntroPlayerCreationStatus.initial:
          case GameIntroPlayerCreationStatus.inProgress:
            break;
          case GameIntroPlayerCreationStatus.success:
            Navigator.of(context).pushReplacement(CrosswordPage.route());
          case GameIntroPlayerCreationStatus.failure:
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(l10n.errorPromptText),
                  behavior: SnackBarBehavior.floating,
                ),
              );
        }
      },
      child: Material(
        child: FlowBuilder<GameIntroStatus>(
          controller: _flowController,
          state: _flowController == null
              ? loadingStatus == LoadingStatus.loaded
                  ? GameIntroStatus.welcome
                  : GameIntroStatus.loading
              : null,
          onGeneratePages: onGenerateGameIntroPages,
          onComplete: (state) {
            final playerState = context.read<PlayerBloc>().state;

            context.read<GameIntroBloc>().add(
                  GameIntroPlayerCreated(
                    initials: playerState.player.initials,
                    mascot: playerState.mascot,
                  ),
                );
          },
        ),
      ),
    );
  }
}

List<Page<void>> onGenerateGameIntroPages(
  GameIntroStatus state,
  List<Page<void>> pages,
) {
  return switch (state) {
    GameIntroStatus.loading => [LoadingPage.page()],
    GameIntroStatus.welcome => [WelcomePage.page()],
    GameIntroStatus.teamSelection => [TeamSelectionPage.page()],
    GameIntroStatus.enterInitials => [InitialsPage.page()],
    GameIntroStatus.howToPlay => [HowToPlayPage.page()],
  };
}
