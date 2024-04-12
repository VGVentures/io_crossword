// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/app/app.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

class _MockApiClient extends Mock implements ApiClient {}

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

class _MockCrosswordResource extends Mock implements CrosswordResource {}

class _MockCrosswordBloc extends Mock implements CrosswordBloc {}

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
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          apiClient: apiClient,
          leaderboardRepository: leaderboardRepository,
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
          user: _MockUser(),
        ),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('$AppView', () {
    group('theme data', () {
      late CrosswordBloc crosswordBloc;

      setUp(() {
        crosswordBloc = _MockCrosswordBloc();
        when(() => crosswordBloc.close())
            .thenAnswer((invocation) => Future.value());
      });

      testWidgets('is Flutter when mascot is dash', (tester) async {
        whenListen(
          crosswordBloc,
          Stream<CrosswordState>.empty(),
          initialState: CrosswordState(
            mascot: Mascots.dash,
            sectionSize: 20,
          ),
        );

        await tester.pumpApp(
          crosswordBloc: crosswordBloc,
          AppView(),
        );

        final themeFinder = find.byType(Theme).last;
        expect(themeFinder, findsOneWidget);

        final theme = tester.widget<Theme>(themeFinder);
        expect(theme.data, MascotTheme.flutterTheme);
      });

      testWidgets('is Flutter when mascot is Dash', (tester) async {
        whenListen(
          crosswordBloc,
          Stream<CrosswordState>.empty(),
          initialState: CrosswordState(
            mascot: Mascots.dash,
            sectionSize: 20,
          ),
        );

        await tester.pumpApp(
          crosswordBloc: crosswordBloc,
          AppView(),
        );

        final themeFinder = find.byType(Theme).last;
        expect(themeFinder, findsOneWidget);

        final theme = tester.widget<Theme>(themeFinder);
        expect(theme.data, MascotTheme.flutterTheme);
      });

      testWidgets('is Firebase when mascot is Sparky', (tester) async {
        whenListen(
          crosswordBloc,
          Stream<CrosswordState>.empty(),
          initialState: CrosswordState(
            mascot: Mascots.sparky,
            sectionSize: 20,
          ),
        );

        await tester.pumpApp(
          crosswordBloc: crosswordBloc,
          AppView(),
        );

        final themeFinder = find.byType(Theme).last;
        expect(themeFinder, findsOneWidget);

        final theme = tester.widget<Theme>(themeFinder);
        expect(theme.data, MascotTheme.firebaseTheme);
      });

      testWidgets('is Chrome when mascot is Dino', (tester) async {
        whenListen(
          crosswordBloc,
          Stream<CrosswordState>.empty(),
          initialState: CrosswordState(
            mascot: Mascots.dino,
            sectionSize: 20,
          ),
        );

        await tester.pumpApp(
          crosswordBloc: crosswordBloc,
          AppView(),
        );

        final themeFinder = find.byType(Theme).last;
        expect(themeFinder, findsOneWidget);

        final theme = tester.widget<Theme>(themeFinder);
        expect(theme.data, MascotTheme.chromeTheme);
      });

      testWidgets('is Android when mascot is Android', (tester) async {
        whenListen(
          crosswordBloc,
          Stream<CrosswordState>.empty(),
          initialState: CrosswordState(
            mascot: Mascots.android,
            sectionSize: 20,
          ),
        );

        await tester.pumpApp(
          crosswordBloc: crosswordBloc,
          AppView(),
        );

        final themeFinder = find.byType(Theme).last;
        expect(themeFinder, findsOneWidget);

        final theme = tester.widget<Theme>(themeFinder);
        expect(theme.data, MascotTheme.androidTheme);
      });

      testWidgets('is default when there is no mascot', (tester) async {
        whenListen(
          crosswordBloc,
          Stream<CrosswordState>.empty(),
          initialState: CrosswordState(),
        );

        await tester.pumpApp(
          crosswordBloc: crosswordBloc,
          AppView(),
        );

        final themeFinder = find.byType(Theme).last;
        expect(themeFinder, findsOneWidget);

        final theme = tester.widget<Theme>(themeFinder);
        expect(theme.data, MascotTheme.defaultTheme);
      });
    });
  });
}
