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
  AssetGenImage get pickUpAnimation => Assets.anim.dinoPickUp;

  @override
  AssetGenImage get dangleAnimation => Assets.anim.dinoDangle;

  @override
  AssetGenImage get dropInAnimation => Assets.anim.dinoDropIn;

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

  @override
  SpriteInformation get pickUpSpriteInformation => const SpriteInformation(
        rows: 15,
        columns: 5,
        stepTime: 0.042,
        width: 200,
        height: 272,
      );

  @override
  SpriteInformation get dangleSpriteInformation => const SpriteInformation(
        rows: 17,
        columns: 2,
        stepTime: 0.042,
        width: 150,
        height: 300,
      );

  @override
  SpriteInformation get dropInSpriteInformation => const SpriteInformation(
        rows: 22,
        columns: 2,
        stepTime: 0.042,
        width: 150,
        height: 300,
      );
}
