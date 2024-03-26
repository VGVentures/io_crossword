// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockGameIntroBloc extends MockBloc<GameIntroEvent, GameIntroState>
    implements GameIntroBloc {}

void main() {
  group('InitialsInputView', () {
    late GameIntroBloc bloc;
    late Widget child;

    setUp(() {
      bloc = _MockGameIntroBloc();

      child = BlocProvider.value(
        value: bloc,
        child: Material(child: InitialsInputView()),
      );
    });

    testWidgets(
      'renders InitialsFormView',
      (tester) async {
        when(() => bloc.state).thenReturn(GameIntroState());
        await tester.pumpApp(child);

        expect(find.byType(InitialsFormView), findsOneWidget);
      },
    );

    testWidgets(
      'adds InitialsSubmitted event when tapping button',
      (tester) async {
        when(() => bloc.state).thenReturn(GameIntroState());
        await tester.pumpApp(child);

        await tester.tap(find.byType(PrimaryButton));

        verify(() => bloc.add(InitialsSubmitted())).called(1);
      },
    );
  });
}
