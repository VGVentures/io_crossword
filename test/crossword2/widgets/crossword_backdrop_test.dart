import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

void main() {
  group('$CrosswordBackdrop', () {
    late WordSelectionBloc wordSelectionBloc;
    late CrosswordLayoutData layoutData;

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();

      layoutData = CrosswordLayoutData.fromConfiguration(
        configuration: const CrosswordConfiguration(
          bottomRight: (40, 40),
          chunkSize: 20,
        ),
        cellSize: const Size.square(20),
      );
    });

    testWidgets('pumps successfully', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: wordSelectionBloc,
          child: CrosswordLayoutScope(
            data: layoutData,
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
          child: CrosswordLayoutScope(
            data: layoutData,
            child: const CrosswordBackdrop(),
          ),
        ),
      );

      await tester.tap(find.byType(CrosswordBackdrop));

      verify(() => wordSelectionBloc.add(const WordUnselected())).called(1);
    });
  });
}
