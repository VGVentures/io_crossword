import 'dart:convert';
import 'dart:io';

import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:hint_repository/hint_repository.dart';
import 'package:http/http.dart' as http;

/// {@template hint_repository}
/// A repository to handle the hints.
/// {@endtemplate}
class HintRepository {
  /// {@macro hint_repository}
  HintRepository({
    required DbClient dbClient,
    http.Client? httpClient,
  })  : _dbClient = dbClient,
        _httpClient = httpClient ?? http.Client();

  final DbClient _dbClient;
  final http.Client _httpClient;

  static const _answersCollection = 'answers';
  static const _hintsCollection = 'hints';
  static const _boardInfoCollection = 'boardInfo';

  static const _defaultMaxHints = 10;

  String _hintsPath(String wordId) =>
      '$_answersCollection/$wordId/$_hintsCollection';

  /// Returns whether the hint feature is enabled.
  Future<bool> isHintsEnabled() async {
    try {
      final results = await _dbClient.findBy(
        _boardInfoCollection,
        'type',
        'is_hints_enabled',
      );

      final data = results.first.data;
      return data['value'] as bool;
    } catch (_) {
      return false;
    }
  }

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
    required String userToken,
  }) async {
    try {
      final url = Uri.https('gethintkit-sea6y22h5q-uc.a.run.app');
      final body = jsonEncode({
        'word': wordAnswer,
        'question': question,
        'context': previousHints
            .map((e) => {'question': e.question, 'answer': e.response.name})
            .toList(),
      });
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $userToken',
      };

      final response = await _httpClient.post(
        url,
        body: body,
        headers: headers,
      );

      final textResponse = response.body;
      final hintResponse = HintResponse.values.firstWhere(
        (element) => element.name == textResponse,
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
