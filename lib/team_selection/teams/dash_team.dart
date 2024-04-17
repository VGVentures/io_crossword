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
  SpriteInformation get spriteInformation => const SpriteInformation(
        rows: 10,
        columns: 7,
        stepTime: 0.042,
        width: 300,
        height: 336,
      );
}
