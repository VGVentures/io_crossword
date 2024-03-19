// ignore_for_file: prefer_const_constructors

import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/app/app.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

void main() {
  group('App', () {
    late CrosswordRepository crosswordRepository;
    late BoardInfoRepository boardInfoRepository;

    setUp(() {
      crosswordRepository = _MockCrosswordRepository();
      boardInfoRepository = _MockBoardInfoRepository();

      when(
        () => crosswordRepository.watchSectionFromPosition(0, 0),
      ).thenAnswer((_) => Stream.value(null));
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });
}
