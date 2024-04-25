import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

class SpriteAnimationList extends StatefulWidget {
  const SpriteAnimationList({
    required this.animationListItems,
    required this.controller,
    super.key,
  });

  final List<AnimationListItem> animationListItems;
  final SpriteListController controller;

  @override
  State<SpriteAnimationList> createState() => _SpriteAnimationListState();
}

class _SpriteAnimationListState extends State<SpriteAnimationList> {
  final List<_AnimationData> _animationDataList = [];

  late String _currentAnimationId;

  @override
  void initState() {
    super.initState();

    _currentAnimationId = widget.animationListItems[0].path;

    for (final animationItem in widget.animationListItems) {
      final spriteAnimation = SpriteAnimation.fromFrameData(
        Flame.images.fromCache(animationItem.path),
        SpriteAnimationData.sequenced(
          amount: animationItem.spriteInformation.rows *
              animationItem.spriteInformation.columns,
          stepTime: animationItem.spriteInformation.stepTime,
          textureSize: Vector2(
            animationItem.spriteInformation.width,
            animationItem.spriteInformation.height,
          ),
          amountPerRow: animationItem.spriteInformation.rows,
          loop: animationItem.loop,
        ),
      );

      final ticker = spriteAnimation.createTicker()
        ..onFrame = (details) {
          widget.controller.setFrameNumber(details);
        };

      _animationDataList.add(
        _AnimationData(
          animationItem.path,
          spriteAnimation,
          ticker,
          onComplete: animationItem.onComplete,
        ),
      );
    }

    widget.controller.addListener(() {
      if (widget.controller.currentAnimationId == null ||
          _currentAnimationId == widget.controller.currentAnimationId) {
        return;
      } else {
        final nextAnimationId = widget.controller.currentAnimationId;
        final index = _animationDataList.indexWhere(
          (element) => element.id == _currentAnimationId,
        );

        if (_animationDataList[index].spriteAnimationTicker.isLastFrame) {
          setState(() {
            _currentAnimationId = nextAnimationId!;
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
      animation: animationData.spriteAnimation,
      animationTicker: animationData.spriteAnimationTicker,
      onComplete: () {
        animationData.onComplete?.call();
      },
    );
  }
}

class SpriteListController extends ChangeNotifier {
  String? _currentAnimationId;
  int _frameNumber = 0;

  String? get currentAnimationId => _currentAnimationId;

  void changeAnimation(String id) {
    _currentAnimationId = id;
    notifyListeners();
  }

  void setFrameNumber(int frameNumber) {
    _frameNumber = frameNumber;
    notifyListeners();
  }

  int get frameNumber => _frameNumber;
}

class AnimationListItem {
  const AnimationListItem({
    required this.path,
    required this.spriteInformation,
    this.loop = true,
    this.onComplete,
  });

  final String path;
  final SpriteInformation spriteInformation;
  final bool loop;
  final VoidCallback? onComplete;
}

class _AnimationData {
  const _AnimationData(
    this.id,
    this.spriteAnimation,
    this.spriteAnimationTicker, {
    this.onComplete,
  });

  final String id;
  final SpriteAnimation spriteAnimation;
  final SpriteAnimationTicker spriteAnimationTicker;
  final VoidCallback? onComplete;
}
