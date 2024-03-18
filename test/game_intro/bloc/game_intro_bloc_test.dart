// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/game_intro/game_intro.dart';

void main() {
  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with mascot selection status when WelcomeCompleted is added',
    build: GameIntroBloc.new,
    act: (bloc) => bloc.add(WelcomeCompleted()),
    expect: () => <GameIntroState>[
      GameIntroState(status: GameIntroStatus.mascotSelection),
    ],
  );

  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with updated selected mascot when MascotUpdated is added',
    build: GameIntroBloc.new,
    act: (bloc) => bloc.add(MascotUpdated(Mascots.dino)),
    expect: () => <GameIntroState>[
      GameIntroState(selectedMascot: Mascots.dino),
    ],
  );

  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with initials input status when MascotSubmitted is added',
    build: GameIntroBloc.new,
    act: (bloc) => bloc.add(MascotSubmitted()),
    expect: () => <GameIntroState>[
      GameIntroState(status: GameIntroStatus.initialsInput),
    ],
  );

  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with intro completed when InitialsSubmitted is added',
    build: GameIntroBloc.new,
    act: (bloc) => bloc.add(InitialsSubmitted()),
    expect: () => <GameIntroState>[
      GameIntroState(isIntroCompleted: true),
    ],
  );
}
