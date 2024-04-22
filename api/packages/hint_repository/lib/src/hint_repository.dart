import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:hint_repository/hint_repository.dart';

/// {@template hint_repository}
/// A repository to handle the hints.
/// {@endtemplate}
class HintRepository {
  /// {@macro hint_repository}
  const HintRepository({
    required DbClient dbClient,
  }) : _dbClient = dbClient;

  final DbClient _dbClient;

  static const _answersCollection = 'answers';
  static const _hintsCollection = 'hints';
  static const _boardInfoCollection = 'boardInfo';

  static const _defaultMaxHints = 10;

  String _hintsPath(String wordId) =>
      '$_answersCollection/$wordId/$_hintsCollection';

  /// Returns the maximum hints allowed for a word.
  Future<int> getMaxHints() async {
    try {
      final results = await _dbClient.findBy(
        _boardInfoCollection,
        'type',
        'max_hints',
      );

      final data = results.first.data;
      return (data['value'] as num).toInt();
    } catch (_) {
      return _defaultMaxHints;
    }
  }

  /// Generates a new hint for the given word, having the context from previous
  /// hints.
  Future<Hint> generateHint({
    required String wordAnswer,
    required String question,
    required List<Hint> previousHints,
  }) async {
    // TODO(jaime): Call the hint generation service.
    final hint = Hint(
      question: question,
      response: HintResponse.yes,
    );

    return hint;
  }

  /// Fetches the previous asked hints for the given word.
  Future<List<Hint>> getPreviousHints({
    required String userId,
    required String wordId,
  }) async {
    try {
      final hintDoc = await _dbClient.getById(_hintsPath(wordId), userId);
      if (hintDoc == null) {
        return [];
      }

      final hintsData = hintDoc.data['hints'] as List<dynamic>;
      final hints = hintsData
          .map((element) => Hint.fromJson(element as Map<String, dynamic>))
          .toList();
      return hints;
    } catch (e, stackTrace) {
      final message = 'Error getting previous hints for word $wordId '
          'by user $userId: $e';
      throw HintException(message, stackTrace);
    }
  }

  /// Saves the hints for the given word.
  Future<void> saveHints({
    required String userId,
    required String wordId,
    required List<Hint> hints,
  }) async {
    try {
      await _dbClient.set(
        _hintsPath(wordId),
        DbEntityRecord(
          id: userId,
          data: {
            'hints': hints.map((e) => e.toJson()).toList(),
          },
        ),
      );
    } catch (e, stackTrace) {
      final message = 'Error saving hints for word $wordId by user $userId: $e';
      throw HintException(message, stackTrace);
    }
  }
}
