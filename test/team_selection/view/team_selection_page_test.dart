import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockTeamSelectionCubit extends MockCubit<int>
    implements TeamSelectionCubit {}

void main() {
  group('$TeamSelectionPage', () {
    testWidgets('renders a TeamSelectionView', (tester) async {
      await tester.pumpApp(const TeamSelectionPage());

      expect(find.byType(TeamSelectionView), findsOneWidget);
    });
  });

  group('$TeamSelectionView', () {
    late TeamSelectionCubit cubit;
    late Widget widget;

    setUp(() {
      cubit = _MockTeamSelectionCubit();

      widget = BlocProvider<TeamSelectionCubit>(
        create: (_) => cubit,
        child: const TeamSelectionView(),
      );
    });

    group('TeamSelectionView', () {
      testWidgets('displays TabBarView on small screen', (tester) async {
        when(() => cubit.state).thenReturn(0);

        await tester.pumpApp(
          widget,
          layout: IoLayoutData.small,
        );

        expect(find.byType(TabBarView), findsOneWidget);
      });

      testWidgets('select Sparky when right button is tapped', (tester) async {
        when(() => cubit.state).thenReturn(0);

        await tester.pumpApp(
          widget,
          layout: IoLayoutData.small,
        );

        await tester.tap(find.byIcon(Icons.chevron_right));

        verify(() => cubit.selectTeam(1)).called(1);
      });

      testWidgets('select Dash when left button is tapped', (tester) async {
        when(() => cubit.state).thenReturn(1);

        await tester.pumpApp(
          widget,
          layout: IoLayoutData.large,
        );

        await tester.tap(find.byIcon(Icons.chevron_left));

        verify(() => cubit.selectTeam(0)).called(1);
      });
    });
  });
}
