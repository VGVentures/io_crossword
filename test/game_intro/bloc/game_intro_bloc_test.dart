// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/game_intro/bloc/game_intro_bloc.dart';
import 'package:io_crossword/game_intro/game_intro.dart';

void main() {
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
    act: (bloc) => bloc.add(MascotSubmitted(Mascots.dino)),
    expect: () => <GameIntroState>[
      GameIntroState(status: GameIntroStatus.initialsInput),
    ],
  );
}
