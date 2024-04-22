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

    group('adding HintRequested', () {
      blocTest<HintBloc, HintState>(
        'emits state with status ${HintStatus.thinking} immediately and '
        '${HintStatus.answered} after',
        setUp: () {
          when(
            () => hintResource.generateHint(wordId: 'id', question: 'blue?'),
          ).thenAnswer(
            (_) async =>
                (Hint(question: 'blue?', response: HintResponse.no), 9),
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
            maxHints: 9,
          ),
        ],
      );

      blocTest<HintBloc, HintState>(
        'does not emit state if there are no hints left',
        seed: () => HintState(
          status: HintStatus.asking,
          hints: [
            Hint(question: 'is it orange?', response: HintResponse.no),
          ],
          maxHints: 1,
        ),
        build: () => HintBloc(hintResource: hintResource),
        act: (bloc) => bloc.add(
          HintRequested(wordId: 'id', question: 'blue?'),
        ),
        expect: () => const <HintState>[],
      );
    });
  });

  group('adding PreviousHintsRequested', () {
    late HintResource hintResource;

    setUp(() {
      hintResource = _MockHintResource();
    });

    blocTest<HintBloc, HintState>(
      'emits state with hints',
      setUp: () {
        when(() => hintResource.getHints(wordId: 'id')).thenAnswer(
          (_) async => (
            [
              Hint(question: 'is it orange?', response: HintResponse.no),
              Hint(question: 'is it blue?', response: HintResponse.yes),
            ],
            8
          ),
        );
      },
      build: () => HintBloc(hintResource: hintResource),
      act: (bloc) => bloc.add(PreviousHintsRequested('id')),
      expect: () => const <HintState>[
        HintState(
          hints: [
            Hint(question: 'is it orange?', response: HintResponse.no),
            Hint(question: 'is it blue?', response: HintResponse.yes),
          ],
          maxHints: 8,
        ),
      ],
    );

    blocTest<HintBloc, HintState>(
      'does not emit state when hints are already present',
      seed: () => HintState(
        hints: [
          Hint(question: 'is it orange?', response: HintResponse.no),
          Hint(question: 'is it blue?', response: HintResponse.yes),
        ],
      ),
      build: () => HintBloc(hintResource: hintResource),
      act: (bloc) => bloc.add(
        PreviousHintsRequested('id'),
      ),
      expect: () => const <HintState>[],
    );
  });
}
