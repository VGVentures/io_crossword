import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:mockingjay/mockingjay.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    MockNavigator? navigator,
  }) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: navigator != null
            ? MockNavigatorProvider(navigator: navigator, child: widget)
            : widget,
      ),
    );
  }
}
