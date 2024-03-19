// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/game_intro/bloc/game_intro_bloc.dart';
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
    'emits state with updated initials when InitialsUpdated is added',
    build: () => GameIntroBloc(boardInfoRepository: boardInfoRepository),
    act: (bloc) => bloc
      ..add(InitialsUpdated(character: 'B', index: 0))
      ..add(InitialsUpdated(character: 'D', index: 1)),
    expect: () => <GameIntroState>[
      GameIntroState(initials: ['B', '', '']),
      GameIntroState(initials: ['B', 'D', '']),
    ],
  );

  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with initials status invalid when InitialsSubmitted is added '
    'and initials are not valid',
    build: () => GameIntroBloc(boardInfoRepository: boardInfoRepository),
    seed: () => GameIntroState(initials: ['A', 'B', '2']),
    act: (bloc) => bloc.add(InitialsSubmitted()),
    expect: () => <GameIntroState>[
      GameIntroState(
        initialsStatus: InitialsFormStatus.invalid,
        initials: ['A', 'B', '2'],
      ),
    ],
  );

  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with initials status blacklisted when InitialsSubmitted '
    'is added and initials are blacklisted',
    build: () => GameIntroBloc(boardInfoRepository: boardInfoRepository),
    seed: () => GameIntroState(initials: ['T', 'S', 'T']),
    act: (bloc) => bloc.add(InitialsSubmitted()),
    expect: () => <GameIntroState>[
      GameIntroState(
        initialsStatus: InitialsFormStatus.blacklisted,
        initials: ['T', 'S', 'T'],
      ),
    ],
  );

  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with intro completed when InitialsSubmitted is added '
    'when initials are valid',
    build: () => GameIntroBloc(boardInfoRepository: boardInfoRepository),
    seed: () => GameIntroState(initials: ['A', 'B', 'C']),
    act: (bloc) => bloc.add(InitialsSubmitted()),
    expect: () => <GameIntroState>[
      GameIntroState(
        initialsStatus: InitialsFormStatus.loading,
        initials: ['A', 'B', 'C'],
      ),
      GameIntroState(
        initialsStatus: InitialsFormStatus.success,
        initials: ['A', 'B', 'C'],
        isIntroCompleted: true,
      ),
    ],
  );
}
