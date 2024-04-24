import 'dart:io';

import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    return _onPost(context);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _onPost(RequestContext context) async {
  final crosswordRepository = context.read<CrosswordRepository>();
  final leaderboardRepository = context.read<LeaderboardRepository>();
  final user = context.read<AuthenticatedUser>();

  final json = await context.request.json() as Map<String, dynamic>;
  final wordId = json['wordId'] as String?;
  final answer = json['answer'] as String?;

  if (wordId == null || answer == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final player = await leaderboardRepository.getPlayer(user.id);

  if (player == null) {
    return Response(
      body: 'Player not found for id ${user.id}',
      statusCode: HttpStatus.internalServerError,
    );
  }

  try {
    final valid = await crosswordRepository.answerWord(
      wordId,
      player.mascot,
      answer,
    );

    var points = 0;
    if (valid) {
      await crosswordRepository.updateSolvedWordsCount();
      points = await leaderboardRepository.updateScore(user.id);
    }

    return Response.json(body: {'points': points});
  } catch (e) {
    return Response(
      body: e.toString(),
      statusCode: HttpStatus.internalServerError,
    );
  }
}
