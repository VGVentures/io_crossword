part of 'initials_bloc.dart';

enum InitialsStatus {
  /// The blocklist of initials has not been fetched yet.
  initial,

  /// The blocklist of initials is being fetched.
  loading,

  /// The blocklist of initials has been fetched successfully.
  success,

  /// An error occurred while fetching the blocklist of initials.
  failure,
}

enum InitialsInputError {
  /// The given initials are in an invalid format.
  invalid,

  /// The given initials are not allowed.
  blocklisted,
}

class InitialsInput extends FormzInput<String, InitialsInputError> {
  InitialsInput.pure({
    required this.blocklist,
  }) : super.pure('');

  final _initialsRegex = RegExp('[A-Z]{3}');

  /// Collection of initials that are not allowed.
  ///
  /// `null` if the blocklist has not been fetched.
  final UnmodifiableSetView<String> blocklist;

  @override
  InitialsInputError? validator(String value) {
    if (value.isEmpty || value.length != 3 || !_initialsRegex.hasMatch(value)) {
      return InitialsInputError.invalid;
    }

    if (blocklist.contains(value)) {
      return InitialsInputError.blocklisted;
    }

    return null;
  }
}

class InitialsState extends Equatable {
  const InitialsState({
    required this.status,
    required this.initials,
  });

  const InitialsState.initial()
      : this(
          initials: null,
          status: InitialsStatus.initial,
        );

  final InitialsStatus status;

  /// The initials that have been entered.
  ///
  /// If `null` the initials can't be entered yet, since the blocklist has not
  /// been fetched.
  final InitialsInput? initials;

  InitialsState copyWith({
    InitialsInput? initials,
    InitialsStatus? status,
  }) {
    return InitialsState(
      status: status ?? this.status,
      initials: initials ?? this.initials,
    );
  }

  @override
  List<Object?> get props => [status, initials];
}
