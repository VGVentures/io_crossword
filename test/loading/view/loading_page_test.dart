// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/loading/loading.dart';
import 'package:io_crossword/welcome/welcome.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockLoadingCubit extends Mock implements LoadingCubit {}

void main() {
  group('$LoadingPage', () {
    testWidgets('renders LoadingView', (tester) async {
      await tester.pumpSubject(const LoadingPage());

      expect(find.byType(LoadingView), findsOneWidget);
    });
  });

  group('$LoadingView', () {
    testWidgets(
      'displays a $LoadingLarge and $LoadingBody when layout is large',
      (tester) async {
        await tester.pumpSubject(
          const IoLayout(
            data: IoLayoutData.large,
            child: LoadingView(),
          ),
        );

        expect(find.byType(LoadingLarge), findsOneWidget);
        expect(find.byType(LoadingBody), findsOneWidget);
      },
    );

    testWidgets(
      'displays a $LoadingSmall and $LoadingBody when layout is large',
      (tester) async {
        await tester.pumpSubject(
          const IoLayout(
            data: IoLayoutData.small,
            child: LoadingView(),
          ),
        );

        expect(find.byType(LoadingSmall), findsOneWidget);
        expect(find.byType(LoadingBody), findsOneWidget);
      },
    );
  });

  group('$LoadingLarge', () {
    group('displays', () {
      testWidgets('an $IoAppBar', (tester) async {
        await tester.pumpSubject(const LoadingLarge());
        expect(find.byType(IoAppBar), findsOneWidget);
      });
    });
  });

  group('$LoadingSmall', () {
    group('displays', () {
      testWidgets('an $IoAppBar', (tester) async {
        await tester.pumpSubject(const LoadingSmall());
        expect(find.byType(IoAppBar), findsOneWidget);
      });

      testWidgets('a $WelcomeHeaderImage', (tester) async {
        await tester.pumpSubject(const LoadingSmall());
        expect(find.byType(WelcomeHeaderImage), findsOneWidget);
      });
    });
  });

  group('$LoadingBody', () {
    testWidgets(
      'updates flow when loading is complete',
      (tester) async {
        final flowController = FlowController(GameIntroStatus.loading);
        addTearDown(flowController.dispose);

        final loadingCubit = _MockLoadingCubit();

        whenListen(
          loadingCubit,
          Stream.fromIterable(
            [
              LoadingState(
                status: LoadingStatus.loaded,
                assetsCount: 8,
                loaded: 8,
              ),
            ],
          ),
          initialState: const LoadingState.initial(),
        );

        await tester.pumpSubject(
          FlowBuilder<GameIntroStatus>(
            controller: flowController,
            onGeneratePages: (_, __) => [
              const MaterialPage(child: LoadingBody()),
            ],
          ),
          loadingCubit: loadingCubit,
        );

        expect(
          flowController.state,
          equals(GameIntroStatus.welcome),
        );
      },
    );

    group('displays', () {
      testWidgets('a localized welcome text', (tester) async {
        late final AppLocalizations l10n;
        await tester.pumpSubject(
          Builder(
            builder: (context) {
              l10n = context.l10n;
              return const LoadingBody();
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
              return const LoadingBody();
            },
          ),
        );

        expect(find.text(l10n.welcomeSubtitle), findsOneWidget);
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    Widget child, {
    LoadingCubit? loadingCubit,
  }) {
    final cubit = loadingCubit ?? _MockLoadingCubit();
    if (loadingCubit == null) {
      whenListen(
        cubit,
        const Stream<LoadingState>.empty(),
        initialState: const LoadingState.initial(),
      );

      when(cubit.close).thenAnswer((_) => Future.value());
    }

    return pumpApp(
      BlocProvider.value(
        value: cubit,
        child: child,
      ),
    );
  }
}
