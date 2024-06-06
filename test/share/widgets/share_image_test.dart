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

    testWidgets('displays shareDash image with ${Mascot.dash}', (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascot.dash)),
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

    testWidgets('displays shareAndroid image with ${Mascot.dino}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascot.dino)),
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

    testWidgets('displays shareDino image with ${Mascot.sparky}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascot.sparky)),
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

    testWidgets('displays shareSparky image with ${Mascot.android}',
        (tester) async {
      when(() => playerBloc.state).thenReturn(
        PlayerState(player: Player.empty.copyWith(mascot: Mascot.android)),
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
