import 'dart:io';

import 'package:board_renderer/board_renderer.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:db_client/db_client.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:logging/logging.dart';

late CrosswordRepository crosswordRepository;
late BoardRenderer boardRenderer;
late LeaderboardRepository leaderboardRepository;

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  final dbClient = DbClient.initialize(_appId, useEmulator: _useEmulator);

  crosswordRepository = CrosswordRepository(dbClient: dbClient);
  boardRenderer = const BoardRenderer();

  leaderboardRepository = LeaderboardRepository(
    dbClient: dbClient,
    blacklistDocumentId: _initialsBlacklistId,
  );

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

String get _initialsBlacklistId {
  final value = Platform.environment['INITIALS_BLACKLIST_ID'];
  if (value == null) {
    throw ArgumentError('INITIALS_BLACKLIST_ID is required to run the API');
  }
  return value;
}

bool get _useEmulator => Platform.environment['USE_EMULATOR'] == 'true';

String get projectId => _appId;

bool get _useEmulator => Platform.environment['USE_EMULATOR'] == 'true';
