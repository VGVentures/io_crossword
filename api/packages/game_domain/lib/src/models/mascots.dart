/// {@template mascots}
/// Google Mascots enum.
/// {@endtemplate}
enum Mascots {
  /// Flutter Dash mascot.
  dash(
    displayName: 'Dash',
    idleAnimation: 'dash_idle.png',
    platformAnimation: 'android_platform.png',
  ),

  /// Firebase Sparky mascot.
  sparky(
    displayName: 'Sparky',
    idleAnimation: 'dash_idle.png',
    platformAnimation: 'android_platform.png',
  ),

  /// Android mascot.
  android(
    displayName: 'Android',
    idleAnimation: 'dash_idle.png',
    platformAnimation: 'android_platform.png',
  ),

  /// Chrome Dino mascot.
  dino(
    displayName: 'Dino',
    idleAnimation: 'dash_idle.png',
    platformAnimation: 'android_platform.png',
  );

  const Mascots({
    required this.displayName,
    required this.idleAnimation,
    required this.platformAnimation,
  });

  /// The display name of the mascot.
  final String displayName;

  /// The file name of the idle animation.
  final String idleAnimation;

  /// The file name of the platform animation.
  final String platformAnimation;
}
