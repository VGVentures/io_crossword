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

  group('Desktop fonts', () {
    test('body returns a text style', () {
      expect(IoCrosswordTextStyles.desktop.body, isNotNull);
    });
    test('body2 returns a text style', () {
      expect(IoCrosswordTextStyles.desktop.body2, isNotNull);
    });
    test('body3 returns a text style', () {
      expect(IoCrosswordTextStyles.desktop.body3, isNotNull);
    });
    test('body4 returns a text style', () {
      expect(IoCrosswordTextStyles.desktop.body4, isNotNull);
    });
    test('body5 returns a text style', () {
      expect(IoCrosswordTextStyles.desktop.body5, isNotNull);
    });
    test('heading1 returns a text style', () {
      expect(IoCrosswordTextStyles.desktop.heading1, isNotNull);
    });
    test('heading2 returns a text style', () {
      expect(IoCrosswordTextStyles.desktop.h2, isNotNull);
    });
  });
  group('Mobile fonts', () {
    test('body returns a text style', () {
      expect(IoCrosswordTextStyles.mobile.body, isNotNull);
    });
    test('body2 returns a text style', () {
      expect(IoCrosswordTextStyles.mobile.body2, isNotNull);
    });
    test('body3 returns a text style', () {
      expect(IoCrosswordTextStyles.mobile.body3, isNotNull);
    });
    test('body4 returns a text style', () {
      expect(IoCrosswordTextStyles.mobile.body4, isNotNull);
    });
    test('body5 returns a text style', () {
      expect(IoCrosswordTextStyles.mobile.body5, isNotNull);
    });
    test('heading1 returns a text style', () {
      expect(IoCrosswordTextStyles.mobile.heading1, isNotNull);
    });
    test('heading2 returns a text style', () {
      expect(IoCrosswordTextStyles.mobile.h2, isNotNull);
    });
  });
}
