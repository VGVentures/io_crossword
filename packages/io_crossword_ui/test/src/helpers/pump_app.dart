import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    IoLayoutData layout = IoLayoutData.small,
  }) {
    return pumpWidget(
      MaterialApp(
        home: IoLayout(
          data: layout,
          child: Scaffold(
            body: widget,
          ),
        ),
      ),
    );
  }
}
