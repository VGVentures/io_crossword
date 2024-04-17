import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/team_selection/teams/team.dart';

class SparkyTeam extends Team {
  const SparkyTeam();

  @override
  String get name => 'Sparky';

  @override
  Mascots get mascot => Mascots.sparky;

  @override
  AssetGenImage get idleAnimation => Assets.anim.dashIdle;

  @override
  AssetGenImage get platformAnimation => Assets.anim.androidPlatform;
}
