import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

/// {@template sprite_animation_list}
/// Widget that simplifies handling of multiple sprite animations.
/// {@endtemplate}
class SpriteAnimationList extends StatefulWidget {
  /// {@macro sprite_animation_list}
  const SpriteAnimationList({
    required this.animationItems,
    required this.controller,
    super.key,
  });

  /// The list of animations.
  final List<AnimationItem> animationItems;

  /// The controller that manages the sprite animations.
  final SpriteListController controller;

  @override
  State<SpriteAnimationList> createState() => _SpriteAnimationListState();
}

class _SpriteAnimationListState extends State<SpriteAnimationList> {
  final List<AnimationData> _animationDataList = [];

  late String _currentAnimationId;

  @override
  void initState() {
    super.initState();

    _currentAnimationId = widget.animationItems[0].spriteData.path;
    widget.controller.currentAnimationId = _currentAnimationId;
    widget.controller.currentPlayingAnimationId = _currentAnimationId;

    for (final animationItem in widget.animationItems) {
      final spriteAnimation = SpriteAnimation.fromFrameData(
        Flame.images.fromCache(animationItem.spriteData.path),
        SpriteAnimationData.sequenced(
          amount: animationItem.spriteData.amountPerRow *
              animationItem.spriteData.amountPerColumn,
          stepTime: animationItem.spriteData.stepTime,
          textureSize: Vector2(
            animationItem.spriteData.width,
            animationItem.spriteData.height,
          ),
          amountPerRow: animationItem.spriteData.amountPerRow,
          loop: animationItem.loop,
        ),
      );

      final ticker = spriteAnimation.createTicker()
        ..onFrame = ((_) => widget.controller.frameUpdated());

      _animationDataList.add(
        AnimationData(
          animationItem.spriteData.path,
          spriteAnimation,
          ticker,
          onComplete: animationItem.onComplete,
        ),
      );
    }

    widget.controller.animationDataList = _animationDataList;

    widget.controller.addListener(() {
      if (!widget.controller.updated &&
          (widget.controller.currentAnimationId == null ||
              _currentAnimationId == widget.controller.currentAnimationId)) {
        return;
      } else {
        final nextAnimationId = widget.controller.currentAnimationId;
        final index = _animationDataList.indexWhere(
          (element) => element.id == _currentAnimationId,
        );

        if (_animationDataList[index].spriteAnimationTicker.isLastFrame) {
          setState(() {
            _currentAnimationId = nextAnimationId!;
            widget.controller.currentPlayingAnimationId = nextAnimationId;
            widget.controller.updated = false;
            _animationDataList[index].onComplete?.call();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final animationData = _animationDataList.firstWhere(
      (element) => element.id == _currentAnimationId,
    );

    return SpriteAnimationWidget(
      key: ValueKey(animationData.id),
      animation: animationData.spriteAnimation,
      animationTicker: animationData.spriteAnimationTicker,
      onComplete: animationData.onComplete?.call,
    );
  }
}

/// {@template sprite_list_controller}
/// Controller that manages the sprite animations.
/// {@endtemplate}
class SpriteListController extends ChangeNotifier {
  /// The id of the animation that is currently playing.
  String? currentPlayingAnimationId;

  /// The list of animations.
  List<AnimationData> animationDataList = [];

  /// The id of the current animation.
  ///
  /// This could be different from the [currentPlayingAnimationId] if
  /// changeAnimation is called before the current animation completes.
  String? currentAnimationId;

  /// Whether the animation has been updated.
  bool updated = false;

  /// Changes the current animation to the one with the given [id].
  ///
  /// The animation will update once the current animation reaches the last
  /// frame in the current loop.
  void changeAnimation(String id) {
    currentAnimationId = id;
    updated = true;
    notifyListeners();
  }

  /// Plays the next animation in the list.
  void playNext() {
    final index = animationDataList.indexWhere(
      (element) => element.id == currentAnimationId,
    );

    if (index == -1) {
      return;
    }

    final nextIndex = index + 1;

    if (nextIndex >= animationDataList.length) {
      return;
    }

    currentAnimationId = animationDataList[nextIndex].id;

    updated = true;

    notifyListeners();
  }

  /// Notifies the listeners that the animation has been updated.
  void update() {
    updated = true;
    notifyListeners();
  }

  /// Notifies the listeners that the frame has been updated.
  void frameUpdated() {
    notifyListeners();
  }
}

/// {@template animation_item}
/// Data class that holds the sprite data and animation settings.
/// {@endtemplate}
class AnimationItem extends Equatable {
  /// {@macro animation_item}
  const AnimationItem({
    required this.spriteData,
    this.loop = true,
    this.onComplete,
  });

  /// The sprite data.
  final SpriteData spriteData;

  /// Whether the animation should loop.
  final bool loop;

  /// Callback that is called when the animation completes.
  final VoidCallback? onComplete;

  @override
  List<Object?> get props => [
        spriteData,
        loop,
        onComplete,
      ];
}

/// {@template animation_data}
/// Data class that contains what is needed for the [SpriteAnimationWidget].
/// {@endtemplate}
class AnimationData {
  /// {@macro animation_data}
  const AnimationData(
    this.id,
    this.spriteAnimation,
    this.spriteAnimationTicker, {
    this.onComplete,
  });

  /// The id of the animation.
  final String id;

  /// The sprite animation.
  final SpriteAnimation spriteAnimation;

  /// The sprite animation ticker.
  final SpriteAnimationTicker spriteAnimationTicker;

  /// Callback that is called when the animation completes.
  final VoidCallback? onComplete;
}

/// {@template sprite_data}
/// Data class that holds the sprite information.
/// {@endtemplate}
class SpriteData extends Equatable {
  /// {@macro sprite_data}
  const SpriteData({
    required this.path,
    required this.amountPerRow,
    required this.amountPerColumn,
    required this.width,
    required this.height,
    required this.stepTime,
  });

  /// The file path to the sprite image.
  final String path;

  /// The number of sprites per row in the sprite sheet.
  final int amountPerRow;

  /// The number of sprites per column in the sprite sheet.
  final int amountPerColumn;

  /// The width of each frame in the sprite sheet.
  final double width;

  /// The height of each frame in the sprite sheet.
  final double height;

  /// The time between each frame in the sprite sheet.
  final double stepTime;

  @override
  List<Object> get props => [
        path,
        amountPerRow,
        amountPerColumn,
        width,
        height,
        stepTime,
      ];
}
