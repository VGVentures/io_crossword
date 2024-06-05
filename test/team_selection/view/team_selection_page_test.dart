// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/bloc/player_bloc.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockTeamSelectionCubit extends MockCubit<TeamSelectionState>
    implements TeamSelectionCubit {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

class _MockAudioController extends Mock implements AudioController {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Flame.images = Images(prefix: '');
    await Flame.images.loadAll([
      Mascot.dash.teamMascot.idleAnimation.keyName,
      Mascot.dash.teamMascot.platformAnimation.keyName,
      Mascot.android.teamMascot.idleAnimation.keyName,
      Mascot.android.teamMascot.platformAnimation.keyName,
      Mascot.dino.teamMascot.idleAnimation.keyName,
      Mascot.dino.teamMascot.platformAnimation.keyName,
      Mascot.sparky.teamMascot.idleAnimation.keyName,
      Mascot.sparky.teamMascot.platformAnimation.keyName,
    ]);
  });

  group('$TeamSelectionPage', () {
    late PlayerBloc playerBloc;

    setUp(() {
      playerBloc = _MockPlayerBloc();
    });

    testWidgets('route builds a $TeamSelectionPage', (tester) async {
      await tester.pumpRoute(TeamSelectionPage.route());
      await tester.pump();

      expect(find.byType(TeamSelectionPage), findsOneWidget);
    });

    testWidgets('renders a $TeamSelectionView', (tester) async {
      await tester.pumpApp(TeamSelectionPage());

      expect(find.byType(TeamSelectionView), findsOneWidget);
    });

    for (final mascot in Mascot.values) {
      testWidgets('updates index to ${mascot.index} with $mascot',
          (tester) async {
        when(() => playerBloc.state).thenReturn(PlayerState(mascot: mascot));

        await tester.pumpApp(
          BlocProvider(
            create: (_) => playerBloc,
            child: TeamSelectionPage(),
          ),
        );

        await tester.pumpAndSettle(Duration(seconds: 2));

        final context = tester.element(find.byType(TeamSelectionView));

        expect(
          context.read<TeamSelectionCubit>().state.index,
          equals(mascot.index),
        );
      });
    }
  });

  group('$TeamSelectionView', () {
    late AudioController audioController;
    late PlayerBloc playerBloc;
    late TeamSelectionCubit teamSelectionCubit;
    late Widget widget;
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      audioController = _MockAudioController();
      teamSelectionCubit = _MockTeamSelectionCubit();

      when(() => teamSelectionCubit.loadAssets()).thenAnswer((_) async {});

      playerBloc = _MockPlayerBloc();

      widget = MultiBlocProvider(
        providers: [
          BlocProvider<TeamSelectionCubit>(
            create: (_) => teamSelectionCubit,
          ),
          BlocProvider<PlayerBloc>(
            create: (_) => playerBloc,
          ),
        ],
        child: const TeamSelectionView(),
      );
    });

    for (final layout in IoLayoutData.values) {
      testWidgets('displays IoAppBar with $layout', (tester) async {
        when(() => teamSelectionCubit.state).thenReturn(
          TeamSelectionState(),
        );

        await tester.pumpApp(
          widget,
          layout: layout,
        );

        expect(find.byType(IoAppBar), findsOneWidget);
      });
    }

    for (final mascot in Mascot.values) {
      testWidgets(
          'calls MascotSelected with $mascot with index '
          '${Mascot.values[mascot.index]}', (tester) async {
        when(() => teamSelectionCubit.state).thenReturn(
          TeamSelectionState(
            assetsStatus: AssetsLoadingStatus.success,
          ),
        );

        whenListen(
          teamSelectionCubit,
          Stream.fromIterable(
            [
              TeamSelectionState(
                index: mascot.index,
              ),
            ],
          ),
          initialState: TeamSelectionState(index: -1),
        );

        await tester.pumpApp(
          widget,
          layout: IoLayoutData.small,
        );

        verify(() => playerBloc.add(MascotSelected(mascot))).called(1);
      });
    }

    testWidgets('select Sparky when right button is tapped', (tester) async {
      when(() => teamSelectionCubit.state).thenReturn(
        TeamSelectionState(
          assetsStatus: AssetsLoadingStatus.success,
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
          index: 1,
          assetsStatus: AssetsLoadingStatus.success,
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
              index: 1,
              assetsStatus: AssetsLoadingStatus.success,
            ),
            TeamSelectionState(
              index: 2,
              assetsStatus: AssetsLoadingStatus.success,
            ),
            TeamSelectionState(
              index: 3,
              assetsStatus: AssetsLoadingStatus.success,
            ),
          ],
        ),
        initialState: TeamSelectionState(
          assetsStatus: AssetsLoadingStatus.success,
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

    group('joining a team', () {
      setUp(() {
        when(() => teamSelectionCubit.state).thenReturn(
          TeamSelectionState(
            index: 2,
          ),
        );
      });

      testWidgets(
          'plays ${Assets.music.startButton1} when '
          'submit button is tapped', (tester) async {
        when(() => teamSelectionCubit.state).thenReturn(
          TeamSelectionState(
            index: 2,
            assetsStatus: AssetsLoadingStatus.success,
          ),
        );

        await tester.pumpApp(
          BlocProvider(
            create: (_) => teamSelectionCubit,
            child: TeamSelectionView(),
          ),
          audioController: audioController,
        );

        final submitButtonFinder = find.text(l10n.joinTeam('Android'));
        await tester.ensureVisible(submitButtonFinder);
        await tester.tap(submitButtonFinder);
        await tester.pump();

        verify(
          () => audioController.playSfx(Assets.music.startButton1),
        ).called(1);
      });

      testWidgets(
        'navigates into $InitialsPage',
        (tester) async {
          final navigator = MockNavigator();
          when(navigator.canPop).thenReturn(true);
          when(() => navigator.push<void>(any())).thenAnswer((_) async {});

          when(() => teamSelectionCubit.state).thenReturn(
            TeamSelectionState(
              index: 2,
              assetsStatus: AssetsLoadingStatus.success,
            ),
          );

          await tester.pumpApp(
            navigator: navigator,
            BlocProvider(
              create: (_) => teamSelectionCubit,
              child: TeamSelectionView(),
            ),
          );

          final submitButtonFinder = find.text(l10n.joinTeam('Android'));
          await tester.ensureVisible(submitButtonFinder);
          await tester.tap(submitButtonFinder);
          await tester.pump();

          verify(
            () => navigator.push<void>(
              any(
                that: isRoute<void>(
                  whereName: equals(InitialsPage.routeName),
                ),
              ),
            ),
          ).called(1);
        },
      );
    });

    testWidgets(
        'select Sparky mascot when tapped '
        'on large layout', (tester) async {
      tester.view.physicalSize = const Size(1600, 1600);

      when(() => teamSelectionCubit.state).thenReturn(
        TeamSelectionState(assetsStatus: AssetsLoadingStatus.success),
      );

      await tester.pumpApp(
        widget,
        layout: IoLayoutData.large,
      );

      await tester.pump();

      await tester.tap(
        find.byType(TeamSelectionMascot).at(Mascot.sparky.index),
      );

      verify(() => teamSelectionCubit.selectTeam(Mascot.sparky.index))
          .called(1);

      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
