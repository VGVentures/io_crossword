// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/loading/loading.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoadingCubit', () {
    test('initial state', () {
      expect(LoadingCubit().state, equals(LoadingState.initial()));
    });

    group('load', () {
      test('emits LoadingState with updated values', () {
        final cubit = LoadingCubit();

        final expectedStates = [
          LoadingState(assetsCount: 12, loaded: 0),
          LoadingState(assetsCount: 12, loaded: 1),
          LoadingState(assetsCount: 12, loaded: 2),
          LoadingState(assetsCount: 12, loaded: 3),
          LoadingState(assetsCount: 12, loaded: 4),
          LoadingState(assetsCount: 12, loaded: 5),
          LoadingState(assetsCount: 12, loaded: 6),
          LoadingState(assetsCount: 12, loaded: 7),
          LoadingState(assetsCount: 12, loaded: 8),
          LoadingState(assetsCount: 12, loaded: 9),
          LoadingState(assetsCount: 12, loaded: 10),
          LoadingState(assetsCount: 12, loaded: 11),
          LoadingState(assetsCount: 12, loaded: 12),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        cubit.load();
      });
    });
  });
}
