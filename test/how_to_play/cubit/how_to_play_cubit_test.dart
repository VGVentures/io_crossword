import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';

void main() {
  group('HowToPlayCubit', () {
    group('updateIndex', () {
      test('emits the index', () {
        final cubit = HowToPlayCubit();

        const index = 1;
        final expectedStates = [index];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        cubit.updateIndex(index);
      });
    });
  });
}
