import 'dart:collection';

import 'package:formz/formz.dart';

/// Collection of initials that are not allowed.
typedef Blocklist = UnmodifiableSetView<String>;

/// Error that can occur when validating initials.
enum InitialsInputError {
  /// The given initials are in an invalid format.
  format,

  /// The given initials are not allowed.
  blocklisted,

  /// The given initials could not be processed, since
  /// the blocklist has not been retrieved yet.
  processing,
}

/// {@template initials_input}
/// Stores the user initials and its validation.
/// {@endtemplate}
class InitialsInput extends FormzInput<String, InitialsInputError> {
  /// {@macro initials_input}
  InitialsInput.pure(
    super.value, {
    this.blocklist,
  }) : super.pure();

  /// {@macro initials_input}
  InitialsInput.dirty(
    super.value, {
    this.blocklist,
  }) : super.dirty();

  final _initialsRegex = RegExp('[A-Z]{3}');

  /// Collection of initials that are not allowed.
  ///
  /// If `null`, the blocklist has not been retrieved yet.
  final Blocklist? blocklist;

  /// Returns a copy of the instance with the given fields replaced with
  /// the new values.
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
