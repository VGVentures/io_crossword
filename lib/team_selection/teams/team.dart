import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.dart';

abstract class Team extends Equatable {
  const Team();

  String get name;
  Mascots get mascot;

  AssetGenImage get idleAnimation;

  AssetGenImage get platformAnimation;

  @override
  List<Object> get props => [
        name,
        mascot,
        idleAnimation,
        platformAnimation,
      ];
}
