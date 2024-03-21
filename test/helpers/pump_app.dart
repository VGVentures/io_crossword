// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    CrosswordRepository? crosswordRepository,
    BoardInfoRepository? boardInfoRepository,
    MockNavigator? navigator,
  }) {
    final mockedCrosswordRepository = _MockCrosswordRepository();
    registerFallbackValue(Point(0, 0));
    when(
      () => mockedCrosswordRepository.watchSectionFromPosition(any(), any()),
    ).thenAnswer((_) => Stream.value(null));
    final mockedBoardInfoRepository = _MockBoardInfoRepository();
    when(mockedBoardInfoRepository.getSolvedWordsCount)
        .thenAnswer((_) => Future.value(123));
    when(mockedBoardInfoRepository.getTotalWordsCount)
        .thenAnswer((_) => Future.value(8900));
    when(mockedBoardInfoRepository.getSectionSize)
        .thenAnswer((_) => Future.value(20));
    when(mockedBoardInfoRepository.getRenderModeZoomLimits)
        .thenAnswer((_) => Future.value([0.8]));

    return pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(
            value: crosswordRepository ?? mockedCrosswordRepository,
          ),
          Provider.value(
            value: boardInfoRepository ?? mockedBoardInfoRepository,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: navigator != null
              ? MockNavigatorProvider(navigator: navigator, child: widget)
              : widget,
        ),
      ),
    );
  }
}

extension PumpRoute on WidgetTester {
  Future<void> pumpRoute(
    Route<dynamic> route, {
    CrosswordRepository? crosswordRepository,
    BoardInfoRepository? boardInfoRepository,
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

    final mockedBoardInfoRepository = _MockBoardInfoRepository();
    when(mockedBoardInfoRepository.getSolvedWordsCount)
        .thenAnswer((_) => Future.value(123));
    when(mockedBoardInfoRepository.getTotalWordsCount)
        .thenAnswer((_) => Future.value(8900));
    when(mockedBoardInfoRepository.getSectionSize)
        .thenAnswer((_) => Future.value(20));
    when(mockedBoardInfoRepository.getRenderModeZoomLimits)
        .thenAnswer((_) => Future.value([0.8]));

    await pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: crosswordRepository ?? mockedCrosswordRepository,
          ),
          Provider.value(
            value: boardInfoRepository ?? mockedBoardInfoRepository,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: navigator != null
              ? MockNavigatorProvider(navigator: navigator, child: widget)
              : widget,
        ),
      ),
    );
    await tap(find.text('Push Route'));
    await pump();
  }
}
