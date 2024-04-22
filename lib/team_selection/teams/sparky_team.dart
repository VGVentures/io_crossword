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
}
