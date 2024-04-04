// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockGameIntroBloc extends MockBloc<GameIntroEvent, GameIntroState>
    implements GameIntroBloc {}

void main() {
  group('WelcomeView', () {
    late GameIntroBloc bloc;
    late Widget child;

    setUp(() {
      bloc = _MockGameIntroBloc();

      child = BlocProvider.value(
        value: bloc,
        child: const IoCrosswordCard(child: WelcomeView()),
      );
    });

    testWidgets(
      'renders the record progress',
      (tester) async {
        when(() => bloc.state).thenReturn(const GameIntroState());
        await tester.pumpApp(child);

        expect(find.byType(RecordProgress), findsOneWidget);
      },
    );

    testWidgets(
      'adds WelcomeCompleted event when tapping button',
      (tester) async {
        when(() => bloc.state).thenReturn(const GameIntroState());
        await tester.pumpApp(child);

        await tester.tap(find.byType(PrimaryButton));

        verify(() => bloc.add(const WelcomeCompleted())).called(1);
      },
    );
  });

  group('RecordProgress', () {
    late GameIntroBloc bloc;
    late Widget child;

    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      bloc = _MockGameIntroBloc();

      child = BlocProvider.value(
        value: bloc,
        child: RecordProgress(),
      );
    });

    testWidgets(
      'renders IoLinearProgressIndicator',
      (tester) async {
        when(() => bloc.state).thenReturn(const GameIntroState());

        await tester.pumpApp(child);

        expect(find.byType(IoLinearProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'renders IoLinearProgressIndicator value 0 with initial state',
      (tester) async {
        when(() => bloc.state).thenReturn(GameIntroState());

        await tester.pumpApp(child);

        expect(
          tester
              .widget<IoLinearProgressIndicator>(
                  find.byType(IoLinearProgressIndicator))
              .value,
          equals(0),
        );
      },
    );

    testWidgets(
      'renders IoLinearProgressIndicator value 0.5 when the solved words are '
      'the half of the total words',
      (tester) async {
        when(() => bloc.state).thenReturn(
          GameIntroState(
            solvedWords: 20,
            totalWords: 40,
          ),
        );

        await tester.pumpApp(child);

        expect(
          tester
              .widget<IoLinearProgressIndicator>(
                  find.byType(IoLinearProgressIndicator))
              .value,
          equals(0.5),
        );
      },
    );

    testWidgets(
      'displays wordsToBreakRecord',
      (tester) async {
        when(() => bloc.state).thenReturn(GameIntroState());

        await tester.pumpApp(child);

        expect(find.text(l10n.wordsToBreakRecord), findsOneWidget);
      },
    );

    testWidgets(
      'displays words solved and total words',
      (tester) async {
        when(() => bloc.state).thenReturn(
          GameIntroState(
            solvedWords: 10,
            totalWords: 50,
          ),
        );

        await tester.pumpApp(child);

        expect(find.text('10 / 50'), findsOneWidget);
      },
    );
  });
}
