// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/hint/bloc/hint_bloc.dart';

void main() {
  group('$HintState', () {
    test('supports equality', () {
      expect(
        HintState(status: HintStatus.asking),
        equals(HintState(status: HintStatus.asking)),
      );
    });

    group('copyWith', () {
      test('returns equivalent object when no properties are passed', () {
        final state = HintState(status: HintStatus.asking);
        expect(state.copyWith(), equals(state));
      });

      test(
        'returns object with updated isHintsEnabled when isHintsEnabled '
        'is passed',
        () {
          final state = HintState(status: HintStatus.asking);
          expect(
            state.copyWith(isHintsEnabled: true),
            equals(HintState(status: HintStatus.asking, isHintsEnabled: true)),
          );
        },
      );

      test('returns object with updated status when status is passed', () {
        final state = HintState(status: HintStatus.asking);
        expect(
          state.copyWith(status: HintStatus.thinking),
          equals(HintState(status: HintStatus.thinking)),
        );
      });

      test('returns object with updated hints when hints are passed', () {
        final state = HintState(status: HintStatus.asking);
        final hint = Hint(
          question: 'is it orange?',
          response: HintResponse.notApplicable,
          readableResponse: 'N/A',
        );
        expect(
          state.copyWith(hints: [hint, hint]),
          equals(HintState(status: HintStatus.asking, hints: [hint, hint])),
        );
      });

      test('returns object with updated maxHints when maxHints is passed', () {
        final state = HintState(status: HintStatus.asking);
        expect(
          state.copyWith(maxHints: 5),
          equals(HintState(status: HintStatus.asking, maxHints: 5)),
        );
      });
    });
  });
}
