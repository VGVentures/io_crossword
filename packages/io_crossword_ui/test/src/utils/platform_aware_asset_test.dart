// ignore_for_file: prefer_const_constructors

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/src/utils/utils.dart';

void main() {
  group('platformAwareAsset', () {
    test('returns mobile by default', () {
      final result = platformAwareAsset(
        desktop: 'desktop',
        mobile: 'mobile',
      );

      expect(result, equals('mobile'));
    });

    test('returns mobile when iOS', () {
      final result = platformAwareAsset(
        desktop: 'desktop',
        mobile: 'mobile',
        overrideDefaultTargetPlatform: TargetPlatform.iOS,
      );

      expect(result, 'mobile');
    });

    test('returns mobile when Android', () {
      final result = platformAwareAsset(
        desktop: 'desktop',
        mobile: 'mobile',
        overrideDefaultTargetPlatform: TargetPlatform.android,
      );

      expect(result, 'mobile');
    });
  });
}
