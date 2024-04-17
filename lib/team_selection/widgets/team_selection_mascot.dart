import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:game_domain/game_domain.dart';

class TeamSelectionMascot extends StatelessWidget {
  const TeamSelectionMascot(this.mascot, {super.key});

  final Mascots mascot;

  @override
  Widget build(BuildContext context) {
    final animation = SpriteAnimation.fromFrameData(
      Flame.images.fromCache(mascot.idleAnimation),
      SpriteAnimationData.sequenced(
        amount: 70,
        stepTime: 0.042,
        textureSize: Vector2(300, 336),
        amountPerRow: 10,
      ),
    );

    return SizedBox(
      child: SpriteAnimationWidget(
        animation: animation,
        animationTicker: SpriteAnimationTicker(animation),
        anchor: Anchor.bottomCenter,
      ),
    );
  }
}
