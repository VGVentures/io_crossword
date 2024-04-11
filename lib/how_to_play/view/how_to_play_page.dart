import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';

class HowToPlayPage extends StatelessWidget {
  const HowToPlayPage({super.key});

  static Page<void> page() {
    return const MaterialPage(child: HowToPlayPage());
  }

  @override
  Widget build(BuildContext context) {
    return const HowToPlayView();
  }
}

class HowToPlayView extends StatelessWidget {
  const HowToPlayView({super.key});

  void _onPlay(BuildContext context) {
    context.flow<GameIntroStatus>().complete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () => _onPlay(context),
          child: Text(l10n.playNow),
        ),
      ),
    );
  }
}
