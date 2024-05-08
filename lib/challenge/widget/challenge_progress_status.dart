import 'package:board_info_repository/board_info_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/challenge/challenge.dart';

class ChallengeProgressStatus extends StatelessWidget {
  const ChallengeProgressStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChallengeBloc(
        boardInfoRepository: context.read<BoardInfoRepository>(),
      )..add(const ChallengeDataRequested()),
      child: const ChallengeProgressStatusView(),
    );
  }
}

@visibleForTesting
class ChallengeProgressStatusView extends StatelessWidget {
  @visibleForTesting
  const ChallengeProgressStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChallengeBloc, ChallengeState, (int, int)>(
      selector: (state) => (state.solvedWords, state.totalWords),
      builder: (context, words) {
        return ChallengeProgress(
          solvedWords: words.$1,
          totalWords: words.$2,
        );
      },
    );
  }
}
