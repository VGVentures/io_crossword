// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/app/app.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/rotate_phone/rotate_phone.dart';
import 'package:io_crossword/settings/settings.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

class _MockApiClient extends Mock implements ApiClient {}

class _MockAudioController extends Mock implements AudioController {}

class _MockBuildContext extends Mock implements BuildContext {}

class _MockLifecycleNotifier extends Mock
    implements ValueNotifier<AppLifecycleState> {}

class _MockSettingsController extends Mock implements SettingsController {}

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

class _MockCrosswordResource extends Mock implements CrosswordResource {}

class _MockHintResource extends Mock implements HintResource {}

class _MockPlayerBloc extends Mock implements PlayerBloc {
  @override
  Future<void> close() async {}
}

class _MockUser extends Mock implements User {}

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

void main() {
  group('App', () {
    late ApiClient apiClient;
    late CrosswordRepository crosswordRepository;
    late BoardInfoRepository boardInfoRepository;
    late LeaderboardRepository leaderboardRepository;

    setUp(() {
      apiClient = _MockApiClient();
      crosswordRepository = _MockCrosswordRepository();
      boardInfoRepository = _MockBoardInfoRepository();
      leaderboardRepository = _MockLeaderboardRepository();

      when(() => apiClient.leaderboardResource)
          .thenReturn(_MockLeaderboardResource());
      when(() => apiClient.crosswordResource)
          .thenReturn(_MockCrosswordResource());
      when(() => apiClient.hintResource).thenReturn(_MockHintResource());
      when(
        () => crosswordRepository.watchSectionFromPosition(0, 0),
      ).thenAnswer((_) => Stream.value(null));
      when(boardInfoRepository.getSolvedWordsCount)
          .thenAnswer((_) => Stream.value(25));
      when(boardInfoRepository.getTotalWordsCount)
          .thenAnswer((_) => Stream.value(100));
      when(boardInfoRepository.getSectionSize)
          .thenAnswer((_) => Future.value(20));
      when(boardInfoRepository.getZoomLimit)
          .thenAnswer((_) => Future.value(0.8));
      when(boardInfoRepository.getGameStatus)
          .thenAnswer((_) => Stream.value(GameStatus.inProgress));
    });

    testWidgets('renders AppView', (tester) async {
      final user = _MockUser();

      when(() => user.id).thenReturn('id');
      when(() => leaderboardRepository.getPlayerRanked('id'))
          .thenAnswer((_) => Stream.value((Player.empty, 4)));

      await tester.pumpWidget(
        App(
          apiClient: apiClient,
          leaderboardRepository: leaderboardRepository,
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
          user: user,
        ),
      );

      expect(find.byType(AppView), findsOneWidget);
    });

    group('update AudioController', () {
      setUpAll(() {
        registerFallbackValue(_MockSettingsController());
        registerFallbackValue(_MockLifecycleNotifier());
      });
      test('initializes, attach to lifecycle', () {
        final buildContext = _MockBuildContext();
        final settingsController = _MockSettingsController();
        final lifecycle = _MockLifecycleNotifier();
        final audioController = _MockAudioController();

        when(audioController.initialize).thenAnswer((_) async {});
        when(() => audioController.attachSettings(any())).thenAnswer((_) {});
        when(() => audioController.attachLifecycleNotifier(any()))
            .thenAnswer((_) {});

        final result = updateAudioController(
          buildContext,
          settingsController,
          lifecycle,
          audioController,
        );
        verify(() => audioController.attachSettings(any())).called(1);
        verify(() => audioController.attachLifecycleNotifier(any())).called(1);

        expect(result, audioController);
      });

      test('returns a new instance when audio controller is null', () {
        final buildContext = _MockBuildContext();
        final audioController = _MockAudioController();

        when(audioController.initialize).thenAnswer((_) async {});
        when(() => audioController.attachSettings(any())).thenAnswer((_) {});
        when(() => audioController.attachLifecycleNotifier(any()))
            .thenAnswer((_) {});

        final result = updateAudioController(
          buildContext,
          SettingsController(),
          ValueNotifier(AppLifecycleState.paused),
          null,
          createAudioController: () => audioController,
        );

        verify(() => audioController.attachLifecycleNotifier(any())).called(1);

        expect(result, audioController);
      });
    });
  });

  group('$AppView', () {
    group('renders', () {
      testWidgets('RotatePhonePage when device is android and landscape',
          (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        tester.setDisplaySize(Size(800, 400));
        await tester.pumpApp(
          AppView(),
        );

        expect(find.byType(RotatePhonePage), findsOneWidget);
        debugDefaultTargetPlatformOverride = null;
      });
      testWidgets('RotatePhonePage when device is ios and landscape',
          (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        tester.setDisplaySize(Size(800, 400));
        await tester.pumpApp(
          AppView(),
        );

        expect(find.byType(RotatePhonePage), findsOneWidget);
        debugDefaultTargetPlatformOverride = null;
      });
    });
    group('theme data', () {
      late PlayerBloc playerBloc;

      setUp(() {
        playerBloc = _MockPlayerBloc();
      });

      testWidgets('is Flutter when mascot is dash', (tester) async {
        whenListen(
          playerBloc,
          Stream<PlayerState>.empty(),
          initialState: PlayerState(
            mascot: Mascots.dash,
          ),
        );

        await tester.pumpApp(
          AppView(),
          playerBloc: playerBloc,
        );

        final themeFinder = find.byType(MaterialApp).last;
        expect(themeFinder, findsOneWidget);

        final theme = tester.widget<MaterialApp>(themeFinder);
        expect(theme.theme, MascotTheme.flutterTheme);
      });

      testWidgets('is Firebase when mascot is Sparky', (tester) async {
        whenListen(
          playerBloc,
          Stream<PlayerState>.empty(),
          initialState: PlayerState(
            mascot: Mascots.sparky,
          ),
        );

        await tester.pumpApp(
          playerBloc: playerBloc,
          AppView(),
        );

        final themeFinder = find.byType(MaterialApp).last;
        expect(themeFinder, findsOneWidget);

        final theme = tester.widget<MaterialApp>(themeFinder);
        expect(theme.theme, MascotTheme.firebaseTheme);
      });

      testWidgets('is Chrome when mascot is Dino', (tester) async {
        whenListen(
          playerBloc,
          Stream<PlayerState>.empty(),
          initialState: PlayerState(
            mascot: Mascots.dino,
          ),
        );

        await tester.pumpApp(
          playerBloc: playerBloc,
          AppView(),
        );

        final themeFinder = find.byType(MaterialApp).last;
        expect(themeFinder, findsOneWidget);

        final theme = tester.widget<MaterialApp>(themeFinder);
        expect(theme.theme, MascotTheme.chromeTheme);
      });

      testWidgets('is Android when mascot is Android', (tester) async {
        whenListen(
          playerBloc,
          Stream<PlayerState>.empty(),
          initialState: PlayerState(
            mascot: Mascots.android,
          ),
        );

        await tester.pumpApp(
          playerBloc: playerBloc,
          AppView(),
        );

        final themeFinder = find.byType(MaterialApp).last;
        expect(themeFinder, findsOneWidget);

        final theme = tester.widget<MaterialApp>(themeFinder);
        expect(theme.theme, MascotTheme.androidTheme);
      });
    });
  });
}
