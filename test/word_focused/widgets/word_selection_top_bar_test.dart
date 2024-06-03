// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/share/share.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockWordCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _UnsolvedFakeWord extends Fake implements Word {
  @override
  String get id => '11000';

  @override
  String get answer => 'answer';

  @override
  WordAxis get axis => WordAxis.horizontal;

  @override
  int get length => 4;

  @override
  String get clue => 'clue';

  @override
  int? get solvedTimestamp => null;

  @override
  Mascots? get mascot => null;
}

class _SolvedFakeWord extends Fake implements Word {
  @override
  String get id => '11000';

  @override
  WordAxis get axis => WordAxis.horizontal;

  @override
  int get length => 4;

  @override
  String get clue => 'clue';

  @override
  int? get solvedTimestamp => 1;

  @override
  Mascots? get mascot => Mascots.android;
}

void main() {
  group('$WordSelectionTopBar', () {
    late WordSelectionBloc wordSelectionBloc;
    late CrosswordBloc crosswordBloc;

    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
      crosswordBloc = _MockWordCrosswordBloc();

      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(
          word: SelectedWord(section: (0, 0), word: _UnsolvedFakeWord()),
          status: WordSelectionStatus.preSolving,
        ),
      );

      when(() => crosswordBloc.state).thenReturn(
        CrosswordState(
          sections: {
            (0, 0): BoardSection(
              id: 'id',
              position: Point(0, 0),
              words: [_UnsolvedFakeWord()],
            ),
          },
        ),
      );
    });

    Widget buildWidget({bool canSolveWord = false}) => BlocProvider(
          create: (context) => wordSelectionBloc,
          child: WordSelectionTopBar(
            canSolveWord: canSolveWord,
          ),
        );

    group('renders', () {
      testWidgets('the word identifier', (tester) async {
        await tester.pumpApp(buildWidget(), crosswordBloc: crosswordBloc);

        expect(find.text('11,000 ACROSS'), findsOneWidget);
      });

      testWidgets(
          'the word identifier and changes with subtitle'
          ' if the word gets solved', (tester) async {
        final section = BoardSection(
          id: 'id',
          position: Point(0, 0),
          words: [_UnsolvedFakeWord()],
        );
        whenListen(
          crosswordBloc,
          Stream.fromIterable(
            [
              CrosswordState(
                sections: {
                  (0, 0): section.copyWith(words: [_SolvedFakeWord()]),
                },
              ),
            ],
          ),
          initialState: CrosswordState(
            sections: {
              (0, 0): section,
            },
          ),
        );
        await tester.pumpApp(
          buildWidget(canSolveWord: true),
          crosswordBloc: crosswordBloc,
        );

        expect(find.text('11,000 ACROSS'), findsOneWidget);

        await tester.pump();

        expect(
          find.text(
            l10n
                .alreadySolvedTitle(_SolvedFakeWord().mascot!.name)
                .toUpperCase(),
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            l10n.alreadySolvedSubtitle.toUpperCase(),
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'the word identifier and alreadySolvedTitle without subtitle'
          ' if the word is already solved', (tester) async {
        final section = BoardSection(
          id: 'id',
          position: Point(0, 0),
          words: [_SolvedFakeWord()],
        );
        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            sections: {
              (0, 0): section,
            },
          ),
        );
        await tester.pumpApp(
          buildWidget(),
          crosswordBloc: crosswordBloc,
        );

        expect(find.text('11,000 ACROSS'), findsOneWidget);
        expect(
          find.text(
            l10n
                .alreadySolvedTitle(_SolvedFakeWord().mascot!.name)
                .toUpperCase(),
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            l10n.alreadySolvedSubtitle.toUpperCase(),
          ),
          findsNothing,
        );
      });

      testWidgets('empty when no word is selected', (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            // ignore: avoid_redundant_argument_values
            word: null,
            status: WordSelectionStatus.empty,
          ),
        );

        await tester.pumpApp(buildWidget(), crosswordBloc: crosswordBloc);

        expect(find.byType(SizedBox), findsAtLeast(1));
      });

      testWidgets('a $CloseWordSelectionIconButton', (tester) async {
        await tester.pumpApp(buildWidget(), crosswordBloc: crosswordBloc);
        expect(find.byType(CloseWordSelectionIconButton), findsOneWidget);
      });

      for (final status in [...WordSelectionStatus.values]
        ..remove(WordSelectionStatus.preSolving)) {
        testWidgets(
          'visible icon ios_share if status is $status',
          (tester) async {
            when(() => wordSelectionBloc.state).thenReturn(
              WordSelectionState(
                word: SelectedWord(section: (0, 0), word: _UnsolvedFakeWord()),
                status: status,
              ),
            );
            await tester.pumpApp(buildWidget(), crosswordBloc: crosswordBloc);

            final visibility =
                tester.widget(find.byType(Visibility)) as Visibility;

            expect(visibility.visible, isTrue);
            expect(find.byIcon(Icons.ios_share), findsOneWidget);
          },
        );
      }

      testWidgets(
        'invisible icon ios_share'
        ' if status is ${WordSelectionStatus.preSolving}',
        (tester) async {
          await tester.pumpApp(buildWidget(), crosswordBloc: crosswordBloc);

          final visibility =
              tester.widget(find.byType(Visibility)) as Visibility;
          expect(visibility.visible, isFalse);
        },
      );

      testWidgets(
        'the number of letters of the selected word'
        ' if status is ${WordSelectionStatus.preSolving}',
        (tester) async {
          await tester.pumpApp(buildWidget(), crosswordBloc: crosswordBloc);

          expect(
            find.text(l10n.nLetters(_UnsolvedFakeWord().length).toUpperCase()),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'ShareWordPage when icon ios_share tapped',
        (tester) async {
          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(
              status: WordSelectionStatus.solved,
              word: SelectedWord(section: (0, 0), word: _UnsolvedFakeWord()),
            ),
          );

          await tester.pumpApp(buildWidget(), crosswordBloc: crosswordBloc);

          await tester.tap(find.byIcon(Icons.ios_share));

          await tester.pumpAndSettle();

          expect(find.byType(ShareWordPage), findsOneWidget);
        },
      );
    });
  });
}
