// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

void main() {
  group('$ShareImage', () {
    late PlayerBloc playerBloc;

    setUp(() {
      playerBloc = _MockPlayerBloc();
    });

    testWidgets('displays shareDash image with ${Mascots.dash}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascots.dash)),
      );

      await tester.pumpApp(
        ShareImage(),
        playerBloc: playerBloc,
      );

      expect(
        (tester.widget<Image>(find.byType(Image)).image as AssetImage)
            .assetName,
        equals('assets/images/share_dash.png'),
      );
    });

    testWidgets('displays shareAndroid image with ${Mascots.dino}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascots.dino)),
      );

      await tester.pumpApp(
        ShareImage(),
        playerBloc: playerBloc,
      );

      await tester.pumpApp(ShareImage());

      expect(
        (tester.widget<Image>(find.byType(Image)).image as AssetImage)
            .assetName,
        equals('assets/images/share_dino.png'),
      );
    });

    testWidgets('displays shareDino image with ${Mascots.sparky}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascots.sparky)),
      );

      await tester.pumpApp(
        ShareImage(),
        playerBloc: playerBloc,
      );

      await tester.pumpApp(ShareImage());

      expect(
        (tester.widget<Image>(find.byType(Image)).image as AssetImage)
            .assetName,
        equals('assets/images/share_sparky.png'),
      );
    });

    testWidgets('displays shareSparky image with ${Mascots.android}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascots.android)),
      );

      await tester.pumpApp(
        ShareImage(),
        playerBloc: playerBloc,
      );

      await tester.pumpApp(ShareImage());

      expect(
        (tester.widget<Image>(find.byType(Image)).image as AssetImage)
            .assetName,
        equals('assets/images/share_android.png'),
      );
    });
  });
}
