// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:mocktail/mocktail.dart';

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

void main() {
  late BoardInfoRepository boardInfoRepository;

  setUp(() {
    boardInfoRepository = _MockBoardInfoRepository();
  });

  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with updated board progress data '
    'when BoardProgressRequested is added',
    build: () => GameIntroBloc(boardInfoRepository: boardInfoRepository),
    setUp: () {
      when(() => boardInfoRepository.getSolvedWordsCount())
          .thenAnswer((_) => Future.value(123));
      when(() => boardInfoRepository.getTotalWordsCount())
          .thenAnswer((_) => Future.value(8900));
    },
    act: (bloc) => bloc.add(BoardProgressRequested()),
    expect: () => <GameIntroState>[
      GameIntroState(
        solvedWords: 123,
        totalWords: 8900,
      ),
    ],
  );

  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with mascot selection status when WelcomeCompleted is added',
    build: () => GameIntroBloc(boardInfoRepository: boardInfoRepository),
    act: (bloc) => bloc.add(WelcomeCompleted()),
    expect: () => <GameIntroState>[
      GameIntroState(status: GameIntroStatus.mascotSelection),
    ],
  );

  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with updated selected mascot when MascotUpdated is added',
    build: () => GameIntroBloc(boardInfoRepository: boardInfoRepository),
    act: (bloc) => bloc.add(MascotUpdated(Mascots.dino)),
    expect: () => <GameIntroState>[
      GameIntroState(selectedMascot: Mascots.dino),
    ],
  );

  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with initials input status when MascotSubmitted is added',
    build: () => GameIntroBloc(boardInfoRepository: boardInfoRepository),
    act: (bloc) => bloc.add(MascotSubmitted()),
    expect: () => <GameIntroState>[
      GameIntroState(status: GameIntroStatus.initialsInput),
    ],
  );

  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with intro completed when InitialsSubmitted is added',
    build: () => GameIntroBloc(boardInfoRepository: boardInfoRepository),
    act: (bloc) => bloc.add(InitialsSubmitted()),
    expect: () => <GameIntroState>[
      GameIntroState(isIntroCompleted: true),
    ],
  );
}
