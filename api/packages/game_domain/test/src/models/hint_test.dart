// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Hint', () {
    test('creates correct json object from Hint object', () {
      final hint = Hint(question: 'to be?', response: HintResponse.yes);
      final json = hint.toJson();

      expect(
        json,
        equals({
          'question': 'to be?',
          'response': 'yes',
        }),
      );
    });

    test('creates correct Hint object from json object', () {
      final json = {
        'question': 'or not to be?',
        'response': 'notApplicable',
      };
      final hint = Hint.fromJson(json);
      expect(
        hint,
        equals(
          Hint(
            question: 'or not to be?',
            response: HintResponse.notApplicable,
          ),
        ),
      );
    });

    test('supports equality', () {
      final firstHint = Hint(
        question: 'to be?',
        response: HintResponse.no,
      );
      final secondHint = Hint(
        question: 'to be?',
        response: HintResponse.no,
      );
      expect(firstHint, equals(secondHint));
    });
  });
}
