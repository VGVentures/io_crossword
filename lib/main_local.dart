// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:js' as js;

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:io_crossword/app/app.dart';
import 'package:io_crossword/bootstrap.dart';
import 'package:io_crossword/firebase_options_development.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

void main() async {
  js.context['FIREBASE_APPCHECK_DEBUG_TOKEN'] =
      const String.fromEnvironment('APPCHECK_DEBUG_TOKEN');

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  unawaited(
    bootstrap(
      (firestore, firebaseAuth, appCheck) async {
        await appCheck.activate(
          webProvider: ReCaptchaV3Provider(
            const String.fromEnvironment('RECAPTCHA_KEY'),
          ),
        );
        await appCheck.setTokenAutoRefreshEnabled(true);

        final authenticationRepository = AuthenticationRepository(
          firebaseAuth: firebaseAuth,
        );

        await authenticationRepository.signInAnonymously();
        await authenticationRepository.idToken.first;

        final apiClient = ApiClient(
          baseUrl: 'http://localhost:8080',
          idTokenStream: authenticationRepository.idToken,
          refreshIdToken: authenticationRepository.refreshIdToken,
          appCheckTokenStream: appCheck.onTokenChange,
          appCheckToken: await appCheck.getToken(),
        );

        final leaderboardRepository = LeaderboardRepository(
          firestore: firestore,
        );

        return App(
          apiClient: apiClient,
          leaderboardRepository: leaderboardRepository,
          crosswordRepository: CrosswordRepository(db: firestore),
          boardInfoRepository: BoardInfoRepository(firestore: firestore),
          user: await authenticationRepository.user.first,
        );
      },
    ),
  );
}
