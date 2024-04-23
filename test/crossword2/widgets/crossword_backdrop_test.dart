import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../helpers/helpers.dart';

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockQuad extends Mock implements Quad {}

void main() {
  group('$CrosswordBackdrop', () {
    late WordSelectionBloc wordSelectionBloc;
    late Quad quad;

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
      quad = _MockQuad();

      when(() => quad.point0).thenReturn(Vector3(0, 0, 0));
      when(() => quad.point2).thenReturn(Vector3(100, 100, 0));
    });

    testWidgets('pumps successfully', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: wordSelectionBloc,
          child: QuadScope(
            data: quad,
            child: const CrosswordBackdrop(),
          ),
        ),
      );

      expect(find.byType(CrosswordBackdrop), findsOneWidget);
    });

    testWidgets('emits $WordUnselected when tapped', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: wordSelectionBloc,
          child: QuadScope(
            data: quad,
            child: const CrosswordBackdrop(),
          ),
        ),
      );

      await tester.tap(find.byType(CrosswordBackdrop));

      verify(() => wordSelectionBloc.add(const WordUnselected())).called(1);
    });
  });
}
