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

    group('copyWith', () {
      test('returns same object when no properties are passed', () {
        final state = InitialsState.initial();

        expect(state.copyWith(), equals(state));
      });

      test('returns object with updated properties', () {
        final state = InitialsState.initial();
        final newState = InitialsState(
          initials: InitialsInput.dirty('ABC'),
        );
        final updatedState = state.copyWith(
          initials: newState.initials,
        );

        expect(updatedState, equals(newState));
      });
    });
  });

  group('$InitialsInput', () {
    group('error', () {
      test('returns format error when value is empty', () {
        final input = InitialsInput.dirty('');

        expect(input.validator(''), equals(InitialsInputError.format));
      });

      test('returns format error when value is not 3 characters', () {
        final input = InitialsInput.dirty('AB');

        expect(input.error, equals(InitialsInputError.format));
      });

      test('returns format error when value contains non-alphabetic characters',
          () {
        final input = InitialsInput.dirty('123');

        expect(input.error, equals(InitialsInputError.format));
      });

      test('returns processing error when blocklist is not set', () {
        final input = InitialsInput.dirty('ABC');

        expect(input.error, equals(InitialsInputError.processing));
      });

      test('returns blocklisted error when value is in blocklist', () {
        final input = InitialsInput.dirty('AAA', blocklist: Blocklist({'AAA'}));

        expect(input.error, equals(InitialsInputError.blocklisted));
      });

      test('returns null when value is valid', () {
        final input = InitialsInput.dirty('ABC', blocklist: Blocklist({'AAA'}));

        expect(input.error, isNull);
      });
    });

    group('copyWith', () {
      test('returns same object when no properties are passed', () {
        final input = InitialsInput.dirty('ABC');

        expect(input.copyWith(), equals(input));
      });

      test('returns dirty input with updated properties', () {
        final input = InitialsInput.dirty('ABC');
        final newInput = InitialsInput.dirty(
          'DEF',
          blocklist: Blocklist({'AAA', 'BBB'}),
        );
        final updatedInput = input.copyWith(
          value: newInput.value,
          blocklist: newInput.blocklist,
        );

        expect(updatedInput, equals(newInput));
      });

      test('returns pure input with updated properties', () {
        final input = InitialsInput.pure('ABC');
        final newInput = InitialsInput.pure(
          'DEF',
          blocklist: Blocklist({'AAA', 'BBB'}),
        );
        final updatedInput = input.copyWith(
          value: newInput.value,
          blocklist: newInput.blocklist,
        );

        expect(updatedInput, equals(newInput));
      });
    });
  });
}
