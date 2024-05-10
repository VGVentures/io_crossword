import 'package:flutter/foundation.dart';

/// Definition of a platform aware asset function.
typedef PlatformAwareAsset<T> = T Function({
  required T desktop,
  required T mobile,
  TargetPlatform? overrideDefaultTargetPlatform,
});

/// Returns an asset based on the current platform.
T platformAwareAsset<T>({
  required T desktop,
  required T mobile,
  TargetPlatform? overrideDefaultTargetPlatform,
}) {
  return isMobile(overrideDefaultTargetPlatform: overrideDefaultTargetPlatform)
      ? mobile
      : desktop;
}

/// Returns whether the current platform is mobile.
bool isMobile({
  TargetPlatform? overrideDefaultTargetPlatform,
}) {
  final platform = overrideDefaultTargetPlatform ?? defaultTargetPlatform;
  return platform == TargetPlatform.iOS || platform == TargetPlatform.android;
}
