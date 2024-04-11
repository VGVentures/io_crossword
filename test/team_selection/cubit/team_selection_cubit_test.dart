import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

void main() {
  group('TeamSelectionCubit', () {
    test('initial state is 0', () {
      expect(TeamSelectionCubit().state, 0);
    });

    group('selectTeam', () {
      test('emits the team index', () {
        final cubit = TeamSelectionCubit();

        const teamIndex = 1;
        final expectedStates = [teamIndex];

        expectLater(
          cubit.stream,
          emitsInOrder(expectedStates),
        );

        cubit.selectTeam(teamIndex);
      });
    });
  });
}
