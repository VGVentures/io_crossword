import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockInitialsBloc extends MockBloc<InitialsEvent, InitialsState>
    implements InitialsBloc {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

class _MockAudioController extends Mock implements AudioController {}

void main() {
  group('$InitialsPage', () {
    testWidgets('displays an $InitialsView', (tester) async {
      await tester.pumpApp(const InitialsPage());

      expect(find.byType(InitialsView), findsOneWidget);
    });
  });

  group('$InitialsView', () {
    late AudioController audioController;

    TestWidgetsFlutterBinding.ensureInitialized();

    setUp(() {
      audioController = _MockAudioController();
    });

    testWidgets(
      'navigates to $HowToPlayPage when submission is valid',
      (tester) async {
        final navigator = MockNavigator();
        when(navigator.canPop).thenReturn(true);
        when(() => navigator.push<void>(any())).thenAnswer((_) async {});

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
        final playerBloc = _MockPlayerBloc();

        await tester.pumpSubject(
          playerBloc: playerBloc,
          initialsBloc: initialsBloc,
          navigator: navigator,
          const InitialsView(),
        );

        verify(
          () => playerBloc.add(const InitialsSelected('ABC')),
        ).called(1);

        verify(
          () => navigator.push<void>(
            any(
              that: isRoute<void>(
                whereName: equals(HowToPlayPage.routeName),
              ),
            ),
          ),
        ).called(1);
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

    testWidgets(
        'plays ${Assets.music.startButton1} when '
        '$InitialsSubmitButton is tapped', (tester) async {
      final initialsBloc = _MockInitialsBloc();
      whenListen(
        initialsBloc,
        const Stream<InitialsState>.empty(),
        initialState: InitialsState.initial(),
      );

      await tester.pumpSubject(
        initialsBloc: initialsBloc,
        const InitialsView(),
        audioController: audioController,
      );

      final submitButtonFinder = find.byType(InitialsSubmitButton);
      await tester.ensureVisible(submitButtonFinder);

      await tester.tap(submitButtonFinder);
      await tester.pumpAndSettle();

      verify(
        () => audioController.playSfx(Assets.music.startButton1),
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
    PlayerBloc? playerBloc,
    AudioController? audioController,
    MockNavigator? navigator,
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
      playerBloc: playerBloc,
      audioController: audioController,
      navigator: navigator,
      BlocProvider(
        create: (_) => bloc,
        child: child,
      ),
    );
  }
}
