import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';

class PlayNowButton extends StatelessWidget {
  const PlayNowButton({super.key});

  void _onPressed(BuildContext context) {
    context.read<PlayerBloc>().add(const PlayerCreateScoreRequested());
    context.read<HowToPlayCubit>().updateStatus(HowToPlayStatus.pickingUp);
    context.read<AudioController>().playSfx(Assets.music.startButton1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return OutlinedButton(
      onPressed: () => _onPressed(context),
      child: Text(l10n.playNow),
    );
  }
}
