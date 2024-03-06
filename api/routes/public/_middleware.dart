import 'package:dart_frog/dart_frog.dart';
import 'package:google_cloud/google_cloud.dart';
import 'package:logging/logging.dart';

import '../../main.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<Logger>((_) => Logger.root))
      .use(fromShelfMiddleware(cloudLoggingMiddleware(projectId)));
}
