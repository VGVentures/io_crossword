// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHintBloc extends MockBloc<HintEvent, HintState>
    implements HintBloc {}

void main() {
  group('$GeminiHintButton', () {
    late AppLocalizations l10n;
    late HintBloc hintBloc;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      hintBloc = _MockHintBloc();
      when(() => hintBloc.state).thenReturn(const HintState());
    });

    testWidgets('displays hint text', (tester) async {
      await tester.pumpApp(GeminiHintButton());

      expect(find.text(l10n.hint), findsOneWidget);
    });

    testWidgets('displays gemini icon', (tester) async {
      await tester.pumpApp(GeminiHintButton());

      expect(find.byIcon(IoIcons.gemini), findsOneWidget);
    });

    testWidgets(
      'emits HintModeEntered when tapped if there are hints left',
      (tester) async {
        when(() => hintBloc.state).thenReturn(
          HintState(hints: [], maxHints: 3),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: hintBloc,
            child: GeminiHintButton(),
          ),
        );

        await tester.tap(find.byType(GeminiHintButton));

        verify(() => hintBloc.add(const HintModeEntered())).called(1);
      },
    );

    testWidgets(
      'is disabled when there are no hints left',
      (tester) async {
        final hint = Hint(question: 'is it orange?', response: HintResponse.no);
        when(() => hintBloc.state).thenReturn(
          HintState(hints: [hint, hint, hint], maxHints: 3),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: hintBloc,
            child: GeminiHintButton(),
          ),
        );
        await tester.tap(find.byType(GeminiHintButton));

        verifyNever(() => hintBloc.add(const HintModeEntered()));
      },
    );
  });
}
