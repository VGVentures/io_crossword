import 'package:equatable/equatable.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

abstract class Team extends Equatable {
  const Team();

  String get name;

  AssetGenImage get idleAnimation;

  AssetGenImage get platformAnimation;

  AssetGenImage get lookUpAnimation;

  AssetGenImage get pickUpAnimation;

  AssetGenImage get dangleAnimation;

  AssetGenImage get dropInAnimation;

  AssetGenImage get howToPlayAnswer;

  AssetGenImage get howToPlayFindWord;

  AssetGenImage get howToPlayStreak;

  SpriteInformation get idleSpriteInformation;

  SpriteInformation get lookUpSpriteInformation;

  SpriteInformation get pickUpSpriteInformation;

  SpriteInformation get dangleSpriteInformation;

  SpriteInformation get dropInSpriteInformation;

  @override
  List<Object> get props => [
        name,
        idleAnimation,
        platformAnimation,
        lookUpAnimation,
        pickUpAnimation,
        dangleAnimation,
        dropInAnimation,
        howToPlayAnswer,
        howToPlayFindWord,
        howToPlayStreak,
        idleSpriteInformation,
        lookUpSpriteInformation,
        pickUpSpriteInformation,
        dangleSpriteInformation,
        dropInSpriteInformation,
      ];
}
