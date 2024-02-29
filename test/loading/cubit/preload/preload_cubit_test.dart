import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/cache.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/loading/loading.dart';
import 'package:mocktail/mocktail.dart';

class _MockImages extends Mock implements Images {}

class _MockAudioCache extends Mock implements AudioCache {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PreloadCubit', () {
    group('loadSequentially', () {
      late Images images;
      late AudioCache audio;

      blocTest<PreloadCubit, PreloadState>(
        'loads assets',
        setUp: () {
          images = _MockImages();
          when(
            () => images.loadAll([]),
          ).thenAnswer((invocation) => Future.value(<Image>[]));

          audio = _MockAudioCache();
          when(
            () => audio.loadAll([]),
          ).thenAnswer(
            (invocation) async => [
              Uri.parse('Assets.audio.background'),
              Uri.parse('Assets.audio.effect'),
            ],
          );
        },
        build: () => PreloadCubit(images, audio),
        act: (bloc) => bloc.loadSequentially(),
        expect: () => [
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals(''))
              .having((s) => s.totalCount, 'totalCount', equals(2)),
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals('audio'))
              .having((s) => s.isComplete, 'isComplete', isFalse)
              .having((s) => s.loadedCount, 'loadedCount', equals(0)),
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals('audio'))
              .having((s) => s.isComplete, 'isComplete', isFalse)
              .having((s) => s.loadedCount, 'loadedCount', equals(1)),
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals('images'))
              .having((s) => s.isComplete, 'isComplete', isFalse)
              .having((s) => s.loadedCount, 'loadedCount', equals(1)),
          isA<PreloadState>()
              .having((s) => s.currentLabel, 'currentLabel', equals('images'))
              .having((s) => s.isComplete, 'isComplete', isTrue)
              .having((s) => s.loadedCount, 'loadedCount', equals(2)),
        ],
        verify: (bloc) {
          verify(
            () => audio.loadAll([]),
          ).called(1);
          verify(
            () => images.loadAll([]),
          ).called(1);
        },
      );
    });
  });
}
