import 'package:equatable/equatable.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

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

  SpriteData get idleSpriteData;

  SpriteData get lookUpSpriteData;

  SpriteData get pickUpSpriteData;

  SpriteData get dangleSpriteData;

  SpriteData get dropInSpriteData;

  List<String> loadableAssets() => [
        idleAnimation.path,
        platformAnimation.path,
        lookUpAnimation.path,
        pickUpAnimation.path,
        dangleAnimation.path,
        dropInAnimation.path,
      ];

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
        idleSpriteData,
        lookUpSpriteData,
        pickUpSpriteData,
        dangleSpriteData,
        dropInSpriteData,
      ];
}
