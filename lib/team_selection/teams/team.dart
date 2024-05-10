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

  AssetGenImage get idleUnselected;

  AssetGenImage get lookUpMobileAnimation;

  AssetGenImage get pickUpMobileAnimation;

  AssetGenImage get dangleMobileAnimation;

  AssetGenImage get dropInMobileAnimation;

  AssetGenImage get howToPlayAnswer;

  AssetGenImage get howToPlayFindWord;

  AssetGenImage get howToPlayStreak;

  SpriteData get idleSpriteData;

  SpriteData get lookUpSpriteDesktopData;

  SpriteData get pickUpSpriteDesktopData;

  SpriteData get dangleSpriteDesktopData;

  SpriteData get dropInSpriteDesktopData;

  SpriteData get lookUpSpriteMobileData;

  SpriteData get pickUpSpriteMobileData;

  SpriteData get dangleSpriteMobileData;

  SpriteData get dropInSpriteMobileData;

  List<String> loadableTeamSelectionAssets() => [
        idleAnimation.path,
        platformAnimation.path,
      ];

  List<String> loadableHowToPlayDesktopAssets() => [
        lookUpAnimation.path,
        pickUpAnimation.path,
        dangleAnimation.path,
        dropInAnimation.path,
      ];

  List<String> loadableHowToPlayMobileAssets() => [
        lookUpMobileAnimation.path,
        pickUpMobileAnimation.path,
        dangleMobileAnimation.path,
        dropInMobileAnimation.path,
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
        idleUnselected,
        lookUpMobileAnimation,
        pickUpMobileAnimation,
        dangleMobileAnimation,
        dropInMobileAnimation,
        howToPlayAnswer,
        howToPlayFindWord,
        howToPlayStreak,
        idleSpriteData,
        lookUpSpriteDesktopData,
        pickUpSpriteDesktopData,
        dangleSpriteDesktopData,
        dropInSpriteDesktopData,
        lookUpSpriteMobileData,
        pickUpSpriteMobileData,
        dangleSpriteMobileData,
        dropInSpriteMobileData,
      ];
}
