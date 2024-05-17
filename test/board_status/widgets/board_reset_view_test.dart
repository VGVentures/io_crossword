// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/board_status/board_status.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockBoardStatusBloc extends MockBloc<BoardStatusEvent, BoardStatusState>
    implements BoardStatusBloc {}

void main() {
  group('BoardResetView', () {
    late BoardStatusBloc boardStatusBloc;
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      boardStatusBloc = _MockBoardStatusBloc();

      when(() => boardStatusBloc.state).thenReturn(BoardStatusInitial());
    });

    testWidgets('renders BoardResetView', (tester) async {
      await tester.pumpSubject(
        BoardResetView(onResume: () {}),
        boardStatusBloc: boardStatusBloc,
      );

      expect(find.byType(BoardResetView), findsOneWidget);
    });

    testWidgets('exit button opens EndGameCheck dialog when pressed',
        (tester) async {
      when(() => boardStatusBloc.state)
          .thenReturn(BoardStatusResetInProgress());

      await tester.pumpSubject(
        BoardResetView(onResume: () {}),
        boardStatusBloc: boardStatusBloc,
      );

      await tester.tap(find.text(l10n.exitButtonLabel));
      await tester.pump();

      expect(find.byType(EndGameCheck), findsOneWidget);
    });

    testWidgets(
        'keep playing button does nothing when pressed when '
        'state is BoardStatusResetInProgress', (tester) async {
      when(() => boardStatusBloc.state)
          .thenReturn(BoardStatusResetInProgress());

      final completer = Completer<void>();

      await tester.pumpSubject(
        BoardResetView(onResume: completer.complete),
        boardStatusBloc: boardStatusBloc,
      );

      await tester.tap(find.text(l10n.keepPlayingButtonLabel));
      await tester.pump();

      expect(completer.isCompleted, isFalse);
    });

    testWidgets(
        'keep playing button calls onResume callback when '
        'state is BoardStatusInProgress', (tester) async {
      when(() => boardStatusBloc.state).thenReturn(BoardStatusInProgress());

      final completer = Completer<void>();

      await tester.pumpSubject(
        BoardResetView(onResume: completer.complete),
        boardStatusBloc: boardStatusBloc,
      );

      await tester.tap(find.text(l10n.keepPlayingButtonLabel));
      await tester.pumpAndSettle();

      expect(completer.isCompleted, isTrue);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    Widget child, {
    required BoardStatusBloc boardStatusBloc,
  }) {
    return pumpApp(
      BlocProvider(
        create: (_) => boardStatusBloc,
        child: child,
      ),
    );
  }
}
