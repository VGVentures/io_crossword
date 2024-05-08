import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

/// {@template game_status}
/// The status of the game.
/// {@endtemplate}
enum GameStatus {
  /// The game is in progress.
  inProgress('in_progress'),

  /// The game is completed and in the process of resetting.
  resetInProgress('reset_in_progress');

  /// {@macro game_status}
  const GameStatus(this.value);

  /// The String value of the status.
  final String value;

  /// Converts the [value] to a [GameStatus].
  static GameStatus fromString(String value) => values.firstWhere(
        (element) => element.value == value,
        orElse: () => inProgress,
      );
}

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

  BehaviorSubject<bool>? _hintsEnabled;

  /// Returns the total words count available in the crossword.
  Stream<int> getTotalWordsCount() {
    try {
      return boardInfoCollection
          .where('type', isEqualTo: 'total_words_count')
          .snapshots()
          .map((event) => (event.docs.first.data()['value'] as num).toInt());
    } catch (error, stackStrace) {
      throw BoardInfoException(error, stackStrace);
    }
  }

  /// Returns the solved words count in the crossword.
  Stream<int> getSolvedWordsCount() {
    try {
      return boardInfoCollection
          .where('type', isEqualTo: 'solved_words_count')
          .snapshots()
          .map((event) => (event.docs.first.data()['value'] as num).toInt());
    } catch (error, stackStrace) {
      throw BoardInfoException(error, stackStrace);
    }
  }

  /// Return the solved words count in the crossword.
  Future<int> getSectionSize() async {
    try {
      final results = await boardInfoCollection
          .where('type', isEqualTo: 'section_size')
          .get();

      final data = results.docs.first.data();
      return (data['value'] as num).toInt();
    } catch (error, stackStrace) {
      throw BoardInfoException(error, stackStrace);
    }
  }

  /// Returns the limit at which the render mode should switch
  Future<double> getZoomLimit() async {
    try {
      final results = await boardInfoCollection
          .where('type', isEqualTo: 'zoom_limit')
          .get();

      final data = results.docs.first.data();
      return (data['value'] as num).toDouble();
    } catch (error, stackStrace) {
      throw BoardInfoException(error, stackStrace);
    }
  }

  /// Returns the hints enabled status.
  Stream<bool> isHintsEnabled() {
    if (_hintsEnabled != null) return _hintsEnabled!.stream;

    _hintsEnabled = BehaviorSubject<bool>();

    boardInfoCollection
        .where('type', isEqualTo: 'is_hints_enabled')
        .snapshots()
        .map((snapshot) {
          final docs = snapshot.docs;
          // If the flag is not found, we assume it is disabled.
          if (docs.isEmpty) return false;

          final isHintsEnabled = docs.first.data()['value'] as bool;
          return isHintsEnabled;
        })
        .listen(_hintsEnabled!.add)
        .onError(_hintsEnabled!.addError);

    return _hintsEnabled!.stream;
  }

  /// Returns the status of the game.
  Stream<GameStatus> getGameStatus() {
    try {
      return boardInfoCollection
          .where('type', isEqualTo: 'game_status')
          .snapshots()
          .map(
            (event) => GameStatus.fromString(
              event.docs.first.data()['value'] as String,
            ),
          );
    } catch (error, stackStrace) {
      throw BoardInfoException(error, stackStrace);
    }
  }
}
