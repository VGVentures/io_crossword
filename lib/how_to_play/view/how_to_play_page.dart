import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/about/view/about_view.dart';
import 'package:io_crossword/game_intro/bloc/game_intro_bloc.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class HowToPlayPage extends StatelessWidget {
  const HowToPlayPage({super.key});

  static Page<void> page() {
    return const MaterialPage(child: HowToPlayPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HowToPlayCubit(),
      child: const HowToPlayView(),
    );
  }
}

@visibleForTesting
class HowToPlayView extends StatelessWidget {
  @visibleForTesting
  const HowToPlayView({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    return Scaffold(
      body: switch (layout) {
        IoLayoutData.small => const _HowToPlaySmall(),
        IoLayoutData.large => const _HowToPlayLarge(),
      },
    );
  }
}

class _HowToPlaySmall extends StatelessWidget {
  const _HowToPlaySmall();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final isCreating = context.select(
      (GameIntroBloc bloc) =>
          bloc.state.status == GameIntroPlayerCreationStatus.inProgress,
    );

    final mascot = context.select((PlayerBloc bloc) => bloc.state.mascot);

    void onPlay(BuildContext context) {
      context.flow<GameIntroStatus>().complete();
    }

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 200,
            height: 400,
            child: LookUp(mascot!),
          ),
        ),
        if (isCreating)
          const Align(child: CircularProgressIndicator())
        else
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: AboutHowToPlayContent(),
                  ),
                  OutlinedButton(
                    onPressed: () => onPlay(context),
                    child: Text(l10n.playNow),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _HowToPlayLarge extends StatelessWidget {
  const _HowToPlayLarge();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final isCreating = context.select(
      (GameIntroBloc bloc) =>
          bloc.state.status == GameIntroPlayerCreationStatus.inProgress,
    );

    final mascot = context.select((PlayerBloc bloc) => bloc.state.mascot);

    void onPlay(BuildContext context) {
      context.flow<GameIntroStatus>().complete();
    }

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 200,
            height: 400,
            child: LookUp(mascot!),
          ),
        ),
        Align(
          child: isCreating
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Flexible(
                      child: SizedBox(
                        width: 500,
                        child: AboutHowToPlayContent(),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => onPlay(context),
                      child: Text(l10n.playNow),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
