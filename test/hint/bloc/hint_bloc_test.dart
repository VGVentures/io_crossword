// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/hint/bloc/hint_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockHintResource extends Mock implements HintResource {}

void main() {
  group('$HintBloc', () {
    late HintResource hintResource;

    setUp(() {
      hintResource = _MockHintResource();
    });

    blocTest<HintBloc, HintState>(
      'emits state with status ${HintStatus.asking} when HintModeEntered '
      'is added',
      build: () => HintBloc(hintResource: hintResource),
      act: (bloc) => bloc.add(const HintModeEntered()),
      expect: () => const <HintState>[
        HintState(status: HintStatus.asking),
      ],
    );

    blocTest<HintBloc, HintState>(
      'emits state with status ${HintStatus.initial} when HintModeExited '
      'is added',
      seed: () => HintState(status: HintStatus.asking),
      build: () => HintBloc(hintResource: hintResource),
      act: (bloc) => bloc.add(const HintModeExited()),
      expect: () => const <HintState>[
        HintState(),
      ],
    );

    blocTest<HintBloc, HintState>(
      'emits state with status ${HintStatus.thinking} immediately and '
      '${HintStatus.answered} after when HintRequested is added',
      setUp: () {
        when(
          () => hintResource.generateHint(wordId: 'id', question: 'blue?'),
        ).thenAnswer(
          (_) async => Hint(question: 'blue?', response: HintResponse.no),
        );
      },
      seed: () => HintState(
        status: HintStatus.asking,
        hints: [
          Hint(question: 'is it orange?', response: HintResponse.no),
        ],
      ),
      build: () => HintBloc(hintResource: hintResource),
      act: (bloc) => bloc.add(
        HintRequested(wordId: 'id', question: 'blue?'),
      ),
      expect: () => const <HintState>[
        HintState(
          status: HintStatus.thinking,
          hints: [
            Hint(question: 'is it orange?', response: HintResponse.no),
          ],
        ),
        HintState(
          status: HintStatus.answered,
          hints: [
            Hint(question: 'is it orange?', response: HintResponse.no),
            Hint(question: 'blue?', response: HintResponse.no),
          ],
        ),
      ],
    );
  });
}
