import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

class TeamSelectionMascot extends StatelessWidget {
  const TeamSelectionMascot(this.mascot, {super.key});

  final Mascots mascot;

  @override
  Widget build(BuildContext context) {
    return SpriteAnimationWidget.asset(
      path: mascot.teamMascot.idleAnimation.path,
      data: SpriteAnimationData.sequenced(
        amount: 70,
        stepTime: 0.042,
        textureSize: Vector2(300, 336),
        amountPerRow: 10,
      ),
      anchor: Anchor.bottomCenter,
    );
  }
}
