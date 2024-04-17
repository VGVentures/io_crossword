import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/team_selection/teams/team.dart';

class DashTeam extends Team {
  const DashTeam();

  @override
  String get name => 'Dash';

  @override
  AssetGenImage get idleAnimation => Assets.anim.dashIdle;

  @override
  AssetGenImage get platformAnimation => Assets.anim.androidPlatform;
}
