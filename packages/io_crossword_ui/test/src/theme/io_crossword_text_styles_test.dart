// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/src/theme/io_crossword_text_styles.dart';

void main() {
  group('font weight extension', () {
    test('bold returns font weight w700', () {
      expect(TextStyle().bold?.fontWeight, equals(FontWeight.w700));
    });

    test('medium returns font weight w500', () {
      expect(TextStyle().medium?.fontWeight, equals(FontWeight.w500));
    });

    test('regular returns font weight w400', () {
      expect(TextStyle().regular?.fontWeight, equals(FontWeight.w400));
    });
  });
}
