part of 'initials_bloc.dart';

class InitialsState {
  const InitialsState({
    required this.initials,
  });

  InitialsState.initial()
      : this(
          initials: InitialsInput.pure(''),
        );

  /// The initials that have been entered.
  final InitialsInput initials;

  InitialsState copyWith({
    InitialsInput? initials,
  }) {
    return InitialsState(
      initials: initials ?? this.initials,
    );
  }
}
