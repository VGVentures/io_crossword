// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword/welcome/welcome.dart';

GoRouter createRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => NoTransitionPage(
          child: WelcomePage(),
        ),
      ),
      GoRoute(
        path: '/team',
        pageBuilder: (context, state) => NoTransitionPage(
          child: TeamSelectionPage(),
        ),
      ),
      GoRoute(
        path: '/initials',
        pageBuilder: (context, state) => NoTransitionPage(
          child: InitialsPage(),
        ),
      ),
      GoRoute(
        path: '/how-to-play',
        pageBuilder: (context, state) => NoTransitionPage(
          child: HowToPlayPage(),
        ),
      ),
      GoRoute(
        path: '/game',
        pageBuilder: (context, state) => NoTransitionPage(
          child: CrosswordPage(),
        ),
      ),
      GoRoute(
        path: '/end-game',
        pageBuilder: (context, state) => NoTransitionPage(
          child: EndGamePage(),
        ),
      ),
    ],
    observers: [RedirectToHomeObserver()],
  );
}

class RedirectToHomeObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (previousRoute == null && route.settings.name != '/') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = route.navigator!.context;
        GoRouter.of(context).go('/');
      });
    }
  }
}
