import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

class AndroidTeam extends Team {
  const AndroidTeam();

  @override
  String get name => 'Android';

  @override
  AssetGenImage get idleAnimation => Assets.anim.androidIdle;

  @override
  AssetGenImage get platformAnimation => Assets.anim.androidPlatform;

  @override
  SpriteInformation get idleSpriteInformation => const SpriteInformation(
        rows: 7,
        columns: 4,
        stepTime: 0.042,
        width: 250,
        height: 360,
      );
}
