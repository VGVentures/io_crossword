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

  final user = context.read<AuthenticatedUser>();

  try {
    await leaderboardRepository.resetStreak(user.id);
  } catch (e, s) {
    context.read<Logger>().severe('Error resetting the streak', e, s);
    rethrow;
  }

  return Response(statusCode: HttpStatus.created);
}
