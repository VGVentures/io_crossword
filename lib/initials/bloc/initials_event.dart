part of 'initials_bloc.dart';

sealed class InitialsEvent extends Equatable {
  const InitialsEvent();

  @override
  List<Object> get props => [];
}

/// {@template initials_blocklist_requested}
/// Requests the blocklist of initials that are not allowed.
/// {@endtemplate}
class InitialsBlocklistRequested extends InitialsEvent {
  /// {@macro initials_blocklist_requested}
  const InitialsBlocklistRequested();
}
