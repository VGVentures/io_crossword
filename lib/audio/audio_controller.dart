// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/settings/settings.dart';

typedef CreateAudioPlayer = AudioPlayer Function({required String playerId});

/// Allows playing music and sound. A facade to `package:audioplayers`.
class AudioController {
  /// Creates an instance that plays music and sound.
  ///
  /// Use [polyphony] to configure the number of sound effects (SFX) that can
  /// play at the same time. A [polyphony] of `1` will always only play one
  /// sound (a new sound will stop the previous one). See discussion
  /// of [_sfxPlayers] to learn why this is the case.
  ///
  /// Background music does not count into the [polyphony] limit. Music will
  /// never be overridden by sound effects because that would be silly.
  AudioController({
    int polyphony = 2,
    CreateAudioPlayer createPlayer = AudioPlayer.new,
  })  : assert(polyphony >= 1, 'polyphony must be bigger or equals than 1'),
        _musicPlayer = createPlayer(playerId: 'musicPlayer'),
        _sfxPlayers = Iterable.generate(
          polyphony,
          (i) => createPlayer(playerId: 'sfxPlayer#$i'),
        ).toList(growable: false) {
    _musicPlayer.onPlayerComplete.listen(_loopSound);
  }

  final AudioPlayer _musicPlayer;

  /// This is a list of [AudioPlayer] instances which are rotated to play
  /// sound effects.
  final List<AudioPlayer> _sfxPlayers;

  int _currentSfxPlayer = 0;

  SettingsController? _settings;

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  /// Enables the [AudioController] to listen to [AppLifecycleState] events,
  /// and therefore do things like stopping playback when the game
  /// goes into the background.
  void attachLifecycleNotifier(
    ValueNotifier<AppLifecycleState> lifecycleNotifier,
  ) {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);

    lifecycleNotifier.addListener(_handleAppLifecycle);
    _lifecycleNotifier = lifecycleNotifier;
  }

  /// Enables the [AudioController] to track changes to settings.
  /// Namely, when [SettingsController.muted] changes,
  /// the audio controller will act accordingly.
  void attachSettings(SettingsController settingsController) {
    if (_settings == settingsController) {
      // Already attached to this instance. Nothing to do.
      return;
    }

    // Remove handlers from the old settings controller if present
    final oldSettings = _settings;
    if (oldSettings != null) {
      oldSettings.muted.removeListener(_mutedHandler);
    }

    _settings = settingsController;

    // Add handlers to the new settings controller
    settingsController.muted.addListener(_mutedHandler);
  }

  Future<void> _configureBackgroundMusicPlayer() async {
    if (_musicPlayer.source != null) {
      return;
    }

    await _musicPlayer.setSource(
      AssetSource(
        _replaceUrl(
          Assets.music.backgroundMusicCrossword,
        ),
      ),
    );

    await _musicPlayer.setVolume(
      0.3,
    );
  }

  Future<void> startMusic() async {
    await _configureBackgroundMusicPlayer();

    if (_settings != null && !_settings!.muted.value) {
      await _playBackgroundMusic();
    }
  }

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    _stopAllSound();
    _musicPlayer.dispose();
    for (final player in _sfxPlayers) {
      player.dispose();
    }
  }

  /// Preloads all sound effects.
  Future<void> initialize() async {
    // This assumes there is only a limited number of sound effects in the game.
    // If there are hundreds of long sound effect files, it's better
    // to be more selective when preloading.

    await AudioCache.instance.loadAll(
      Assets.music.values.map(_replaceUrl).toList(),
    );
  }

  String _replaceUrl(String asset) {
    return asset.replaceFirst('assets/', '');
  }

  /// Plays a single sound effect.
  ///
  /// The controller will ignore this call when the attached settings'
  /// [SettingsController.muted] is `true`.
  void playSfx(String sfx) {
    if (!Assets.music.values.contains(sfx)) {
      throw ArgumentError.value(
        sfx,
        'sfx',
        'The given sfx is not a valid sound effect.',
      );
    }

    final muted = _settings?.muted.value ?? true;
    if (muted) {
      return;
    }

    _sfxPlayers[_currentSfxPlayer].play(
      AssetSource(_replaceUrl(sfx)),
    );
    _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
  }

  Future<void> _loopSound(void _) async {
    //Loop the sound forever.

    await _playBackgroundMusic();
  }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _stopAllSound();

      case AppLifecycleState.resumed:
        if (!_settings!.muted.value) {
          _resumeMusic();
        }

      case AppLifecycleState.inactive:
      // No need to react to this state change.
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _mutedHandler() {
    if (_settings!.muted.value) {
      // All sound just got muted.
      _stopAllSound();
    } else {
      // All sound just got un-muted.
      if (_musicPlayer.source != null) {
        _resumeMusic();
      }
    }
  }

  Future<void> _playBackgroundMusic() async {
    await _musicPlayer.resume();
  }

  Future<void> _resumeMusic() async {
    switch (_musicPlayer.state) {
      case PlayerState.paused:
        try {
          await _musicPlayer.resume();
        } catch (e) {
          await _musicPlayer.play(
            AssetSource(
              _replaceUrl(
                Assets.music.backgroundMusicCrossword,
              ),
            ),
            volume: 0.3,
          );
        }
      case PlayerState.stopped:
        await _musicPlayer.stop();
        await _playBackgroundMusic();

      case PlayerState.playing:
        break;
      case PlayerState.completed:
        await _playBackgroundMusic();
      case PlayerState.disposed:
        break;
    }
  }

  void _stopAllSound() {
    if (_musicPlayer.state == PlayerState.playing) {
      _musicPlayer.pause();
    }
    for (final player in _sfxPlayers) {
      player.stop();
    }
  }
}
