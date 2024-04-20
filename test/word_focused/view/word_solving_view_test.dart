// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockWordSolvingBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockHintBloc extends MockBloc<HintEvent, HintState>
    implements HintBloc {}

class _FakeWord extends Fake implements Word {
  @override
  String get id => 'id';

  @override
  String get clue => 'clue';

  @override
  Axis get axis => Axis.horizontal;

  @override
  int? get solvedTimestamp => null;

  @override
  int get length => 6;
}

void main() {
  late AppLocalizations l10n;
  late SelectedWord selectedWord;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(Locale('en'));
  });

  setUp(() {
    selectedWord = SelectedWord(section: (0, 0), word: _FakeWord());
  });

  group('$WordSolvingView', () {
    late WordSelectionBloc wordSolvingBloc;
    late HintBloc hintBloc;
    late Widget widget;

    setUp(() {
      wordSolvingBloc = _MockWordSolvingBloc();
      when(() => wordSolvingBloc.state).thenReturn(
        WordSelectionState(
          status: WordSelectionStatus.solving,
          word: selectedWord,
          wordPoints: null,
        ),
      );
      hintBloc = _MockHintBloc();
      when(() => hintBloc.state).thenReturn(HintState());

      widget = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: wordSolvingBloc),
          BlocProvider.value(value: hintBloc),
        ],
        child: WordSolvingView(),
      );
    });

    group('renders', () {
      testWidgets(
        'a $WordSolvingLargeView when layout is large',
        (tester) async {
          await tester.pumpApp(
            layout: IoLayoutData.large,
            widget,
          );

          expect(find.byType(WordSolvingLargeView), findsOneWidget);
          expect(find.byType(WordSolvingSmallView), findsNothing);
        },
      );

      testWidgets(
        'a $WordSolvingSmallView when layout is small',
        (tester) async {
          await tester.pumpApp(
            layout: IoLayoutData.small,
            widget,
          );

          expect(find.byType(WordSolvingSmallView), findsOneWidget);
          expect(find.byType(WordSolvingLargeView), findsNothing);
        },
      );
    });
  });

  group('$WordSolvingLargeView', () {
    late WordSelectionBloc wordSelectionBloc;
    late HintBloc hintBloc;
    late Widget widget;

    setUp(() {
      wordSelectionBloc = _MockWordSolvingBloc();
      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(
          status: WordSelectionStatus.solving,
          word: selectedWord,
        ),
      );
      hintBloc = _MockHintBloc();
      when(() => hintBloc.state).thenReturn(HintState());

      widget = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: wordSelectionBloc),
          BlocProvider.value(value: hintBloc),
        ],
        child: WordSolvingLargeView(),
      );
    });

    group('renders', () {
      testWidgets(
        'the clue text',
        (tester) async {
          await tester.pumpApp(widget);
          expect(find.text(selectedWord.word.clue), findsOneWidget);
        },
      );

      testWidgets(
        'a $WordSelectionTopBar',
        (tester) async {
          await tester.pumpApp(widget);
          expect(find.byType(WordSelectionTopBar), findsOneWidget);
        },
      );

      testWidgets(
        'a $WordValidatingLoadingIndicator',
        (tester) async {
          await tester.pumpApp(widget);
          expect(find.byType(WordValidatingLoadingIndicator), findsOneWidget);
        },
      );

      testWidgets(
        'a $HintText',
        (tester) async {
          await tester.pumpApp(widget);
          expect(find.byType(HintText), findsOneWidget);
        },
      );

      testWidgets(
        'a $BottomPanel',
        (tester) async {
          await tester.pumpApp(widget);
          expect(find.byType(BottomPanel), findsOneWidget);
        },
      );
    });
  });

  group('$WordSolvingSmallView', () {
    late WordSelectionBloc wordSelectionBloc;
    late HintBloc hintBloc;
    late Widget widget;

    setUp(() {
      wordSelectionBloc = _MockWordSolvingBloc();
      hintBloc = _MockHintBloc();

      widget = Theme(
        data: IoCrosswordTheme().themeData,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: wordSelectionBloc),
            BlocProvider.value(value: hintBloc),
          ],
          child: WordSolvingSmallView(),
        ),
      );

      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(
          status: WordSelectionStatus.solving,
          word: selectedWord,
        ),
      );
      when(() => hintBloc.state).thenReturn(HintState());
    });

    group('renders', () {
      testWidgets(
        'the clue text',
        (tester) async {
          await tester.pumpApp(widget);
          expect(find.text(selectedWord.word.clue), findsOneWidget);
        },
      );

      testWidgets(
        'a $WordSelectionTopBar',
        (tester) async {
          await tester.pumpApp(widget);
          expect(find.byType(WordSelectionTopBar), findsOneWidget);
        },
      );

      testWidgets(
        'a $WordValidatingLoadingIndicator',
        (tester) async {
          await tester.pumpApp(widget);
          expect(find.byType(WordValidatingLoadingIndicator), findsOneWidget);
        },
      );

      testWidgets(
        'a $HintText',
        (tester) async {
          await tester.pumpApp(widget);
          expect(find.byType(HintText), findsOneWidget);
        },
      );

      testWidgets(
        'a $BottomPanel',
        (tester) async {
          await tester.pumpApp(widget);
          expect(find.byType(BottomPanel), findsOneWidget);
        },
      );
    });

    testWidgets(
      'tap the submit button sends $WordSolveAttempted',
      (tester) async {
        await tester.pumpApp(widget);

        final editableTexts = find.byType(EditableText);
        await tester.enterText(editableTexts.at(0), 'A');
        await tester.pumpAndSettle();
        await tester.enterText(editableTexts.at(1), 'N');
        await tester.pumpAndSettle();
        await tester.enterText(editableTexts.at(2), 'S');
        await tester.pumpAndSettle();
        await tester.enterText(editableTexts.at(3), 'W');
        await tester.pumpAndSettle();
        await tester.enterText(editableTexts.at(4), 'E');
        await tester.pumpAndSettle();
        await tester.enterText(editableTexts.at(5), 'R');
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.submit));
        await tester.pumpAndSettle();

        verify(
          () => wordSelectionBloc.add(
            const WordSolveAttempted(answer: 'ANSWER'),
          ),
        ).called(1);
      },
    );
  });

  group('$WordValidatingLoadingIndicator', () {
    late WordSelectionBloc wordSelectionBloc;
    late Widget widget;

    setUp(() {
      wordSelectionBloc = _MockWordSolvingBloc();

      widget = BlocProvider.value(
        value: wordSelectionBloc,
        child: WordValidatingLoadingIndicator(),
      );
    });

    testWidgets(
      'renders a circular progress indicator when the status is validating',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.validating,
            word: selectedWord,
          ),
        );
        await tester.pumpApp(widget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'dos not render a circular progress indicator '
      'when the status is other than validating',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.solving,
            word: selectedWord,
          ),
        );
        await tester.pumpApp(widget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );
  });

  group('$BottomPanel', () {
    late WordSelectionBloc wordSelectionBloc;
    late HintBloc hintBloc;
    late Widget widget;

    setUp(() {
      wordSelectionBloc = _MockWordSolvingBloc();
      hintBloc = _MockHintBloc();

      widget = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: wordSelectionBloc),
          BlocProvider.value(value: hintBloc),
        ],
        child: BottomPanel(),
      );

      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(
          status: WordSelectionStatus.solving,
          word: selectedWord,
        ),
      );
      when(() => hintBloc.state).thenReturn(HintState());
    });

    group('renders', () {
      testWidgets(
        'a $CloseHintButton and $GeminiTextField when the status is asking',
        (tester) async {
          when(() => hintBloc.state).thenReturn(
            HintState(status: HintStatus.asking),
          );

          await tester.pumpApp(widget);

          expect(find.byType(CloseHintButton), findsOneWidget);
          expect(find.byType(GeminiTextField), findsOneWidget);
        },
      );

      testWidgets(
        'a $GeminiHintButton and $SubmitButton when the status is answered',
        (tester) async {
          when(() => hintBloc.state).thenReturn(
            HintState(status: HintStatus.answered),
          );

          await tester.pumpApp(widget);

          expect(find.byType(GeminiHintButton), findsOneWidget);
          expect(find.byType(SubmitButton), findsOneWidget);
        },
      );
    });
  });

  group('$SubmitButton', () {
    late WordSelectionBloc wordSelectionBloc;
    late Widget widget;

    setUp(() {
      wordSelectionBloc = _MockWordSolvingBloc();

      widget = BlocProvider.value(
        value: wordSelectionBloc,
        child: SubmitButton(),
      );
    });

    testWidgets(
      'onPressed is not null when the status is other than validating',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.solving,
          ),
        );

        await tester.pumpApp(widget);
        final submitButton =
            tester.widget<OutlinedButton>(find.byType(OutlinedButton));

        expect(submitButton.onPressed, isNotNull);
      },
    );

    testWidgets(
      'onPressed is null when the status is validating',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.validating,
          ),
        );

        await tester.pumpApp(widget);
        final submitButton =
            tester.widget<OutlinedButton>(find.byType(OutlinedButton));

        expect(submitButton.onPressed, isNull);
      },
    );
  });
}
