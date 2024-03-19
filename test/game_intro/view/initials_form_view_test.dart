// ignore_for_file: prefer_const_constructors,
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/game_intro/formatters/formatters.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockGameIntroBloc extends MockBloc<GameIntroEvent, GameIntroState>
    implements GameIntroBloc {}

void main() {
  late AppLocalizations l10n;
  late GameIntroBloc bloc;
  late Widget child;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(Locale('en'));
  });

  setUp(() {
    bloc = _MockGameIntroBloc();

    child = BlocProvider.value(
      value: bloc,
      child: Material(child: InitialsInputView()),
    );
  });

  group('InitialsFormView', () {
    testWidgets('renders 3 InitialFormFields', (tester) async {
      when(() => bloc.state).thenReturn(GameIntroState());

      await tester.pumpApp(child);

      expect(find.byType(InitialFormField), findsNWidgets(3));
    });

    testWidgets(
      'renders blacklisted error text when initials are blacklisted',
      (tester) async {
        when(() => bloc.state).thenReturn(
          GameIntroState(initialsStatus: InitialsFormStatus.blacklisted),
        );

        await tester.pumpApp(child);

        expect(find.text(l10n.initialsBlacklistedMessage), findsOneWidget);
      },
    );

    testWidgets(
      'renders error text when initials are not valid',
      (tester) async {
        when(() => bloc.state).thenReturn(
          GameIntroState(initialsStatus: InitialsFormStatus.invalid),
        );

        await tester.pumpApp(child);

        expect(find.text(l10n.initialsErrorMessage), findsOneWidget);
      },
    );

    testWidgets(
      'renders submission error text when initials fail to submit',
      (tester) async {
        when(() => bloc.state).thenReturn(
          GameIntroState(initialsStatus: InitialsFormStatus.failure),
        );

        await tester.pumpApp(child);

        expect(find.text(l10n.initialsSubmissionErrorMessage), findsOneWidget);
      },
    );

    group('initials textfield', () {
      testWidgets('correctly updates fields and focus', (tester) async {
        when(() => bloc.state).thenReturn(GameIntroState());
        await tester.pumpApp(child);

        final initial0 = find.byKey(const Key('initial_form_field_0'));
        final initial1 = find.byKey(const Key('initial_form_field_1'));
        final initial2 = find.byKey(const Key('initial_form_field_2'));

        await tester.enterText(initial0, 'a');
        await tester.enterText(initial1, 'a');
        await tester.enterText(initial2, 'a');

        await tester.pumpAndSettle();

        final inputs =
            tester.widgetList<EditableText>(find.byType(EditableText));
        for (final input in inputs) {
          expect(input.controller.text == 'A', isTrue);
        }

        await tester.enterText(initial2, '');
        await tester.pumpAndSettle();

        expect(inputs.last.controller.text, equals(emptyCharacter));
        expect(find.text(l10n.initialsErrorMessage), findsNothing);
      });

      testWidgets('correctly moves focus on backspaces', (tester) async {
        when(() => bloc.state).thenReturn(GameIntroState());
        await tester.pumpApp(child);

        final initial0 = find.byKey(const Key('initial_form_field_0'));
        final initial2 = find.byKey(const Key('initial_form_field_2'));

        await tester.enterText(initial0, 'a');
        await tester.enterText(initial2, 'a');

        await tester.pumpAndSettle();
        await tester.tap(initial2);

        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pumpAndSettle();

        final inputs =
            tester.widgetList<EditableText>(find.byType(EditableText));

        for (final input in inputs) {
          expect(input.controller.text == emptyCharacter, isTrue);
        }
      });

      testWidgets('moves focus on typing repeated letters', (tester) async {
        when(() => bloc.state).thenReturn(GameIntroState());
        await tester.pumpApp(child);

        final initial0 = find.byKey(const Key('initial_form_field_0'));
        final initial1 = find.byKey(const Key('initial_form_field_1'));
        final initial2 = find.byKey(const Key('initial_form_field_2'));

        await tester.enterText(initial0, 'a');
        await tester.enterText(initial1, 'a');
        await tester.enterText(initial2, 'a');

        await tester.pumpAndSettle();
        await tester.tap(initial0);

        await tester.pumpAndSettle();

        await tester.enterText(initial0, 'aa');
        await tester.enterText(initial1, 'ab');
        await tester.enterText(initial0, 'aa');

        final inputs =
            tester.widgetList<EditableText>(find.byType(EditableText));
        await tester.pumpAndSettle();

        expect(inputs.elementAt(1).controller.text, 'B');
      });

      testWidgets('validates initials', (tester) async {
        when(() => bloc.state).thenReturn(
          GameIntroState(initials: ['A', 'A', 'A']),
        );
        await tester.pumpApp(child);

        await tester.tap(find.byType(PrimaryButton));
        await tester.pumpAndSettle();

        expect(find.text(l10n.initialsErrorMessage), findsNothing);
      });

      testWidgets('shows error text on failed validation', (tester) async {
        when(() => bloc.state).thenReturn(
          GameIntroState(
            initials: ['A', 'A', ''],
            initialsStatus: InitialsFormStatus.invalid,
          ),
        );
        await tester.pumpApp(child);

        expect(find.text(l10n.initialsErrorMessage), findsOneWidget);
      });

      testWidgets(
        'requests focus on last input when initials status is '
        'InitialsFormStatus.blacklisted',
        (tester) async {
          whenListen(
            bloc,
            Stream.fromIterable([
              GameIntroState(
                initials: ['A', 'A', 'A'],
                initialsStatus: InitialsFormStatus.blacklisted,
              ),
            ]),
            initialState: GameIntroState(),
          );

          await tester.pumpApp(child);

          final inputs =
              tester.widgetList<EditableText>(find.byType(EditableText));

          for (final input in inputs) {
            if (input != inputs.last) {
              expect(input.focusNode.hasFocus, isFalse);
            } else {
              expect(input.focusNode.hasFocus, isTrue);
            }
          }
        },
      );

      testWidgets('shows blacklist error text on blacklist initials',
          (tester) async {
        when(() => bloc.state).thenReturn(
          GameIntroState(
            initials: ['A', 'A', 'A'],
            initialsStatus: InitialsFormStatus.blacklisted,
          ),
        );
        await tester.pumpApp(child);

        expect(find.text(l10n.initialsBlacklistedMessage), findsOneWidget);
      });

      testWidgets('shows blacklist error styling on blacklist initials',
          (tester) async {
        when(() => bloc.state).thenReturn(
          GameIntroState(
            initials: ['A', 'A', 'A'],
            initialsStatus: InitialsFormStatus.blacklisted,
          ),
        );
        await tester.pumpApp(child);
        final blacklistDecoration = find.byWidgetPredicate(
          (widget) =>
              widget is DecoratedBox &&
              widget.decoration is BoxDecoration &&
              ((widget.decoration as BoxDecoration).border ==
                  Border.all(color: IoCrosswordColors.seedRed, width: 3)),
        );

        expect(blacklistDecoration, findsNWidgets(3));
      });

      testWidgets('capitalizes lowercase letters', (tester) async {
        when(() => bloc.state).thenReturn(GameIntroState());
        await tester.pumpApp(child);

        final initial0 = find.byKey(const Key('initial_form_field_0'));
        final initial1 = find.byKey(const Key('initial_form_field_1'));
        final initial2 = find.byKey(const Key('initial_form_field_2'));

        await tester.enterText(initial0, 'a');
        await tester.enterText(initial1, 'a');
        await tester.enterText(initial2, 'a');

        await tester.pumpAndSettle();

        final inputs =
            tester.widgetList<EditableText>(find.byType(EditableText));
        for (final input in inputs) {
          expect(input.controller.text == 'A', isTrue);
        }

        expect(find.text(l10n.initialsErrorMessage), findsNothing);
      });

      testWidgets('typing two letters in the same field keeps last letter',
          (tester) async {
        when(() => bloc.state).thenReturn(GameIntroState());
        await tester.pumpApp(child);

        final initial = find.byKey(const Key('initial_form_field_0'));

        await tester.enterText(initial, 'ab');

        await tester.pumpAndSettle();

        final input =
            tester.widget<EditableText>(find.byType(EditableText).first);
        expect(input.controller.text == 'B', isTrue);

        expect(find.text(l10n.initialsErrorMessage), findsNothing);
      });
    });
  });
}
