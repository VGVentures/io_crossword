// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/word_selection/word_selection.dart'
    hide WordUnselected;
import 'package:io_crossword/word_selection/word_selection.dart' as selection;
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

class _MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

class _FakeWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => null;

  @override
  String get id => 'id';

  @override
  String get answer => 'answer';

  @override
  Axis get axis => Axis.horizontal;
}

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(Locale('en'));
  });

  group('$WordSuccessView', () {
    late WordSelectionBloc wordSelectionBloc;

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(
          status: WordSelectionStatus.solved,
          word: SelectedWord(section: (0, 0), word: _FakeWord()),
        ),
      );
    });

    group('renders', () {
      testWidgets('$WordSelectionSuccessLargeView when layout is large',
          (tester) async {
        await tester.pumpApp(
          layout: IoLayoutData.large,
          BlocProvider(
            create: (_) => wordSelectionBloc,
            child: WordSuccessView(),
          ),
        );

        expect(find.byType(WordSelectionSuccessLargeView), findsOneWidget);
      });

      testWidgets('$WordSelectionSuccessSmallView when layout is small',
          (tester) async {
        await tester.pumpApp(
          layout: IoLayoutData.small,
          BlocProvider(
            create: (_) => wordSelectionBloc,
            child: WordSuccessView(),
          ),
        );

        expect(find.byType(WordSelectionSuccessSmallView), findsOneWidget);
      });
    });
  });

  group('$WordSelectionSuccessLargeView', () {
    late Widget widget;

    setUp(() {
      final wordSelectionBloc = _MockWordSelectionBloc();
      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(
          status: WordSelectionStatus.solved,
          word: SelectedWord(section: (0, 0), word: _FakeWord()),
        ),
      );

      widget = BlocProvider<WordSelectionBloc>(
        create: (_) => wordSelectionBloc,
        child: WordSelectionSuccessLargeView(),
      );
    });

    testWidgets('renders word solved text', (tester) async {
      await tester.pumpApp(widget);

      expect(find.text(l10n.wordSolved), findsOneWidget);
    });

    testWidgets('renders top bar', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(SuccessTopBar), findsOneWidget);
    });

    testWidgets('renders $IoWord', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(IoWord), findsOneWidget);
    });

    testWidgets('renders success stats', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(SuccessStats), findsOneWidget);
    });

    testWidgets('renders keep playing button', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(KeepPlayingButton), findsOneWidget);
    });

    testWidgets('renders claim badge button', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(ClaimBadgeButton), findsOneWidget);
    });
  });

  group('$WordSelectionSuccessSmallView', () {
    late Widget widget;

    setUp(() {
      final wordSelectionBloc = _MockWordSelectionBloc();
      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(
          status: WordSelectionStatus.solved,
          word: SelectedWord(section: (0, 0), word: _FakeWord()),
        ),
      );

      widget = BlocProvider<WordSelectionBloc>(
        create: (_) => wordSelectionBloc,
        child: WordSelectionSuccessLargeView(),
      );
    });

    testWidgets('renders word solved text', (tester) async {
      await tester.pumpApp(widget);

      expect(find.text(l10n.wordSolved), findsOneWidget);
    });

    testWidgets('renders top bar', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(SuccessTopBar), findsOneWidget);
    });

    testWidgets('renders $IoWord', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(IoWord), findsOneWidget);
    });

    testWidgets('renders success stats', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(SuccessStats), findsOneWidget);
    });

    testWidgets('renders keep playing button', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(KeepPlayingButton), findsOneWidget);
    });

    testWidgets('renders claim badge button', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(ClaimBadgeButton), findsOneWidget);
    });
  });

  group('SuccessTopBar', () {
    late CrosswordBloc crosswordBloc;
    late Widget widget;

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();
      widget = BlocProvider.value(
        value: crosswordBloc,
        child: SuccessTopBar(),
      );
    });

    testWidgets(
      'renders a $CloseWordSelectionIconButton',
      (tester) async {
        await tester.pumpApp(widget);

        expect(find.byType(CloseWordSelectionIconButton), findsOneWidget);
      },
    );
  });

  group('KeepPlayingButton', () {
    late CrosswordBloc crosswordBloc;
    late WordSelectionBloc wordSelectionBloc;
    late Widget widget;

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
      crosswordBloc = _MockCrosswordBloc();
      widget = BlocProvider.value(
        value: crosswordBloc,
        child: KeepPlayingButton(),
      );
    });

    testWidgets(
      'adds $WordUnselected event when tapping the keep playing button',
      (tester) async {
        await tester.pumpApp(
          BlocProvider(
            create: (_) => wordSelectionBloc,
            child: widget,
          ),
        );

        await tester.tap(find.byIcon(Icons.gamepad));

        verify(() => crosswordBloc.add(const WordUnselected())).called(1);
        verify(() => wordSelectionBloc.add(const selection.WordUnselected()))
            .called(1);
      },
    );
  });

  group('ClaimBadgeButton', () {
    late UrlLauncherPlatform urlLauncher;
    late CrosswordBloc crosswordBloc;
    late Widget widget;

    setUpAll(() {
      registerFallbackValue(_FakeLaunchOptions());
    });

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();
      widget = BlocProvider.value(
        value: crosswordBloc,
        child: ClaimBadgeButton(),
      );

      urlLauncher = _MockUrlLauncherPlatform();

      UrlLauncherPlatform.instance = urlLauncher;

      when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => true);
      when(() => urlLauncher.launchUrl(any(), any()))
          .thenAnswer((_) async => true);
    });

    testWidgets(
      'launches developer profile url when tapping the claim badge button',
      (tester) async {
        await tester.pumpApp(widget);

        await tester.tap(find.byIcon(IoIcons.google));

        verify(
          () => urlLauncher.launchUrl(
            'https://io.google/2024',
            any(),
          ),
        );
      },
    );
  });

  group('$SuccessStats', () {
    late PlayerBloc playerBloc;
    late WordSelectionBloc wordSelectionBloc;
    late Widget widget;

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
      playerBloc = _MockPlayerBloc();
      widget = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: playerBloc),
          BlocProvider.value(value: wordSelectionBloc),
        ],
        child: SuccessStats(),
      );

      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(
          status: WordSelectionStatus.solved,
          word: SelectedWord(section: (0, 0), word: _FakeWord()),
          wordPoints: 10,
        ),
      );
      when(() => playerBloc.state).thenReturn(
        PlayerState(
          player: Player(
            id: 'id',
            initials: 'VGV',
            mascot: Mascots.sparky,
            score: 100,
            streak: 5,
          ),
          rank: 111222333,
        ),
      );
    });

    testWidgets('render points', (tester) async {
      await tester.pumpApp(widget);

      expect(find.text(l10n.points), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('render streak', (tester) async {
      await tester.pumpApp(widget);

      expect(find.text(l10n.streak), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('render rank', (tester) async {
      await tester.pumpApp(widget);

      expect(find.text(l10n.rank), findsOneWidget);
      expect(find.text('111M'), findsOneWidget);
    });

    testWidgets('render total score', (tester) async {
      await tester.pumpApp(widget);

      expect(find.text(l10n.totalScore), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
    });
  });
}
