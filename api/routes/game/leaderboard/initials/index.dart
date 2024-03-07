import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final leaderboardRepository = context.read<LeaderboardRepository>();

    final json = await context.request.json() as Map<String, dynamic>;

    LeaderboardPlayer player;

    try {
      player = LeaderboardPlayer.fromJson(json);
    } catch (error) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final initials = player.initials;

    if (player.initials.length != 3) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final blacklist = await leaderboardRepository.getInitialsBlacklist();

    if (blacklist.contains(initials.toUpperCase())) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    await leaderboardRepository.addPlayerToLeaderboard(
      leaderboardPlayer: player,
    );

    return Response(statusCode: HttpStatus.noContent);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
