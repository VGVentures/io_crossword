// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

void main() {
  group('TopBar', () {
    late Widget widget;
    late CrosswordBloc crosswordBloc;

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();
      widget = BlocProvider(
        create: (context) => crosswordBloc,
        child: TopBar(wordId: 'wordId'),
      );
    });

    testWidgets('renders the word id', (tester) async {
      await tester.pumpApp(widget);

      expect(find.text('wordId'), findsOneWidget);
    });

    testWidgets(
      'tapping the cancel button dispatches the WordUnselected event',
      (tester) async {
        await tester.pumpApp(widget);

        await tester.tap(find.byIcon(Icons.cancel));

        verify(() => crosswordBloc.add(const WordUnselected())).called(1);
      },
    );
  });
}
