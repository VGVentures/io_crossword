import 'package:bloc_test/bloc_test.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/challenge/challenge.dart';
import 'package:mocktail/mocktail.dart';

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

void main() {
  group('$ChallengeBloc', () {
    late BoardInfoRepository boardInfoRepository;

    setUp(() {
      boardInfoRepository = _MockBoardInfoRepository();
    });

    test('initial state is ChallengeState.initial', () {
      expect(
        ChallengeBloc(boardInfoRepository: boardInfoRepository).state,
        equals(const ChallengeState.initial()),
      );
    });

    blocTest<ChallengeBloc, ChallengeState>(
      'remains the same when retrieval fails',
      seed: () => const ChallengeState(solvedWords: 1, totalWords: 2),
      build: () => ChallengeBloc(boardInfoRepository: boardInfoRepository),
      act: (bloc) {
        when(() => boardInfoRepository.getSolvedWordsCount())
            .thenAnswer((_) => Stream.error(Exception()));
        when(() => boardInfoRepository.getTotalWordsCount())
            .thenAnswer((_) => Stream.error(Exception()));
        bloc.add(const ChallengeDataRequested());
      },
      expect: () => <ChallengeState>[],
    );

    blocTest<ChallengeBloc, ChallengeState>(
      'emits ChallengeState with updated values when data is requested',
      build: () => ChallengeBloc(boardInfoRepository: boardInfoRepository),
      act: (bloc) {
        when(() => boardInfoRepository.getSolvedWordsCount())
            .thenAnswer((_) => Stream.value(1));
        when(() => boardInfoRepository.getTotalWordsCount())
            .thenAnswer((_) => Stream.value(2));
        bloc.add(const ChallengeDataRequested());
      },
      expect: () => <ChallengeState>[
        const ChallengeState(solvedWords: 1, totalWords: 2),
      ],
    );
  });
}
