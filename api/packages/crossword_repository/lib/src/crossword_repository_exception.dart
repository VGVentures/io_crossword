import 'package:crossword_repository/crossword_repository.dart';

/// {@template crossword_repository_exception}
/// Exception thrown when an error occurs in the [CrosswordRepository].
/// {@endtemplate}
class CrosswordRepositoryException implements Exception {
  /// {@macro crossword_repository_exception}
  CrosswordRepositoryException(this.cause, this.stackTrace);

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
