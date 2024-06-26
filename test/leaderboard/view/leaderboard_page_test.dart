// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:io_crossword/leaderboard/view/leaderboard_page.dart';
import 'package:io_crossword/player/bloc/player_bloc.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockLeaderboardBloc extends MockBloc<LeaderboardEvent, LeaderboardState>
    implements LeaderboardBloc {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

void main() {
  group('LeaderboardPage', () {
    testWidgets('renders $LeaderboardView route', (tester) async {
      await tester.pumpRoute(LeaderboardPage.route());
      await tester.pump();

      expect(find.byType(LeaderboardView), findsOneWidget);
    });

    testWidgets(
      'renders LeaderboardView',
      (tester) async {
        final themeData = IoCrosswordTheme().themeData;
        await tester.pumpApp(Theme(data: themeData, child: LeaderboardPage()));

        expect(find.byType(LeaderboardView), findsOneWidget);
      },
    );
  });

  group('LeaderboardView', () {
    late LeaderboardBloc leaderboardBloc;
    late PlayerBloc playerBloc;
    late Widget widget;

    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      leaderboardBloc = _MockLeaderboardBloc();
      playerBloc = _MockPlayerBloc();

      widget = MultiBlocProvider(
        providers: [
          BlocProvider<LeaderboardBloc>(
            create: (_) => leaderboardBloc,
          ),
          BlocProvider<PlayerBloc>(
            create: (context) => playerBloc,
          ),
        ],
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
        when(() => playerBloc.state).thenReturn(PlayerState());

        await tester.pumpApp(widget);

        expect(find.byType(LeaderboardSuccess), findsOneWidget);
      },
    );
  });
}
