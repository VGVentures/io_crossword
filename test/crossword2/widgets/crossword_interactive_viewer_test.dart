import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockWord extends Mock implements Word {}

void main() {
  group('$CrosswordInteractiveViewer', () {
    late WordSelectionBloc wordSelectionBloc;

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
      when(() => wordSelectionBloc.state)
          .thenReturn(const WordSelectionState.initial());
    });

    testWidgets('pumps successfully', (tester) async {
      await tester.pumpWidget(
        BlocProvider<WordSelectionBloc>(
          create: (_) => wordSelectionBloc,
          child: CrosswordInteractiveViewer(
            builder: (context, position) {
              return const SizedBox();
            },
          ),
        ),
      );

      expect(find.byType(CrosswordInteractiveViewer), findsOneWidget);
    });

    testWidgets(
      "pumps a $QuadScope with the viewer's viewport",
      (tester) async {
        late BuildContext buildContext;
        late Quad quad;

        await tester.pumpWidget(
          BlocProvider<WordSelectionBloc>(
            create: (_) => wordSelectionBloc,
            child: CrosswordInteractiveViewer(
              builder: (context, viewport) {
                quad = viewport;

                return Builder(
                  builder: (context) {
                    buildContext = context;
                    return const SizedBox();
                  },
                );
              },
            ),
          ),
        );

        expect(QuadScope.of(buildContext), equals(quad));
      },
    );

    group('panning', () {
      testWidgets('is enabled when no word is selected', (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          const WordSelectionState(
            status: WordSelectionStatus.empty,
            // ignore: avoid_redundant_argument_values
            word: null,
          ),
        );

        await tester.pumpWidget(
          BlocProvider<WordSelectionBloc>(
            create: (_) => wordSelectionBloc,
            child: CrosswordInteractiveViewer(
              builder: (context, position) {
                return const SizedBox();
              },
            ),
          ),
        );

        final interactiveViewerFinder = find.byType(InteractiveViewer);
        expect(interactiveViewerFinder, findsOneWidget);

        final interactiveViewer =
            tester.widget<InteractiveViewer>(interactiveViewerFinder);
        expect(interactiveViewer.panEnabled, isTrue);
      });

      testWidgets('is disabled when a word is selected', (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.preSolving,
            word: SelectedWord(
              section: (0, 0),
              word: _MockWord(),
            ),
          ),
        );

        await tester.pumpWidget(
          BlocProvider<WordSelectionBloc>(
            create: (_) => wordSelectionBloc,
            child: CrosswordInteractiveViewer(
              builder: (context, position) {
                return const SizedBox();
              },
            ),
          ),
        );

        final interactiveViewerFinder = find.byType(InteractiveViewer);
        expect(interactiveViewerFinder, findsOneWidget);

        final interactiveViewer =
            tester.widget<InteractiveViewer>(interactiveViewerFinder);
        expect(interactiveViewer.panEnabled, isFalse);
      });
    });
  });
}
