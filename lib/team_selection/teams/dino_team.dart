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
  SpriteInformation get idleSpriteInformation => const SpriteInformation(
        rows: 14,
        columns: 2,
        stepTime: 0.042,
        width: 280,
        height: 370,
      );
}
