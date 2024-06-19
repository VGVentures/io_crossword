// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/foundation.dart';

/// A class that holds settings like [muted].
class SettingsController {
  /// Creates a new instance of [SettingsController] .
  SettingsController();

  /// Whether or not the sound is on at all. This overrides both music
  /// and sound.
  ValueNotifier<bool> muted = ValueNotifier(false);

  void toggleMuted() {
    muted.value = !muted.value;
  }
}
