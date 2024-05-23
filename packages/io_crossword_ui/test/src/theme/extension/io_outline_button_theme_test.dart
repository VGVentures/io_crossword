import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

void main() {
  group('$IoOutlineButtonTheme', () {
    test('lerps', () {
      final from = IoOutlineButtonTheme(
        simpleBorder: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xff00ff00)),
        ),
        googleBorder: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xff000000)),
        ),
      );
      final to = IoOutlineButtonTheme(
        simpleBorder: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xff0000ff)),
        ),
        googleBorder: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xff000040)),
        ),
      );

      final newTheme = from.lerp(to, 0.5);

      expect(newTheme.simpleBorder, isNot(equals(from.simpleBorder)));
      expect(newTheme.simpleBorder, isNot(equals(to.simpleBorder)));
    });
  });
}
