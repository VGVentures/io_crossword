// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/bottom_bar/view/bottom_bar.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

void main() {
  group('$BottomBar', () {
    late WordSelectionBloc wordSelectionBloc;
    late Widget widget;

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
      widget = BlocProvider<WordSelectionBloc>(
        create: (_) => wordSelectionBloc,
        child: BottomBar(),
      );
    });

    testWidgets(
      'renders SizedBox.shrink when status is not empty',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(status: WordSelectionStatus.preSolving),
        );

        await tester.pumpApp(widget);

        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(BottomBarContent), findsNothing);
      },
    );

    testWidgets(
      'renders $BottomBarContent when status is empty',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          const WordSelectionState.initial(),
        );

        await tester.pumpApp(widget);

        expect(find.byType(BottomBarContent), findsOneWidget);
      },
    );
  });
}
