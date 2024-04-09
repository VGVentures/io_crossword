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

/// {@template initials_word_changed}
/// The word that the user has entered has changed.
/// {@endtemplate}
class InitialsChanged extends InitialsEvent {
  /// {@macro initials_word_changed}
  const InitialsChanged(this.initials);

  /// The new word that the user has entered to be its initials.
  final String initials;

  @override
  List<Object> get props => [initials];
}

/// {@template initials_submitted}
/// The user has submitted their initials.
/// {@endtemplate}
class InitialsSubmitted extends InitialsEvent {
  /// {@macro initials_submitted}
  const InitialsSubmitted();
}
