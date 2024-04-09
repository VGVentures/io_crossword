part of 'section_component.dart';

class SectionTapController extends PositionComponent
    with ParentIsA<SectionComponent>, TapCallbacks, HasGameRef<CrosswordGame> {
  SectionTapController({
    super.position,
    super.size,
  });

  @override
  void onTapUp(TapUpEvent event) {
    final boardSection = parent._boardSection;

    if (boardSection != null) {
      final absolutePosition =
          boardSection.position * CrosswordGame.cellSize * boardSection.size;
      final localPosition = event.localPosition +
          Vector2(
            absolutePosition.x.toDouble(),
            absolutePosition.y.toDouble(),
          );

      for (final word in [...boardSection.words, ...boardSection.borderWords]) {
        final wordRect = Rect.fromLTWH(
          (word.position.x * CrosswordGame.cellSize).toDouble(),
          (word.position.y * CrosswordGame.cellSize).toDouble(),
          word.width.toDouble(),
          word.height.toDouble(),
        );

        if (wordRect.contains(localPosition.toOffset())) {
          gameRef.bloc.add(WordSelected(parent.index, word));
          final viewportWidth = gameRef.camera.visibleWorldRect.size.width;
          final newCameraPosition = gameRef.isMobile
              ? Vector2(
                  wordRect.left + wordRect.width / 2,
                  wordRect.top + wordRect.height / 2,
                )
              : Vector2(
                  wordRect.left + wordRect.width / 2,
                  wordRect.top + wordRect.height / 2,
                ).translated(
                  viewportWidth * WordFocusedDesktopView.widthRatio / 2,
                  0,
                );

          gameRef.camera.viewfinder.add(
            MoveEffect.to(
              newCameraPosition,
              CurvedEffectController(.8, Curves.easeInOut),
            ),
          );

          break;
        }
      }
    }
  }
}
