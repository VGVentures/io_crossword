// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHintBloc extends MockBloc<HintEvent, HintState>
    implements HintBloc {}

void main() {
  late AppLocalizations l10n;
  late HintBloc hintBloc;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(Locale('en'));
  });

  setUp(() {
    hintBloc = _MockHintBloc();
  });

  group('$HintsTitle', () {
    late Widget widget;

    setUp(() {
      widget = BlocProvider(
        create: (context) => hintBloc,
        child: HintsTitle(),
      );
    });

    testWidgets(
      'renders "ask gemini a hint" when the hint mode is not active',
      (tester) async {
        when(() => hintBloc.state).thenReturn(
          HintState(status: HintStatus.initial),
        );
        await tester.pumpApp(widget);

        expect(find.text(l10n.askGeminiHint), findsOneWidget);
      },
    );

    testWidgets(
      'renders "run out of hints" when there are no more hints available',
      (tester) async {
        final hint = Hint(question: 'Q1', response: HintResponse.yes);
        when(() => hintBloc.state).thenReturn(
          HintState(
            status: HintStatus.asking,
            hints: [hint, hint, hint],
            maxHints: 3,
          ),
        );
        await tester.pumpApp(widget);

        expect(find.text(l10n.runOutOfHints), findsOneWidget);
      },
    );

    testWidgets(
      'renders "ask yes or no question" when the hint mode is active',
      (tester) async {
        when(() => hintBloc.state).thenReturn(
          HintState(status: HintStatus.asking),
        );
        await tester.pumpApp(widget);

        expect(find.text(l10n.askYesOrNoQuestion), findsOneWidget);
      },
    );

    testWidgets(
      'renders "1 of 2 hints remaining" when the hint mode is active '
      'and there are hints available',
      (tester) async {
        final hint = Hint(question: 'Q1', response: HintResponse.yes);
        when(() => hintBloc.state).thenReturn(
          HintState(
            status: HintStatus.asking,
            hints: [hint, hint],
            maxHints: 3,
          ),
        );
        await tester.pumpApp(widget);

        expect(find.text(l10n.hintsRemaining(1, 3)), findsOneWidget);
      },
    );
  });

  group('$HintsSection', () {
    late Widget widget;

    setUp(() {
      widget = BlocProvider(
        create: (context) => hintBloc,
        child: HintsSection(),
      );
    });

    testWidgets(
      'renders a SizedBox when hints are not enabled',
      (tester) async {
        when(() => hintBloc.state).thenReturn(
          HintState(isHintsEnabled: false),
        );
        await tester.pumpApp(widget);

        expect(find.byType(SizedBox), findsOneWidget);
      },
    );

    testWidgets(
      'renders as many $HintQuestionResponse widgets as hints are available',
      (tester) async {
        final hints = [
          Hint(question: 'Q1', response: HintResponse.yes),
          Hint(question: 'Q2', response: HintResponse.no),
          Hint(question: 'Q3', response: HintResponse.notApplicable),
          Hint(question: 'Q4', response: HintResponse.no),
        ];
        when(() => hintBloc.state).thenReturn(
          HintState(hints: hints, isHintsEnabled: true),
        );
        await tester.pumpApp(widget);

        expect(find.byType(HintQuestionResponse), findsNWidgets(hints.length));
      },
    );

    testWidgets(
      'renders a hint loading indicator when the hint status is thinking',
      (tester) async {
        when(() => hintBloc.state).thenReturn(
          HintState(status: HintStatus.thinking, isHintsEnabled: true),
        );
        await tester.pumpApp(widget);

        expect(find.byType(HintLoadingIndicator), findsOneWidget);
      },
    );
  });
}
