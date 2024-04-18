import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

class TeamSelectionMascotPlatform extends StatelessWidget {
  const TeamSelectionMascotPlatform({
    required this.mascot,
    required this.selected,
    super.key,
  });

  final Mascots mascot;

  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (selected) {
      final animation = SpriteAnimation.fromFrameData(
        Flame.images.fromCache(mascot.teamMascot.platformAnimation.path),
        SpriteAnimationData.sequenced(
          amount: 60,
          stepTime: 0.042,
          textureSize: Vector2(366, 231),
          amountPerRow: 10,
        ),
      );

      return SpriteAnimationWidget(
        animation: animation,
        animationTicker: SpriteAnimationTicker(animation),
      );
    }

    return Assets.images.platformNotSelected.image();
  }
}
