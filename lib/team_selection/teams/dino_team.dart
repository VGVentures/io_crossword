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
  AssetGenImage get lookUpAnimation => Assets.anim.dinoLookUp;

  @override
  AssetGenImage get pickUpAnimation => Assets.anim.dinoPickUp;

  @override
  AssetGenImage get dangleAnimation => Assets.anim.dinoDangle;

  @override
  AssetGenImage get dropInAnimation => Assets.anim.dinoDropIn;

  @override
  AssetGenImage get idleUnselected => Assets.images.dinoIdleUnselected;

  @override
  AssetGenImage get lookUpMobileAnimation => Assets.anim.dinoLookUpMobile;

  @override
  AssetGenImage get pickUpMobileAnimation => Assets.anim.dinoPickUpMobile;

  @override
  AssetGenImage get dangleMobileAnimation => Assets.anim.dinoDangleMobile;

  @override
  AssetGenImage get dropInMobileAnimation => Assets.anim.dinoDropInMobile;

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
  SpriteData get lookUpSpriteDesktopData => SpriteData(
        path: lookUpAnimation.path,
        amountPerRow: 9,
        amountPerColumn: 7,
        stepTime: 0.042,
        width: 384,
        height: 544,
      );

  @override
  SpriteData get pickUpSpriteDesktopData => SpriteData(
        path: pickUpAnimation.path,
        amountPerRow: 17,
        amountPerColumn: 4,
        stepTime: 0.042,
        width: 384,
        height: 544,
      );

  @override
  SpriteData get dangleSpriteDesktopData => SpriteData(
        path: dangleAnimation.path,
        amountPerRow: 9,
        amountPerColumn: 3,
        stepTime: 0.042,
        width: 384,
        height: 544,
      );

  @override
  SpriteData get dropInSpriteDesktopData => SpriteData(
        path: dropInAnimation.path,
        amountPerRow: 7,
        amountPerColumn: 5,
        stepTime: 0.042,
        width: 384,
        height: 544,
      );

  @override
  SpriteData get lookUpSpriteMobileData => SpriteData(
        path: lookUpMobileAnimation.path,
        amountPerRow: 9,
        amountPerColumn: 7,
        stepTime: 0.042,
        width: 384 / 2,
        height: 544 / 2,
      );

  @override
  SpriteData get pickUpSpriteMobileData => SpriteData(
        path: pickUpMobileAnimation.path,
        amountPerRow: 17,
        amountPerColumn: 4,
        stepTime: 0.042,
        width: 384 / 2,
        height: 544 / 2,
      );

  @override
  SpriteData get dangleSpriteMobileData => SpriteData(
        path: dangleMobileAnimation.path,
        amountPerRow: 9,
        amountPerColumn: 3,
        stepTime: 0.042,
        width: 384 / 2,
        height: 544 / 2,
      );

  @override
  SpriteData get dropInSpriteMobileData => SpriteData(
        path: dropInMobileAnimation.path,
        amountPerRow: 7,
        amountPerColumn: 5,
        stepTime: 0.042,
        width: 384 / 2,
        height: 544 / 2,
      );
}
