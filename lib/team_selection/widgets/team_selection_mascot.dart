import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

class TeamSelectionMascot extends StatelessWidget {
  const TeamSelectionMascot(this.mascot, {super.key});

  final Mascot mascot;

  @override
  Widget build(BuildContext context) {
    final idleSpriteData = mascot.teamMascot.idleSpriteData;

    return SpriteAnimationWidget.asset(
      path: mascot.teamMascot.idleAnimation.path,
      data: SpriteAnimationData.sequenced(
        amount: idleSpriteData.amountPerRow * idleSpriteData.amountPerColumn,
        stepTime: idleSpriteData.stepTime,
        textureSize: Vector2(
          idleSpriteData.width,
          idleSpriteData.height,
        ),
        amountPerRow: idleSpriteData.amountPerRow,
      ),
      anchor: Anchor.bottomCenter,
    );
  }
}
