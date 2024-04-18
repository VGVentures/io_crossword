// ignore_for_file: prefer_const_constructors

import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flame/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

import '../../helpers/helpers.dart';

void main() {
  group('TeamSelectionMascot', () {
    setUpAll(() async {
      Flame.images = Images(prefix: '');
      await Flame.images.loadAll([
        Mascots.dash.teamMascot.idleAnimation.keyName,
        Mascots.android.teamMascot.platformAnimation.keyName,
      ]);
    });

    testWidgets('renders a SpriteAnimationWidget', (tester) async {
      await tester.pumpApp(TeamSelectionMascot(Mascots.sparky));

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });
  });
}
