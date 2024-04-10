// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockTeamSelectionCubit extends MockCubit<int>
    implements TeamSelectionCubit {}

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

void main() {
  group('$TeamSelectionPage', () {
    testWidgets('renders a TeamSelectionView', (tester) async {
      await tester.pumpApp(const TeamSelectionPage());

      expect(find.byType(TeamSelectionView), findsOneWidget);
    });
  });

  group('$TeamSelectionView', () {
    late TeamSelectionCubit teamSelectionCubit;
    late Widget widget;
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      teamSelectionCubit = _MockTeamSelectionCubit();

      widget = BlocProvider<TeamSelectionCubit>(
        create: (_) => teamSelectionCubit,
        child: const TeamSelectionView(),
      );
    });

    group('TeamSelectionView', () {
      for (final layout in IoLayoutData.values) {
        testWidgets('displays IoAppBar with $layout', (tester) async {
          when(() => teamSelectionCubit.state).thenReturn(0);

          await tester.pumpApp(
            widget,
            layout: layout,
          );

          expect(find.byType(IoAppBar), findsOneWidget);
        });
      }

      testWidgets('displays TabBarView on small screen', (tester) async {
        when(() => teamSelectionCubit.state).thenReturn(0);

        await tester.pumpApp(
          widget,
          layout: IoLayoutData.small,
        );

        expect(find.byType(TabBarView), findsOneWidget);
      });

      testWidgets('select Sparky when right button is tapped', (tester) async {
        when(() => teamSelectionCubit.state).thenReturn(0);

        await tester.pumpApp(
          widget,
          layout: IoLayoutData.small,
        );

        await tester.tap(find.byIcon(Icons.chevron_right));

        verify(() => teamSelectionCubit.selectTeam(1)).called(1);
      });

      testWidgets('select Dash when left button is tapped', (tester) async {
        when(() => teamSelectionCubit.state).thenReturn(1);

        await tester.pumpApp(
          widget,
          layout: IoLayoutData.large,
        );

        await tester.tap(find.byIcon(Icons.chevron_left));

        verify(() => teamSelectionCubit.selectTeam(0)).called(1);
      });

      testWidgets('TabPageSelector shows correct position', (tester) async {
        whenListen(
          teamSelectionCubit,
          Stream.fromIterable(
            [
              1,
              2,
              3,
            ],
          ),
          initialState: 0,
        );

        await tester.pumpApp(
          widget,
          layout: IoLayoutData.small,
        );

        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pumpAndSettle();

        final tabPageSelector = find
            .byType(TabPageSelector)
            .evaluate()
            .single
            .widget as TabPageSelector;

        expect(tabPageSelector.controller!.index, equals(3));
      });
    });

    testWidgets('flows and submits new mascot', (tester) async {
      when(() => teamSelectionCubit.state).thenReturn(2);

      final flowController = FlowController<GameIntroStatus>(
        GameIntroStatus.teamSelection,
      );
      addTearDown(flowController.dispose);

      final crosswordBloc = _MockCrosswordBloc();

      await tester.pumpApp(
        crosswordBloc: crosswordBloc,
        BlocProvider(
          create: (_) => teamSelectionCubit,
          child: FlowBuilder<GameIntroStatus>(
            controller: flowController,
            onGeneratePages: (_, __) => [
              const MaterialPage(child: TeamSelectionView()),
            ],
          ),
        ),
      );

      final submitButtonFinder = find.text(l10n.joinTeam('Android'));
      await tester.ensureVisible(submitButtonFinder);
      await tester.tap(submitButtonFinder);
      await tester.pumpAndSettle();

      verify(() => crosswordBloc.add(MascotSelected(Mascots.android)))
          .called(1);
      expect(flowController.state, equals(GameIntroStatus.enterInitials));
    });
  });
}
