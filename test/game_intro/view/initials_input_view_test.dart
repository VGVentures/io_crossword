import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
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
        child: const InitialsInputView(),
      );
    });

    testWidgets(
      'adds InitialsSubmitted event when tapping button',
      (tester) async {
        when(() => bloc.state).thenReturn(const GameIntroState());
        await tester.pumpApp(child);

        await tester.tap(find.byType(ElevatedButton));

        verify(() => bloc.add(const InitialsSubmitted())).called(1);
      },
    );
  });
}
