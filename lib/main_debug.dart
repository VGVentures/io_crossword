import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:io_crossword/app/app.dart';
import 'package:io_crossword/bootstrap.dart';
import 'package:io_crossword/crossword/game/game.dart';
import 'package:io_crossword/firebase_options_development.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  unawaited(
    bootstrap(
      (firestore, firebaseAuth) async {
        final authenticationRepository = AuthenticationRepository(
          firebaseAuth: firebaseAuth,
        );

        await authenticationRepository.signInAnonymously();
        await authenticationRepository.idToken.first;

        CrosswordGame.debugOverlay = true;

        final apiClient = ApiClient(
          baseUrl: 'https://io-crossword-dev-api-sea6y22h5q-uc.a.run.app',
          idTokenStream: authenticationRepository.idToken,
          refreshIdToken: authenticationRepository.refreshIdToken,
          // TODO(any): implement app check
          appCheckTokenStream: const Stream.empty(),
        );

        return App(
          apiClient: apiClient,
          crosswordRepository: CrosswordRepository(db: firestore),
          boardInfoRepository: BoardInfoRepository(firestore: firestore),
        );
      },
    ),
  );
}
