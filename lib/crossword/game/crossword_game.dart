import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:io_crossword/crossword/crossword.dart';

class CrosswordGame extends FlameGame with PanDetector {
  CrosswordGame(this.bloc);

  static const cellSize = 40;

  final CrosswordBloc bloc;

  late final Size totalArea;
  late final int sectionSize;

  late final Image lettersSprite;

  var _visibleSections = <(double, double)>[];

  CrosswordLoaded get state {
    final state = bloc.state;
    if (state is! CrosswordLoaded) {
      throw ArgumentError('Cannot load game without a loaded state.');
    }
    return state;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    // TODO(erickzanardo): Use the assets cubit instead
    lettersSprite = await images.load('letters.png');

    sectionSize = state.sectionSize * cellSize;

    totalArea = Size(
      (state.width * cellSize).toDouble(),
      (state.height * cellSize).toDouble(),
    );

    camera
      ..priority = 1
      ..viewport = (MaxViewport()..anchor = Anchor.topLeft)
      ..viewfinder.position = Vector2(
        totalArea.width,
        totalArea.height,
      );

    _updateVisibleSections();
  }

  void _updateVisibleSections() {
    final visibleViewport = camera.visibleWorldRect;

    final viewportMiddle = visibleViewport.size / 2;

    final horizontalSectionsVisibleInViewport =
        (visibleViewport.width / sectionSize).ceilToDouble();
    final verticalSectionsVisibleInViewport =
        (visibleViewport.height / sectionSize).ceilToDouble();

    final cameraPosition =
        camera.viewfinder.position + viewportMiddle.toVector2();

    final startSection = Vector2(
          ((cameraPosition.x - viewportMiddle.width) ~/ sectionSize).toDouble(),
          ((cameraPosition.y - viewportMiddle.height) ~/ sectionSize)
              .toDouble(),
        ) -
        Vector2(
          horizontalSectionsVisibleInViewport,
          verticalSectionsVisibleInViewport,
        );

    final endSection = Vector2(
          ((cameraPosition.x + viewportMiddle.width) ~/ sectionSize).toDouble(),
          ((cameraPosition.y + viewportMiddle.height) ~/ sectionSize)
              .toDouble(),
        ) +
        Vector2(
          horizontalSectionsVisibleInViewport,
          verticalSectionsVisibleInViewport,
        );

    final currentVisibleSections = <(double, double)>[];
    for (var x = startSection.x; x <= endSection.x; x++) {
      for (var y = startSection.y; y <= endSection.y; y++) {
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
    camera.viewfinder.position -= info.delta.global;

    if (_distanceMoved >= 280) {
      _distanceMoved = 0;
      _updateVisibleSections();
    }
  }

  void zoomOut() {
    if (camera.viewfinder.zoom <= 0.05) {
      return;
    }
    camera.viewport.position /= 1.05;
    camera.viewfinder.zoom = camera.viewfinder.zoom - 0.05;

    _updateVisibleSections();
  }

  void zoomIn() {
    camera.viewport.position *= 1.05;
    camera.viewfinder.zoom += 0.05;

    _updateVisibleSections();
  }
}
