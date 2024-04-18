import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';

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
    required String wordId,
    required String answer,
  }) async {
    final response = await _apiClient.post(
      '/game/answer',
      body: jsonEncode({
        'wordId': wordId,
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
