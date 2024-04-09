import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/about/about.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/initials/view/initials_page.dart';
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
          onComplete: (_) {
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
    GameIntroStatus.mascotSelection => [MascotSelectionView.page()],
    GameIntroStatus.initialsInput => [InitialsPage.page()],
  };
}
