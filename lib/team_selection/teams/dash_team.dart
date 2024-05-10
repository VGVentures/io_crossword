import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class DashTeam extends Team {
  const DashTeam();

  @override
  String get name => 'Dash';

  @override
  AssetGenImage get idleAnimation => Assets.anim.dashIdle;

  @override
  AssetGenImage get platformAnimation => Assets.anim.dashPlatform;

  @override
  AssetGenImage get lookUpAnimation => Assets.anim.dashLookUpMobile;

  @override
  AssetGenImage get pickUpAnimation => Assets.anim.dashPickUpMobile;

  @override
  AssetGenImage get dangleAnimation => Assets.anim.dashDangleMobile;

  @override
  AssetGenImage get dropInAnimation => Assets.anim.dashDropInMobile;

  @override
  AssetGenImage get howToPlayAnswer => Assets.images.howToPlayAnswerDash;

  @override
  AssetGenImage get howToPlayFindWord => Assets.images.howToPlayFindAWordDash;

  @override
  AssetGenImage get howToPlayStreak => Assets.images.howToPlayStreakDash;

  @override
  SpriteData get idleSpriteData => SpriteData(
        path: idleAnimation.path,
        amountPerRow: 10,
        amountPerColumn: 7,
        stepTime: 0.042,
        width: 300,
        height: 336,
      );

  @override
  SpriteData get lookUpSpriteData => SpriteData(
        path: lookUpAnimation.path,
        amountPerRow: 15,
        amountPerColumn: 4,
        stepTime: 0.042,
        width: 457 / 2,
        height: 612 / 2,
      );

  @override
  SpriteData get pickUpSpriteData => SpriteData(
        path: pickUpAnimation.path,
        amountPerRow: 16,
        amountPerColumn: 4,
        stepTime: 0.042,
        width: 457 / 2,
        height: 612 / 2,
      );

  @override
  SpriteData get dangleSpriteData => SpriteData(
        path: dangleAnimation.path,
        amountPerRow: 12,
        amountPerColumn: 3,
        stepTime: 0.042,
        width: 457 / 2,
        height: 612 / 2,
      );

  @override
  SpriteData get dropInSpriteData => SpriteData(
        path: dropInAnimation.path,
        amountPerRow: 7,
        amountPerColumn: 5,
        stepTime: 0.042,
        width: 457 / 2,
        height: 612 / 2,
      );
}
