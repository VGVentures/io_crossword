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
  AssetGenImage get lookUpAnimation => Assets.anim.androidLookUpMobile;

  @override
  AssetGenImage get pickUpAnimation => Assets.anim.androidPickUpMobile;

  @override
  AssetGenImage get dangleAnimation => Assets.anim.androidDangleMobile;

  @override
  AssetGenImage get dropInAnimation => Assets.anim.androidDropInMobile;

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
  SpriteData get lookUpSpriteData => SpriteData(
        path: lookUpAnimation.path,
        amountPerRow: 11,
        amountPerColumn: 7,
        stepTime: 0.042,
        width: 360 / 2,
        height: 612 / 2,
      );

  @override
  SpriteData get pickUpSpriteData => SpriteData(
        path: pickUpAnimation.path,
        amountPerRow: 18,
        amountPerColumn: 4,
        stepTime: 0.042,
        width: 360 / 2,
        height: 612 / 2,
      );

  @override
  SpriteData get dangleSpriteData => SpriteData(
        path: dangleAnimation.path,
        amountPerRow: 7,
        amountPerColumn: 6,
        stepTime: 0.042,
        width: 360 / 2,
        height: 612 / 2,
      );

  @override
  SpriteData get dropInSpriteData => SpriteData(
        path: dropInAnimation.path,
        amountPerRow: 7,
        amountPerColumn: 6,
        stepTime: 0.042,
        width: 360 / 2,
        height: 612 / 2,
      );
}
