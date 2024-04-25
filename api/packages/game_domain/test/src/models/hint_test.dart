// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Hint', () {
    test('creates correct json object from Hint object', () {
      final hint = Hint(
        question: 'to be?',
        response: HintResponse.yes,
        readableResponse: 'Yes, that is correct!',
      );
      final json = hint.toJson();

      expect(
        json,
        equals({
          'question': 'to be?',
          'response': 'yes',
          'readableResponse': 'Yes, that is correct!',
        }),
      );
    });

    test('creates correct Hint object from json object', () {
      final json = {
        'question': 'or not to be?',
        'response': 'notApplicable',
        'readableResponse': "I can't answer that.",
      };
      final hint = Hint.fromJson(json);
      expect(
        hint,
        equals(
          Hint(
            question: 'or not to be?',
            response: HintResponse.notApplicable,
            readableResponse: "I can't answer that.",
          ),
        ),
      );
    });

    test('supports equality', () {
      final firstHint = Hint(
        question: 'to be?',
        response: HintResponse.no,
        readableResponse: 'Nope!',
      );
      final secondHint = Hint(
        question: 'to be?',
        response: HintResponse.no,
        readableResponse: 'Nope!',
      );
      expect(firstHint, equals(secondHint));
    });
  });
}
