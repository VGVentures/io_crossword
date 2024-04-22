// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHintBloc extends MockBloc<HintEvent, HintState>
    implements HintBloc {}

void main() {
  group('$CloseHintButton', () {
    late HintBloc hintBloc;

    setUp(() {
      hintBloc = _MockHintBloc();
    });

    testWidgets('displays close icon', (tester) async {
      await tester.pumpApp(CloseHintButton());

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('emits HintModeExited when tapped', (tester) async {
      await tester.pumpApp(
        BlocProvider(
          create: (context) => hintBloc,
          child: CloseHintButton(),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));

      verify(() => hintBloc.add(const HintModeExited())).called(1);
    });
  });
}
