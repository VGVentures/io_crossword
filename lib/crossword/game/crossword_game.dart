import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/debug.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/word_selection/word_selection.dart';

class CrosswordGame extends FlameGame
    with PanDetector, HasKeyboardHandlerComponents {
  CrosswordGame({
    required this.crosswordBloc,
    required this.playerBloc,
    required this.wordSelectionBloc,
    bool? showDebugOverlay,
  }) : showDebugOverlay = showDebugOverlay ?? debugOverlay;

  static const cellSize = 80;

  static bool debugOverlay = false;
  final bool showDebugOverlay;

  final CrosswordBloc crosswordBloc;
  final PlayerBloc playerBloc;

  final WordSelectionBloc wordSelectionBloc;

  late final int sectionSize;

  late final Image lettersSprite;

  var _visibleSections = <(double, double)>[];

  CrosswordState get state {
    return crosswordBloc.state;
  }

  Player get player {
    return playerBloc.state.player;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    // TODO(erickzanardo): Use the assets cubit instead
    lettersSprite = await images.load('letters.png');

    sectionSize = state.sectionSize * cellSize;

    camera.priority = 1;

    _updateVisibleSections();

    if (showDebugOverlay) {
      await add(
        RectangleComponent(
          size: Vector2(
            200,
            50,
          ),
          paint: Paint()..color = const Color(0xFF000000),
          children: [
            FpsComponent(),
            FpsTextComponent(),
            ChildCounterComponent<SectionComponent>(
              position: Vector2(0, 30),
              target: world,
            ),
          ],
        ),
      );
    }
  }

  void _updateVisibleSections() {
    final visibleViewport = camera.visibleWorldRect;

    final horizontalSectionsVisibleInViewport =
        (visibleViewport.width / sectionSize).ceilToDouble();
    final verticalSectionsVisibleInViewport =
        (visibleViewport.height / sectionSize).ceilToDouble();

    final cameraPosition = camera.viewfinder.position;

    final cameraPositionIndex = Vector2(
      (cameraPosition.x / sectionSize).floorToDouble(),
      (cameraPosition.y / sectionSize).floorToDouble(),
    );

    final startSection = cameraPositionIndex -
        Vector2(
          horizontalSectionsVisibleInViewport,
          verticalSectionsVisibleInViewport,
        );

    final endSection = cameraPositionIndex +
        Vector2(
          horizontalSectionsVisibleInViewport,
          verticalSectionsVisibleInViewport,
        );

    final currentVisibleSections = <(double, double)>[];
    final lx = endSection.x - startSection.x;
    final ly = endSection.y - startSection.y;

    for (var x = startSection.x; x <= endSection.x; x++) {
      for (var y = startSection.y; y <= endSection.y; y++) {
        final dx = x - startSection.x;
        final dy = y - startSection.y;

        // Skip edges
        // If the viewport allow just a 2x2 grid, we
        // don't skip edges, since all sections are edges.
        if ((lx >= 4 && ly >= 4) &&
            (
                // Top left
                (dx == 0 && dy == 0) ||
                    // Top right
                    (dx == lx - 1 && dy == 0) ||
                    // Bottom left
                    (dx == 0 && dy == ly - 1) ||
                    // Bottom right
                    (dx == lx - 1 && dy == ly - 1))) {
          continue;
        }

        final sectionIndex = (x, y);
        currentVisibleSections.add(sectionIndex);
      }
    }
    final sectionsToRemove =
        _visibleSections.toSet().difference(currentVisibleSections.toSet());
    final sectionsToAdd =
        currentVisibleSections.toSet().difference(_visibleSections.toSet());

    if (sectionsToRemove.isNotEmpty) {
      for (final sectionIndex in sectionsToRemove) {
        findByKeyName('section-$sectionIndex')?.removeFromParent();
      }
    }

    if (sectionsToAdd.isNotEmpty) {
      for (final sectionIndex in sectionsToAdd) {
        if (findByKeyName('section-$sectionIndex') != null) {
          continue;
        }
        world.add(
          SectionComponent(
            key: ComponentKey.named('section-$sectionIndex'),
            index: (
              sectionIndex.$1.toInt(),
              sectionIndex.$2.toInt(),
            ),
          ),
        );
      }
    }

    _visibleSections = currentVisibleSections;
  }

  var _distanceMoved = 0.0;

  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);

    _distanceMoved += info.delta.global.length;
    camera.viewfinder.position -= info.delta.global / camera.viewfinder.zoom;

    if (_distanceMoved >= 280) {
      _distanceMoved = 0;
      _updateVisibleSections();
    }
  }

  void zoomOut() {
    if (camera.viewfinder.zoom <= 0.05 ||
        camera.viewfinder.zoom <= state.zoomLimit) {
      return;
    }
    camera.viewport.position /= 1.05;

    camera.viewfinder.zoom -= 0.05;

    _updateVisibleSections();
  }

  void zoomIn() {
    if (camera.viewfinder.zoom >= 1.1) {
      return;
    }

    camera.viewport.position *= 1.05;

    camera.viewfinder.zoom += 0.05;

    _updateVisibleSections();
  }

  @override
  Color backgroundColor() {
    return const Color(0xFF212123);
  }

  bool get isMobile {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }
}
