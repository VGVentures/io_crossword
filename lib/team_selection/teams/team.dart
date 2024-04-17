import 'package:equatable/equatable.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

abstract class Team extends Equatable {
  const Team();

  String get name;

  AssetGenImage get idleAnimation;

  AssetGenImage get platformAnimation;

  SpriteInformation get spriteInformation;

  @override
  List<Object> get props => [
        name,
        idleAnimation,
        platformAnimation,
        spriteInformation,
      ];
}
