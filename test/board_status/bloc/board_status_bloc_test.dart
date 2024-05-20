// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/board_status/board_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

void main() {
  group('BoardStatusBloc', () {
    late BoardInfoRepository boardInfoRepository;

    setUp(() {
      boardInfoRepository = _MockBoardInfoRepository();
    });

    group('BoardStatusRequested', () {
      blocTest<BoardStatusBloc, BoardStatusState>(
        'emits [BoardStatusResetInProgress] when GameStatus is resetInProgress',
        setUp: () {
          when(() => boardInfoRepository.getGameStatus()).thenAnswer(
            (_) => Stream.value(GameStatus.resetInProgress),
          );
        },
        build: () => BoardStatusBloc(boardInfoRepository: boardInfoRepository),
        act: (bloc) => bloc.add(BoardStatusRequested()),
        expect: () => const <BoardStatusState>[BoardStatusResetInProgress()],
      );

      blocTest<BoardStatusBloc, BoardStatusState>(
        'emits [BoardStatusInProgress] when GameStatus is not resetInProgress',
        setUp: () {
          when(() => boardInfoRepository.getGameStatus()).thenAnswer(
            (_) => Stream.value(GameStatus.inProgress),
          );
        },
        build: () => BoardStatusBloc(boardInfoRepository: boardInfoRepository),
        act: (bloc) => bloc.add(BoardStatusRequested()),
        expect: () => const <BoardStatusState>[BoardStatusInProgress()],
      );

      blocTest<BoardStatusBloc, BoardStatusState>(
        'emits [BoardStatusFailure] when an error occurs',
        setUp: () {
          when(() => boardInfoRepository.getGameStatus())
              .thenAnswer((_) => Stream.error(Exception('oops')));
        },
        build: () => BoardStatusBloc(boardInfoRepository: boardInfoRepository),
        act: (bloc) => bloc.add(BoardStatusRequested()),
        expect: () => const <BoardStatusState>[BoardStatusFailure()],
      );
    });
  });
}
