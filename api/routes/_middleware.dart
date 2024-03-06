import 'package:board_renderer/board_renderer.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:google_cloud/google_cloud.dart';
import 'package:logging/logging.dart';

import '../main.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<Logger>((_) => Logger.root))
      .use(provider<CrosswordRepository>((_) => crosswordRepository))
      .use(provider<BoardRenderer>((_) => boardRenderer))
      .use(fromShelfMiddleware(cloudLoggingMiddleware(projectId)));
}
