// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/team_selection/team_selection.dart'
    hide AssetsLoadingStatus;
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockHowToPlayCubit extends MockCubit<HowToPlayState>
    implements HowToPlayCubit {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

class _MockRoute extends Mock implements Route<dynamic> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    Flame.images = Images(prefix: '');
    await Flame.images.loadAll([
      ...Mascot.dash.teamMascot.loadableHowToPlayDesktopAssets(),
      ...Mascot.dash.teamMascot.loadableHowToPlayMobileAssets(),
    ]);

    registerFallbackValue(Mascot.dash);
  });

  group('$HowToPlayPage', () {
    late PlayerBloc playerBloc;

    setUp(() {
      playerBloc = _MockPlayerBloc();
    });

    testWidgets('route builds a $HowToPlayPage', (tester) async {
      when(() => playerBloc.state).thenReturn(PlayerState());

      await tester.pumpRoute(
        playerBloc: playerBloc,
        HowToPlayPage.route(),
      );
      await tester.pump();

      expect(find.byType(HowToPlayPage), findsOneWidget);
    });

    group('canPop', () {
      for (final status in PlayerStatus.values.toSet()
        ..removeAll({PlayerStatus.loading, PlayerStatus.playing})) {
        testWidgets('is true when status is $status', (tester) async {
          when(() => playerBloc.state).thenReturn(PlayerState(status: status));

          await tester.pumpApp(
            playerBloc: playerBloc,
            HowToPlayPage(),
          );

          final popScope = tester.widget<PopScope>(find.byType(PopScope));
          final canPop = popScope.canPop;

          expect(canPop, isTrue);
        });
      }

      for (final status in {PlayerStatus.loading, PlayerStatus.playing}) {
        testWidgets('is false when status is $status', (tester) async {
          when(() => playerBloc.state).thenReturn(PlayerState(status: status));

          await tester.pumpApp(
            playerBloc: playerBloc,
            HowToPlayPage(),
          );

          final popScope = tester.widget<PopScope>(find.byType(PopScope));
          final canPop = popScope.canPop;

          expect(canPop, isFalse);
        });
      }
    });

    testWidgets('displays a $HowToPlayView', (tester) async {
      when(() => playerBloc.state).thenReturn(PlayerState());

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: playerBloc,
            ),
          ],
          child: HowToPlayPage(),
        ),
        layout: IoLayoutData.small,
      );

      expect(find.byType(HowToPlayView), findsOneWidget);
    });
  });

  group('$HowToPlayView', () {
    late HowToPlayCubit howToPlayCubit;
    late PlayerBloc playerBloc;
    late Widget widget;

    setUp(() {
      howToPlayCubit = _MockHowToPlayCubit();
      playerBloc = _MockPlayerBloc();

      when(() => howToPlayCubit.loadAssets(any())).thenAnswer((_) async {});

      when(() => howToPlayCubit.state).thenReturn(
        HowToPlayState(
          assetsStatus: AssetsLoadingStatus.success,
        ),
      );

      when(() => playerBloc.state).thenReturn(PlayerState());

      widget = MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: howToPlayCubit,
          ),
          BlocProvider.value(
            value: playerBloc,
          ),
        ],
        child: HowToPlayView(),
      );
    });

    for (final layout in IoLayoutData.values) {
      testWidgets('displays IoAppBar with $layout', (tester) async {
        await tester.pumpApp(
          widget,
          layout: layout,
        );

        expect(find.byType(IoAppBar), findsOneWidget);
      });
    }

    for (final layout in IoLayoutData.values) {
      testWidgets(
        'navigates to $CrosswordPage when animation completes for $layout',
        (tester) async {
          final navigator = MockNavigator();
          when(navigator.canPop).thenReturn(true);
          when(() => navigator.pushAndRemoveUntil<void>(any(), any()))
              .thenAnswer((_) async {});

          whenListen(
            howToPlayCubit,
            Stream.fromIterable(
              [
                HowToPlayState(
                  status: HowToPlayStatus.pickingUp,
                  assetsStatus: AssetsLoadingStatus.success,
                ),
              ],
            ),
            initialState: HowToPlayState(),
          );

          await tester.pumpApp(
            layout: layout,
            navigator: navigator,
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: howToPlayCubit,
                ),
                BlocProvider.value(
                  value: playerBloc,
                ),
              ],
              child: HowToPlayView(),
            ),
          );

          await tester.tap(find.byType(PlayNowButton), warnIfMissed: false);
          await tester.pump();

          final spriteAnimationList = tester.widget<SpriteAnimationList>(
            find.byType(SpriteAnimationList),
          );

          final controller = spriteAnimationList.controller;

          controller.animationDataList.last.spriteAnimationTicker.setToLast();

          final verification = verify(
            () => navigator.pushAndRemoveUntil<void>(
              any(
                that: isRoute<void>(
                  whereName: equals(CrosswordPage.routeName),
                ),
              ),
              captureAny(),
            ),
          );

          final capturedPredicate =
              verification.captured.first as RoutePredicate;

          final firstRoute = _MockRoute();
          when(() => firstRoute.isFirst).thenReturn(true);

          final secondRoute = _MockRoute();
          when(() => secondRoute.isFirst).thenReturn(false);

          expect(capturedPredicate(firstRoute), isTrue);
          expect(capturedPredicate(secondRoute), isFalse);
        },
      );

      testWidgets(
          'verify status is updated to pickingUp '
          'when done button is pressed', (tester) async {
        final l10n = await AppLocalizations.delegate.load(Locale('en'));

        when(() => howToPlayCubit.state).thenReturn(
          HowToPlayState(
            index: 4,
            assetsStatus: AssetsLoadingStatus.success,
          ),
        );

        await tester.pumpApp(
          widget,
          layout: layout,
        );

        await tester.tap(find.text(l10n.doneButtonLabel));

        verify(() => howToPlayCubit.updateStatus(HowToPlayStatus.pickingUp))
            .called(1);
      });
    }

    group('displays', () {
      testWidgets('a $PlayNowButton when small layout', (tester) async {
        await tester.pumpApp(
          widget,
          layout: IoLayoutData.small,
        );

        expect(find.byType(PlayNowButton), findsOneWidget);
      });

      testWidgets('a $PlayNowButton when large layout', (tester) async {
        await tester.pumpApp(
          widget,
          layout: IoLayoutData.large,
        );

        expect(find.byType(PlayNowButton), findsOneWidget);
      });

      testWidgets('localized playNow text', (tester) async {
        late final AppLocalizations l10n;

        await tester.pumpApp(
          Builder(
            builder: (context) {
              l10n = context.l10n;
              return widget;
            },
          ),
          layout: IoLayoutData.small,
        );

        expect(find.text(l10n.playNow), findsOneWidget);
      });

      testWidgets('renders LookUp animation for dash', (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;

        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: howToPlayCubit,
              ),
              BlocProvider.value(
                value: playerBloc,
              ),
            ],
            child: HowToPlayView(),
          ),
          layout: IoLayoutData.small,
        );

        final widget = find.byType(SpriteAnimationList).evaluate().single.widget
            as SpriteAnimationList;

        expect(
          widget.animationItems.first,
          isA<AnimationItem>().having(
            (item) => item.spriteData,
            'spriteData',
            Mascot.dash.teamMascot.lookUpSpriteMobileData,
          ),
        );

        debugDefaultTargetPlatformOverride = null;
      });
    });
  });
}
