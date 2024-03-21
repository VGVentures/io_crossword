import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' hide Axis, Image;
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';

class SectionTapController extends PositionComponent
    with ParentIsA<SectionComponent>, TapCallbacks {
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
        final wordLength = word.answer.length * CrosswordGame.cellSize;
        final width =
            word.axis == Axis.horizontal ? wordLength : CrosswordGame.cellSize;
        final height =
            word.axis == Axis.vertical ? wordLength : CrosswordGame.cellSize;

        final wordRect = Rect.fromLTWH(
          (word.position.x * CrosswordGame.cellSize).toDouble(),
          (word.position.y * CrosswordGame.cellSize).toDouble(),
          width.toDouble(),
          height.toDouble(),
        );

        if (wordRect.contains(localPosition.toOffset())) {
          parent.gameRef.bloc.add(
            WordSelected(parent.index, word),
          );
          break;
        }
      }
    }
  }
}

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

class SectionComponent extends Component with HasGameRef<CrosswordGame> {
  SectionComponent({
    required this.index,
    super.key,
  });

  final (int, int) index;
  late RenderMode _renderMode;

  SpriteBatchComponent? spriteBatchComponent;
  late Map<String, (int, int)> _wordIndex;
  late final StreamSubscription<CrosswordState> _subscription;

  BoardSection? _boardSection;

  @visibleForTesting
  String? lastSelectedWord;
  @visibleForTesting
  (int, int)? lastSelectedSection;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final state = gameRef.state;

    _subscription = gameRef.bloc.stream.listen(_onNewState);

    lastSelectedWord = state.selectedWord?.wordId;
    lastSelectedSection = state.selectedWord?.section;
    _renderMode = state.renderMode;

    final boardSection = gameRef.state.sections[index];
    if (boardSection != null) {
      _boardSection = boardSection;
      _loadWithCurrentRenderMode();
    } else {
      gameRef.bloc.add(
        BoardSectionRequested(index),
      );
    }

    if (gameRef.showDebugOverlay) {
      await addAll(
        [
          SectionDebugOutline(
            priority: 8,
            position: Vector2(
              index.$1 * gameRef.sectionSize.toDouble(),
              index.$2 * gameRef.sectionSize.toDouble(),
            ),
            size: Vector2.all(gameRef.sectionSize.toDouble()),
          ),
          SectionDebugIndex(
            priority: 10,
            index: index,
            position: Vector2(
              index.$1 * gameRef.sectionSize.toDouble(),
              index.$2 * gameRef.sectionSize.toDouble(),
            ),
          ),
        ],
      );
    }
  }

  @override
  void onRemove() {
    super.onRemove();
    _subscription.cancel();
  }

  void _loadWithCurrentRenderMode() {
    if (_renderMode == RenderMode.snapshot) {
      _loadSnapshot();
    } else {
      _loadBoardSection();
    }
  }

  void _onNewState(CrosswordState state) {
    if (state is CrosswordLoaded) {
      if (_boardSection == null) {
        final boardSection = state.sections[index];
        _renderMode = state.renderMode;
        if (boardSection != null) {
          _boardSection = boardSection;
          _loadWithCurrentRenderMode();
        }
      } else {
        if (_renderMode != state.renderMode) {
          _renderMode = state.renderMode;
          _loadWithCurrentRenderMode();
        }
        final selectedWord = state.selectedWord?.wordId;
        final selectedSection = state.selectedWord?.section;
        if (selectedWord != lastSelectedWord ||
            selectedSection != lastSelectedSection) {
          _updateSelection(
            previousWord: lastSelectedWord,
            newWord: selectedWord,
            previousSection: lastSelectedSection,
            newSection: selectedSection,
          );
        }
        lastSelectedWord = selectedWord;
        lastSelectedSection = selectedSection;
      }
    }
  }

  Vector2 get sectionPosition => Vector2(
        index.$1 * gameRef.sectionSize.toDouble(),
        index.$2 * gameRef.sectionSize.toDouble(),
      );

  Future<void> _loadSnapshot() async {
    final snapshot = await gameRef.networkImages.load(
      _boardSection!.snapshotUrl!,
    );

    spriteBatchComponent?.removeFromParent();
    add(
      SpriteComponent.fromImage(
        position: sectionPosition,
        snapshot,
      ),
    );
  }

  void _loadBoardSection() {
    final section = _boardSection;
    if (section == null) {
      return;
    }

    add(
      SectionTapController(
        position: sectionPosition,
        size: Vector2(
          gameRef.sectionSize.toDouble(),
          gameRef.sectionSize.toDouble(),
        ),
      ),
    );

    firstChild<SpriteComponent>()?.removeFromParent();

    final spriteBatch = SpriteBatch(gameRef.lettersSprite);

    _wordIndex = {};

    final color = Colors.white.withOpacity(.2);
    for (var i = 0; i < _boardSection!.words.length; i++) {
      final word = _boardSection!.words[i];

      final wordCharacters = word.answer.toUpperCase().characters;

      final wordIndexStart = spriteBatch.length;
      for (var c = 0; c < wordCharacters.length; c++) {
        late Rect rect;
        if (word.solvedTimestamp != null) {
          // A bug in coverage is preventing this block from being covered
          // coverage:ignore-start
          final char = wordCharacters.elementAt(c);
          final charIndex = char.codeUnitAt(0) - 65;
          rect = Rect.fromLTWH(
            (charIndex * CrosswordGame.cellSize).toDouble(),
            0,
            CrosswordGame.cellSize.toDouble(),
            CrosswordGame.cellSize.toDouble(),
          );
          // coverage:ignore-end
        } else {
          rect = Rect.fromLTWH(
            2080,
            0,
            CrosswordGame.cellSize.toDouble(),
            CrosswordGame.cellSize.toDouble(),
          );
        }

        final x = word.axis == Axis.horizontal
            ? word.position.x + c
            : word.position.x;

        final y =
            word.axis == Axis.vertical ? word.position.y + c : word.position.y;
        final offset = Vector2(
          x * CrosswordGame.cellSize.toDouble(),
          y * CrosswordGame.cellSize.toDouble(),
        );

        spriteBatch.add(
          source: rect,
          offset: offset,
          color: color,
        );
      }
      final wordIndexEnd = spriteBatch.length;
      _wordIndex[word.id] = (wordIndexStart, wordIndexEnd);
    }

    add(
      spriteBatchComponent = SpriteBatchComponent(
        spriteBatch: spriteBatch,
        blendMode: BlendMode.srcATop,
      ),
    );
  }

  void _updateSelection({
    String? previousWord,
    String? newWord,
    (int, int)? previousSection,
    (int, int)? newSection,
  }) {
    final indexes = <(String, Color, (int, int))>[];
    if (previousSection == index &&
        previousWord != null &&
        _wordIndex.containsKey(previousWord)) {
      indexes.add(
        (
          previousWord,
          Colors.white.withOpacity(.2),
          _wordIndex[previousWord]!,
        ),
      );
    }

    if (newSection == index &&
        newWord != null &&
        _wordIndex.containsKey(newWord)) {
      indexes.add(
        (
          newWord,
          Colors.white,
          _wordIndex[newWord]!,
        ),
      );
    }

    for (final index in indexes) {
      for (var i = index.$3.$1; i < index.$3.$2; i++) {
        spriteBatchComponent?.spriteBatch?.replace(
          i,
          color: index.$2,
        );
      }
    }
  }
}
