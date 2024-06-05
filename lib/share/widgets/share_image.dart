import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/player/player.dart';

class ShareImage extends StatelessWidget {
  const ShareImage({super.key});

  @override
  Widget build(BuildContext context) {
    final mascot =
        context.select((PlayerBloc bloc) => bloc.state.player.mascot);

    final image = switch (mascot) {
      Mascot.dash => Assets.images.shareDash,
      Mascot.android => Assets.images.shareAndroid,
      Mascot.dino => Assets.images.shareDino,
      Mascot.sparky => Assets.images.shareSparky,
    };

    return image.image(
      fit: BoxFit.fitWidth,
    );
  }
}
