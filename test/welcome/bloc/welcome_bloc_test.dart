import 'package:bloc_test/bloc_test.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/welcome/welcome.dart';
import 'package:mocktail/mocktail.dart';

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

void main() {
  group('$WelcomeBloc', () {
    late BoardInfoRepository boardInfoRepository;

    setUp(() {
      boardInfoRepository = _MockBoardInfoRepository();
    });

    test('initial state is WelcomeState.initial', () {
      expect(
        WelcomeBloc(boardInfoRepository: boardInfoRepository).state,
        equals(const WelcomeState.initial()),
      );
    });

    blocTest<WelcomeBloc, WelcomeState>(
      'remains the same when retrieval fails',
      build: () => WelcomeBloc(boardInfoRepository: boardInfoRepository),
      act: (bloc) {
        when(() => boardInfoRepository.getSolvedWordsCount())
            .thenThrow(Exception('oops'));
        when(() => boardInfoRepository.getTotalWordsCount())
            .thenThrow(Exception('oops'));
        bloc.add(const WelcomeDataRequested());
      },
      expect: () => <WelcomeState>[],
    );

    blocTest<WelcomeBloc, WelcomeState>(
      'emits WelcomeState with updated values when data is requested',
      build: () => WelcomeBloc(boardInfoRepository: boardInfoRepository),
      act: (bloc) {
        when(() => boardInfoRepository.getSolvedWordsCount())
            .thenAnswer((_) => Future.value(1));
        when(() => boardInfoRepository.getTotalWordsCount())
            .thenAnswer((_) => Future.value(2));
        bloc.add(const WelcomeDataRequested());
      },
      expect: () => <WelcomeState>[
        const WelcomeState(solvedWords: 1, totalWords: 2),
      ],
    );
  });
}
