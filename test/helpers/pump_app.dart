// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:api_client/api_client.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/challenge/challenge.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

class _MockCrosswordResource extends Mock implements CrosswordResource {}

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    IoLayoutData? layout,
    CrosswordRepository? crosswordRepository,
    CrosswordResource? crosswordResource,
    BoardInfoRepository? boardInfoRepository,
    LeaderboardResource? leaderboardResource,
    CrosswordBloc? crosswordBloc,
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
            value: crosswordRepository ?? mockedCrosswordRepository,
          ),
          Provider.value(
            value: boardInfoRepository ?? mockedBoardInfoRepository,
          ),
          Provider.value(
            value: leaderboardResource ?? _MockLeaderboardResource(),
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
                        crosswordResource: context.read<CrosswordResource>(),
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
    CrosswordRepository? crosswordRepository,
    CrosswordResource? crosswordResource,
    BoardInfoRepository? boardInfoRepository,
    LeaderboardResource? leaderboardResource,
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
        ],
        child: Builder(
          builder: (context) {
            return BlocProvider(
              create: (context) => CrosswordBloc(
                crosswordRepository: context.read<CrosswordRepository>(),
                boardInfoRepository: context.read<BoardInfoRepository>(),
                crosswordResource: context.read<CrosswordResource>(),
              ),
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
