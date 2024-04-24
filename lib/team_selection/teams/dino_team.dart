import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

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
  AssetGenImage get howToPlayAnswer => Assets.images.howToPlayAnswerDino;

  @override
  AssetGenImage get howToPlayFindWord => Assets.images.howToPlayFindAWordDino;

  @override
  AssetGenImage get howToPlayStreak => Assets.images.howToPlayStreakDino;

  @override
  SpriteInformation get idleSpriteInformation => const SpriteInformation(
        rows: 14,
        columns: 2,
        stepTime: 0.042,
        width: 280,
        height: 370,
      );

  @override
  SpriteInformation get lookUpSpriteInformation => const SpriteInformation(
        rows: 15,
        columns: 4,
        stepTime: 0.042,
        width: 250,
        height: 340,
      );
}
