part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class UserLoaded extends AppEvent {
  const UserLoaded();

  @override
  List<Object?> get props => [];
}

class LogOutUser extends AppEvent {
  const LogOutUser();

  @override
  List<Object?> get props => [];
}
