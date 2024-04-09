import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/initials/initials.dart';

void main() {
  group('$InitialsState', () {
    test('initials has empty pure input', () {
      expect(
        InitialsState.initial().initials,
        equals(InitialsInput.pure('')),
      );
    });

    test('supports value equality', () {
      final state1 = InitialsState.initial();
      final state2 = InitialsState.initial();
      final state3 = InitialsState.initial().copyWith(
        initials: InitialsInput.dirty('ABC'),
      );

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });
}
