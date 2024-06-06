// ignore_for_file: prefer_const_constructors

import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flame/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

import '../../helpers/helpers.dart';

void main() {
  group('TeamSelectionMascotPlatform', () {
    setUpAll(() async {
      Flame.images = Images(prefix: '');
      await Flame.images.loadAll([
        Mascot.dash.teamMascot.idleAnimation.keyName,
        Mascot.dash.teamMascot.platformAnimation.keyName,
        Mascot.android.teamMascot.idleAnimation.keyName,
        Mascot.android.teamMascot.platformAnimation.keyName,
        Mascot.dino.teamMascot.idleAnimation.keyName,
        Mascot.dino.teamMascot.platformAnimation.keyName,
        Mascot.sparky.teamMascot.idleAnimation.keyName,
        Mascot.sparky.teamMascot.platformAnimation.keyName,
      ]);
    });

    testWidgets('renders a SpriteAnimationWidget when selected',
        (tester) async {
      await tester.pumpApp(
        TeamSelectionMascotPlatform(
          mascot: Mascot.sparky,
          selected: true,
        ),
      );

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });

    testWidgets('renders a platformNotSelected image when not selected',
        (tester) async {
      await tester.pumpApp(
        TeamSelectionMascotPlatform(
          mascot: Mascot.sparky,
          selected: false,
        ),
      );

      expect(
        find.image(Assets.images.platformNotSelected.provider()),
        findsOneWidget,
      );
    });
  });
}
