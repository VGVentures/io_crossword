import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:hint_repository/hint_repository.dart';

/// {@template hint_repository}
/// A repository to handle the hints.
/// {@endtemplate}
class HintRepository {
  /// {@macro hint_repository}
  HintRepository({
    required DbClient dbClient,
    required GenerativeModelWrapper generativeModelWrapper,
  })  : _dbClient = dbClient,
        _generativeModel = generativeModelWrapper;

  final DbClient _dbClient;
  final GenerativeModelWrapper _generativeModel;

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
    final context = previousHints
        .map((e) => '${e.question}: ${e.response.name}')
        .join(', ');
    final contextPrompt = previousHints.isEmpty
        ? ''
        : "The questions I've been asked so far with their "
            'corresponding answers are: $context.';

    final prompt = 'I am solving a crossword puzzle and you are a helpful '
        'agent that can answer only yes or no questions to assist me in '
        'guessing what the word is I am trying to identify for a given clue. '
        'Crossword words can be subjective and use plays on words so be '
        'liberal with your answers meaning if you think saying "yes" will '
        'help me guess the word even if technically the answer is "no", '
        'say "yes". If you think saying "no" will help me guess the word even '
        'if technically the answer is "yes", say "no". If you think saying '
        '"yes" or "no" will not help me guess the word even if technically '
        'the answer is "yes" or "no", say "notApplicable". If you think the '
        'question is offensive or not appropriate for the game, '
        'say "notApplicable".\nThe word I am trying to guess is "$wordAnswer", '
        'and the question I\'ve been given is "$question". $contextPrompt';

    try {
      final response = await _generativeModel.generateTextContent(prompt);
      final hintResponse = HintResponse.values.firstWhere(
        (element) => element.name == response,
        orElse: () => HintResponse.notApplicable,
      );

      final hint = Hint(
        question: question,
        response: hintResponse,
      );
      return hint;
    } catch (e, stackTrace) {
      final message = 'Error generating hint for word $wordAnswer '
          'with question $question: $e';
      throw HintException(message, stackTrace);
    }
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
