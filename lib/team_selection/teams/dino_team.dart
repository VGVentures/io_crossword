import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/team_selection/teams/team.dart';

class DinoTeam extends Team {
  const DinoTeam();

  @override
  String get name => 'Dino';

  @override
  AssetGenImage get idleAnimation => Assets.anim.dashIdle;

  @override
  AssetGenImage get platformAnimation => Assets.anim.androidPlatform;
}
