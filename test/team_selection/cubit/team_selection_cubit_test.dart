// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

void main() {
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
  });
}
