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

/// {@template crossword_repository_bad_request_exception}
/// Exception thrown when a bad request is made to the [CrosswordRepository].
/// {@endtemplate}
class CrosswordRepositoryBadRequestException
    extends CrosswordRepositoryException {
  /// {@macro crossword_repository_bad_request_exception}
  CrosswordRepositoryBadRequestException(super.cause, super.stackTrace);
}
