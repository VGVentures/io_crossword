import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

class LookUp extends StatelessWidget {
  const LookUp(this.mascot, {super.key});

  final Mascots mascot;

  @override
  Widget build(BuildContext context) {
    final lookUpSpriteInformation = mascot.teamMascot.lookUpSpriteInformation;

    return SpriteAnimationWidget.asset(
      path: mascot.teamMascot.lookUpAnimation.path,
      data: SpriteAnimationData.sequenced(
        amount: lookUpSpriteInformation.rows * lookUpSpriteInformation.columns,
        stepTime: lookUpSpriteInformation.stepTime,
        textureSize: Vector2(
          lookUpSpriteInformation.width,
          lookUpSpriteInformation.height,
        ),
        amountPerRow: lookUpSpriteInformation.rows,
      ),
      anchor: Anchor.bottomCenter,
    );
  }
}
