// ignore_for_file: prefer_const_constructors

import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TeamSelectionCubit', () {
    group('selectTeam', () {
      test('emits the team index', () {
        final cubit = TeamSelectionCubit();

        const teamIndex = 1;
        final expectedStates = [TeamSelectionState(index: teamIndex)];

        expectLater(
          cubit.stream,
          emitsInOrder(expectedStates),
        );

        cubit.selectTeam(teamIndex);
      });
    });

    group('loadAssets', () {
      setUp(() {
        Flame.images = Images(prefix: '');
      });

      test('emits inProgress and success', () {
        final cubit = TeamSelectionCubit();

        final expectedStates = [
          TeamSelectionState(),
          TeamSelectionState(assetsStatus: AssetsLoadingStatus.success),
        ];

        expectLater(
          cubit.stream,
          emitsInOrder(expectedStates),
        );

        cubit.loadAssets();
      });
    });
  });
}
