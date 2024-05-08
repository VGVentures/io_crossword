part of 'app_bloc.dart';

enum AppStatus {
  initial,
  success,
  failure,
}

class AppState extends Equatable {
  const AppState({
    this.status = AppStatus.initial,
    this.user = User.unauthenticated,
    this.mascot,
  });

  final AppStatus status;
  final User user;
  final Mascots? mascot;

  AppState copyWith({
    AppStatus? status,
    User? user,
    Mascots? mascot,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      mascot: mascot ?? this.mascot,
    );
  }

  @override
  List<Object?> get props => [status, user, mascot];
}
