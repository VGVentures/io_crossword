import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'package:io_crossword/crossword/game/game.dart';

class MiniMap extends PositionComponent
    with HasGameRef<CrosswordGame>, TapCallbacks {
  MiniMap({
    super.position,
  }) : super(priority: 100, size: Vector2.all(200));

  static const miniMapSize = 200.0;

  late final RectangleComponent reticle;
  late final Image mapImage;

  late Vector2 _reticleSize;
  late Vector2 _reticlePosition;

  void calculateReticleSize() {
    final gameSize = gameRef.size /
        (CrosswordGame.cellSize.toDouble() * gameRef.camera.viewfinder.zoom);

    final xRate = gameSize.x / mapImage.width;
    final yRate = gameSize.y / mapImage.height;

    _reticleSize = Vector2(
      xRate * miniMapSize,
      yRate * miniMapSize,
    );

    final cameraX = gameRef.camera.viewfinder.position.x /
        (mapImage.width * CrosswordGame.cellSize);
    final cameraY = gameRef.camera.viewfinder.position.y /
        (mapImage.height * CrosswordGame.cellSize);

    _reticlePosition = Vector2(
          cameraX * miniMapSize,
          cameraY * miniMapSize,
        ) +
        (Vector2.all(miniMapSize) - _reticleSize) / 2.0;
  }

  void _updateRecticle() {
    calculateReticleSize();
    reticle
      ..size = _reticleSize
      ..position = _reticlePosition;
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);

    final x = event.localPosition.x / miniMapSize;
    final y = event.localPosition.y / miniMapSize;

    final totalWidth = mapImage.width * CrosswordGame.cellSize;
    final totalHeight = mapImage.height * CrosswordGame.cellSize;

    final xTween = Tween(
      begin: -totalWidth / 2,
      end: totalWidth / 2,
    );

    final yTween = Tween(
      begin: -totalHeight / 2,
      end: totalHeight / 2,
    );

    final cameraX = xTween.transform(x);
    final cameraY = yTween.transform(y);

    gameRef.camera.viewfinder.position = Vector2(cameraX, cameraY);

    gameRef.updateVisibleSections();
  }

  Vector2? _lastCameraPosition;
  Vector2? _lastGameSize;
  double? _lastZoom;

  @override
  void update(double dt) {
    super.update(dt);

    if (_lastCameraPosition != gameRef.camera.viewfinder.position ||
        _lastGameSize != gameRef.size ||
        _lastZoom != gameRef.camera.viewfinder.zoom) {
      _updateRecticle();
      _lastCameraPosition = gameRef.camera.viewfinder.position;
      _lastGameSize = gameRef.size;
      _lastZoom = gameRef.camera.viewfinder.zoom;
    }
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    // TODO(any): Load from the server and update from time to time.
    mapImage = await gameRef.images.load('full_render.png');

    calculateReticleSize();

    await add(
      RectangleComponent(
        paint: Paint()..color = const Color(0x88000000),
        size: Vector2.all(miniMapSize),
        children: [
          SpriteComponent.fromImage(
            mapImage,
            size: Vector2.all(miniMapSize),
          ),
          reticle = RectangleComponent(
            position: _reticlePosition,
            paint: Paint()
              ..color = const Color(0xFFFFFF00)
              ..strokeWidth = 1
              ..style = PaintingStyle.stroke,
            size: _reticleSize,
          ),
        ],
      ),
    );
  }
}
