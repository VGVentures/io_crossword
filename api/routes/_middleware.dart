import 'package:board_renderer/board_renderer.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_cloud_storage/firebase_cloud_storage.dart';
import 'package:google_cloud/google_cloud.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:logging/logging.dart';

import '../headers/cors_headers.dart';
import '../main.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<Logger>((_) => Logger.root))
      .use(provider<CrosswordRepository>((_) => crosswordRepository))
      .use(provider<BoardRenderer>((_) => boardRenderer))
      .use(provider<LeaderboardRepository>((_) => leaderboardRepository))
      .use(provider<FirebaseCloudStorage>((_) => firebaseCloudStorage))
      .use(corsHeaders())
      .use(fromShelfMiddleware(cloudLoggingMiddleware(projectId)));
}
