import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:game_domain/game_domain.dart';

/// {@template crossword_resource}
/// An api resource for interacting with the crossword.
/// {@endtemplate}
class CrosswordResource {
  /// {@macro crossword_resource}
  CrosswordResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Post /game/answer
  ///
  /// Returns a [bool].
  Future<int> answerWord({
    required (int, int) section,
    required Word word,
    required String answer,
  }) async {
    final response = await _apiClient.post(
      '/game/answer',
      body: jsonEncode({
        'sectionId': '${section.$1},${section.$2}',
        'wordId': word.id,
        'answer': answer,
      }),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'POST /game/answer'
        ' returned status ${response.statusCode} '
        'with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final points = body['points'] as int;
      return points;
    } catch (error, stackTrace) {
      throw ApiClientError(
        'POST /game/answer'
        ' returned invalid response: "${response.body}"',
        stackTrace,
      );
    }
  }
}
