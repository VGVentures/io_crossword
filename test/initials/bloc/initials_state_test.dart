import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/initials/initials.dart';

void main() {
  group('$InitialsState', () {
    test('initials has empty pure input', () {
      expect(
        InitialsState.initial().initials,
        equals(InitialsInput.pure('')),
      );
    });

    test('does not support value equality', () {
      final state1 = InitialsState.initial();
      final state2 = InitialsState.initial();

      expect(state1, isNot(equals(state2)));
    });

    group('copyWith', () {
      test('does not change properties when no properties are passed', () {
        final state = InitialsState.initial();

        final copy = state.copyWith();

        expect(copy.initials, equals(state.initials));
      });

      test('returns object with updated properties', () {
        final state = InitialsState.initial();
        final newState = InitialsState(
          initials: InitialsInput.dirty('ABC'),
        );
        final updatedState = state.copyWith(
          initials: newState.initials,
        );

        expect(updatedState.initials, equals(newState.initials));
      });
    });
  });
}
