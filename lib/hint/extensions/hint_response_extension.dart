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
  'Yes!',
];

@visibleForTesting
const noResponses = [
  'Nope',
];

@visibleForTesting
const notApplicableResponses = [
  'Try with a "Yes or No" question',
];
