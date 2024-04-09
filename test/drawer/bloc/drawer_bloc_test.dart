import 'package:bloc_test/bloc_test.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/drawer/bloc/drawer_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

void main() {
  group('$DrawerBloc', () {
    late BoardInfoRepository boardInfoRepository;

    setUp(() {
      boardInfoRepository = _MockBoardInfoRepository();
    });

    test('initial state is DrawerState.initial', () {
      expect(
        DrawerBloc(boardInfoRepository: boardInfoRepository).state,
        equals(const DrawerState.initial()),
      );
    });

    blocTest<DrawerBloc, DrawerState>(
      'remains the same when retrieval fails',
      build: () => DrawerBloc(boardInfoRepository: boardInfoRepository),
      act: (bloc) {
        when(() => boardInfoRepository.getSolvedWordsCount())
            .thenThrow(Exception('oops'));
        when(() => boardInfoRepository.getTotalWordsCount())
            .thenThrow(Exception('oops'));
        bloc.add(const RecordDataRequested());
      },
      expect: () => <DrawerState>[],
    );

    blocTest<DrawerBloc, DrawerState>(
      'emits DrawerState with updated values when data is requested',
      build: () => DrawerBloc(boardInfoRepository: boardInfoRepository),
      act: (bloc) {
        when(() => boardInfoRepository.getSolvedWordsCount())
            .thenAnswer((_) => Future.value(1));
        when(() => boardInfoRepository.getTotalWordsCount())
            .thenAnswer((_) => Future.value(2));
        bloc.add(const RecordDataRequested());
      },
      expect: () => <DrawerState>[
        const DrawerState(solvedWords: 1, totalWords: 2),
      ],
    );
  });
}
