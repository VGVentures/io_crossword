import 'dart:io';

import 'package:api/game_url.dart';
import 'package:board_renderer/board_renderer.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:db_client/db_client.dart';
import 'package:firebase_cloud_storage/firebase_cloud_storage.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:logging/logging.dart';

final gameUrl = GameUrl(_gameUrl);
late CrosswordRepository crosswordRepository;
late BoardRenderer boardRenderer;
late LeaderboardRepository leaderboardRepository;
late FirebaseCloudStorage firebaseCloudStorage;
late JwtMiddleware jwtMiddleware;

Future<void> init(InternetAddress ip, int port) async {
  final dbClient = DbClient.initialize(_appId, useEmulator: _useEmulator);

  crosswordRepository = CrosswordRepository(dbClient: dbClient);
  boardRenderer = const BoardRenderer();

  leaderboardRepository = LeaderboardRepository(
    dbClient: dbClient,
    blacklistDocumentId: _initialsBlacklistId,
  );

  firebaseCloudStorage = FirebaseCloudStorage(
    bucketName: _firebaseStorageBucket,
  );

  jwtMiddleware = JwtMiddleware(
    projectId: _appId,
    isEmulator: _useEmulator,
  );
}

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

String get _initialsBlacklistId {
  final value = Platform.environment['INITIALS_BLACKLIST_ID'];
  if (value == null) {
    throw ArgumentError('INITIALS_BLACKLIST_ID is required to run the API');
  }
  return value;
}

String get _firebaseStorageBucket {
  final value = Platform.environment['FB_STORAGE_BUCKET'];
  if (value == null) {
    throw ArgumentError('FB_STORAGE_BUCKET is required to run the API');
  }
  return value;
}

bool get _useEmulator => Platform.environment['USE_EMULATOR'] == 'true';

String get _gameUrl {
  final value = Platform.environment['GAME_URL'];
  if (value == null) {
    throw ArgumentError('GAME_URL is required to run the API');
  }
  return value;
}

String get projectId => _appId;
