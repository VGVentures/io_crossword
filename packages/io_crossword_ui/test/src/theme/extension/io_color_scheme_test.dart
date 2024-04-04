// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

void main() {
  group('$IoColorScheme', () {
    test('lerps', () {
      final from = IoColorScheme(
        primaryGradient: LinearGradient(
          colors: const [Color(0xff00ff00), Color(0xff00ff00)],
        ),
      );
      final to = IoColorScheme(
        primaryGradient: LinearGradient(
          colors: const [Color(0xff0000ff), Color(0xff0000ff)],
        ),
      );
      final lerp = from.lerp(to, 0.5);

      expect(lerp.primaryGradient, isNot(from.primaryGradient));
      expect(lerp.primaryGradient, isNot(to.primaryGradient));
      expect(lerp.primaryGradient.colors, [
        Color(0xff007f7f),
        Color(0xff007f7f),
      ]);
    });
  });
}
