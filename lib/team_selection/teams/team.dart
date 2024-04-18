import 'package:equatable/equatable.dart';
import 'package:io_crossword/assets/assets.dart';

abstract class Team extends Equatable {
  const Team();

  String get name;

  AssetGenImage get idleAnimation;

  AssetGenImage get platformAnimation;

  @override
  List<Object> get props => [
        name,
        idleAnimation,
        platformAnimation,
      ];
}
