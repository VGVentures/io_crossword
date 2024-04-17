import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart'
    hide WordUnselected;
import 'package:io_crossword/word_selection/word_selection.dart' as selection;
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

void main() {
  group('$CloseWordSelectionIconButton', () {
    late CrosswordBloc crosswordBloc;
    late WordSelectionBloc wordSelectionBloc;

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();
      wordSelectionBloc = _MockWordSelectionBloc();
    });

    testWidgets('renders $CloseWordSelectionIconButton', (tester) async {
      await tester.pumpApp(const CloseWordSelectionIconButton());

      expect(find.byType(CloseWordSelectionIconButton), findsOneWidget);
    });

    testWidgets('emits $WordUnselected when tapped', (tester) async {
      await tester.pumpApp(
        crosswordBloc: crosswordBloc,
        BlocProvider(
          create: (_) => wordSelectionBloc,
          child: const CloseWordSelectionIconButton(),
        ),
      );

      await tester.tap(find.byType(CloseWordSelectionIconButton));
      await tester.pumpAndSettle();

      verify(() => crosswordBloc.add(const WordUnselected())).called(1);
      verify(() => wordSelectionBloc.add(const selection.WordUnselected()))
          .called(1);
    });
  });
}
