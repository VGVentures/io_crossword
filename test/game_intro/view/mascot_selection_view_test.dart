// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockGameIntroBloc extends MockBloc<GameIntroEvent, GameIntroState>
    implements GameIntroBloc {}

void main() {
  group('MascotSelectionView', () {
    late GameIntroBloc bloc;
    late Widget child;

    setUp(() {
      bloc = _MockGameIntroBloc();

      child = BlocProvider.value(
        value: bloc,
        child: Material(child: MascotSelectionView()),
      );
    });

    testWidgets(
      'adds MascotSubmitted event when tapping button and a mascot is selected',
      (tester) async {
        when(() => bloc.state).thenReturn(
          GameIntroState(
            status: GameIntroStatus.mascotSelection,
            selectedMascot: Mascots.dash,
          ),
        );
        await tester.pumpApp(child);

        await tester.tap(find.byType(PrimaryButton));

        verify(() => bloc.add(MascotSubmitted())).called(1);
      },
    );

    testWidgets(
      'renders 4 mascot items',
      (tester) async {
        when(() => bloc.state).thenReturn(GameIntroState());
        await tester.pumpApp(child);

        expect(find.byType(MascotItem), findsNWidgets(4));
      },
    );

    testWidgets('renders $IoAppBar', (tester) async {
      when(() => bloc.state).thenReturn(GameIntroState());

      await tester.pumpApp(child);

      expect(find.byType(IoAppBar), findsOneWidget);
    });

    testWidgets(
      'emits MascotUpdated when tapping a mascot item',
      (tester) async {
        when(() => bloc.state).thenReturn(GameIntroState());
        await tester.pumpApp(child);

        final dashMascotItem = find.byWidgetPredicate(
          (widget) => widget is MascotItem && widget.mascot == Mascots.sparky,
        );
        await tester.tap(dashMascotItem);

        verify(() => bloc.add(MascotUpdated(Mascots.sparky))).called(1);
      },
    );
  });
}
