// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/app/app.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

class _MockApiClient extends Mock implements ApiClient {}

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

class _MockCrosswordResource extends Mock implements CrosswordResource {}

void main() {
  group('App', () {
    late ApiClient apiClient;
    late CrosswordRepository crosswordRepository;
    late BoardInfoRepository boardInfoRepository;

    setUp(() {
      apiClient = _MockApiClient();
      crosswordRepository = _MockCrosswordRepository();
      boardInfoRepository = _MockBoardInfoRepository();

      when(() => apiClient.leaderboardResource)
          .thenReturn(_MockLeaderboardResource());
      when(() => apiClient.crosswordResource)
          .thenReturn(_MockCrosswordResource());
      when(
        () => crosswordRepository.watchSectionFromPosition(0, 0),
      ).thenAnswer((_) => Stream.value(null));
      when(boardInfoRepository.getSolvedWordsCount)
          .thenAnswer((_) => Future.value(25));
      when(boardInfoRepository.getTotalWordsCount)
          .thenAnswer((_) => Future.value(100));
      when(boardInfoRepository.getSectionSize)
          .thenAnswer((_) => Future.value(20));
      when(boardInfoRepository.getZoomLimit)
          .thenAnswer((_) => Future.value(0.8));
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          apiClient: apiClient,
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });
}
