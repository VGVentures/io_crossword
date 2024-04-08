import 'package:bloc_test/bloc_test.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/game_intro/bloc/game_intro_bloc.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/welcome/welcome.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWelcomeBloc extends Mock implements WelcomeBloc {}

void main() {
  group('$WelcomePage', () {
    testWidgets('displays a $WelcomeView', (tester) async {
      await tester.pumpApp(const WelcomePage());

      expect(find.byType(WelcomeView), findsOneWidget);
    });
  });

  group('$WelcomeView', () {
    testWidgets(
      'updates flow when pressed',
      (tester) async {
        final flowController = FlowController(const GameIntroState());
        addTearDown(flowController.dispose);

        await tester.pumpSubject(
          FlowBuilder<GameIntroState>(
            controller: flowController,
            onGeneratePages: (_, __) => [
              const MaterialPage(child: WelcomeView()),
            ],
          ),
        );

        final outlinedButtonFinder = find.byType(OutlinedButton);
        await tester.ensureVisible(outlinedButtonFinder);
        await tester.pumpAndSettle();

        await tester.tap(outlinedButtonFinder);
        await tester.pump();

        expect(
          flowController.state,
          equals(
            const GameIntroState(status: GameIntroStatus.mascotSelection),
          ),
        );
      },
    );

    group('displays', () {
      testWidgets('a $ChallengeProgress', (tester) async {
        await tester.pumpSubject(const WelcomeView());
        expect(find.byType(ChallengeProgress), findsOneWidget);
      });

      testWidgets('a $WelcomeHeaderImage', (tester) async {
        await tester.pumpSubject(const WelcomeView());
        expect(find.byType(WelcomeHeaderImage), findsOneWidget);
      });

      testWidgets('a localized welcome text', (tester) async {
        late final AppLocalizations l10n;
        await tester.pumpSubject(
          Builder(
            builder: (context) {
              l10n = context.l10n;
              return const WelcomeView();
            },
          ),
        );

        expect(find.text(l10n.welcome), findsOneWidget);
      });

      testWidgets('a localized welcomeSubtitle text', (tester) async {
        late final AppLocalizations l10n;
        await tester.pumpSubject(
          Builder(
            builder: (context) {
              l10n = context.l10n;
              return const WelcomeView();
            },
          ),
        );

        expect(find.text(l10n.welcomeSubtitle), findsOneWidget);
      });

      testWidgets(
        'an $OutlinedButton with a localized getStarted text',
        (tester) async {
          late final AppLocalizations l10n;
          await tester.pumpSubject(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return const WelcomeView();
              },
            ),
          );

          final outlinedButtonFinder = find.byType(OutlinedButton);
          expect(outlinedButtonFinder, findsOneWidget);

          final outlinedButton =
              tester.widget<OutlinedButton>(outlinedButtonFinder);
          expect(
            outlinedButton.child,
            isA<Text>().having((text) => text.data, 'data', l10n.getStarted),
          );
        },
      );
    });
  });
}

extension on WidgetTester {
  /// Pumps the test subject with all its required ancestors.
  Future<void> pumpSubject(
    Widget child, {
    WelcomeBloc? welcomeBloc,
  }) {
    final bloc = welcomeBloc ?? _MockWelcomeBloc();
    if (welcomeBloc == null) {
      whenListen(
        bloc,
        const Stream<WelcomeState>.empty(),
        initialState: const WelcomeState.initial(),
      );
      when(bloc.close).thenAnswer((_) => Future.value());
    }

    return pumpApp(
      BlocProvider(
        create: (_) => bloc,
        child: child,
      ),
    );
  }
}
