import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

extension CommonFindersExt on CommonFinders {
  bool tapTextSpan(RichText richText, String text) {
    final isTapped = !richText.text.visitChildren(
      (visitor) {
        if (visitor is TextSpan && visitor.text == text) {
          (visitor.recognizer! as TapGestureRecognizer).onTap!();

          return false;
        }

        return true;
      },
    );

    return isTapped;
  }
}
