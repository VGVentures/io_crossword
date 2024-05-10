import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' as domain show Axis;
import 'package:game_domain/game_domain.dart' hide Axis;
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

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
      await tester.pumpSubject(
        CrosswordInteractiveViewer(
          builder: (context, position) {
            return const SizedBox();
          },
        ),
      );

      expect(find.byType(CrosswordInteractiveViewer), findsOneWidget);
    });

    testWidgets(
      "pumps a $QuadScope with the viewer's viewport",
      (tester) async {
        late BuildContext buildContext;
        late Quad quad;

        await tester.pumpSubject(
          CrosswordInteractiveViewer(
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
        );

        expect(QuadScope.of(buildContext), equals(quad));
      },
    );

    group('scales selected word', () {
      late _MockWord word;

      setUp(() {
        word = _MockWord();
        when(() => word.id).thenReturn('id');
        when(() => word.axis).thenReturn(domain.Axis.horizontal);
        when(() => word.position).thenReturn(const Point(0, 0));
        wordSelectionBloc = _MockWordSelectionBloc();
        when(() => word.solvedCharacters).thenReturn({});

        when(() => wordSelectionBloc.state)
            .thenReturn(const WordSelectionState.initial());
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.solving,
            word: SelectedWord(
              section: (0, 0),
              word: word,
            ),
          ),
        );
        when(() => word.isSolved).thenReturn(false);
      });

      testWidgets(
        'with normal word',
        (tester) async {
          when(() => word.length).thenReturn(5);
          await tester.pumpApp(
            layout: IoLayoutData.large,
            DefaultWordInputController(
              child: BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            ),
          );

          await tester.ensureVisible(find.byType(EditableText).first);
          await tester.ensureVisible(find.byType(EditableText).last);
          expect(find.byType(EditableText), findsNWidgets(5));
        },
      );

      testWidgets(
        'with big horizontal word',
        (tester) async {
          when(() => word.length).thenReturn(25);
          await tester.pumpApp(
            layout: IoLayoutData.large,
            DefaultWordInputController(
              child: BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            ),
          );

          await tester.ensureVisible(find.byType(EditableText).first);
          await tester.ensureVisible(find.byType(EditableText).last);
          expect(find.byType(EditableText), findsNWidgets(25));
        },
      );

      testWidgets(
        'with big vertical word',
        (tester) async {
          when(() => word.length).thenReturn(25);
          when(() => word.axis).thenReturn(domain.Axis.vertical);
          await tester.pumpApp(
            layout: IoLayoutData.large,
            DefaultWordInputController(
              child: BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            ),
          );

          await tester.ensureVisible(find.byType(EditableText).first);
          await tester.ensureVisible(find.byType(EditableText).last);
          expect(find.byType(EditableText), findsNWidgets(25));
        },
      );
    });

    group('panning', () {
      late _MockWord word;

      setUp(() {
        word = _MockWord();
        when(() => word.id).thenReturn('id');
        when(() => word.length).thenReturn(5);
        when(() => word.axis).thenReturn(domain.Axis.horizontal);
        when(() => word.position).thenReturn(const Point(0, 0));
      });

      testWidgets('is enabled when no word is selected', (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          const WordSelectionState(
            status: WordSelectionStatus.empty,
            // ignore: avoid_redundant_argument_values
            word: null,
          ),
        );

        await tester.pumpSubject(
          wordSelectionBloc: wordSelectionBloc,
          CrosswordInteractiveViewer(
            builder: (context, position) {
              return const SizedBox();
            },
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
              word: word,
            ),
          ),
        );

        await tester.pumpSubject(
          wordSelectionBloc: wordSelectionBloc,
          CrosswordInteractiveViewer(
            builder: (context, position) {
              return const SizedBox();
            },
          ),
        );

        final interactiveViewerFinder = find.byType(InteractiveViewer);
        expect(interactiveViewerFinder, findsOneWidget);

        final interactiveViewer =
            tester.widget<InteractiveViewer>(interactiveViewerFinder);
        expect(interactiveViewer.panEnabled, isFalse);
      });

      testWidgets('updates when selected word changes', (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          const WordSelectionState(
            status: WordSelectionStatus.empty,
            // ignore: avoid_redundant_argument_values
            word: null,
          ),
        );
        final streamController = StreamController<WordSelectionState>();
        addTearDown(streamController.close);
        final stream = streamController.stream.asBroadcastStream();

        whenListen<WordSelectionState>(wordSelectionBloc, stream);

        await tester.pumpSubject(
          wordSelectionBloc: wordSelectionBloc,
          CrosswordInteractiveViewer(
            builder: (context, position) {
              return const SizedBox();
            },
          ),
        );

        final interactiveViewerFinder = find.byType(InteractiveViewer);
        expect(
          tester.widget<InteractiveViewer>(interactiveViewerFinder).panEnabled,
          isTrue,
        );

        final newState = WordSelectionState(
          status: WordSelectionStatus.preSolving,
          word: SelectedWord(section: (0, 0), word: word),
        );
        when(() => wordSelectionBloc.state).thenReturn(newState);
        streamController.add(newState);
        await tester.pumpAndSettle();

        expect(
          tester.widget<InteractiveViewer>(interactiveViewerFinder).panEnabled,
          isFalse,
        );
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    Widget widget, {
    WordSelectionBloc? wordSelectionBloc,
    CrosswordLayoutData? crosswordLayoutData,
  }) {
    final internalWordSelectionBloc =
        wordSelectionBloc ?? _MockWordSelectionBloc();

    if (wordSelectionBloc == null) {
      when(() => internalWordSelectionBloc.state)
          .thenReturn(const WordSelectionState.initial());
    }

    final internalCrosswordLayoutData = crosswordLayoutData ??
        CrosswordLayoutData.fromConfiguration(
          configuration: const CrosswordConfiguration(
            bottomRight: (1, 1),
            chunkSize: 20,
          ),
          cellSize: const Size.square(50),
        );

    return pumpApp(
      DefaultTransformationController(
        child: BlocProvider<WordSelectionBloc>(
          create: (_) => internalWordSelectionBloc,
          child: CrosswordLayoutScope(
            data: internalCrosswordLayoutData,
            child: widget,
          ),
        ),
      ),
    );
  }
}
