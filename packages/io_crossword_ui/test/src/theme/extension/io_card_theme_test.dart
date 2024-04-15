// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

void main() {
  group('$IoCardTheme', () {
    test('supports value equality', () {
      final theme1 = IoCardTheme(
        plain: CardTheme(color: Color(0xff00ff00)),
        plainAlternative: CardTheme(color: Color(0xff00ff00)),
        highlight: CardTheme(color: Color(0xff00ff00)),
        elevated: CardTheme(color: Color(0xff00ff00)),
      );
      final theme2 = IoCardTheme(
        plain: CardTheme(color: Color(0xff00ff00)),
        plainAlternative: CardTheme(color: Color(0xff00ff00)),
        highlight: CardTheme(color: Color(0xff00ff00)),
        elevated: CardTheme(color: Color(0xff00ff00)),
      );
      final theme3 = IoCardTheme(
        plain: CardTheme(color: Color(0xff00ff00)),
        plainAlternative: CardTheme(color: Color(0xff00ff00)),
        highlight: CardTheme(color: Color(0xff0000ff)),
        elevated: CardTheme(color: Color(0xff00ff00)),
      );

      expect(theme1, equals(theme2));
      expect(theme1, isNot(equals(theme3)));
      expect(theme2, isNot(equals(theme3)));
    });

    test('lerps', () {
      final from = IoCardTheme(
        plain: CardTheme(color: Color(0xff00ff00)),
        plainAlternative: CardTheme(color: Color(0xff00ff00)),
        highlight: CardTheme(color: Color(0xff00ff00)),
        elevated: CardTheme(color: Color(0xff00ff00)),
      );
      final to = IoCardTheme(
        plain: CardTheme(color: Color(0xff0000ff)),
        plainAlternative: CardTheme(color: Color(0xff0000ff)),
        highlight: CardTheme(color: Color(0xff0000ff)),
        elevated: CardTheme(color: Color(0xff0000ff)),
      );

      final lerp = from.lerp(to, 0.5);

      expect(lerp.plain.color, equals(const Color(0xff007f7f)));
      expect(lerp.highlight.color, equals(const Color(0xff007f7f)));

      expect(lerp.plain, isNot(equals(from.plain)));
      expect(lerp.plain, isNot(equals(to.plain)));

      expect(lerp.highlight, isNot(equals(from.highlight)));
      expect(lerp.highlight, isNot(equals(to.highlight)));
    });
  });
}
