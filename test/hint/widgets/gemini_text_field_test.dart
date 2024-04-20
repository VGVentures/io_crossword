// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHintBloc extends MockBloc<HintEvent, HintState>
    implements HintBloc {}

void main() {
  group('$GeminiTextField', () {
    late AppLocalizations l10n;
    late HintBloc hintBloc;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      hintBloc = _MockHintBloc();
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
        await tester.pumpApp(
          BlocProvider.value(
            value: hintBloc,
            child: GeminiTextField(),
          ),
        );

        await tester.tap(find.byIcon(Icons.send));

        verify(() => hintBloc.add(const HintRequested('is it red?'))).called(1);
      },
    );
  });
}
