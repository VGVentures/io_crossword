// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/app/bloc/app_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  group('AppBloc', () {
    late AuthenticationRepository authenticationRepository;
    late AppBloc bloc;

    setUp(() {
      authenticationRepository = _MockAuthenticationRepository();
      bloc = AppBloc(
        authenticationRepository: authenticationRepository,
      );
    });

    test('can be instantiated', () {
      expect(
        AppBloc(
          authenticationRepository: authenticationRepository,
        ),
        isA<AppBloc>(),
      );
    });

    group('$UserLoaded', () {
      blocTest<AppBloc, AppState>(
        'calls user',
        build: () => bloc,
        setUp: () {
          when(() => authenticationRepository.user)
              .thenAnswer((_) => Stream.value(User(id: '1234')));
        },
        act: (bloc) => bloc.add(UserLoaded()),
        verify: (bloc) {
          verify(() => authenticationRepository.user).called(1);
        },
      );

      blocTest<AppBloc, AppState>(
        'emits [success] with the updated user',
        build: () => bloc,
        setUp: () {
          when(() => authenticationRepository.user)
              .thenAnswer((_) => Stream.value(User(id: '1234')));
        },
        act: (bloc) => bloc.add(UserLoaded()),
        expect: () => [
          AppState(
            status: AppStatus.success,
            user: User(id: '1234'),
          ),
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits [success] with the updated user and mascot remains seeded',
        seed: () => AppState(
          mascot: Mascots.sparky,
        ),
        build: () => bloc,
        setUp: () {
          when(() => authenticationRepository.user)
              .thenAnswer((_) => Stream.value(User(id: '1234')));
        },
        act: (bloc) => bloc.add(UserLoaded()),
        expect: () => [
          AppState(
            status: AppStatus.success,
            user: User(id: '1234'),
            mascot: Mascots.sparky,
          ),
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits [failure] when user fails',
        build: () => bloc,
        setUp: () {
          when(() => authenticationRepository.user)
              .thenAnswer((_) => Stream.error(Exception()));
        },
        act: (bloc) => bloc.add(UserLoaded()),
        expect: () => [
          AppState(
            status: AppStatus.failure,
          ),
        ],
      );
    });

    group('$LogOutUser', () {
      blocTest<AppBloc, AppState>(
        'calls user',
        build: () => bloc,
        setUp: () {
          when(() => authenticationRepository.signOut())
              .thenAnswer((_) async {});
        },
        act: (bloc) => bloc.add(LogOutUser()),
        verify: (bloc) {
          verify(() => authenticationRepository.signOut()).called(1);
        },
      );

      blocTest<AppBloc, AppState>(
        'emits [initial] when logged out correctly',
        seed: () => AppState(
          status: AppStatus.success,
          user: User(id: '1234'),
          mascot: Mascots.sparky,
        ),
        build: () => bloc,
        setUp: () {
          when(() => authenticationRepository.signOut())
              .thenAnswer((_) async {});
        },
        act: (bloc) => bloc.add(LogOutUser()),
        expect: () => [
          AppState(),
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits [failure] when signOut fails',
        seed: () => AppState(
          status: AppStatus.success,
          user: User(id: '1234'),
          mascot: Mascots.sparky,
        ),
        build: () => bloc,
        setUp: () {
          when(() => authenticationRepository.signOut()).thenThrow(Exception());
        },
        act: (bloc) => bloc.add(LogOutUser()),
        expect: () => [
          AppState(
            status: AppStatus.failure,
            user: User(id: '1234'),
            mascot: Mascots.sparky,
          ),
        ],
      );
    });
  });
}
