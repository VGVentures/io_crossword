import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AppState()) {
    on<UserLoaded>(_onUserLoaded);
    on<LogOutUser>(_onLogOutUser);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onUserLoaded(
    UserLoaded event,
    Emitter<AppState> emit,
  ) {
    return emit.forEach(
      _authenticationRepository.user,
      onData: (user) {
        return state.copyWith(
          status: AppStatus.success,
          user: user,
        );
      },
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        return state.copyWith(
          status: AppStatus.failure,
        );
      },
    );
  }

  Future<void> _onLogOutUser(
    LogOutUser event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _authenticationRepository.signOut();

      emit(const AppState());
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          status: AppStatus.failure,
        ),
      );
    }
  }
}
