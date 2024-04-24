import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:game_domain/game_domain.dart';

extension HintResponseExtension on HintResponse {
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

@visibleForTesting
const notApplicableResponses = [
  "I can't answer that.",
  'Sorry but this cannot be answered.',
  'This question is not applicable.',
  "I'm afraid I cannot answer that.",
];
