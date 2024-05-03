// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/settings/settings.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  group('$MuteButton', () {
    late SettingsController settingsController;

    setUp(() {
      settingsController = _MockSettingsController();
    });

    testWidgets('renders volume_off when muted is true', (tester) async {
      when(() => settingsController.muted).thenReturn(ValueNotifier(true));
      await tester.pumpApp(
        MuteButton(),
        settingsController: settingsController,
      );
      expect(find.byIcon(Icons.volume_off), findsOneWidget);
    });

    testWidgets('renders volume_on when muted is true', (tester) async {
      when(() => settingsController.muted).thenReturn(ValueNotifier(false));
      await tester.pumpApp(
        MuteButton(),
        settingsController: settingsController,
      );
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });

    testWidgets('calls toggleMuted when pressed', (tester) async {
      when(() => settingsController.muted).thenReturn(ValueNotifier(false));
      await tester.pumpApp(
        MuteButton(),
        settingsController: settingsController,
      );

      await tester.tap(find.byType(IconButton));

      verify(settingsController.toggleMuted).called(1);
    });
  });
}
