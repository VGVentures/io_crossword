import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    CrosswordRepository? crosswordRepository,
    MockNavigator? navigator,
  }) {
    return pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(
            value: crosswordRepository ?? _MockCrosswordRepository(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: navigator != null
              ? MockNavigatorProvider(navigator: navigator, child: widget)
              : widget,
        ),
      ),
    );
  }
}

extension PumpRoute on WidgetTester {
  Future<void> pumpRoute(
    Route<dynamic> route, {
    MockNavigator? navigator,
  }) async {
    final widget = Center(
      child: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(route);
            },
            child: const Text('Push Route'),
          );
        },
      ),
    );
    await pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: navigator != null
            ? MockNavigatorProvider(navigator: navigator, child: widget)
            : widget,
      ),
    );
    await tap(find.text('Push Route'));
    await pump();
  }
}
