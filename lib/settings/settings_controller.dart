// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/foundation.dart';

/// An class that holds settings like [muted] or [musicOn],
class SettingsController {
  /// Creates a new instance of [SettingsController] .
  SettingsController();

  /// Whether or not the sound is on at all. This overrides both music
  /// and sound.
  ValueNotifier<bool> muted = ValueNotifier(false);

  ValueNotifier<bool> soundsOn = ValueNotifier(true);

  ValueNotifier<bool> musicOn = ValueNotifier(true);

  void toggleMusicOn() {
    musicOn.value = !musicOn.value;
  }

  void toggleMuted() {
    muted.value = !muted.value;
  }

  void toggleSoundsOn() {
    soundsOn.value = !soundsOn.value;
  }
}
