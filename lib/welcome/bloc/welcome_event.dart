part of 'welcome_bloc.dart';

sealed class WelcomeEvent extends Equatable {
  const WelcomeEvent();

  @override
  List<Object> get props => [];
}

/// Requests the data needed to welcome the user.
class WelcomeDataRequested extends WelcomeEvent {
  const WelcomeDataRequested();
}
