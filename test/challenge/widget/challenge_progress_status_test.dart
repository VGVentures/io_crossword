// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/challenge/challenge.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockChallengeBloc extends MockBloc<ChallengeEvent, ChallengeState>
    implements ChallengeBloc {}

void main() {
  group('$ChallengeProgressStatus', () {
    testWidgets('renders $ChallengeProgressStatusView', (tester) async {
      await tester.pumpApp(ChallengeProgressStatus());

      expect(find.byType(ChallengeProgressStatusView), findsOneWidget);
    });
  });

  group('$ChallengeProgressStatusView', () {
    late ChallengeBloc challengeBloc;

    late Widget widget;

    setUp(() {
      challengeBloc = _MockChallengeBloc();

      widget = BlocProvider<ChallengeBloc>(
        create: (_) => challengeBloc,
        child: ChallengeProgressStatusView(),
      );
    });

    testWidgets(
      'renders $ChallengeProgress',
      (tester) async {
        when(() => challengeBloc.state).thenReturn(
          ChallengeState(
            solvedWords: 100,
            totalWords: 400,
          ),
        );

        await tester.pumpApp(widget);

        expect(find.byType(ChallengeProgress), findsOneWidget);
      },
    );

    testWidgets(
      'renders $ChallengeProgress with correct solved and total values',
      (tester) async {
        when(() => challengeBloc.state).thenReturn(
          ChallengeState(
            solvedWords: 100,
            totalWords: 400,
          ),
        );

        await tester.pumpApp(widget);

        final challengeProgress = tester.widget<ChallengeProgress>(
          find.byType(ChallengeProgress),
        );

        expect(challengeProgress.solvedWords, equals(100));
        expect(challengeProgress.totalWords, equals(400));
      },
    );
  });
}
