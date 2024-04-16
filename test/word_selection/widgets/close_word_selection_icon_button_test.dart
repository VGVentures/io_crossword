import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart'
    hide WordUnselected;
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

void main() {
  group('$CloseWordSelectionIconButton', () {
    late CrosswordBloc crosswordBloc;

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();
    });

    testWidgets('renders $CloseWordSelectionIconButton', (tester) async {
      await tester.pumpApp(const CloseWordSelectionIconButton());

      expect(find.byType(CloseWordSelectionIconButton), findsOneWidget);
    });

    testWidgets('emits $WordUnselected when tapped', (tester) async {
      await tester.pumpApp(
        crosswordBloc: crosswordBloc,
        const CloseWordSelectionIconButton(),
      );

      await tester.tap(find.byType(CloseWordSelectionIconButton));
      await tester.pumpAndSettle();

      verify(() => crosswordBloc.add(const WordUnselected())).called(1);
    });
  });
}
