import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class DinoTeam extends Team {
  const DinoTeam();

  @override
  String get name => 'Dino';

  @override
  AssetGenImage get idleAnimation => Assets.anim.dinoIdle;

  @override
  AssetGenImage get platformAnimation => Assets.anim.dinoPlatform;

  @override
  AssetGenImage get lookUpAnimation => Assets.anim.dinoLookUpMobile;

  @override
  AssetGenImage get pickUpAnimation => Assets.anim.dinoPickUpMobile;

  @override
  AssetGenImage get dangleAnimation => Assets.anim.dinoDangleMobile;

  @override
  AssetGenImage get dropInAnimation => Assets.anim.dinoDropInMobile;

  @override
  AssetGenImage get howToPlayAnswer => Assets.images.howToPlayAnswerDino;

  @override
  AssetGenImage get howToPlayFindWord => Assets.images.howToPlayFindAWordDino;

  @override
  AssetGenImage get howToPlayStreak => Assets.images.howToPlayStreakDino;

  @override
  SpriteData get idleSpriteData => SpriteData(
        path: idleAnimation.path,
        amountPerRow: 14,
        amountPerColumn: 2,
        stepTime: 0.042,
        width: 280,
        height: 370,
      );

  @override
  SpriteData get lookUpSpriteData => SpriteData(
        path: lookUpAnimation.path,
        amountPerRow: 9,
        amountPerColumn: 7,
        stepTime: 0.042,
        width: 384 / 2,
        height: 544 / 2,
      );

  @override
  SpriteData get pickUpSpriteData => SpriteData(
        path: pickUpAnimation.path,
        amountPerRow: 17,
        amountPerColumn: 4,
        stepTime: 0.042,
        width: 384 / 2,
        height: 544 / 2,
      );

  @override
  SpriteData get dangleSpriteData => SpriteData(
        path: dangleAnimation.path,
        amountPerRow: 9,
        amountPerColumn: 3,
        stepTime: 0.042,
        width: 384 / 2,
        height: 544 / 2,
      );

  @override
  SpriteData get dropInSpriteData => SpriteData(
        path: dropInAnimation.path,
        amountPerRow: 7,
        amountPerColumn: 5,
        stepTime: 0.042,
        width: 384 / 2,
        height: 544 / 2,
      );
}
