/// {@template mascots}
/// Google Mascots enum.
/// {@endtemplate}
enum Mascots {
  /// Flutter Dash mascot.
  dash(
    name: 'Dash',
    idleAnimation: 'dash_idle.png',
    platformAnimation: 'android_platform.png',
  ),

  /// Firebase Sparky mascot.
  sparky(
    name: 'Sparky',
    idleAnimation: 'dash_idle.png',
    platformAnimation: 'android_platform.png',
  ),

  /// Android mascot.
  android(
    name: 'Android',
    idleAnimation: 'dash_idle.png',
    platformAnimation: 'android_platform.png',
  ),

  /// Chrome Dino mascot.
  dino(
    name: 'Dino',
    idleAnimation: 'dash_idle.png',
    platformAnimation: 'android_platform.png',
  );

  const Mascots({
    required this.name,
    required this.idleAnimation,
    required this.platformAnimation,
  });

  /// The name of the mascot.
  final String name;

  /// The file name of the idle animation.
  final String idleAnimation;

  /// The file name of the platform animation.
  final String platformAnimation;
}
