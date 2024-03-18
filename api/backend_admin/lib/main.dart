import 'dart:async';

import 'package:backend_admin/app/app.dart';
import 'package:backend_admin/bootstrap.dart';
import 'package:backend_admin/http_client/http_client.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:db_client/db_client.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbClient = DbClient.initialize(_appId);
  final crosswordRepository = CrosswordRepository(dbClient: dbClient);

  final httpClient = HttpClient(
    baseUrl: 'http://localhost:8080',
  );

  unawaited(
    bootstrap(
      () async {
        return App(
          crosswordRepository: crosswordRepository,
          httpClient: httpClient,
        );
      },
    ),
  );
}

String get _appId {
  const value = String.fromEnvironment('FB_APP_ID');
  return value;
}
