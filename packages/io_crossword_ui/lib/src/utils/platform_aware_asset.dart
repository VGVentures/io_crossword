import 'package:flutter/foundation.dart';

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
