import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'package:io_crossword/crossword/game/game.dart';

class MiniMap extends RectangleComponent
    with HasGameRef<CrosswordGame>, TapCallbacks {
  MiniMap({
    super.position,
  }) : super(priority: 100, size: Vector2.all(200));

  static const miniMapSize = 200.0;

  late final RectangleComponent reticle;
  late final SpriteComponent map;
  late final Image mapImage;
  bool expanded = false;

  late Vector2 _mapImageSize;
  late Vector2 _reticleSize;
  late Vector2 _reticlePosition;

  void calculateReticleSize() {
    final gameSize = gameRef.size /
        (CrosswordGame.cellSize.toDouble() * gameRef.camera.viewfinder.zoom);

    final xRate = gameSize.x / mapImage.width;
    final yRate = gameSize.y / mapImage.height;

    _reticleSize = Vector2(
      xRate * size.x,
      yRate * size.x,
    );

    final cameraX = gameRef.camera.viewfinder.position.x /
        (mapImage.width * CrosswordGame.cellSize);
    final cameraY = gameRef.camera.viewfinder.position.y /
        (mapImage.height * CrosswordGame.cellSize);

    _reticlePosition = Vector2(
          cameraX * size.x,
          cameraY * size.x,
        ) +
        (Vector2.all(size.x) - _reticleSize) / 2.0;
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

    final x = event.localPosition.x / size.x;
    final y = event.localPosition.y / size.y;

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

  //void _zoom(double zoom) {
  //  _mapImageSize += Vector2.all(zoom * miniMapSize);
  //  map.size = _mapImageSize;
  //}

  void _expand() {
    if (expanded) {
      position = Vector2(
        gameRef.size.x - miniMapSize - 40,
        40,
      );
      size = Vector2.all(miniMapSize);
      map.size = _mapImageSize;
      firstChild<ClipComponent>()?.size = size;
      expanded = false;

      firstChild<MiniMapZoomButton>()?.position =
          Vector2(miniMapSize - 40, miniMapSize - 40);

      _updateRecticle();
    } else {
      final newTentativeSize = gameRef.size - Vector2.all(40);
      final newSize = Vector2.all(
        math.min(newTentativeSize.x, newTentativeSize.y),
      );

      final newPosition = Vector2(
        gameRef.size.x / 2 - newSize.x / 2,
        gameRef.size.y / 2 - newSize.y / 2,
      );

      position = newPosition;
      size = newSize;
      firstChild<ClipComponent>()?.size = newSize;
      map.size = newSize;
      expanded = true;

      firstChild<MiniMapZoomButton>()?.position =
          Vector2(newSize.x - 40, newSize.y - 40);

      _updateRecticle();
    }
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    paint = Paint()..color = const Color(0x88000000);

    // TODO(any): Load from the server and update from time to time.
    mapImage = await gameRef.images.load('full_render.png');
    _mapImageSize = Vector2.all(miniMapSize);

    calculateReticleSize();
    size = Vector2.all(miniMapSize);

    await addAll([
      ClipComponent.rectangle(
        size: size,
        children: [
          map = SpriteComponent.fromImage(
            mapImage,
            size: _mapImageSize,
          ),
        ],
      ),
      reticle = RectangleComponent(
        position: _reticlePosition,
        paint: Paint()
          ..color = const Color(0xFFFFFF00)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
        size: _reticleSize,
      ),
      //MiniMapZoomButton(
      //  position: Vector2(miniMapSize - 40, miniMapSize - 40),
      //  paint: Paint()..color = const Color(0xFFFF0000),
      //  onTap: () {
      //    _zoom(0.01);
      //  },
      //),
      MiniMapZoomButton(
        position: Vector2(miniMapSize - 40, miniMapSize - 40),
        paint: Paint()..color = const Color(0xFF0000FF),
        onTap: _expand,
      ),
    ]);
  }
}

class MiniMapZoomButton extends RectangleComponent
    with ParentIsA<MiniMap>, TapCallbacks {
  MiniMapZoomButton({
    required this.onTap,
    super.position,
    super.paint,
  }) : super(size: Vector2.all(40));

  final void Function() onTap;

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    onTap();
  }
}
