// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/drawer/bloc/drawer_bloc.dart';

void main() {
  group('DrawerEvent', () {
    group('$RecordDataRequested', () {
      test('can be instantiated', () {
        expect(RecordDataRequested(), isA<DrawerEvent>());
      });

      test('supports value equality', () {
        expect(RecordDataRequested(), RecordDataRequested());
      });
    });
  });
}
