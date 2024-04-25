import 'dart:math';

import 'package:game_domain/game_domain.dart';
import 'package:meta/meta.dart';

/// An extension on [HintResponse] to provide readable responses.
extension HintResponseExtension on HintResponse {
  /// Returns a readable response for the hint.
  String get readable {
    final random = Random();

    switch (this) {
      case HintResponse.yes:
        return yesResponses[random.nextInt(yesResponses.length)];
      case HintResponse.no:
        return noResponses[random.nextInt(noResponses.length)];
      case HintResponse.notApplicable:
        return notApplicableResponses[
            random.nextInt(notApplicableResponses.length)];
    }
  }
}

/// Response alternatives to [HintResponse.yes].
@visibleForTesting
const yesResponses = [
  'Yes, that is correct!',
  "Yes, you're on the right track.",
  'Heck yeah, yes!',
  'A hundred percent yes!',
  'Yes, for sure.',
  'Yes, absolutely!',
  'Yes, definitely!',
  'You betcha, yes!',
  'Yes! You got this.',
  'Yes!',
];

/// Response alternatives to [HintResponse.no].
@visibleForTesting
const noResponses = [
  'No, unfortunately.',
  'Not really.',
  "I'm afraid not.",
  'Nope.',
  "No, that's not correct.",
  'Nope, sorry!',
  'Not at all.',
  'Absolutely not.',
  'Never.',
  'Sorry, but no!',
];

/// Response alternatives to [HintResponse.notApplicable].
@visibleForTesting
const notApplicableResponses = [
  "I can't answer that.",
  'Sorry but this cannot be answered.',
  'This question is not applicable.',
  "I'm afraid I cannot answer that.",
];
