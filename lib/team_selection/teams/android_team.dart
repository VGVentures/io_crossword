import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class AndroidTeam extends Team {
  const AndroidTeam();

  @override
  String get name => 'Android';

  @override
  AssetGenImage get idleAnimation => Assets.anim.androidIdle;

  @override
  AssetGenImage get platformAnimation => Assets.anim.androidPlatform;

  @override
  AssetGenImage get lookUpAnimation => Assets.anim.androidLookUp;

  @override
  AssetGenImage get pickUpAnimation => Assets.anim.androidPickUp;

  @override
  AssetGenImage get dangleAnimation => Assets.anim.androidDangle;

  @override
  AssetGenImage get dropInAnimation => Assets.anim.androidDropIn;

  @override
  AssetGenImage get lookUpMobileAnimation => Assets.anim.androidLookUpMobile;

  @override
  AssetGenImage get pickUpMobileAnimation => Assets.anim.androidPickUpMobile;

  @override
  AssetGenImage get dangleMobileAnimation => Assets.anim.androidDangleMobile;

  @override
  AssetGenImage get dropInMobileAnimation => Assets.anim.androidDropInMobile;

  @override
  AssetGenImage get howToPlayAnswer => Assets.images.howToPlayAnswerAndroid;

  @override
  AssetGenImage get howToPlayFindWord =>
      Assets.images.howToPlayFindAWordAndroid;

  @override
  AssetGenImage get howToPlayStreak => Assets.images.howToPlayStreakAndroid;

  @override
  SpriteData get idleSpriteData => SpriteData(
        path: idleAnimation.path,
        amountPerRow: 7,
        amountPerColumn: 4,
        stepTime: 0.042,
        width: 250,
        height: 360,
      );

  @override
  SpriteData get lookUpSpriteDesktopData => SpriteData(
        path: lookUpAnimation.path,
        amountPerRow: 11,
        amountPerColumn: 7,
        stepTime: 0.042,
        width: 360,
        height: 612,
      );

  @override
  SpriteData get pickUpSpriteDesktopData => SpriteData(
        path: pickUpAnimation.path,
        amountPerRow: 18,
        amountPerColumn: 4,
        stepTime: 0.042,
        width: 360,
        height: 612,
      );

  @override
  SpriteData get dangleSpriteDesktopData => SpriteData(
        path: dangleAnimation.path,
        amountPerRow: 7,
        amountPerColumn: 6,
        stepTime: 0.042,
        width: 360,
        height: 612,
      );

  @override
  SpriteData get dropInSpriteDesktopData => SpriteData(
        path: dropInAnimation.path,
        amountPerRow: 7,
        amountPerColumn: 6,
        stepTime: 0.042,
        width: 360,
        height: 612,
      );

  @override
  SpriteData get lookUpSpriteMobileData => SpriteData(
        path: lookUpMobileAnimation.path,
        amountPerRow: 11,
        amountPerColumn: 7,
        stepTime: 0.042,
        width: 360 / 2,
        height: 612 / 2,
      );

  @override
  SpriteData get pickUpSpriteMobileData => SpriteData(
        path: pickUpMobileAnimation.path,
        amountPerRow: 18,
        amountPerColumn: 4,
        stepTime: 0.042,
        width: 360 / 2,
        height: 612 / 2,
      );

  @override
  SpriteData get dangleSpriteMobileData => SpriteData(
        path: dangleMobileAnimation.path,
        amountPerRow: 7,
        amountPerColumn: 6,
        stepTime: 0.042,
        width: 360 / 2,
        height: 612 / 2,
      );

  @override
  SpriteData get dropInSpriteMobileData => SpriteData(
        path: dropInMobileAnimation.path,
        amountPerRow: 7,
        amountPerColumn: 6,
        stepTime: 0.042,
        width: 360 / 2,
        height: 612 / 2,
      );
}
