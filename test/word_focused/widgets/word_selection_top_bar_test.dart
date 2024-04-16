// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _FakeWord extends Fake implements Word {
  @override
  String get id => 'wordId';
}

void main() {
  group('$WordSelectionTopBar', () {
    late Widget widget;
    late WordSelectionBloc wordSelectionBloc;

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(
          word: SelectedWord(section: (0, 0), word: _FakeWord()),
          status: WordSelectionStatus.preSolving,
        ),
      );

      widget = BlocProvider(
        create: (context) => wordSelectionBloc,
        child: const WordSelectionTopBar(),
      );
    });

    group('renders', () {
      testWidgets('the word identifier', (tester) async {
        await tester.pumpApp(widget);

        expect(find.text('wordId'), findsOneWidget);
      });

      testWidgets('a $CloseWordSelectionIconButton', (tester) async {
        await tester.pumpApp(widget);
        expect(find.byType(CloseWordSelectionIconButton), findsOneWidget);
      });
    });
  });
}
