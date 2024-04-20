import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword/bloc/crossword_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

void main() {
  group('$Crossword2View', () {
    testWidgets('pumps successfully', (tester) async {
      await tester.pumpApp(const Crossword2View());
      expect(find.byType(Crossword2View), findsOneWidget);
    });

    testWidgets('requests chunk', (tester) async {
      final crosswordBloc = _MockCrosswordBloc();
      when(() => crosswordBloc.state).thenReturn(const CrosswordState());

      await tester.pumpApp(
        crosswordBloc: crosswordBloc,
        const Crossword2View(),
      );

      verify(() => crosswordBloc.add(const BoardSectionRequested((0, 0))))
          .called(1);
    });
  });
}
