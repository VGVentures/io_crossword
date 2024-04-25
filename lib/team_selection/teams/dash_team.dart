import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

class DashTeam extends Team {
  const DashTeam();

  @override
  String get name => 'Dash';

  @override
  AssetGenImage get idleAnimation => Assets.anim.dashIdle;

  @override
  AssetGenImage get platformAnimation => Assets.anim.dashPlatform;

  @override
  AssetGenImage get lookUpAnimation => Assets.anim.dashLookUp;

  @override
  AssetGenImage get pickUpAnimation => Assets.anim.dashPickUp;

  @override
  AssetGenImage get dangleAnimation => Assets.anim.dashDangle;

  @override
  AssetGenImage get dropInAnimation => Assets.anim.dashDropIn;

  @override
  AssetGenImage get howToPlayAnswer => Assets.images.howToPlayAnswerDash;

  @override
  AssetGenImage get howToPlayFindWord => Assets.images.howToPlayFindAWordDash;

  @override
  AssetGenImage get howToPlayStreak => Assets.images.howToPlayStreakDash;

  @override
  SpriteInformation get idleSpriteInformation => const SpriteInformation(
        rows: 10,
        columns: 7,
        stepTime: 0.042,
        width: 300,
        height: 336,
      );

  @override
  SpriteInformation get lookUpSpriteInformation => const SpriteInformation(
        rows: 20,
        columns: 3,
        stepTime: 0.042,
        width: 200,
        height: 340,
      );

  @override
  SpriteInformation get pickUpSpriteInformation => const SpriteInformation(
        rows: 11,
        columns: 6,
        stepTime: 0.042,
        width: 270,
        height: 340,
      );

  @override
  SpriteInformation get dangleSpriteInformation => const SpriteInformation(
        rows: 23,
        columns: 2,
        stepTime: 0.042,
        width: 150,
        height: 300,
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
