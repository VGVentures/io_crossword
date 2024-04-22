// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

void main() {
  group('$PlayerInitials', () {
    late PlayerBloc playerBloc;
    late Widget widget;

    setUp(() {
      playerBloc = _MockPlayerBloc();
      widget = BlocProvider(
        create: (_) => playerBloc,
        child: PlayerInitials(),
      );
    });

    testWidgets(
      'renders IoWord',
      (tester) async {
        when(() => playerBloc.state).thenReturn(PlayerState());

        await tester.pumpApp(widget);

        expect(find.byType(IoWord), findsOneWidget);
      },
    );

    testWidgets(
      'renders IoWord with the initials',
      (tester) async {
        when(() => playerBloc.state).thenReturn(
          PlayerState(player: Player.empty.copyWith(initials: 'ABC')),
        );

        await tester.pumpApp(widget);

        expect(
          tester.widget<IoWord>(find.byType(IoWord)).data,
          equals('ABC'),
        );
      },
    );
  });
}
