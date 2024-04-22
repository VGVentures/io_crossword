import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' hide Axis;
import 'package:game_domain/game_domain.dart' as domain show Axis;
import 'package:io_crossword/crossword/bloc/crossword_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockWord extends Mock implements Word {}

void main() {
  group('$Crossword2View', () {
    late WordSelectionBloc wordSelectionBloc;

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
      when(() => wordSelectionBloc.state)
          .thenReturn(const WordSelectionState.initial());
    });

    testWidgets('requests chunk', (tester) async {
      final crosswordBloc = _MockCrosswordBloc();
      when(() => crosswordBloc.state).thenReturn(const CrosswordState());

      await tester.pumpApp(
        crosswordBloc: crosswordBloc,
        BlocProvider<WordSelectionBloc>(
          create: (_) => wordSelectionBloc,
          child: const Crossword2View(),
        ),
      );

      verify(() => crosswordBloc.add(const BoardSectionRequested((0, 0))))
          .called(1);
    });

    testWidgets('pumps successfully', (tester) async {
      await tester.pumpApp(
        BlocProvider<WordSelectionBloc>(
          create: (_) => wordSelectionBloc,
          child: const Crossword2View(),
        ),
      );

      expect(find.byType(Crossword2View), findsOneWidget);
    });

    group('$IoWordInput', () {
      late Word word;

      setUp(() {
        word = _MockWord();
        when(() => word.length).thenReturn(5);
        when(() => word.axis).thenReturn(domain.Axis.horizontal);
        when(() => word.position).thenReturn(const Point(0, 0));
        when(() => word.id).thenReturn('id');
      });

      group('shown', () {
        testWidgets(
          'horizontally when an horizontal word is to be solved',
          (tester) async {
            when(() => wordSelectionBloc.state).thenReturn(
              WordSelectionState(
                status: WordSelectionStatus.preSolving,
                word: SelectedWord(
                  section: (0, 0),
                  word: word,
                ),
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.large,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            );

            final wordInputFinder = find.byType(IoWordInput);
            expect(wordInputFinder, findsOneWidget);

            final wordInput = tester.widget<IoWordInput>(wordInputFinder);
            expect(wordInput.direction, equals(Axis.horizontal));
          },
        );

        testWidgets(
          'vertically when a vertical word is to be solved',
          (tester) async {
            when(() => wordSelectionBloc.state).thenReturn(
              WordSelectionState(
                status: WordSelectionStatus.preSolving,
                word: SelectedWord(
                  section: (0, 0),
                  word: word,
                ),
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.large,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            );

            final wordInputFinder = find.byType(IoWordInput);
            expect(wordInputFinder, findsOneWidget);

            final wordInput = tester.widget<IoWordInput>(wordInputFinder);
            expect(wordInput.direction, equals(Axis.horizontal));
          },
        );

        testWidgets(
          'horizontally when a word is to be solved',
          (tester) async {
            when(() => word.axis).thenReturn(domain.Axis.vertical);
            when(() => wordSelectionBloc.state).thenReturn(
              WordSelectionState(
                status: WordSelectionStatus.preSolving,
                word: SelectedWord(
                  section: (0, 0),
                  word: word,
                ),
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.large,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            );

            final wordInputFinder = find.byType(IoWordInput);
            expect(wordInputFinder, findsOneWidget);

            final wordInput = tester.widget<IoWordInput>(wordInputFinder);
            expect(wordInput.direction, equals(Axis.vertical));
          },
        );
      });

      group('not shown', () {
        testWidgets(
          'when word is not solved with a small layout',
          (tester) async {
            when(() => wordSelectionBloc.state).thenReturn(
              WordSelectionState(
                status: WordSelectionStatus.preSolving,
                word: SelectedWord(
                  section: (0, 0),
                  word: word,
                ),
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.small,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            );

            expect(find.byType(IoWordInput), findsNothing);
          },
        );

        testWidgets(
          'when word is solved',
          (tester) async {
            when(() => word.solvedTimestamp).thenReturn(1);
            when(() => wordSelectionBloc.state).thenReturn(
              WordSelectionState(
                status: WordSelectionStatus.preSolving,
                word: SelectedWord(
                  section: (0, 0),
                  word: word,
                ),
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.large,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            );

            expect(find.byType(IoWordInput), findsNothing);
          },
        );

        testWidgets(
          'when there is no selected word',
          (tester) async {
            when(() => wordSelectionBloc.state).thenReturn(
              const WordSelectionState(
                status: WordSelectionStatus.empty,
                // ignore: avoid_redundant_argument_values
                word: null,
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.large,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            );

            expect(find.byType(IoWordInput), findsNothing);
          },
        );
      });
    });
  });
}
