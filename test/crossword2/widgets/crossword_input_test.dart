// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/crossword2/widgets/widgets.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockIoWordInputController extends Mock implements IoWordInputController {
  @override
  void updateWord(String word, {required bool isInitial}) {}
}

void main() {
  group('$CrosswordInput', () {
    late WordSelectionBloc wordSelectionBloc;

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(status: WordSelectionStatus.solving),
      );
    });

    for (final status in WordSelectionStatus.values.toList()
      ..remove(WordSelectionStatus.empty)
      ..remove(WordSelectionStatus.preSolving)) {
      testWidgets(
        'IoWordInput is not read only with $status',
        (tester) async {
          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(
              status: status,
            ),
          );

          await tester.pumpApp(
            DefaultWordInputController(
              child: BlocProvider.value(
                value: wordSelectionBloc,
                child: const CrosswordInput(
                  length: 5,
                  characters: {},
                ),
              ),
            ),
          );

          expect(
            tester.widget<IoWordInput>(find.byType(IoWordInput)).readOnly,
            isFalse,
          );
        },
      );
    }

    for (final status in [
      WordSelectionStatus.empty,
      WordSelectionStatus.preSolving,
    ]) {
      testWidgets(
        'IoWordInput is read only with $status',
        (tester) async {
          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(
              status: status,
            ),
          );

          await tester.pumpApp(
            DefaultWordInputController(
              child: BlocProvider.value(
                value: wordSelectionBloc,
                child: const CrosswordInput(
                  length: 5,
                  characters: {},
                ),
              ),
            ),
          );

          expect(
            tester.widget<IoWordInput>(find.byType(IoWordInput)).readOnly,
            isTrue,
          );
        },
      );
    }

    testWidgets(
      'incorrect attempt causes word controller to reset',
      (tester) async {
        whenListen(
          wordSelectionBloc,
          Stream.fromIterable([
            WordSelectionState(
              status: WordSelectionStatus.incorrect,
            ),
          ]),
          initialState: WordSelectionState(
            status: WordSelectionStatus.solving,
          ),
        );
        final controller = _MockIoWordInputController();

        await tester.pumpApp(
          IoWordInputControllerScope(
            wordInputController: controller,
            child: BlocProvider.value(
              value: wordSelectionBloc,
              child: const CrosswordInput(
                length: 5,
                characters: {},
              ),
            ),
          ),
        );

        await tester.pump();

        verify(controller.reset).called(1);
      },
    );

    testWidgets(
      'submitting the input sends the WordSolveAttempted event',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.solving,
          ),
        );

        await tester.pumpApp(
          DefaultWordInputController(
            child: BlocProvider.value(
              value: wordSelectionBloc,
              child: const CrosswordInput(
                length: 5,
                characters: {},
              ),
            ),
          ),
        );

        final input = tester.widget<IoWordInput>(find.byType(IoWordInput));
        input.onSubmit?.call('hello');

        verify(
          () =>
              wordSelectionBloc.add(const WordSolveAttempted(answer: 'hello')),
        ).called(1);
      },
    );

    testWidgets(
      'sends characters correctly to IoWordInput',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.solving,
          ),
        );

        await tester.pumpApp(
          DefaultWordInputController(
            child: BlocProvider.value(
              value: wordSelectionBloc,
              child: const CrosswordInput(
                length: 5,
                characters: {
                  1: 'a',
                  4: 'y',
                },
              ),
            ),
          ),
        );

        expect(
          tester.widget<IoWordInput>(find.byType(IoWordInput)).characters,
          equals(
            {
              1: 'a',
              4: 'y',
            },
          ),
        );
      },
    );
  });
}
