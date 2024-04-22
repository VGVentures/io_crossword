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
}
