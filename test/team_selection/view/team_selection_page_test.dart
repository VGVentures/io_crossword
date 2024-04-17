// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
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

class _MockTeamSelectionCubit extends MockCubit<TeamSelectionState>
    implements TeamSelectionCubit {}

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('$TeamSelectionPage', () {
    testWidgets('renders a TeamSelectionView', (tester) async {
      await tester.pumpApp(TeamSelectionPage());

      expect(find.byType(TeamSelectionView), findsOneWidget);
    });
  });

  group('$TeamSelectionView', () {
    late TeamSelectionCubit teamSelectionCubit;
    late Widget widget;
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));

      Flame.images = Images(prefix: '');
      await Flame.images.loadAll([
        Mascots.dash.teamMascot.idleAnimation.keyName,
        Mascots.android.teamMascot.platformAnimation.keyName,
      ]);
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
          when(() => teamSelectionCubit.state).thenReturn(
            TeamSelectionState(
              status: TeamSelectionStatus.loadingComplete,
            ),
          );

          await tester.pumpApp(
            widget,
            layout: layout,
          );

          expect(find.byType(IoAppBar), findsOneWidget);
        });
      }

      testWidgets('select Sparky when right button is tapped', (tester) async {
        when(() => teamSelectionCubit.state).thenReturn(
          TeamSelectionState(
            status: TeamSelectionStatus.loadingComplete,
          ),
        );

        await tester.pumpApp(
          widget,
          layout: IoLayoutData.small,
        );

        await tester.tap(find.byIcon(Icons.chevron_right));

        verify(() => teamSelectionCubit.selectTeam(1)).called(1);
      });

      testWidgets('select Dash when left button is tapped', (tester) async {
        when(() => teamSelectionCubit.state).thenReturn(
          TeamSelectionState(
            status: TeamSelectionStatus.loadingComplete,
            index: 1,
          ),
        );

        await tester.pumpApp(
          widget,
          layout: IoLayoutData.large,
        );

        await tester.tap(find.byIcon(Icons.chevron_left));

        verify(() => teamSelectionCubit.selectTeam(0)).called(1);
      });

      testWidgets('ScrollController shows correct position', (tester) async {
        whenListen(
          teamSelectionCubit,
          Stream.fromIterable(
            [
              TeamSelectionState(
                status: TeamSelectionStatus.loadingComplete,
                index: 1,
              ),
              TeamSelectionState(
                status: TeamSelectionStatus.loadingComplete,
                index: 2,
              ),
              TeamSelectionState(
                status: TeamSelectionStatus.loadingComplete,
                index: 3,
              ),
            ],
          ),
          initialState: TeamSelectionState(
            status: TeamSelectionStatus.loadingComplete,
          ),
        );

        await tester.pumpApp(
          widget,
          layout: IoLayoutData.small,
        );

        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pump(Duration(milliseconds: 400));
        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pump(Duration(milliseconds: 400));
        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pump(Duration(milliseconds: 400));

        final singleChildScrollView = find
            .byType(SingleChildScrollView)
            .evaluate()
            .single
            .widget as SingleChildScrollView;

        // index * (tileWidth * 2)
        expect(singleChildScrollView.controller!.offset, equals(3 * 366 * 2));
      });
    });

    group('joining a team', () {
      late CrosswordBloc crosswordBloc;
      late FlowController<GameIntroStatus> flowController;

      setUp(() {
        when(() => teamSelectionCubit.state).thenReturn(
          TeamSelectionState(
            status: TeamSelectionStatus.loadingComplete,
            index: 2,
          ),
        );

        crosswordBloc = _MockCrosswordBloc();
        flowController = FlowController<GameIntroStatus>(
          GameIntroStatus.teamSelection,
        );
        addTearDown(flowController.dispose);
      });

      testWidgets('adds MascotSelected', (tester) async {
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
        await tester.pump();

        verify(() => crosswordBloc.add(MascotSelected(Mascots.android)))
            .called(1);
      });

      testWidgets(
        'flows into enterInitials',
        (tester) async {
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
          await tester.pump();

          expect(flowController.state, equals(GameIntroStatus.enterInitials));
        },
      );
    });
  });
}
