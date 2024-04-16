import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:game_domain/game_domain.dart';

/// {@template leaderboard_resource}
/// An api resource for interacting with the leaderboard.
/// {@endtemplate}
class LeaderboardResource {
  /// {@macro leaderboard_resource}
  LeaderboardResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Get /game/leaderboard/results
  ///
  /// Returns a list of [Player].
  Future<List<Player>> getLeaderboardResults() async {
    final response = await _apiClient.get('/game/leaderboard/results');

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'GET /leaderboard/results returned status ${response.statusCode} '
        'with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final leaderboardPlayers = json['leaderboardPlayers'] as List;

      return leaderboardPlayers
          .map(
            (json) => Player.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (error, stackTrace) {
      throw ApiClientError(
        'GET /leaderboard/results returned invalid response "${response.body}"',
        stackTrace,
      );
    }
  }

  /// Get /game/leaderboard/initials_blacklist
  ///
  /// Returns a [List<String>].
  Future<List<String>> getInitialsBlacklist() async {
    final response =
        await _apiClient.get('/game/leaderboard/initials_blacklist');

    if (response.statusCode == HttpStatus.notFound) {
      return [];
    }

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'GET /leaderboard/initials_blacklist returned status '
        '${response.statusCode} with the following response: '
        '"${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return (json['list'] as List).cast<String>();
    } catch (error, stackTrace) {
      throw ApiClientError(
        'GET /leaderboard/initials_blacklist '
        'returned invalid response "${response.body}"',
        stackTrace,
      );
    }
  }

  /// Post /game/leaderboard/initials
  Future<void> addLeaderboardPlayer({
    required Player leaderboardPlayer,
  }) async {
    final response = await _apiClient.post(
      '/game/leaderboard/initials',
      body: jsonEncode(leaderboardPlayer.toJson()),
    );

    if (response.statusCode != HttpStatus.noContent) {
      throw ApiClientError(
        'POST /leaderboard/initials returned status ${response.statusCode} '
        'with the following response: "${response.body}"',
        StackTrace.current,
      );
    }
  }

  /// Post /game/leaderboard/create_score
  Future<void> createScore({
    required String initials,
    required Mascots mascot,
  }) async {
    final response = await _apiClient.post(
      '/game/create_score',
      body: jsonEncode({
        'initials': initials,
        'mascot': mascot.name,
      }),
    );

    if (response.statusCode != HttpStatus.created) {
      throw ApiClientError(
        'POST /game/create_score returned status ${response.statusCode} '
        'with the following response: "${response.body}"',
        StackTrace.current,
      );
    }
  }
}
