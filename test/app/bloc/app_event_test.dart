// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/app/app.dart';

void main() {
  group('$AppEvent', () {
    group('$UserLoaded', () {
      test('supports equality', () {
        expect(UserLoaded(), equals(UserLoaded()));
      });
    });

    group('$LogOutUser', () {
      test('supports equality', () {
        expect(LogOutUser(), equals(LogOutUser()));
      });
    });
  });
}
