import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

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
  SpriteData get idleSpriteData => SpriteData(
        path: idleAnimation.path,
        amountPerRow: 16,
        amountPerColumn: 5,
        stepTime: 0.042,
        width: 225,
        height: 325,
      );

  @override
  SpriteData get lookUpSpriteData => SpriteData(
        path: lookUpAnimation.path,
        amountPerRow: 21,
        amountPerColumn: 3,
        stepTime: 0.042,
        width: 360,
        height: 612,
      );

  @override
  SpriteData get pickUpSpriteData => SpriteData(
        path: pickUpAnimation.path,
        amountPerRow: 19,
        amountPerColumn: 3,
        stepTime: 0.042,
        width: 360,
        height: 612,
      );

  @override
  SpriteData get dangleSpriteData => SpriteData(
        path: dangleAnimation.path,
        amountPerRow: 9,
        amountPerColumn: 3,
        stepTime: 0.042,
        width: 360,
        height: 612,
      );

  @override
  SpriteData get dropInSpriteData => SpriteData(
        path: dropInAnimation.path,
        amountPerRow: 11,
        amountPerColumn: 3,
        stepTime: 0.042,
        width: 360,
        height: 612,
      );
}
