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

void main() {
  group('$CrosswordInput', () {
    late WordSelectionBloc wordSelectionBloc;

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
    });

    testWidgets(
      'submitting the input sends the WordSolveAttempted event',
      (tester) async {
        await tester.pumpApp(
          DefaultWordInputController(
            child: BlocProvider.value(
              value: wordSelectionBloc,
              child: const CrosswordInput(length: 5),
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
  });
}
