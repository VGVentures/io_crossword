import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/extensions/extensions.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/leaderboard/view/leaderboard_page.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/project_details/project_details.dart';
import 'package:io_crossword/share/share.dart';
import 'package:io_crossword/widget/widget.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

part '../widgets/leaderboard_button.dart';
part 'end_game_view_content.dart';

class EndGamePage extends StatelessWidget {
  const EndGamePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const EndGamePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    return switch (layout) {
      IoLayoutData.large => const EndGameLargeView(),
      IoLayoutData.small => const EndGameSmallView(),
    };
  }
}

@visibleForTesting
class EndGameLargeView extends StatelessWidget {
  @visibleForTesting
  const EndGameLargeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 512),
            child: const Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LeaderboardButton(),
                  SizedBox(height: 48),
                  EndGameContent(),
                  SizedBox(height: 48),
                  ActionButtonsEndGame(),
                ],
              ),
            ),
          ),
        ),
      ),
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
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EndGameContent(),
              SizedBox(height: 24),
              ActionButtonsEndGame(),
            ],
          ),
        ),
      ),
    );
  }
}
