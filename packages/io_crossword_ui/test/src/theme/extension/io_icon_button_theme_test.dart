import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/src/theme/extension/io_icon_button_theme.dart';

void main() {
  group('$IoIconButtonTheme', () {
    test('lerps', () {
      final from = IoIconButtonTheme(
        flat: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xff00ff00)),
        ),
        outlined: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xff00ff00)),
        ),
        filled: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xff00ff00)),
        ),
      );
      final to = IoIconButtonTheme(
        flat: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xff00ff00)),
        ),
        outlined: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xff0000ff)),
        ),
        filled: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xff0000ff)),
        ),
      );

      final newTheme = from.lerp(to, 0.5);

      expect(newTheme.flat, isNot(equals(from.flat)));
      expect(newTheme.flat, isNot(equals(to.flat)));

      expect(newTheme.outlined, isNot(equals(from.outlined)));
      expect(newTheme.outlined, isNot(equals(to.outlined)));

      expect(newTheme.filled, isNot(equals(from.filled)));
      expect(newTheme.filled, isNot(equals(to.filled)));
    });
  });
}
