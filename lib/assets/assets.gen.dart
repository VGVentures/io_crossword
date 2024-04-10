/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsAnimGen {
  const $AssetsAnimGen();

  /// File path: assets/anim/android_celebrating.png
  AssetGenImage get androidCelebrating =>
      const AssetGenImage('assets/anim/android_celebrating.png');

  /// File path: assets/anim/android_dangle.png
  AssetGenImage get androidDangle =>
      const AssetGenImage('assets/anim/android_dangle.png');

  /// File path: assets/anim/android_idle.png
  AssetGenImage get androidIdle =>
      const AssetGenImage('assets/anim/android_idle.png');

  /// File path: assets/anim/android_look_up.png
  AssetGenImage get androidLookUp =>
      const AssetGenImage('assets/anim/android_look_up.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [androidCelebrating, androidDangle, androidIdle, androidLookUp];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/io.svg
  SvgGenImage get io => const SvgGenImage('assets/icons/io.svg');

  /// List of all assets
  List<SvgGenImage> get values => [io];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/android.png
  AssetGenImage get android => const AssetGenImage('assets/images/android.png');

  /// File path: assets/images/android_platform.png
  AssetGenImage get androidPlatform =>
      const AssetGenImage('assets/images/android_platform.png');

  /// File path: assets/images/dash.png
  AssetGenImage get dash => const AssetGenImage('assets/images/dash.png');

  /// File path: assets/images/dash_platform.png
  AssetGenImage get dashPlatform =>
      const AssetGenImage('assets/images/dash_platform.png');

  /// File path: assets/images/dino.png
  AssetGenImage get dino => const AssetGenImage('assets/images/dino.png');

  /// File path: assets/images/dino_platform.png
  AssetGenImage get dinoPlatform =>
      const AssetGenImage('assets/images/dino_platform.png');

  /// File path: assets/images/letters.png
  AssetGenImage get letters => const AssetGenImage('assets/images/letters.png');

  /// File path: assets/images/platform.png
  AssetGenImage get platform =>
      const AssetGenImage('assets/images/platform.png');

  /// File path: assets/images/sparky.png
  AssetGenImage get sparky => const AssetGenImage('assets/images/sparky.png');

  /// File path: assets/images/sparky_platform.png
  AssetGenImage get sparkyPlatform =>
      const AssetGenImage('assets/images/sparky_platform.png');

  /// File path: assets/images/tile.png
  AssetGenImage get tile => const AssetGenImage('assets/images/tile.png');

  /// File path: assets/images/welcome_background.png
  AssetGenImage get welcomeBackground =>
      const AssetGenImage('assets/images/welcome_background.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        android,
        androidPlatform,
        dash,
        dashPlatform,
        dino,
        dinoPlatform,
        letters,
        platform,
        sparky,
        sparkyPlatform,
        tile,
        welcomeBackground
      ];
}

class Assets {
  Assets._();

  static const $AssetsAnimGen anim = $AssetsAnimGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
