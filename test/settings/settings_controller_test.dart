import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/settings/settings.dart';

void main() {
  group('SettingsController', () {
    late SettingsController controller;

    setUp(() {
      controller = SettingsController();
    });

    test('can toggle musicOn', () async {
      controller.toggleMusicOn();
      expect(controller.musicOn.value, isFalse);
    });

    test('can toggle soundsOn', () async {
      controller.toggleSoundsOn();

      expect(controller.soundsOn.value, isFalse);
    });

    test('can toggle muted', () async {
      controller.toggleMuted();

      expect(controller.muted.value, isTrue);
    });
  });
}
