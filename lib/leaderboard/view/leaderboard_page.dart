import 'package:authentication_repository/authentication_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/extensions/extensions.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

part 'leaderboard_success.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const LeaderboardPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LeaderboardBloc>(
      create: (context) => LeaderboardBloc(
        leaderboardRepository: context.read<LeaderboardRepository>(),
      )..add(
          LoadRequestedLeaderboardEvent(
            userId: context.read<User>().id,
          ),
        ),
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

    return Scaffold(
      appBar: IoAppBar(
        title: Text(l10n.leaderboard),
        crossword: l10n.crossword,
        actions: (context) {
          return const CloseButton();
        },
      ),
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
