import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/hint/bloc/hint_bloc.dart';

void main() {
  group('$HintBloc', () {
    blocTest<HintBloc, HintState>(
      'emits state with status ${HintStatus.asking} when HintModeEntered '
      'is added',
      build: HintBloc.new,
      act: (bloc) => bloc.add(const HintModeEntered()),
      expect: () => const <HintState>[
        HintState(status: HintStatus.asking),
      ],
    );

    blocTest<HintBloc, HintState>(
      'emits state with status ${HintStatus.initial} when HintModeExited '
      'is added',
      build: HintBloc.new,
      act: (bloc) => bloc.add(const HintModeExited()),
      expect: () => const <HintState>[
        HintState(),
      ],
    );

    blocTest<HintBloc, HintState>(
      'emits state with status ${HintStatus.thinking} immediately and '
      '${HintStatus.answered} after when HintRequested is added',
      build: HintBloc.new,
      act: (bloc) => bloc.add(const HintRequested('is it blue?')),
      expect: () => const <HintState>[
        HintState(status: HintStatus.thinking),
        HintState(status: HintStatus.answered),
      ],
      wait: const Duration(seconds: 1),
    );
  });
}
