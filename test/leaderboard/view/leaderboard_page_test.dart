// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:io_crossword/leaderboard/view/leaderboard_page.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockLeaderboardBloc extends MockBloc<LeaderboardEvent, LeaderboardState>
    implements LeaderboardBloc {}

void main() {
  group('LeaderboardPage', () {
    testWidgets(
      'renders LeaderboardView',
      (tester) async {
        await tester.pumpApp(LeaderboardPage());

        expect(find.byType(LeaderboardView), findsOneWidget);
      },
    );
  });

  group('LeaderboardView', () {
    late LeaderboardBloc leaderboardBloc;
    late Widget widget;

    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      leaderboardBloc = _MockLeaderboardBloc();

      widget = BlocProvider<LeaderboardBloc>(
        create: (_) => leaderboardBloc,
        child: LeaderboardView(),
      );
    });

    testWidgets(
      'renders CloseButton',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());

        await tester.pumpApp(widget);

        expect(find.byType(CloseButton), findsOneWidget);
      },
    );

    testWidgets(
      'renders CircularProgressIndicator with ${LeaderboardStatus.initial}',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());

        await tester.pumpApp(widget);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'renders ErrorView with ${LeaderboardStatus.failure}',
      (tester) async {
        when(() => leaderboardBloc.state)
            .thenReturn(LeaderboardState(status: LeaderboardStatus.failure));

        await tester.pumpApp(widget);

        expect(find.byType(ErrorView), findsOneWidget);
        expect(find.text(l10n.errorPromptText), findsOneWidget);
      },
    );

    testWidgets(
      'renders LeaderboardSuccess with ${LeaderboardStatus.success}',
      (tester) async {
        when(() => leaderboardBloc.state)
            .thenReturn(LeaderboardState(status: LeaderboardStatus.success));

        await tester.pumpApp(widget);

        expect(find.byType(LeaderboardSuccess), findsOneWidget);
      },
    );

    testWidgets(
      'does not display playAgain and icon on small screen',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());

        await tester.pumpApp(widget);

        expect(find.text(l10n.playAgain), findsNothing);
        expect(find.byIcon(Icons.gamepad), findsNothing);
      },
    );

    testWidgets(
      'display playAgain and icon on large screen',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());

        await tester.pumpApp(
          widget,
          layout: IoLayoutData.large,
        );

        expect(find.text(l10n.playAgain), findsOneWidget);
        expect(find.byIcon(Icons.gamepad), findsOneWidget);
      },
    );

    testWidgets(
      'pops the screen when playAgain is tapped',
      (tester) async {
        final mockNavigator = MockNavigator();

        when(mockNavigator.canPop).thenReturn(true);

        when(() => leaderboardBloc.state).thenReturn(LeaderboardState());

        await tester.pumpApp(
          widget,
          navigator: mockNavigator,
          layout: IoLayoutData.large,
        );

        await tester.tap(find.text(l10n.playAgain));

        verify(mockNavigator.pop).called(1);
      },
    );
  });
}
