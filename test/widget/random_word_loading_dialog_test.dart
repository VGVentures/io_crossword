// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/random_word_selection/bloc/random_word_selection_bloc.dart';
import 'package:io_crossword/widget/widget.dart';
import 'package:mockingjay/mockingjay.dart';

import '../helpers/helpers.dart';

class _MockRandomWordSelectionBloc
    extends MockBloc<RandomWordSelectionEvent, RandomWordSelectionState>
    implements RandomWordSelectionBloc {}

void main() {
  group('RandomWordLoadingDialog', () {
    late RandomWordSelectionBloc randomWordSelectionBloc;
    late MockNavigator mockNavigator;

    setUp(() {
      mockNavigator = MockNavigator();
      when(mockNavigator.canPop).thenReturn(true);

      randomWordSelectionBloc = _MockRandomWordSelectionBloc();
      when(() => randomWordSelectionBloc.state).thenReturn(
        RandomWordSelectionState(),
      );
    });

    testWidgets(
      'displays RandomWordLoadingDialog when openDialog is called',
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
      RandomWordSelectionStatus.failure,
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
  });
}
