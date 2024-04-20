// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHintBloc extends MockBloc<HintEvent, HintState>
    implements HintBloc {}

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _FakeWord extends Fake implements Word {
  @override
  String get id => 'id';
}

void main() {
  group('$GeminiTextField', () {
    late AppLocalizations l10n;
    late HintBloc hintBloc;
    late WordSelectionBloc wordSelectionBloc;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      hintBloc = _MockHintBloc();
      wordSelectionBloc = _MockWordSelectionBloc();
    });

    testWidgets('displays type hint', (tester) async {
      await tester.pumpApp(GeminiTextField());

      expect(find.text(l10n.type), findsOneWidget);
    });

    testWidgets('displays gemini icon', (tester) async {
      await tester.pumpApp(GeminiTextField());

      expect(find.byIcon(IoIcons.gemini), findsOneWidget);
    });

    testWidgets('displays send icon', (tester) async {
      await tester.pumpApp(GeminiTextField());

      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets(
      'sends HintRequested when tapping the send button',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.solving,
            word: SelectedWord(section: (0, 0), word: _FakeWord()),
          ),
        );
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: hintBloc),
              BlocProvider.value(value: wordSelectionBloc),
            ],
            child: GeminiTextField(),
          ),
        );

        await tester.enterText(find.byType(TextField), 'is it red?');
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.send));

        verify(
          () => hintBloc.add(
            HintRequested(wordId: 'id', question: 'is it red?'),
          ),
        ).called(1);
      },
    );
  });
}
