import 'package:bloc_test/bloc_test.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword/bloc/crossword_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockInitialsBloc extends MockBloc<InitialsEvent, InitialsState>
    implements InitialsBloc {}

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

void main() {
  group('$InitialsPage', () {
    testWidgets('displays an $InitialsView', (tester) async {
      await tester.pumpApp(const InitialsPage());

      expect(find.byType(InitialsView), findsOneWidget);
    });
  });

  group('$InitialsView', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    testWidgets(
      'updates initials and flow when submission is valid',
      (tester) async {
        final initialsBloc = _MockInitialsBloc();
        whenListen(
          initialsBloc,
          Stream.fromIterable(
            [
              InitialsState(
                initials: InitialsInput.dirty('ABC', blocklist: Blocklist({})),
              ),
            ],
          ),
          initialState: InitialsState.initial(),
        );
        final crosswordBloc = _MockCrosswordBloc();

        final flowController = FlowController(GameIntroStatus.enterInitials);
        addTearDown(flowController.dispose);

        await tester.pumpSubject(
          crosswordBloc: crosswordBloc,
          initialsBloc: initialsBloc,
          FlowBuilder<GameIntroStatus>(
            controller: flowController,
            onGeneratePages: (_, __) => [
              const MaterialPage(child: InitialsView()),
            ],
          ),
        );

        verify(
          () => crosswordBloc.add(const InitialsSelected('ABC')),
        ).called(1);
        expect(flowController.state, equals(GameIntroStatus.howToPlay));
      },
    );

    testWidgets('$IoWordInput onSubmit submits', (tester) async {
      final initialsBloc = _MockInitialsBloc();
      whenListen(
        initialsBloc,
        const Stream<InitialsState>.empty(),
        initialState: InitialsState.initial(),
      );

      await tester.pumpSubject(
        initialsBloc: initialsBloc,
        const InitialsView(),
      );

      final editableTexts = find.byType(EditableText);
      await tester.enterText(editableTexts.at(0), 'A');
      await tester.enterText(editableTexts.at(1), 'B');

      await TestWidgetsFlutterBinding.instance.testTextInput
          .receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(
        () => initialsBloc.add(const InitialsSubmitted('AB')),
      ).called(1);
    });

    testWidgets('$InitialsSubmitButton submits', (tester) async {
      final initialsBloc = _MockInitialsBloc();
      whenListen(
        initialsBloc,
        const Stream<InitialsState>.empty(),
        initialState: InitialsState.initial(),
      );

      await tester.pumpSubject(
        initialsBloc: initialsBloc,
        const InitialsView(),
      );

      final editableTexts = find.byType(EditableText);
      await tester.enterText(editableTexts.at(0), 'A');
      await tester.enterText(editableTexts.at(1), 'B');

      final submitButtonFinder = find.byType(InitialsSubmitButton);
      await tester.ensureVisible(submitButtonFinder);
      await tester.pumpAndSettle();

      await tester.tap(submitButtonFinder);
      await tester.pumpAndSettle();

      verify(
        () => initialsBloc.add(const InitialsSubmitted('AB')),
      ).called(1);
    });

    group('displays', () {
      testWidgets('a $IoAppBar', (tester) async {
        await tester.pumpSubject(const InitialsView());

        expect(find.byType(IoAppBar), findsOneWidget);
      });

      testWidgets('a $IoWordInput of length 3', (tester) async {
        await tester.pumpSubject(const InitialsView());

        final ioWordInputFinder = find.byType(IoWordInput);
        expect(ioWordInputFinder, findsOneWidget);

        final ioWordInput = tester.widget<IoWordInput>(ioWordInputFinder);
        expect(
          ioWordInput.length,
          equals(3),
          reason: 'The initials should have a length of 3',
        );
      });

      testWidgets('a $InitialsSubmitButton', (tester) async {
        await tester.pumpSubject(const InitialsView());

        expect(find.byType(InitialsSubmitButton), findsOneWidget);
      });

      testWidgets('a localized enterInitials text', (tester) async {
        late final AppLocalizations l10n;
        await tester.pumpSubject(
          Builder(
            builder: (context) {
              l10n = context.l10n;
              return const InitialsView();
            },
          ),
        );

        expect(find.text(l10n.enterInitials), findsOneWidget);
      });

      testWidgets(
        'no $InitialsErrorText when input has had no interaction',
        (tester) async {
          await tester.pumpSubject(const InitialsView());

          expect(find.byType(InitialsErrorText), findsNothing);
        },
      );

      testWidgets(
        'an $InitialsErrorText when input has an error',
        (tester) async {
          final initialsBloc = _MockInitialsBloc();
          when(() => initialsBloc.state).thenReturn(
            InitialsState(
              initials: InitialsInput.dirty(
                '!@#',
              ),
            ),
          );

          await tester.pumpSubject(
            initialsBloc: initialsBloc,
            const InitialsView(),
          );

          expect(find.byType(InitialsErrorText), findsOneWidget);
        },
      );
    });
  });
}

extension on WidgetTester {
  /// Pumps the test subject with all its required ancestors.
  Future<void> pumpSubject(
    Widget child, {
    InitialsBloc? initialsBloc,
    CrosswordBloc? crosswordBloc,
  }) {
    final bloc = initialsBloc ?? _MockInitialsBloc();
    if (initialsBloc == null) {
      whenListen(
        bloc,
        const Stream<InitialsState>.empty(),
        initialState: InitialsState.initial(),
      );
      when(bloc.close).thenAnswer((_) => Future.value());
    }

    return pumpApp(
      crosswordBloc: crosswordBloc,
      BlocProvider(
        create: (_) => bloc,
        child: child,
      ),
    );
  }
}
