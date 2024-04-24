import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final l10n = context.l10n;
    final layout = IoLayout.of(context);

    return Scaffold(
      appBar: IoAppBar(
        crossword: l10n.crossword,
      ),
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

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 400,
            height: 800,
            child: LookUp(mascot!),
          ),
        ),
        if (isCreating)
          const Align(child: CircularProgressIndicator())
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              48,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 375),
                      child: SingleChildScrollView(
                        child: HowToPlayContent(mascot: mascot),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => context.flow<GameIntroStatus>().complete(),
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

    return Stack(
      children: [
        Positioned.fill(
          bottom: -100,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 400,
              height: 800,
              child: LookUp(mascot!),
            ),
          ),
        ),
        if (isCreating)
          const Align(child: CircularProgressIndicator())
        else
          Padding(
            padding: const EdgeInsets.all(24),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 539,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      HowToPlayContent(mascot: mascot),
                      const SizedBox(height: 40),
                      OutlinedButton(
                        onPressed: () =>
                            context.flow<GameIntroStatus>().complete(),
                        child: Text(l10n.playNow),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
