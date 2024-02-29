// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/loading/loading.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockImages extends Mock implements Images {}

class _MockAudioCache extends Mock implements AudioCache {}

void main() {
  group('LoadingPage', () {
    late PreloadCubit preloadCubit;
    late Widget widget;
    late _MockImages images;
    late _MockAudioCache audio;

    setUp(() {
      preloadCubit = PreloadCubit(
        images = _MockImages(),
        audio = _MockAudioCache(),
      );
      widget = BlocProvider.value(
        value: preloadCubit,
        child: LoadingPage(),
      );

      when(() => images.loadAll(any())).thenAnswer((_) async => <Image>[]);

      when(() => audio.loadAll([])).thenAnswer(
        (_) async => [],
      );
    });

    testWidgets('basic layout', (tester) async {
      await tester.pumpApp(widget);

      expect(find.byType(AnimatedProgressBar), findsOneWidget);
      expect(find.textContaining('Loading'), findsOneWidget);

      await tester.pumpAndSettle(Duration(seconds: 1));
    });

    testWidgets('loading text', (tester) async {
      Text textWidgetFinder() {
        return find.textContaining('Loading').evaluate().first.widget as Text;
      }

      await tester.pumpApp(
        BlocProvider.value(
          value: preloadCubit,
          child: LoadingPage(),
        ),
      );

      expect(textWidgetFinder().data, 'Loading  ...');

      unawaited(preloadCubit.loadSequentially());

      await tester.pump();

      expect(textWidgetFinder().data, 'Loading Delightful music...');
      await tester.pump(const Duration(milliseconds: 200));

      expect(textWidgetFinder().data, 'Loading Beautiful scenery...');

      /// flush animation timers
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('redirects after loading', (tester) async {
      final navigator = MockNavigator();
      when(navigator.canPop).thenReturn(true);
      when(() => navigator.pushReplacement<void, void>(any()))
          .thenAnswer((_) async {});

      await tester.pumpApp(
        widget,
        navigator: navigator,
      );

      unawaited(preloadCubit.loadSequentially());

      await tester.pump(const Duration(milliseconds: 800));

      await tester.pumpAndSettle();

      verify(() => navigator.pushReplacement<void, void>(any())).called(1);
    });
  });
}
