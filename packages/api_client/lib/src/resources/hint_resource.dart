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
  /// Returns a [Hint].
  Future<Hint> getHint({
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
      final hint = Hint.fromJson(body);
      return hint;
    } catch (error, stackTrace) {
      throw ApiClientError(
        'POST $path returned invalid response: "${response.body}"',
        stackTrace,
      );
    }
  }
}
