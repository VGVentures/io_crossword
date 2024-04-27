// ignore_for_file: prefer_const_constructors, one_member_abstracts

import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:mocktail/mocktail.dart';

abstract class _StubFunction {
  void call();
}

class _MockFunction extends Mock implements _StubFunction {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const dangleAssetPath = 'assets/anim/dash_dangle.png';
  const dropInAssetPath = 'assets/anim/dash_drop_in.png';

  setUpAll(() async {
    Flame.images = Images(prefix: '');
    await Flame.images.loadAll([
      dangleAssetPath,
      dropInAssetPath,
    ]);
  });

  group('SpriteAnimationList', () {
    final mockFunction = _MockFunction();

    final dangleSpriteInformation = SpriteInformation(
      path: dangleAssetPath,
      rows: 23,
      columns: 2,
      stepTime: 0.042,
      width: 150,
      height: 300,
    );

    final dropInSpriteInformation = SpriteInformation(
      path: dropInAssetPath,
      rows: 11,
      columns: 4,
      stepTime: 0.042,
      width: 150,
      height: 300,
    );

    final dangleAnimationListItem = AnimationListItem(
      spriteInformation: dangleSpriteInformation,
    );
    final dropInAnimationListItem = AnimationListItem(
      spriteInformation: dropInSpriteInformation,
      loop: false,
      onComplete: mockFunction.call,
    );

    testWidgets('renders SpriteAnimationList', (tester) async {
      final controller = SpriteListController();

      final spriteAnimationList = SpriteAnimationList(
        animationListItems: [
          dangleAnimationListItem,
          dropInAnimationListItem,
        ],
        controller: controller,
      );

      await tester.pumpWidget(spriteAnimationList);

      expect(find.byType(SpriteAnimationList), findsOneWidget);
    });

    testWidgets('shows the second animation when changed', (tester) async {
      final controller = SpriteListController();

      final spriteAnimationList = SpriteAnimationList(
        animationListItems: [
          dangleAnimationListItem,
          dropInAnimationListItem,
        ],
        controller: controller,
      );

      await tester.pumpWidget(spriteAnimationList);

      controller.changeAnimation(dropInSpriteInformation.path);

      controller.animationDataList.first.spriteAnimationTicker.setToLast();

      expect(
        controller.currentPlayingAnimationId,
        equals(dropInSpriteInformation.path),
      );
    });

    testWidgets('triggers onComplete when animation is done', (tester) async {
      final controller = SpriteListController();

      final spriteAnimationList = SpriteAnimationList(
        animationListItems: [
          dropInAnimationListItem,
        ],
        controller: controller,
      );

      await tester.pumpWidget(spriteAnimationList);

      controller.animationDataList.last.spriteAnimationTicker.setToLast();

      await controller.animationDataList.last.spriteAnimationTicker.completed;

      verify(mockFunction.call).called(1);
    });
  });
}
