import 'package:flame/components.dart';
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
      return SpriteAnimationWidget.asset(
        path: mascot.teamMascot.platformAnimation.path,
        data: SpriteAnimationData.sequenced(
          amount: 60,
          stepTime: 0.042,
          textureSize: Vector2(366, 231),
          amountPerRow: 10,
        ),
        anchor: Anchor.bottomCenter,
      );
    }

    return Assets.images.platformNotSelected.image();
  }
}
