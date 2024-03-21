import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:logging/logging.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    return _onPost(context);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}

Future<Response> _onPost(RequestContext context) async {
  final leaderboardRepository = context.read<LeaderboardRepository>();

  // TODO(jaime): get the user from the session once implemented
  const user = AuthenticatedUser('id');
  // final user = context.read<AuthenticatedUser>();

  final json = await context.request.json() as Map<String, dynamic>;
  final initials = json['initials'] as String?;
  final mascot = json['mascot'] as String?;

  if (initials == null || mascot == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  try {
    await leaderboardRepository.createScore(user.id, initials, mascot);
  } catch (e, s) {
    context.read<Logger>().severe('Error creating a player score', e, s);
    rethrow;
  }

  return Response(statusCode: HttpStatus.created);
}
