// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/random_word_selection/random_word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockRandomWordSelectionBloc
    extends MockBloc<RandomWordSelectionEvent, RandomWordSelectionState>
    implements RandomWordSelectionBloc {}

void main() {
  group('$RandomWordLoadingDialog', () {
    late RandomWordSelectionBloc randomWordSelectionBloc;
    late MockNavigator mockNavigator;
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      mockNavigator = MockNavigator();
      when(mockNavigator.canPop).thenReturn(true);

      randomWordSelectionBloc = _MockRandomWordSelectionBloc();
      when(() => randomWordSelectionBloc.state).thenReturn(
        RandomWordSelectionState(),
      );
    });

    testWidgets(
      'displays $RandomWordLoadingDialog when openDialog is called',
      (tester) async {
        await tester.pumpApp(
          BlocProvider(
            create: (_) => randomWordSelectionBloc,
            child: Builder(
              builder: (context) {
                return TextButton(
                  onPressed: () {
                    RandomWordLoadingDialog.openDialog(context);
                  },
                  child: Text('display dialog'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('display dialog'));

        await tester.pump();

        expect(find.byType(RandomWordLoadingDialog), findsOneWidget);
      },
    );

    for (final status in [
      RandomWordSelectionStatus.success,
      RandomWordSelectionStatus.notFound,
      RandomWordSelectionStatus.initial,
    ]) {
      testWidgets('pops when status is $status', (tester) async {
        whenListen(
          randomWordSelectionBloc,
          Stream.value(RandomWordSelectionState(status: status)),
          initialState: RandomWordSelectionState(
            status: RandomWordSelectionStatus.loading,
          ),
        );
        await tester.pumpApp(
          BlocProvider(
            create: (_) => randomWordSelectionBloc,
            child: RandomWordLoadingDialog(),
          ),
          navigator: mockNavigator,
        );
        await tester.pump();
        verify(mockNavigator.pop).called(1);
      });
    }

    testWidgets('displays loading message when status is loading',
        (tester) async {
      when(() => randomWordSelectionBloc.state).thenReturn(
        RandomWordSelectionState(
          status: RandomWordSelectionStatus.loading,
        ),
      );
      await tester.pumpApp(
        BlocProvider(
          create: (_) => randomWordSelectionBloc,
          child: RandomWordLoadingDialog(),
        ),
        navigator: mockNavigator,
      );

      expect(find.byType(LoadingView), findsOneWidget);
    });

    testWidgets('displays error message when status is failure',
        (tester) async {
      when(() => randomWordSelectionBloc.state).thenReturn(
        RandomWordSelectionState(
          status: RandomWordSelectionStatus.failure,
        ),
      );
      await tester.pumpApp(
        BlocProvider(
          create: (_) => randomWordSelectionBloc,
          child: RandomWordLoadingDialog(),
        ),
        navigator: mockNavigator,
      );

      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text(l10n.findRandomWordError), findsOneWidget);
    });

    testWidgets('pops when status is failure and close button is tapped',
        (tester) async {
      when(() => randomWordSelectionBloc.state).thenReturn(
        RandomWordSelectionState(
          status: RandomWordSelectionStatus.failure,
        ),
      );
      await tester.pumpApp(
        BlocProvider(
          create: (_) => randomWordSelectionBloc,
          child: RandomWordLoadingDialog(),
        ),
        navigator: mockNavigator,
      );

      await tester.tap(find.text(l10n.close));
      verify(mockNavigator.pop).called(1);
    });
  });
}
