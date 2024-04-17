// ignore_for_file: prefer_const_constructors

import 'package:flame/flame.dart';
import 'package:flame/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

import '../../helpers/helpers.dart';

void main() {
  group('TeamSelectionMascot', () {
    setUpAll(() async {
      await Flame.images.loadAll([
        Mascots.dash.idleAnimation,
        Mascots.dash.platformAnimation,
        Mascots.android.idleAnimation,
        Mascots.android.platformAnimation,
        Mascots.sparky.idleAnimation,
        Mascots.sparky.platformAnimation,
        Mascots.dino.idleAnimation,
        Mascots.dino.platformAnimation,
      ]);
    });

    testWidgets('renders a SpriteAnimationWidget', (tester) async {
      await tester.pumpApp(TeamSelectionMascot(Mascots.sparky));

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });
  });
}
