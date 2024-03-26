// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword/view/word_focused_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _FakeWord extends Fake implements Word {
  @override
  String get id => 'id';

  @override
  String get clue => 'clue';

  @override
  Axis get axis => Axis.horizontal;
}

void main() {
  group('WordFocusedView', () {
    late CrosswordBloc crosswordBloc;
    late Widget widget;

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();

      widget = Scaffold(
        body: BlocProvider.value(
          value: crosswordBloc,
          child: WordFocusedView(),
        ),
      );
    });

    testWidgets(
      'renders an empty SizedBox when the selected word is null',
      (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          CrosswordLoaded(
            sectionSize: 20,
            selectedWord: null,
          ),
        );
        await tester.pumpApp(widget);

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));

        expect(find.byType(SizedBox), findsOneWidget);
        expect(sizedBox.child, isNull);
      },
    );

    testWidgets(
      'renders a WordFocusedDesktopView when the selected word is not null',
      (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          CrosswordLoaded(
            sectionSize: 20,
            selectedWord: WordSelection(section: (0, 0), word: _FakeWord()),
          ),
        );
        await tester.pumpApp(widget);

        expect(find.byType(WordFocusedDesktopView), findsOneWidget);
      },
    );
  });

  group('WordFocusedDesktopView', () {
    late CrosswordBloc crosswordBloc;
    late Widget widget;

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();

      widget = Scaffold(
        body: BlocProvider.value(
          value: crosswordBloc,
          child: WordFocusedDesktopView(
            WordSelection(section: (0, 0), word: _FakeWord()),
          ),
        ),
      );
    });

    testWidgets(
      'renders the clue text',
      (tester) async {
        await tester.pumpApp(widget);

        final clueText = _FakeWord().clue;
        expect(find.text(clueText), findsOneWidget);
      },
    );

    testWidgets(
      'tapping the close button sends WordUnselected event',
      (tester) async {
        await tester.pumpApp(widget);

        final closeButton = find.byIcon(Icons.cancel);
        await tester.tap(closeButton);

        verify(() => crosswordBloc.add(const WordUnselected())).called(1);
      },
    );
  });
}
