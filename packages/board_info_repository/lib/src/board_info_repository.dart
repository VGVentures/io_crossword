import 'package:cloud_firestore/cloud_firestore.dart';

/// {@template board_info_exception}
/// An exception to throw when there is an error fetching the board info.
/// {@endtemplate}
class BoardInfoException implements Exception {
  /// {@macro board_info_exception}
  const BoardInfoException(this.error, this.stackTrace);

  /// The error that was caught.
  final Object error;

  /// The stack trace associated with the error.
  final StackTrace stackTrace;

  @override
  String toString() => error.toString();
}

/// {@template board_info_repository}
/// A repository to manage the general board information and parameters
/// {@endtemplate}
class BoardInfoRepository {
  /// {@macro board_info_repository}
  BoardInfoRepository({
    required this.firestore,
  }) {
    boardInfoCollection = firestore.collection('boardInfo');
  }

  /// The [FirebaseFirestore] instance.
  final FirebaseFirestore firestore;

  /// The [CollectionReference] for the config.
  late final CollectionReference<Map<String, dynamic>> boardInfoCollection;

  /// Returns the total words count available in the crossword.
  Future<int> getTotalWordsCount() async {
    try {
      final results = await boardInfoCollection
          .where('type', isEqualTo: 'total_words_count')
          .get();

      final data = results.docs.first.data();
      return data['value'] as int;
    } catch (error, stackStrace) {
      throw BoardInfoException(error, stackStrace);
    }
  }

  /// Returns the solved words count in the crossword.
  Future<int> getSolvedWordsCount() async {
    try {
      final results = await boardInfoCollection
          .where('type', isEqualTo: 'solved_words_count')
          .get();

      final data = results.docs.first.data();
      return data['value'] as int;
    } catch (error, stackStrace) {
      throw BoardInfoException(error, stackStrace);
    }
  }

  /// Returns the limit at which the render mode should switch
  Future<List<double>> getRenderModeZoomLimits() async {
    try {
      final results = await boardInfoCollection
          .where('type', isEqualTo: 'render_mode_limit')
          .get();

      return results.docs.map((e) => e.data()['value'] as double).toList();
    } catch (error, stackStrace) {
      throw BoardInfoException(error, stackStrace);
    }
  }
}
