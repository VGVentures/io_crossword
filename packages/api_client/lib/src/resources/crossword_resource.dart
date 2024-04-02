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

  /// Post /game/board/sections/{sectionId}/{wordPosition}
  ///
  /// Returns a [bool].
  Future<bool> answerWord({
    required BoardSection section,
    required Word word,
    required String answer,
    required Mascots mascot,
  }) async {
    final response = await _apiClient.post(
      '/game/answer',
      body: jsonEncode({
        'sectionId': '${section.position.x},${section.position.y}',
        'wordPosition': '${word.position.x},${word.position.y}',
        'answer': answer,
        'mascot': mascot.toString(),
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
      final isValidAnswer = body['valid'] as bool;
      return isValidAnswer;
    } catch (error, stackTrace) {
      throw ApiClientError(
        'POST /game/answer'
        ' returned invalid response: "${response.body}"',
        stackTrace,
      );
    }
  }
}
