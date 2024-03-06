import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  return serve(handler, ip, port);
}

String get _appId {
  final value = Platform.environment['FB_APP_ID'];
  if (value == null) {
    throw ArgumentError('FB_APP_ID is required to run the API');
  }
  return value;
}

String get projectId => _appId;
