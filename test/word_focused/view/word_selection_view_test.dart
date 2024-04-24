// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockHintBloc extends MockBloc<HintEvent, HintState>
    implements HintBloc {}

class _FakeWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => null;

  @override
  String get id => 'id';

  @override
  String get clue => 'clue';

  @override
  String? get answer => 'ant';

  @override
  int get length => 3;

  @override
  Axis get axis => Axis.horizontal;
}

void main() {
  group('$WordSelectionView', () {
    group('renders', () {
      late HintBloc hintBloc;
      late WordSelectionBloc wordSelectionBloc;
      late SelectedWord selectedWord;

      setUp(() {
        hintBloc = _MockHintBloc();
        wordSelectionBloc = _MockWordSelectionBloc();
        selectedWord = SelectedWord(section: (0, 0), word: _FakeWord());
      });

      testWidgets(
        '$WordSelectionLargeContainer when layout is large',
        (tester) async {
          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
              word: selectedWord,
            ),
          );

          await tester.pumpApp(
            layout: IoLayoutData.large,
            BlocProvider(
              create: (_) => wordSelectionBloc,
              child: WordSelectionView(),
            ),
          );

          expect(find.byType(WordSelectionLargeContainer), findsOneWidget);
        },
      );

      testWidgets(
        '$WordSelectionSmallContainer when layout is small',
        (tester) async {
          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
              word: selectedWord,
            ),
          );

          await tester.pumpApp(
            layout: IoLayoutData.small,
            BlocProvider(
              create: (_) => wordSelectionBloc,
              child: WordSelectionView(),
            ),
          );

          expect(find.byType(WordSelectionSmallContainer), findsOneWidget);
        },
      );

      testWidgets('$WordPreSolvingView when status is preSolving',
          (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.preSolving,
            word: selectedWord,
          ),
        );

        await tester.pumpApp(
          BlocProvider(
            create: (_) => wordSelectionBloc,
            child: WordSelectionView(),
          ),
        );

        expect(find.byType(WordPreSolvingView), findsOneWidget);
      });

      testWidgets('$WordSolvingView when status is solving', (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.solving,
            word: selectedWord,
          ),
        );
        when(() => hintBloc.state).thenReturn(HintState());

        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => wordSelectionBloc),
              BlocProvider(create: (context) => hintBloc),
            ],
            child: WordSelectionView(),
          ),
        );

        expect(find.byType(WordSolvingView), findsOneWidget);
      });

      testWidgets('$WordSuccessView when status is solved', (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.solved,
            word: selectedWord,
            wordPoints: 10,
          ),
        );

        await tester.pumpApp(
          BlocProvider(
            create: (_) => wordSelectionBloc,
            child: WordSelectionView(),
          ),
        );

        expect(find.byType(WordSuccessView), findsOneWidget);
      });
    });
  });
}
