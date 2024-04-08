import 'package:api_client/api_client.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/extensions/extensions.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

part 'leaderboard_success.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LeaderboardBloc>(
      create: (context) => LeaderboardBloc(
        leaderboardResource: context.read<LeaderboardResource>(),
      )..add(const LoadRequestedLeaderboardEvent()),
      child: const LeaderboardView(),
    );
  }
}

class LeaderboardView extends StatelessWidget {
  @visibleForTesting
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final layout = IoLayout.of(context);

    return Scaffold(
      appBar: switch (layout) {
        IoLayoutData.small => AppBar(
            leading: const SizedBox.shrink(),
            leadingWidth: 0,
            title: Text(l10n.leaderboard),
            centerTitle: false,
            actions: const [
              CloseButton(),
            ],
          ),
        // TODO(Ayad): create app bar with logo
        // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6409053334
        IoLayoutData.large => AppBar(
            leading: const Placeholder(
              color: Colors.white,
            ),
            leadingWidth: 170,
            centerTitle: true,
            title: Text(l10n.leaderboard),
            actions: [
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.gamepad),
                label: Text(l10n.playAgain),
              ),
              const SizedBox(width: 7),
              const CloseButton(),
            ],
          ),
      },
      body: BlocBuilder<LeaderboardBloc, LeaderboardState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          switch (state.status) {
            case LeaderboardStatus.initial:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case LeaderboardStatus.success:
              return const LeaderboardSuccess();
            case LeaderboardStatus.failure:
              return ErrorView(
                title: l10n.errorPromptText,
              );
          }
        },
      ),
    );
  }
}
