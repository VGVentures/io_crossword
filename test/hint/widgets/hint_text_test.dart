// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHintBloc extends MockBloc<HintEvent, HintState>
    implements HintBloc {}

void main() {
  group('$HintText', () {
    late AppLocalizations l10n;
    late HintBloc hintBloc;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      hintBloc = _MockHintBloc();
    });

    group('renders ask gemini a hint text', () {
      for (final status in [
        HintStatus.initial,
        HintStatus.answered,
      ]) {
        testWidgets(
          'when the status is $status',
          (tester) async {
            when(() => hintBloc.state).thenReturn(HintState(status: status));
            await tester.pumpApp(
              BlocProvider(
                create: (context) => hintBloc,
                child: HintText(),
              ),
            );

            expect(find.text(l10n.askGeminiHint), findsOneWidget);
          },
        );
      }
    });

    group('renders ask yes or no question text', () {
      for (final status in [
        HintStatus.asking,
        HintStatus.thinking,
        HintStatus.invalid,
      ]) {
        testWidgets(
          'when the status is $status',
          (tester) async {
            when(() => hintBloc.state).thenReturn(HintState(status: status));
            await tester.pumpApp(
              BlocProvider(
                create: (context) => hintBloc,
                child: HintText(),
              ),
            );

            expect(find.text(l10n.askYesOrNoQuestion), findsOneWidget);
          },
        );
      }
    });
  });
}
