// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/app/bloc/app_bloc.dart';

void main() {
  group('$AppState', () {
    test('supports value comparisons', () {
      expect(
        AppState(
          user: User(id: '123'),
          mascot: Mascots.sparky,
          status: AppStatus.failure,
        ),
        equals(
          AppState(
            user: User(id: '123'),
            mascot: Mascots.sparky,
            status: AppStatus.failure,
          ),
        ),
      );

      expect(
        AppState(status: AppStatus.failure),
        isNot(equals(AppState())),
      );

      expect(
        AppState(user: User(id: '123')),
        isNot(equals(AppState())),
      );

      expect(
        AppState(mascot: Mascots.sparky),
        isNot(equals(AppState())),
      );
    });

    group('copyWith', () {
      test('updates status', () {
        expect(
          AppState().copyWith(status: AppStatus.failure),
          equals(AppState(status: AppStatus.failure)),
        );
      });

      test('updates mascot', () {
        expect(
          AppState().copyWith(mascot: Mascots.sparky),
          equals(AppState(mascot: Mascots.sparky)),
        );
      });

      test('updates user', () {
        expect(
          AppState().copyWith(user: User(id: '123')),
          equals(AppState(user: User(id: '123'))),
        );
      });
    });
  });
}
