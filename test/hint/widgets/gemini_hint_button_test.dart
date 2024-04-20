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
  group('$GeminiHintButton', () {
    late AppLocalizations l10n;
    late HintBloc hintBloc;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      hintBloc = _MockHintBloc();
    });

    testWidgets('displays hint text', (tester) async {
      await tester.pumpApp(GeminiHintButton());

      expect(find.text(l10n.hint), findsOneWidget);
    });

    testWidgets('displays gemini icon', (tester) async {
      await tester.pumpApp(GeminiHintButton());

      expect(find.byIcon(IoIcons.gemini), findsOneWidget);
    });

    testWidgets('emits HintModeEntered when tapped', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: hintBloc,
          child: GeminiHintButton(),
        ),
      );

      await tester.tap(find.byType(GeminiHintButton));

      verify(() => hintBloc.add(const HintModeEntered())).called(1);
    });
  });
}
