// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockWord extends Mock implements Word {}

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

const _boardPadding = 800.0;

void main() {
  group('$CrosswordInteractiveViewer', () {
    late WordSelectionBloc wordSelectionBloc;
    late CrosswordBloc crosswordBloc;

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
      crosswordBloc = _MockCrosswordBloc();

      when(() => wordSelectionBloc.state)
          .thenReturn(const WordSelectionState.initial());

      when(() => crosswordBloc.state).thenReturn(
        const CrosswordState(
          mascotVisible: false,
        ),
      );
    });

    testWidgets('pumps successfully', (tester) async {
      await tester.pumpSubject(
        CrosswordInteractiveViewer(
          zoomLimit: 0.4,
          builder: (context, position) {
            return const SizedBox();
          },
        ),
      );

      expect(find.byType(CrosswordInteractiveViewer), findsOneWidget);
    });

    testWidgets('pumps without zoom controls when layout is large',
        (tester) async {
      await tester.pumpSubject(
        layoutData: IoLayoutData.large,
        CrosswordInteractiveViewer(
          zoomLimit: 0.4,
          builder: (context, position) {
            return const SizedBox();
          },
        ),
      );

      expect(find.byType(ZoomControls), findsNothing);
    });

    testWidgets(
        'pumps with zoom controls when layout '
        'is large when mascot is not visible', (tester) async {
      await tester.pumpSubject(
        layoutData: IoLayoutData.large,
        crosswordBloc: crosswordBloc,
        CrosswordInteractiveViewer(
          zoomLimit: 0.4,
          builder: (context, position) {
            return const SizedBox();
          },
        ),
      );

      expect(find.byType(ZoomControls), findsOneWidget);
    });

    testWidgets('pumps without zoom controls when layout is small',
        (tester) async {
      await tester.pumpSubject(
        layoutData: IoLayoutData.small,
        CrosswordInteractiveViewer(
          zoomLimit: 0.4,
          builder: (context, position) {
            return const SizedBox();
          },
        ),
      );

      expect(find.byType(ZoomControls), findsNothing);
    });

    testWidgets('zooms in when zoom in button is pressed', (tester) async {
      await tester.pumpSubject(
        crosswordBloc: crosswordBloc,
        CrosswordInteractiveViewer(
          zoomLimit: 0.4,
          builder: (context, position) {
            return const SizedBox();
          },
        ),
      );

      final viewerState = tester.state<CrosswordInteractiveViewerState>(
        find.byType(CrosswordInteractiveViewer),
      );

      expect(viewerState.currentScale, 1.0);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(viewerState.currentScale, 1.2);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(viewerState.currentScale, 1.4);
    });

    testWidgets(
        'does nothing when zoom in button is pressed and '
        'limit has been reached', (tester) async {
      await tester.pumpSubject(
        crosswordBloc: crosswordBloc,
        CrosswordInteractiveViewer(
          zoomLimit: 0.4,
          builder: (context, position) {
            return const SizedBox();
          },
        ),
      );

      final viewerState = tester.state<CrosswordInteractiveViewerState>(
        find.byType(CrosswordInteractiveViewer),
      );
      final maxScale = viewerState.maxScale;

      while (viewerState.currentScale < maxScale) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
      }
      expect(viewerState.currentScale, maxScale);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(viewerState.currentScale, maxScale);
    });

    testWidgets(
      'keeps same scale when zoom out button is pressed and zoom value limit '
      'has been reached',
      (tester) async {
        const zoomLimit = 0.6;
        await tester.pumpSubject(
          crosswordBloc: crosswordBloc,
          CrosswordInteractiveViewer(
            zoomLimit: zoomLimit,
            builder: (context, position) {
              return const SizedBox();
            },
          ),
        );

        final viewerState = tester.state<CrosswordInteractiveViewerState>(
          find.byType(CrosswordInteractiveViewer),
        );

        while (viewerState.currentScale > zoomLimit) {
          await tester.tap(find.byIcon(Icons.remove));
          await tester.pumpAndSettle();
        }
        expect(viewerState.currentScale, zoomLimit);

        await tester.tap(find.byIcon(Icons.remove));
        await tester.pumpAndSettle();

        expect(viewerState.currentScale, zoomLimit);
      },
    );

    testWidgets(
      'keeps same scale when zoom out button is pressed and board size limit '
      'has been reached',
      (tester) async {
        const zoomLimit = 0.2;
        await tester.pumpSubject(
          crosswordBloc: crosswordBloc,
          CrosswordInteractiveViewer(
            zoomLimit: zoomLimit,
            builder: (context, position) {
              return const SizedBox();
            },
          ),
        );

        final viewerState = tester.state<CrosswordInteractiveViewerState>(
          find.byType(CrosswordInteractiveViewer),
        );

        var previousScale = 0.0;
        while (viewerState.currentScale != previousScale) {
          previousScale = viewerState.currentScale;
          await tester.tap(find.byIcon(Icons.remove));
          await tester.pumpAndSettle();
        }

        expect(viewerState.currentScale >= zoomLimit, isTrue);

        await tester.tap(find.byIcon(Icons.remove));
        await tester.pumpAndSettle();

        expect(viewerState.currentScale >= zoomLimit, isTrue);
      },
    );

    testWidgets(
      'keeps board within boundaries when viewport is in the bottom right and '
      'zoom out button is pressed',
      (tester) async {
        const zoomLimit = 0.2;
        late double boardWidth;
        late double boardHeight;
        late Quad gameViewport;

        await tester.pumpSubject(
          crosswordBloc: crosswordBloc,
          CrosswordInteractiveViewer(
            zoomLimit: zoomLimit,
            builder: (context, viewport) {
              gameViewport = viewport;
              final crosswordLayout = CrosswordLayoutScope.of(context);
              boardWidth = crosswordLayout.padding.left +
                  crosswordLayout.crosswordSize.width +
                  crosswordLayout.padding.right;
              boardHeight = crosswordLayout.padding.top +
                  crosswordLayout.crosswordSize.height +
                  crosswordLayout.padding.bottom;
              return SizedBox(
                width: boardWidth,
                height: boardHeight,
              );
            },
          ),
        );

        tester
            .state<CrosswordInteractiveViewerState>(
              find.byType(CrosswordInteractiveViewer),
            )
            .transform(
              Matrix4.identity()
                ..translate2(
                  Vector2(
                    gameViewport.point2.x - boardWidth,
                    gameViewport.point2.y - boardHeight,
                  ),
                ),
            );

        await tester.pumpAndSettle();

        expect(gameViewport.point2.x, equals(boardWidth));
        expect(gameViewport.point2.y, equals(boardHeight));

        await tester.tap(find.byIcon(Icons.remove));
        await tester.pumpAndSettle();

        expect(gameViewport.point2.x.roundToDouble(), equals(boardWidth));
        expect(gameViewport.point2.y.roundToDouble(), equals(boardHeight));
      },
    );

    testWidgets('zooms out when zoom out button is pressed', (tester) async {
      await tester.pumpSubject(
        crosswordBloc: crosswordBloc,
        CrosswordInteractiveViewer(
          zoomLimit: 0.6,
          builder: (context, position) {
            return const SizedBox();
          },
        ),
      );

      final viewerState = tester.state<CrosswordInteractiveViewerState>(
        find.byType(CrosswordInteractiveViewer),
      );

      expect(viewerState.currentScale, 1.0);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(viewerState.currentScale, 0.8);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(viewerState.currentScale, 0.6);
    });

    testWidgets(
      "pumps a $QuadScope with the viewer's viewport",
      (tester) async {
        late BuildContext buildContext;
        late Quad quad;

        await tester.pumpSubject(
          CrosswordInteractiveViewer(
            zoomLimit: 0.4,
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
        when(() => word.axis).thenReturn(WordAxis.horizontal);
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
                child: const CrosswordBoardView(),
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
                child: const CrosswordBoardView(),
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
          when(() => word.axis).thenReturn(WordAxis.vertical);
          await tester.pumpApp(
            layout: IoLayoutData.large,
            DefaultWordInputController(
              child: BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const CrosswordBoardView(),
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
        when(() => word.axis).thenReturn(WordAxis.horizontal);
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
            zoomLimit: 0.4,
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
            zoomLimit: 0.4,
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
            zoomLimit: 0.4,
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

    group('transformation', () {
      testWidgets('translates when centering section', (tester) async {
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

        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            initialWord: SelectedWord(
              section: (0, 0),
              word: Word(
                id: 'id',
                position: Point(0, 0),
                axis: WordAxis.horizontal,
                clue: 'clue',
                answer: 'answer',
              ),
            ),
          ),
        );

        await tester.pumpSubject(
          wordSelectionBloc: wordSelectionBloc,
          crosswordBloc: crosswordBloc,
          CrosswordInteractiveViewer(
            zoomLimit: 0.4,
            builder: (context, position) {
              return const SizedBox();
            },
          ),
        );

        // Viewport size 520x600.
        // "answer" is 300x50 and is placed in the 0,0 point of the 0,0 chunk.
        final rect = Rect.fromLTWH(_boardPadding, _boardPadding, 300, 50);

        final center = rect.center;

        final interactiveViewerFinder = find.byType(InteractiveViewer);
        expect(
          tester
              .widget<InteractiveViewer>(interactiveViewerFinder)
              .transformationController!
              .value,
          Matrix4.translation(
            Vector3(
                  double.parse((520 / 2).toStringAsFixed(3)),
                  double.parse((600 / 2).toStringAsFixed(3)),
                  0,
                ) -
                Vector3(center.dx, center.dy, 0),
          ),
        );
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    Widget widget, {
    WordSelectionBloc? wordSelectionBloc,
    CrosswordBloc? crosswordBloc,
    CrosswordLayoutData? crosswordLayoutData,
    IoLayoutData? layoutData,
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
          padding: const EdgeInsets.all(_boardPadding),
        );

    return pumpApp(
      layout: layoutData ?? IoLayoutData.large,
      DefaultTransformationController(
        child: BlocProvider<WordSelectionBloc>(
          create: (_) => internalWordSelectionBloc,
          child: CrosswordLayoutScope(
            data: internalCrosswordLayoutData,
            child: widget,
          ),
        ),
      ),
      crosswordBloc: crosswordBloc,
    );
  }
}
