import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/settings/settings.dart';
import 'package:mocktail/mocktail.dart';

class _MockSettingsController extends Mock implements SettingsController {}

class _MockBoolValueListener extends Mock implements ValueNotifier<bool> {}

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _MockAudioPlayerFactory {
  _MockAudioPlayerFactory();
  final Map<String, AudioPlayer> players = {};
  final Map<String, StreamController<void>> controllers = {};

  AudioPlayer createPlayer({required String playerId}) {
    final player = _MockAudioPlayer();
    final streamController = StreamController<void>();

    when(
      () => player.play(
        any(),
        volume: any(named: 'volume'),
      ),
    ).thenAnswer((_) async {});
    when(() => player.onPlayerComplete).thenAnswer(
      (_) => streamController.stream,
    );
    when(player.stop).thenAnswer((_) async {});
    when(player.pause).thenAnswer((_) async {});
    when(player.resume).thenAnswer((_) async {});
    when(() => player.setSource(any())).thenAnswer((_) async {});
    when(() => player.setVolume(any())).thenAnswer((_) async {});

    controllers[playerId] = streamController;
    return players[playerId] = player;
  }
}

ValueNotifier<bool> _createMockNotifier() {
  final notifier = _MockBoolValueListener();

  when(() => notifier.addListener(any())).thenAnswer((_) {});
  when(() => notifier.removeListener(any())).thenAnswer((_) {});
  when(() => notifier.value).thenReturn(true);

  return notifier;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioController', () {
    late SettingsController settingsController;
    late ValueNotifier<bool> muted;

    setUpAll(() {
      registerFallbackValue(AssetSource(''));
    });

    setUp(() {
      settingsController = _MockSettingsController();

      muted = _createMockNotifier();
      when(() => settingsController.muted).thenReturn(muted);
    });

    test('can be instantiated', () {
      final playerFactory = _MockAudioPlayerFactory();
      expect(
        AudioController(createPlayer: playerFactory.createPlayer),
        isNotNull,
      );
    });

    test('stop playing music when ${PlayerState.stopped}', () async {
      final lifecycleNotifier = ValueNotifier(AppLifecycleState.resumed);
      final playerFactory = _MockAudioPlayerFactory();

      when(() => muted.value).thenReturn(false);

      final audioController = AudioController(
        createPlayer: playerFactory.createPlayer,
        polyphony: 1,
      )
        ..attachSettings(
          settingsController,
        )
        ..attachLifecycleNotifier(lifecycleNotifier);

      await audioController.startMusic();

      final musicPlayer = playerFactory.players.entries
          .firstWhere((entry) => entry.key.startsWith('music'))
          .value;
      when(() => musicPlayer.state).thenReturn(PlayerState.completed);

      lifecycleNotifier.value = AppLifecycleState.detached;

      await Future.microtask(() {});

      verify(musicPlayer.resume).called(1);
    });

    group('attachSettings', () {
      test('attach to the settings', () {
        final playerFactory = _MockAudioPlayerFactory();
        AudioController(createPlayer: playerFactory.createPlayer)
            .attachSettings(settingsController);

        verify(() => muted.addListener(any())).called(1);
      });

      test('replace an old settings', () async {
        final playerFactory = _MockAudioPlayerFactory();
        final audioController =
            AudioController(createPlayer: playerFactory.createPlayer)
              ..attachSettings(settingsController);
        verify(() => muted.addListener(any())).called(1);

        final newController = _MockSettingsController();

        final newMuted = _createMockNotifier();
        when(() => newController.muted).thenReturn(newMuted);

        audioController.attachSettings(newController);

        verify(() => muted.removeListener(any())).called(1);
        verify(() => newMuted.addListener(any())).called(1);
      });
    });

    group('playSfx', () {
      test('plays a sfx', () {
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..playSfx(Assets.music.rightWord);

        final player = playerFactory.players['sfxPlayer#0']!;

        final captured = verify(
          () => player.play(
            captureAny(),
          ),
        ).captured;
        final source = captured.first;
        expect(source, isA<AssetSource>());
        expect((source as AssetSource).path, 'music/RightWord.mp3');
      });

      test(
        "throws ArgumentError when trying to play a sound that doesn't exists",
        () {
          final playerFactory = _MockAudioPlayerFactory();

          when(() => muted.value).thenReturn(false);

          expect(
            () => AudioController(
              createPlayer: playerFactory.createPlayer,
              polyphony: 1,
            )
              ..attachSettings(
                settingsController,
              )
              ..playSfx('this_assets_does_not_exists.mp3'),
            throwsArgumentError,
          );
        },
      );

      test("doesn't play when is muted", () {
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(true);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..playSfx(Assets.music.rightWord);

        final player = playerFactory.players['sfxPlayer#0']!;

        verifyNever(
          () => player.play(
            AssetSource('music/RightWord.mp3'),
          ),
        );
      });

      test("doesn't play when sounds is off", () {
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..playSfx(Assets.music.rightWord);

        final player = playerFactory.players['sfxPlayer#0']!;

        verifyNever(
          () => player.play(
            AssetSource('music/RightWord.mp3'),
          ),
        );
      });
    });

    group('muted', () {
      test('stops the music when muted', () async {
        final playerFactory = _MockAudioPlayerFactory();

        final muted = ValueNotifier(false);
        when(() => settingsController.muted).thenReturn(muted);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..playSfx(Assets.music.rightWord);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        final sfxPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('sfxPlayer'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.playing);
        when(() => sfxPlayer.state).thenReturn(PlayerState.playing);

        muted.value = true;

        await Future.microtask(() {});

        verify(musicPlayer.pause).called(1);
        verify(sfxPlayer.stop).called(1);
      });

      test('resumes the music when unmuting', () async {
        final playerFactory = _MockAudioPlayerFactory();

        final muted = ValueNotifier(false);
        when(() => settingsController.muted).thenReturn(muted);

        final audioController = AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )..attachSettings(
            settingsController,
          );

        await audioController.startMusic();

        muted.value = true;

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        when(() => musicPlayer.source)
            .thenReturn(AssetSource('assets/music.mp3'));

        when(() => musicPlayer.state).thenReturn(PlayerState.paused);

        muted.value = false;

        await Future.microtask(() {});

        verify(musicPlayer.resume).called(2);
      });
    });

    group('lifecycle handling', () {
      test('when app is paused, pauses and stop sounds', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.resumed);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier)
          ..playSfx(Assets.music.rightWord);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        final sfxPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('sfxPlayer'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.playing);
        when(() => sfxPlayer.state).thenReturn(PlayerState.playing);

        lifecycleNotifier.value = AppLifecycleState.paused;

        await Future.microtask(() {});

        verify(musicPlayer.pause).called(1);
        verify(sfxPlayer.stop).called(1);
      });

      test('when app is detached, pauses and stop sounds', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.resumed);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier)
          ..playSfx(Assets.music.rightWord);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        final sfxPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('sfxPlayer'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.playing);
        when(() => sfxPlayer.state).thenReturn(PlayerState.playing);

        lifecycleNotifier.value = AppLifecycleState.detached;

        await Future.microtask(() {});

        verify(musicPlayer.pause).called(1);
        verify(sfxPlayer.stop).called(1);
      });

      test('when app is inactive, do nothing', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.resumed);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier)
          ..playSfx(Assets.music.rightWord);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        final sfxPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('sfxPlayer'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.playing);
        when(() => sfxPlayer.state).thenReturn(PlayerState.playing);

        lifecycleNotifier.value = AppLifecycleState.inactive;

        await Future.microtask(() {});

        verifyNever(musicPlayer.pause);
        verifyNever(sfxPlayer.stop);
      });

      test('when app is hidden, do nothing', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.resumed);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier)
          ..playSfx(Assets.music.rightWord);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        final sfxPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('sfxPlayer'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.playing);
        when(() => sfxPlayer.state).thenReturn(PlayerState.playing);

        lifecycleNotifier.value = AppLifecycleState.hidden;

        await Future.microtask(() {});

        verifyNever(musicPlayer.pause);
        verifyNever(sfxPlayer.stop);
      });

      test('when app is resumed, resumes the music', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.inactive);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier)
          ..playSfx(Assets.music.rightWord);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.paused);

        lifecycleNotifier.value = AppLifecycleState.resumed;

        await Future.microtask(() {});

        verify(musicPlayer.resume).called(1);
      });

      test('when resuming, and an error happens, play the next', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.paused);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(false);

        final audioController = AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier);

        await audioController.startMusic();

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.paused);
        when(musicPlayer.resume).thenThrow('Error');

        lifecycleNotifier.value = AppLifecycleState.resumed;

        await Future.microtask(() {});

        verify(() => musicPlayer.play(any(), volume: any(named: 'volume')))
            .called(1);
      });

      test('when resuming, and player is completed, play the next', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.paused);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(false);

        final audioController = AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier);

        await audioController.startMusic();

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.completed);

        lifecycleNotifier.value = AppLifecycleState.resumed;

        await Future.microtask(() {});

        verify(musicPlayer.resume).called(2);
      });

      test('when resuming, and player is playing, do nothing', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.paused);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(false);

        final audioController = AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier);

        await audioController.startMusic();

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.playing);

        lifecycleNotifier.value = AppLifecycleState.resumed;

        await Future.microtask(() {});

        verify(musicPlayer.resume).called(1);
      });

      test('when resuming, and player is stopped, play music', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.paused);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(false);

        final audioController = AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier);

        await audioController.startMusic();

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.stopped);

        lifecycleNotifier.value = AppLifecycleState.resumed;

        await Future.microtask(() {});

        verify(musicPlayer.resume).called(2);
      });

      test('when resuming, and player is disposed, do nothing', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.paused);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(false);

        final audioController = AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier);

        await audioController.startMusic();

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.disposed);

        lifecycleNotifier.value = AppLifecycleState.resumed;

        await Future.microtask(() {});

        verify(musicPlayer.resume).called(1);
      });
    });

    group('changeSong', () {
      test('plays the next song when the one is playing finishes', () async {
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(false);

        final audioController = AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )..attachSettings(
            settingsController,
          );

        await audioController.startMusic();

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        playerFactory.controllers.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value
            .add(null);

        await Future.microtask(() {});

        verify(musicPlayer.resume).called(2);
      });
    });
  });
}
