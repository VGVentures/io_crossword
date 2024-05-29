// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/challenge/challenge.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/bloc/player_bloc.dart';
import 'package:io_crossword/settings/settings.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

class _MockCrosswordResource extends Mock implements CrosswordResource {}

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

class _MockHintResource extends Mock implements HintResource {}

class _MockAudioController extends Mock implements AudioController {}

class _MockSettingsController extends Mock implements SettingsController {
  @override
  ValueNotifier<bool> get muted => ValueNotifier(true);
}

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

class _MockUser extends Mock implements User {
  @override
  String get id => '';
}

class _FakeSolvedWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => 1;
}

class _FakeUnsolvedWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => null;
}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    IoLayoutData? layout,
    User? user,
    CrosswordRepository? crosswordRepository,
    BoardInfoRepository? boardInfoRepository,
    LeaderboardRepository? leaderboardRepository,
    CrosswordResource? crosswordResource,
    LeaderboardResource? leaderboardResource,
    HintResource? hintResource,
    CrosswordBloc? crosswordBloc,
    PlayerBloc? playerBloc,
    AudioController? audioController,
    SettingsController? settingsController,
    ChallengeBloc? challengeBloc,
    MockNavigator? navigator,
  }) {
    final mockedCrosswordResource = _MockCrosswordResource();
    final mockedCrosswordRepository = _MockCrosswordRepository();
    registerFallbackValue(Point(0, 0));
    when(() => mockedCrosswordRepository.getRandomUncompletedSection(any()))
        .thenAnswer(
      (_) => Future.value(
        BoardSection(
          id: '',
          position: Point(1, 1),
          size: 10,
          words: [_FakeUnsolvedWord(), _FakeSolvedWord()],
          borderWords: [_FakeUnsolvedWord(), _FakeSolvedWord()],
        ),
      ),
    );
    when(
      () => mockedCrosswordRepository.watchSectionFromPosition(any(), any()),
    ).thenAnswer((_) => Stream.value(null));
    final mockedBoardInfoRepository = _MockBoardInfoRepository();
    when(mockedBoardInfoRepository.getSolvedWordsCount)
        .thenAnswer((_) => Stream.value(123));
    when(mockedBoardInfoRepository.getTotalWordsCount)
        .thenAnswer((_) => Stream.value(8900));
    when(mockedBoardInfoRepository.getSectionSize)
        .thenAnswer((_) => Future.value(20));
    when(mockedBoardInfoRepository.getZoomLimit)
        .thenAnswer((_) => Future.value(0.8));
    when(mockedBoardInfoRepository.getGameStatus)
        .thenAnswer((_) => Stream.value(GameStatus.inProgress));

    final child = Scaffold(body: widget);

    return pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(
            value: crosswordResource ?? mockedCrosswordResource,
          ),
          Provider.value(
            value: crosswordRepository ?? mockedCrosswordRepository,
          ),
          Provider.value(
            value: boardInfoRepository ?? mockedBoardInfoRepository,
          ),
          Provider.value(
            value: leaderboardResource ?? _MockLeaderboardResource(),
          ),
          Provider.value(
            value: leaderboardRepository ?? _MockLeaderboardRepository(),
          ),
          Provider.value(
            value: hintResource ?? _MockHintResource(),
          ),
          Provider.value(
            value: user ?? _MockUser(),
          ),
          Provider.value(
            value: settingsController ?? _MockSettingsController(),
          ),
          Provider.value(
            value: audioController ?? _MockAudioController(),
          ),
        ],
        child: Builder(
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      crosswordBloc ??
                      CrosswordBloc(
                        crosswordRepository:
                            context.read<CrosswordRepository>(),
                        boardInfoRepository:
                            context.read<BoardInfoRepository>(),
                      ),
                ),
                BlocProvider(
                  create: (context) =>
                      playerBloc ??
                      PlayerBloc(
                        leaderboardResource:
                            context.read<LeaderboardResource>(),
                        leaderboardRepository:
                            context.read<LeaderboardRepository>(),
                      ),
                ),
                BlocProvider(
                  create: (context) =>
                      challengeBloc ??
                      ChallengeBloc(
                        boardInfoRepository:
                            context.read<BoardInfoRepository>(),
                      ),
                ),
              ],
              child: IoLayout(
                data: layout,
                child: MaterialApp(
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  theme: IoCrosswordTheme().themeData,
                  home: navigator != null
                      ? MockNavigatorProvider(
                          navigator: navigator,
                          child: child,
                        )
                      : child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

extension PumpRoute on WidgetTester {
  Future<void> pumpRoute(
    Route<dynamic> route, {
    User? user,
    CrosswordRepository? crosswordRepository,
    BoardInfoRepository? boardInfoRepository,
    LeaderboardRepository? leaderboardRepository,
    CrosswordResource? crosswordResource,
    LeaderboardResource? leaderboardResource,
    AudioController? audioController,
    SettingsController? settingsController,
    HintResource? hintResource,
    MockNavigator? navigator,
    PlayerBloc? playerBloc,
  }) async {
    final widget = Center(
      child: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(route);
            },
            child: const Text('Push Route'),
          );
        },
      ),
    );
    final mockedCrosswordRepository = _MockCrosswordRepository();
    when(() => mockedCrosswordRepository.getRandomUncompletedSection(any()))
        .thenAnswer(
      (_) => Future.value(
        BoardSection(
          id: '',
          position: Point(1, 1),
          size: 10,
          words: [_FakeUnsolvedWord(), _FakeSolvedWord()],
          borderWords: [_FakeUnsolvedWord(), _FakeSolvedWord()],
        ),
      ),
    );
    when(
      () => mockedCrosswordRepository.watchSectionFromPosition(any(), any()),
    ).thenAnswer((_) => Stream.value(null));
    final mockedCrosswordResource = _MockCrosswordResource();

    final mockedBoardInfoRepository = _MockBoardInfoRepository();
    when(mockedBoardInfoRepository.getSolvedWordsCount)
        .thenAnswer((_) => Stream.value(123));
    when(mockedBoardInfoRepository.getTotalWordsCount)
        .thenAnswer((_) => Stream.value(8900));
    when(mockedBoardInfoRepository.getSectionSize)
        .thenAnswer((_) => Future.value(20));
    when(mockedBoardInfoRepository.getZoomLimit)
        .thenAnswer((_) => Future.value(0.8));
    when(mockedBoardInfoRepository.getGameStatus)
        .thenAnswer((_) => Stream.value(GameStatus.inProgress));

    await pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: crosswordRepository ?? mockedCrosswordRepository,
          ),
          Provider.value(
            value: crosswordResource ?? mockedCrosswordResource,
          ),
          Provider.value(
            value: boardInfoRepository ?? mockedBoardInfoRepository,
          ),
          Provider.value(
            value: leaderboardResource ?? _MockLeaderboardResource(),
          ),
          Provider.value(
            value: leaderboardRepository ?? _MockLeaderboardRepository(),
          ),
          Provider.value(
            value: hintResource ?? _MockHintResource(),
          ),
          Provider.value(
            value: user ?? _MockUser(),
          ),
          Provider.value(
            value: settingsController ?? _MockSettingsController(),
          ),
          Provider.value(
            value: audioController ?? _MockAudioController(),
          ),
        ],
        child: Builder(
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => CrosswordBloc(
                    crosswordRepository: context.read<CrosswordRepository>(),
                    boardInfoRepository: context.read<BoardInfoRepository>(),
                  ),
                ),
                BlocProvider(
                  create: (context) =>
                      playerBloc ??
                      PlayerBloc(
                        leaderboardResource:
                            context.read<LeaderboardResource>(),
                        leaderboardRepository: leaderboardRepository ??
                            _MockLeaderboardRepository(),
                      ),
                ),
              ],
              child: IoLayout(
                child: MaterialApp(
                  theme: IoCrosswordTheme().themeData,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  home: navigator != null
                      ? MockNavigatorProvider(
                          navigator: navigator,
                          child: widget,
                        )
                      : widget,
                ),
              ),
            );
          },
        ),
      ),
    );
    await tap(find.text('Push Route'));
    await pump();
  }
}
