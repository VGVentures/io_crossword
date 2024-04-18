// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

void main() {
  group('TeamSelectionCubit', () {
    test('initial state is 0', () {
      expect(
        TeamSelectionCubit().state,
        TeamSelectionState(),
      );
    });

    group('load', () {
      TestWidgetsFlutterBinding.ensureInitialized();

      test('emits loadingComplete status', () {
        final cubit = TeamSelectionCubit();

        const expectedStates = [
          TeamSelectionState(),
          TeamSelectionState(status: TeamSelectionStatus.loadingComplete),
        ];

        expectLater(
          cubit.stream,
          emitsInOrder(expectedStates),
        );

        cubit.load();
      });
    });

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
  });
}
