import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/hint/hint.dart';

void main() {
  group('HintResponseExtension', () {
    test('${HintResponse.yes} returns one of the readable responses', () {
      const response = HintResponse.yes;
      final readable = response.readable;

      expect(yesResponses, contains(readable));
    });

    test('${HintResponse.no} returns one of the readable responses', () {
      const response = HintResponse.no;
      final readable = response.readable;

      expect(noResponses, contains(readable));
    });

    test('${HintResponse.notApplicable} returns one of the readable responses',
        () {
      const response = HintResponse.notApplicable;
      final readable = response.readable;

      expect(notApplicableResponses, contains(readable));
    });
  });
}
