// ignore_for_file: prefer_const_constructors

import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HowToPlayCubit', () {
    group('updateIndex', () {
      test('emits the index', () {
        final cubit = HowToPlayCubit();

        const index = 1;
        final expectedStates = [HowToPlayState(index: index)];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        cubit.updateIndex(index);
      });
    });

    group('updateStatus', () {
      test('emits the status', () {
        final cubit = HowToPlayCubit();

        const status = HowToPlayStatus.pickingUp;
        final expectedStates = [HowToPlayState(status: status)];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        cubit.updateStatus(status);
      });
    });

    group('loadAssets', () {
      setUp(() {
        Flame.images = Images(prefix: '');
      });

      test('emits inProgress and success for mobile', () {
        final cubit = HowToPlayCubit();

        final expectedStates = [
          HowToPlayState(),
          HowToPlayState(assetsStatus: AssetsLoadingStatus.success),
        ];

        expectLater(
          cubit.stream,
          emitsInOrder(expectedStates),
        );

        cubit.loadAssets(Mascots.dash, mobile: true);
      });

      test('emits inProgress and success for desktop', () {
        final cubit = HowToPlayCubit();

        final expectedStates = [
          HowToPlayState(),
          HowToPlayState(assetsStatus: AssetsLoadingStatus.success),
        ];

        expectLater(
          cubit.stream,
          emitsInOrder(expectedStates),
        );

        cubit.loadAssets(Mascots.dash, mobile: false);
      });
    });
  });
}
