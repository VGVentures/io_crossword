import 'dart:io';

import 'package:api/extensions/path_param_to_position.dart';
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
  final sectionId = json['sectionId'] as String?;
  final wordId = json['wordId'] as String?;
  final answer = json['answer'] as String?;

  if (sectionId == null || wordId == null || answer == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final posSection = sectionId.parseToPosition();
  final sectionX = posSection?.$1;
  final sectionY = posSection?.$2;

  if (sectionX == null || sectionY == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final player = await leaderboardRepository.getPlayer(user.id);

  if (player == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  try {
    final valid = await crosswordRepository.answerWord(
      sectionX,
      sectionY,
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
