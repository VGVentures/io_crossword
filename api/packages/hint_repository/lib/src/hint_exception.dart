import 'package:hint_repository/hint_repository.dart';

/// {@template hint_exception}
/// Exception thrown when an error occurs in the [HintRepository].
/// {@endtemplate}
class HintException implements Exception {
  /// {@macro hint_exception}
  HintException(this.cause, this.stackTrace);

  /// Error cause.
  final dynamic cause;

  /// The stack trace of the error.
  final StackTrace stackTrace;

  @override
  String toString() {
    return '''
cause: $cause
stackTrace: $stackTrace
''';
  }
}
