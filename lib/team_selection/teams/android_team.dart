import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

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
  AssetGenImage get howToPlayAnswer => Assets.images.howToPlayAnswerAndroid;

  @override
  AssetGenImage get howToPlayFindWord =>
      Assets.images.howToPlayFindAWordAndroid;

  @override
  AssetGenImage get howToPlayStreak => Assets.images.howToPlayStreakAndroid;

  @override
  SpriteInformation get idleSpriteInformation => SpriteInformation(
        path: idleAnimation.path,
        rows: 7,
        columns: 4,
        stepTime: 0.042,
        width: 250,
        height: 360,
      );

  @override
  SpriteInformation get lookUpSpriteInformation => SpriteInformation(
        path: lookUpAnimation.path,
        rows: 15,
        columns: 5,
        stepTime: 0.042,
        width: 200,
        height: 340,
      );

  @override
  SpriteInformation get pickUpSpriteInformation => SpriteInformation(
        path: pickUpAnimation.path,
        rows: 17,
        columns: 4,
        stepTime: 0.042,
        width: 200,
        height: 340,
      );

  @override
  SpriteInformation get dangleSpriteInformation => SpriteInformation(
        path: dangleAnimation.path,
        rows: 17,
        columns: 2,
        stepTime: 0.042,
        width: 150,
        height: 300,
      );

  @override
  SpriteInformation get dropInSpriteInformation => SpriteInformation(
        path: dropInAnimation.path,
        rows: 22,
        columns: 2,
        stepTime: 0.042,
        width: 150,
        height: 300,
      );
}
