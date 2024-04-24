// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/challenge/challenge.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/bloc/player_bloc.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

class _MockCrosswordResource extends Mock implements CrosswordResource {}

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

class _MockHintResource extends Mock implements HintResource {}

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

class _MockUser extends Mock implements User {
  @override
  String get id => '';
}

class _MockShareResource extends Mock implements ShareResource {
  @override
  String facebookShareBaseUrl() {
    return 'https://facebook';
  }

  @override
  String linkedinShareBaseUrl() {
    return 'https://linkedin';
  }

  @override
  String twitterShareBaseUrl() {
    return 'https://twitter';
  }
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
    ShareResource? shareResource,
    HintResource? hintResource,
    CrosswordBloc? crosswordBloc,
    PlayerBloc? playerBloc,
    ChallengeBloc? challengeBloc,
    MockNavigator? navigator,
  }) {
    final mockedCrosswordResource = _MockCrosswordResource();
    final mockedCrosswordRepository = _MockCrosswordRepository();
    registerFallbackValue(Point(0, 0));
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

    final child = Scaffold(body: widget);

    return pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(
            value: crosswordResource ?? mockedCrosswordResource,
          ),
          Provider.value(
            value: shareResource ?? _MockShareResource(),
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
    HintResource? hintResource,
    MockNavigator? navigator,
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
                  create: (context) => PlayerBloc(
                    leaderboardRepository:
                        leaderboardRepository ?? _MockLeaderboardRepository(),
                  ),
                ),
              ],
              child: IoLayout(
                child: MaterialApp(
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
