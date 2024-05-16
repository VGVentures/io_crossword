// ignore_for_file: prefer_const_constructors, one_member_abstracts

import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

abstract class _StubFunction {
  void call();
}

class _MockFunction extends Mock implements _StubFunction {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const dangleAssetPath = 'assets/anim/dash_dangle.png';
  const dropInAssetPath = 'assets/anim/dash_drop_in.png';

  group('SpriteAnimationList', () {
    setUpAll(() async {
      Flame.images = Images(prefix: '');
      await Flame.images.loadAll([
        dangleAssetPath,
        dropInAssetPath,
      ]);
    });
    final mockFunction = _MockFunction();

    final dangleSpriteData = SpriteData(
      path: dangleAssetPath,
      amountPerRow: 23,
      amountPerColumn: 2,
      stepTime: 0.042,
      width: 150,
      height: 300,
    );

    final dropInSpriteData = SpriteData(
      path: dropInAssetPath,
      amountPerRow: 11,
      amountPerColumn: 4,
      stepTime: 0.042,
      width: 150,
      height: 300,
    );

    final dangleAnimationListItem = AnimationItem(
      spriteData: dangleSpriteData,
    );
    final dropInAnimationListItem = AnimationItem(
      spriteData: dropInSpriteData,
      loop: false,
      onComplete: mockFunction.call,
    );

    testWidgets('renders SpriteAnimationList', (tester) async {
      final controller = SpriteListController();

      final spriteAnimationList = SpriteAnimationList(
        animationItems: [
          dangleAnimationListItem,
          dropInAnimationListItem,
        ],
        controller: controller,
      );

      await tester.pumpWidget(spriteAnimationList);

      expect(find.byType(SpriteAnimationList), findsOneWidget);
    });

    testWidgets('plays next animation when playNext is called', (tester) async {
      final controller = SpriteListController();

      final spriteAnimationList = SpriteAnimationList(
        animationItems: [
          dangleAnimationListItem,
          dropInAnimationListItem,
        ],
        controller: controller,
      );

      await tester.pumpWidget(spriteAnimationList);

      controller.playNext();

      controller.animationDataList.first.spriteAnimationTicker.setToLast();

      expect(
        controller.currentAnimationId,
        equals(dropInSpriteData.path),
      );
    });

    testWidgets('triggers onComplete when animation is done', (tester) async {
      final controller = SpriteListController();

      final spriteAnimationList = SpriteAnimationList(
        animationItems: [
          dropInAnimationListItem,
        ],
        controller: controller,
      );

      await tester.pumpWidget(spriteAnimationList);

      controller.animationDataList.last.spriteAnimationTicker.setToLast();

      await controller.animationDataList.last.spriteAnimationTicker.completed;

      verify(mockFunction.call).called(1);
    });

    group('AnimationItem', () {
      test('supports equality', () {
        final animationItem1 = AnimationItem(
          spriteData: dangleSpriteData,
        );

        final animationItem2 = AnimationItem(
          spriteData: dangleSpriteData,
        );

        expect(animationItem1, equals(animationItem2));
      });
    });

    group('SpriteData', () {
      test('supports equality', () {
        final spriteData1 = SpriteData(
          path: 'path',
          amountPerRow: 16,
          amountPerColumn: 5,
          stepTime: 0.042,
          width: 225,
          height: 325,
        );

        final spriteData2 = SpriteData(
          path: 'path',
          amountPerRow: 16,
          amountPerColumn: 5,
          stepTime: 0.042,
          width: 225,
          height: 325,
        );

        expect(spriteData1, equals(spriteData2));
      });
    });
  });
}
