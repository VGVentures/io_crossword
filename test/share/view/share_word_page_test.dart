// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/project_details/project_details.dart';
import 'package:io_crossword/share/share.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _FakeWord extends Fake implements Word {
  @override
  String get answer => 'an  er';

  @override
  String get clue => 'clue';

  @override
  int get length => 5;
}

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

void main() {
  group('$ShareWordPage', () {
    testWidgets(
      'renders IoWord',
      (tester) async {
        final word = _FakeWord();
        await tester.pumpApp(
          ShareWordPage(word: word),
        );

        expect(find.byType(IoWord), findsOneWidget);
      },
    );

    testWidgets(
      'displays the answer correctly in IoWord',
      (tester) async {
        final word = _FakeWord();
        await tester.pumpApp(
          ShareWordPage(word: word),
        );

        expect(
          tester.widget<IoWord>(find.byType(IoWord)).data,
          equals('an__er'),
        );
      },
    );

    testWidgets(
      'displays clue',
      (tester) async {
        final word = _FakeWord();
        await tester.pumpApp(
          ShareWordPage(word: word),
        );

        expect(find.text(word.clue), findsOneWidget);
      },
    );

    group('showModal', () {
      late WordSelectionBloc wordSelectionBloc;

      setUp(() {
        wordSelectionBloc = _MockWordSelectionBloc();
      });

      testWidgets(
        'opens the $ShareWordPage in a $ShareDialog when there is a word',
        (tester) async {
          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
              word: SelectedWord(
                word: _FakeWord(),
                section: (0, 0),
              ),
            ),
          );

          await tester.pumpApp(
            BlocProvider<WordSelectionBloc>(
              create: (context) => wordSelectionBloc,
              child: Scaffold(
                body: Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () => ShareWordPage.showModal(context),
                      child: Text('Show ShareWordPage'),
                    );
                  },
                ),
              ),
            ),
          );

          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();

          expect(find.byType(ShareDialog), findsOneWidget);
          expect(find.byType(ShareWordPage), findsOneWidget);
        },
      );

      testWidgets(
        'Displays $SnackBar error when there is a word',
        (tester) async {
          late AppLocalizations l10n;

          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
            ),
          );

          await tester.pumpApp(
            BlocProvider<WordSelectionBloc>(
              create: (context) => wordSelectionBloc,
              child: Scaffold(
                body: Builder(
                  builder: (BuildContext context) {
                    l10n = context.l10n;

                    return ElevatedButton(
                      onPressed: () => ShareWordPage.showModal(context),
                      child: Text('Show ShareWordPage'),
                    );
                  },
                ),
              ),
            ),
          );

          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget);
          expect(find.text(l10n.errorPromptText), findsOneWidget);
        },
      );

      testWidgets(
        'uses correct facebook url',
        (tester) async {
          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
              word: SelectedWord(
                word: _FakeWord(),
                section: (0, 0),
              ),
            ),
          );

          await tester.pumpApp(
            BlocProvider<WordSelectionBloc>(
              create: (context) => wordSelectionBloc,
              child: Scaffold(
                body: Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () => ShareWordPage.showModal(context),
                      child: Text('open share score'),
                    );
                  },
                ),
              ),
            ),
          );

          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();

          expect(
            tester.widget<ShareDialog>(find.byType(ShareDialog)).url,
            equals(ProjectDetailsLinks.crossword),
          );
        },
      );
    });
  });
}
