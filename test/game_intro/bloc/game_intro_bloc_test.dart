import 'package:bloc_test/bloc_test.dart';
import 'package:io_crossword/game_intro/game_intro.dart';

void main() {
  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with mascot selection status when WelcomeCompleted is added',
    build: GameIntroBloc.new,
    act: (bloc) => bloc.add(const WelcomeCompleted()),
    expect: () => <GameIntroState>[
      const GameIntroState(status: GameIntroStatus.mascotSelection),
    ],
  );

  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with initials input status when MascotSubmitted is added',
    build: GameIntroBloc.new,
    act: (bloc) => bloc.add(const MascotSubmitted()),
    expect: () => <GameIntroState>[
      const GameIntroState(status: GameIntroStatus.initialsInput),
    ],
  );

  blocTest<GameIntroBloc, GameIntroState>(
    'emits state with intro completed when InitialsSubmitted is added',
    build: GameIntroBloc.new,
    act: (bloc) => bloc.add(const InitialsSubmitted()),
    expect: () => <GameIntroState>[
      const GameIntroState(isIntroCompleted: true),
    ],
  );
}
