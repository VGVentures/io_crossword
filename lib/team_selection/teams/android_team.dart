import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/team_selection/teams/team.dart';

class AndroidTeam extends Team {
  const AndroidTeam();

  @override
  String get name => 'Android';

  @override
  Mascots get mascot => Mascots.android;

  @override
  AssetGenImage get idleAnimation => Assets.anim.dashIdle;

  @override
  AssetGenImage get platformAnimation => Assets.anim.androidPlatform;
}
