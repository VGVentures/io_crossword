import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword/about/link/about_links.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/extensions/context_ext.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/leaderboard/view/leaderboard_page.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

part '../widgets/leaderboard_button.dart';
part 'end_game_view_content.dart';

class EndGameView extends StatelessWidget {
  const EndGameView({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    return switch (layout) {
      IoLayoutData.large => const EngGameLargeView(),
      IoLayoutData.small => const EndGameSmallView(),
    };
  }
}

@visibleForTesting
class EngGameLargeView extends StatelessWidget {
  @visibleForTesting
  const EngGameLargeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 31,
          ),
          child: LeaderboardButton(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 80,
          ),
          child: EndGameContent(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 56,
          ),
          child: ActionButtonsEndGame(),
        ),
      ],
    );
  }
}

@visibleForTesting
class EndGameSmallView extends StatelessWidget {
  @visibleForTesting
  const EndGameSmallView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: IoAppBar(
        crossword: l10n.crossword,
        title: const LeaderboardButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Assets.images.endImage.image(
                fit: BoxFit.fitWidth,
                height: 150,
              ),
              const SizedBox(height: 24),
              const EndGameContent(),
              const SizedBox(height: 24),
              const ActionButtonsEndGame(),
            ],
          ),
        ),
      ),
    );
  }
}
