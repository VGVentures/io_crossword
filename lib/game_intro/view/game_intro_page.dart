import 'package:api_client/api_client.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/about/about.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/welcome/view/welcome_page.dart';

class GameIntroPage extends StatelessWidget {
  const GameIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameIntroBloc(
        boardInfoRepository: context.read<BoardInfoRepository>(),
        leaderboardResource: context.read<LeaderboardResource>(),
      )
        ..add(const BoardProgressRequested())
        ..add(const BlacklistRequested()),
      child: const GameIntroView(),
    );
  }
}

class GameIntroView extends StatelessWidget {
  const GameIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameIntroBloc, GameIntroState>(
      listenWhen: (previous, current) =>
          (previous.status != current.status) || current.isIntroCompleted,
      listener: (context, state) {
        if (state.status == GameIntroStatus.initialsInput) {
          context
              .read<CrosswordBloc>()
              .add(MascotSelected(state.selectedMascot));
        }
        if (state.isIntroCompleted) {
          context.read<CrosswordBloc>().add(InitialsSelected(state.initials));

          Navigator.of(context).pushReplacement(CrosswordPage.route());
          AboutView.showModal(context);
        }
      },
      child: Material(
        child: FlowBuilder<GameIntroState>(
          state: context.select((GameIntroBloc bloc) => bloc.state),
          onGeneratePages: onGenerateGameIntroPages,
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
    GameIntroStatus.mascotSelection => [MascotSelectionView.page()],
    GameIntroStatus.initialsInput => [InitialsInputView.page()],
  };
}
