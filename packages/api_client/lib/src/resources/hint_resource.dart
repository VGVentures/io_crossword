import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:game_domain/game_domain.dart';

/// {@template hint_resource}
/// An api resource for interacting with the hints.
/// {@endtemplate}
class HintResource {
  /// {@macro hint_resource}
  HintResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Post /game/hint
  ///
  /// Generates a [Hint] for the provided word by answering to the question.
  Future<(Hint, int)> generateHint({
    required String wordId,
    required String question,
  }) async {
    const path = '/game/hint';
    final response = await _apiClient.post(
      path,
      body: jsonEncode({
        'wordId': wordId,
        'question': question,
      }),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'POST $path returned status ${response.statusCode} '
        'with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final hint = Hint.fromJson(body['hint'] as Map<String, dynamic>);
      final maxHints = (body['maxHints'] as num).toInt();
      return (hint, maxHints);
    } catch (error, stackTrace) {
      throw ApiClientError(
        'POST $path returned invalid response: "${response.body}"',
        stackTrace,
      );
    }
  }

  /// Get /game/hint
  ///
  /// Fetches all the hints for the provided word.
  Future<(List<Hint>, int)> getHints({
    required String wordId,
  }) async {
    const path = '/game/hint';
    final response = await _apiClient.get(
      path,
      queryParameters: {
        'wordId': wordId,
      },
    );

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'GET $path returned status ${response.statusCode} '
        'with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final hints = (body['hints'] as List)
          .map((hint) => Hint.fromJson(hint as Map<String, dynamic>))
          .toList();
      final maxHints = (body['maxHints'] as num).toInt();
      return (hints, maxHints);
    } catch (error, stackTrace) {
      throw ApiClientError(
        'GET $path returned invalid response: "${response.body}"',
        stackTrace,
      );
    }
  }
}
