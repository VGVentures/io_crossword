// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/bloc/crossword_bloc.dart';
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
  Axis get axis => Axis.horizontal;

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
  Axis get axis => Axis.horizontal;

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
    late Widget widget;
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
          selectedWord:
              WordSelection(section: (0, 0), word: _UnsolvedFakeWord()),
          sections: {
            (0, 0): BoardSection(
              id: 'id',
              position: Point(0, 0),
              size: 20,
              words: [_UnsolvedFakeWord()],
              borderWords: const [],
            ),
          },
        ),
      );
      widget = BlocProvider(
        create: (context) => wordSelectionBloc,
        child: const WordSelectionTopBar(),
      );
    });

    group('renders', () {
      testWidgets('the word identifier', (tester) async {
        await tester.pumpApp(widget, crosswordBloc: crosswordBloc);

        expect(find.text('11,000 ACROSS'), findsOneWidget);
      });

      testWidgets('the word identifier and changes if the word gets solved',
          (tester) async {
        final section = BoardSection(
          id: 'id',
          position: Point(0, 0),
          size: 20,
          words: [_UnsolvedFakeWord()],
          borderWords: const [],
        );
        whenListen(
          crosswordBloc,
          Stream.fromIterable(
            [
              CrosswordState(
                selectedWord:
                    WordSelection(section: (0, 0), word: _UnsolvedFakeWord()),
                sections: {
                  (0, 0): section.copyWith(words: [_SolvedFakeWord()]),
                },
              ),
            ],
          ),
          initialState: CrosswordState(
            selectedWord:
                WordSelection(section: (0, 0), word: _UnsolvedFakeWord()),
            sections: {
              (0, 0): section,
            },
          ),
        );
        await tester.pumpApp(widget, crosswordBloc: crosswordBloc);

        expect(find.text('11,000 ACROSS'), findsOneWidget);
        await tester.pump();
        expect(
          find.text(l10n.alreadySolvedTitle(_SolvedFakeWord().mascot!.name)),
          findsOneWidget,
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

        await tester.pumpApp(widget, crosswordBloc: crosswordBloc);

        expect(find.byType(SizedBox), findsAtLeast(1));
      });

      testWidgets('a $CloseWordSelectionIconButton', (tester) async {
        await tester.pumpApp(widget, crosswordBloc: crosswordBloc);
        expect(find.byType(CloseWordSelectionIconButton), findsOneWidget);
      });

      testWidgets(
        'icon ios_share',
        (tester) async {
          await tester.pumpApp(widget, crosswordBloc: crosswordBloc);

          expect(find.byIcon(Icons.ios_share), findsOneWidget);
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

          await tester.pumpApp(widget, crosswordBloc: crosswordBloc);

          await tester.tap(find.byIcon(Icons.ios_share));

          await tester.pumpAndSettle();

          expect(find.byType(ShareWordPage), findsOneWidget);
        },
      );
    });
  });
}
