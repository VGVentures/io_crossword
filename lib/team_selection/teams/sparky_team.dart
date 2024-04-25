import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

class SparkyTeam extends Team {
  const SparkyTeam();

  @override
  String get name => 'Sparky';

  @override
  AssetGenImage get idleAnimation => Assets.anim.sparkyIdle;

  @override
  AssetGenImage get platformAnimation => Assets.anim.sparkyPlatform;

  @override
  AssetGenImage get lookUpAnimation => Assets.anim.sparkyLookUp;

  @override
  AssetGenImage get pickUpAnimation => Assets.anim.sparkyPickUp;

  @override
  AssetGenImage get dangleAnimation => Assets.anim.sparkyDangle;

  @override
  AssetGenImage get dropInAnimation => Assets.anim.sparkyDropIn;

  @override
  AssetGenImage get howToPlayAnswer => Assets.images.howToPlayAnswerSparky;

  @override
  AssetGenImage get howToPlayFindWord => Assets.images.howToPlayFindAWordSparky;

  @override
  AssetGenImage get howToPlayStreak => Assets.images.howToPlayStreakSparky;

  @override
  SpriteInformation get idleSpriteInformation => const SpriteInformation(
        rows: 16,
        columns: 5,
        stepTime: 0.042,
        width: 225,
        height: 325,
      );

  @override
  SpriteInformation get lookUpSpriteInformation => const SpriteInformation(
        rows: 9,
        columns: 7,
        stepTime: 0.042,
        width: 200,
        height: 340,
      );

  @override
  SpriteInformation get pickUpSpriteInformation => const SpriteInformation(
        rows: 7,
        columns: 9,
        stepTime: 0.042,
        width: 270,
        height: 340,
      );

  @override
  SpriteInformation get dangleSpriteInformation => const SpriteInformation(
        rows: 6,
        columns: 6,
        stepTime: 0.042,
        width: 140,
        height: 340,
      );

  @override
  SpriteInformation get dropInSpriteInformation => const SpriteInformation(
        rows: 11,
        columns: 4,
        stepTime: 0.042,
        width: 150,
        height: 300,
      );
}
