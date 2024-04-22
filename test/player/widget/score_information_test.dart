// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

void main() {
  group('$ScoreInformation', () {
    late PlayerBloc playerBloc;
    late Widget widget;

    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      playerBloc = _MockPlayerBloc();
      widget = BlocProvider(
        create: (_) => playerBloc,
        child: ScoreInformation(),
      );
    });

    testWidgets(
      'renders rank',
      (tester) async {
        when(() => playerBloc.state).thenReturn(
          PlayerState(
            rank: 300,
          ),
        );

        await tester.pumpApp(widget);

        expect(find.text(l10n.rank), findsOneWidget);
        expect(find.text('300'), findsOneWidget);
      },
    );

    testWidgets(
      'displays streak',
      (tester) async {
        when(() => playerBloc.state).thenReturn(
          PlayerState(player: Player.empty.copyWith(streak: 5)),
        );

        await tester.pumpApp(widget);

        expect(find.text(l10n.streak), findsOneWidget);
        expect(find.text('5'), findsOneWidget);
      },
    );

    testWidgets(
      'displays points',
      (tester) async {
        when(() => playerBloc.state).thenReturn(
          PlayerState(player: Player.empty.copyWith(streak: 100)),
        );

        await tester.pumpApp(widget);

        expect(find.text(l10n.points), findsOneWidget);
        expect(find.text('100'), findsOneWidget);
      },
    );
  });
}
