// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';

void main() {
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
  });
}
