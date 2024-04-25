// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/hint/bloc/hint_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockHintResource extends Mock implements HintResource {}

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

void main() {
  group('$HintBloc', () {
    late HintResource hintResource;
    late BoardInfoRepository boardInfoRepository;

    setUp(() {
      hintResource = _MockHintResource();
      boardInfoRepository = _MockBoardInfoRepository();
    });

    blocTest<HintBloc, HintState>(
      'emits state with updated isHintsEnabled when $HintEnabledRequested '
      'is added',
      setUp: () {
        when(() => boardInfoRepository.isHintsEnabled()).thenAnswer(
          (_) => Stream.value(true),
        );
      },
      build: () => HintBloc(
        hintResource: hintResource,
        boardInfoRepository: boardInfoRepository,
      ),
      act: (bloc) => bloc.add(const HintEnabledRequested()),
      expect: () => const <HintState>[
        HintState(isHintsEnabled: true),
      ],
    );

    blocTest<HintBloc, HintState>(
      'emits state with status ${HintStatus.asking} when HintModeEntered '
      'is added',
      build: () => HintBloc(
        hintResource: hintResource,
        boardInfoRepository: boardInfoRepository,
      ),
      act: (bloc) => bloc.add(const HintModeEntered()),
      expect: () => const <HintState>[
        HintState(status: HintStatus.asking),
      ],
    );

    blocTest<HintBloc, HintState>(
      'emits state with status ${HintStatus.initial} when HintModeExited '
      'is added',
      seed: () => HintState(status: HintStatus.asking),
      build: () => HintBloc(
        hintResource: hintResource,
        boardInfoRepository: boardInfoRepository,
      ),
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
            (_) async => (
              Hint(
                question: 'blue?',
                response: HintResponse.no,
                readableResponse: 'Nope!',
              ),
              9
            ),
          );
        },
        seed: () => HintState(
          status: HintStatus.asking,
          hints: [
            Hint(
              question: 'is it orange?',
              response: HintResponse.no,
              readableResponse: 'No!',
            ),
          ],
        ),
        build: () => HintBloc(
          hintResource: hintResource,
          boardInfoRepository: boardInfoRepository,
        ),
        act: (bloc) => bloc.add(
          HintRequested(wordId: 'id', question: 'blue?'),
        ),
        expect: () => const <HintState>[
          HintState(
            status: HintStatus.thinking,
            hints: [
              Hint(
                question: 'is it orange?',
                response: HintResponse.no,
                readableResponse: 'No!',
              ),
            ],
          ),
          HintState(
            status: HintStatus.answered,
            hints: [
              Hint(
                question: 'is it orange?',
                response: HintResponse.no,
                readableResponse: 'No!',
              ),
              Hint(
                question: 'blue?',
                response: HintResponse.no,
                readableResponse: 'Nope!',
              ),
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
            Hint(
              question: 'is it orange?',
              response: HintResponse.no,
              readableResponse: 'No!',
            ),
          ],
          maxHints: 1,
        ),
        build: () => HintBloc(
          hintResource: hintResource,
          boardInfoRepository: boardInfoRepository,
        ),
        act: (bloc) => bloc.add(
          HintRequested(wordId: 'id', question: 'blue?'),
        ),
        expect: () => const <HintState>[],
      );
    });
  });

  group('adding PreviousHintsRequested', () {
    late HintResource hintResource;
    late BoardInfoRepository boardInfoRepository;

    setUp(() {
      hintResource = _MockHintResource();
      boardInfoRepository = _MockBoardInfoRepository();
    });

    blocTest<HintBloc, HintState>(
      'emits state with hints',
      setUp: () {
        when(() => boardInfoRepository.isHintsEnabled()).thenAnswer(
          (_) => Stream.value(true),
        );
        when(() => hintResource.getHints(wordId: 'id')).thenAnswer(
          (_) async => (
            [
              Hint(
                question: 'is it orange?',
                response: HintResponse.no,
                readableResponse: 'No!',
              ),
              Hint(
                question: 'is it blue?',
                response: HintResponse.yes,
                readableResponse: 'Yes!',
              ),
            ],
            8
          ),
        );
      },
      build: () => HintBloc(
        hintResource: hintResource,
        boardInfoRepository: boardInfoRepository,
      ),
      act: (bloc) => bloc.add(PreviousHintsRequested('id')),
      expect: () => const <HintState>[
        HintState(
          hints: [
            Hint(
              question: 'is it orange?',
              response: HintResponse.no,
              readableResponse: 'No!',
            ),
            Hint(
              question: 'is it blue?',
              response: HintResponse.yes,
              readableResponse: 'Yes!',
            ),
          ],
          maxHints: 8,
        ),
      ],
    );

    blocTest<HintBloc, HintState>(
      'does not emit state when hints are already present',
      setUp: () {
        when(() => boardInfoRepository.isHintsEnabled()).thenAnswer(
          (_) => Stream.value(true),
        );
      },
      seed: () => HintState(
        hints: [
          Hint(
            question: 'is it orange?',
            response: HintResponse.no,
            readableResponse: 'No!',
          ),
          Hint(
            question: 'is it blue?',
            response: HintResponse.yes,
            readableResponse: 'Yes!',
          ),
        ],
      ),
      build: () => HintBloc(
        hintResource: hintResource,
        boardInfoRepository: boardInfoRepository,
      ),
      act: (bloc) => bloc.add(
        PreviousHintsRequested('id'),
      ),
      expect: () => const <HintState>[],
    );

    blocTest<HintBloc, HintState>(
      'does not emit state when hints are disabled',
      setUp: () {
        when(() => boardInfoRepository.isHintsEnabled()).thenAnswer(
          (_) => Stream.fromIterable([true, false]),
        );
      },
      build: () => HintBloc(
        hintResource: hintResource,
        boardInfoRepository: boardInfoRepository,
      ),
      act: (bloc) => bloc.add(
        PreviousHintsRequested('id'),
      ),
      expect: () => const <HintState>[],
    );
  });
}
