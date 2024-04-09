part of 'initials_bloc.dart';

/// Collection of initials that are not allowed.
typedef Blocklist = UnmodifiableSetView<String>;

enum InitialsStatus {
  /// The initials are yet to be entered.
  initial,

  /// The initials have been submitted and are processed.
  loading,

  /// The initials have been successfully processed.
  success,

  /// An error occurred while processing the initials.
  failure,
}

enum InitialsInputError {
  /// The given initials are in an invalid format.
  format,

  /// The given initials are not allowed.
  blocklisted,

  /// The given initials could not be processed, since
  /// the blocklist has not been retrieved yet.
  processing,
}

// TODO(alestiago): Consider sharing this with the backend.
class InitialsInput extends FormzInput<String, InitialsInputError> {
  InitialsInput.pure(
    super.value, {
    this.blocklist,
  }) : super.pure();

  InitialsInput.dirty(
    super.value, {
    this.blocklist,
  }) : super.dirty();

  final _initialsRegex = RegExp('[A-Z]{3}');

  /// Collection of initials that are not allowed.
  ///
  /// If `null`, the blocklist has not been retrieved yet.
  final Blocklist? blocklist;

  InitialsInput copyWith({
    String? value,
    Blocklist? blocklist,
  }) {
    final newValue = value ?? this.value;
    final newBlocklist = blocklist ?? this.blocklist;

    if (isPure) {
      return InitialsInput.pure(newValue, blocklist: newBlocklist);
    } else {
      return InitialsInput.dirty(newValue, blocklist: newBlocklist);
    }
  }

  @override
  InitialsInputError? validator(String value) {
    if (value.isEmpty || value.length != 3 || !_initialsRegex.hasMatch(value)) {
      return InitialsInputError.format;
    }

    if (blocklist == null) {
      return InitialsInputError.processing;
    }

    if (blocklist!.contains(value)) {
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

  InitialsState.initial()
      : this(
          status: InitialsStatus.initial,
          initials: InitialsInput.pure(''),
        );

  final InitialsStatus status;

  /// The initials that have been entered.
  final InitialsInput initials;

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
