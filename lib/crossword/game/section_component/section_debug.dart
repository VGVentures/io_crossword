part of 'section_component.dart';

class SectionDebugOutline extends RectangleComponent
    with ParentIsA<SectionComponent> {
  SectionDebugOutline({
    required Vector2 position,
    required Vector2 size,
    super.priority,
  }) : super(
          position: position,
          size: size,
          paint: Paint()
            ..color = Colors.pink
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
}

class SectionDebugIndex extends TextComponent
    with ParentIsA<SectionComponent>, HasGameRef<CrosswordGame> {
  SectionDebugIndex({
    required Vector2 position,
    required (int, int) index,
    super.priority,
  }) : super(
          position: position,
          text: '(${index.$1}, ${index.$2})',
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.pink,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
}
