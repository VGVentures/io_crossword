// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/bottom_bar/view/bottom_bar.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _FakeWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => null;

  @override
  String get id => 'id';

  @override
  String get clue => 'clue';

  @override
  String get answer => 'answer';
}

void main() {
  group('BottomBar', () {
    late CrosswordBloc crosswordBloc;
    late Widget widget;

    final selectedWord = WordSelection(section: (0, 0), word: _FakeWord());

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();

      widget = BlocProvider.value(
        value: crosswordBloc,
        child: BottomBar(),
      );
    });

    testWidgets(
      'renders SizedBox.shrink when selectedWord is not null',
      (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          CrosswordLoaded(
            sectionSize: 20,
            selectedWord: selectedWord,
          ),
        );

        await tester.pumpApp(widget);

        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(BottomBarContent), findsNothing);
      },
    );

    testWidgets(
      'renders BottomBarContent when selectedWord is null',
      (tester) async {
        when(() => crosswordBloc.state)
            .thenReturn(CrosswordLoaded(sectionSize: 20));

        await tester.pumpApp(widget);

        expect(find.byType(BottomBarContent), findsOneWidget);
      },
    );
  });
}
