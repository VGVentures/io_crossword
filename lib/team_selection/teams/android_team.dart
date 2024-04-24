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
  AssetGenImage get howToPlayAnswer => Assets.images.howToPlayAnswerAndroid;

  @override
  AssetGenImage get howToPlayFindWord =>
      Assets.images.howToPlayFindAWordAndroid;

  @override
  AssetGenImage get howToPlayStreak => Assets.images.howToPlayStreakAndroid;

  @override
  SpriteInformation get idleSpriteInformation => const SpriteInformation(
        rows: 7,
        columns: 4,
        stepTime: 0.042,
        width: 250,
        height: 360,
      );

  @override
  SpriteInformation get lookUpSpriteInformation => const SpriteInformation(
        rows: 15,
        columns: 5,
        stepTime: 0.042,
        width: 200,
        height: 340,
      );
}
