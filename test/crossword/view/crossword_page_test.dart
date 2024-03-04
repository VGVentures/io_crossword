// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends Mock implements CrosswordBloc {}

extension on WidgetTester {
  Future<void> pumpCrosswordView(CrosswordBloc bloc) {
    return pumpApp(
      BlocProvider.value(
        value: bloc,
        child: CrosswordView(),
      ),
    );
  }
}

void main() {
  group('CrosswordPage', () {
    late CrosswordBloc bloc;

    setUp(() {
      bloc = _MockCrosswordBloc();

      whenListen(
        bloc,
        Stream.fromIterable(const <CrosswordState>[]),
        initialState: const CrosswordInitial(),
      );
    });

    testWidgets('renders CrosswordView', (tester) async {
      await tester.pumpRoute(CrosswordPage.route());
      await tester.pump();
      expect(find.byType(CrosswordView), findsOneWidget);
    });

    testWidgets('renders loading when is initial', (tester) async {
      when(() => bloc.state).thenReturn(const CrosswordInitial());

      await tester.pumpCrosswordView(bloc);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders loading when is loading', (tester) async {
      when(() => bloc.state).thenReturn(const CrosswordLoading());

      await tester.pumpCrosswordView(bloc);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error when is error', (tester) async {
      when(() => bloc.state).thenReturn(const CrosswordError(''));

      await tester.pumpCrosswordView(bloc);
      expect(find.text('Error loading crossword'), findsOneWidget);
    });

    testWidgets('renders game when is loaded', (tester) async {
      when(() => bloc.state).thenReturn(
        const CrosswordLoaded(
          width: 40,
          height: 40,
          sections: [
            BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  id: '1',
                  axis: Axis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: ['dart', 'mobile', 'cross-platform'],
                  visible: true,
                  solvedTimestamp: null,
                ),
              ],
              borderWords: [],
            ),
          ],
        ),
      );

      await tester.pumpCrosswordView(bloc);
      expect(find.byType(GameWidget<CrosswordGame>), findsOneWidget);
    });
  });
}
