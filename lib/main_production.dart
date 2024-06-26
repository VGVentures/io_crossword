import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:io_crossword/app/app.dart';
import 'package:io_crossword/bootstrap.dart';
import 'package:io_crossword/firebase_options_production.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

void main() async {
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

        final leaderboardRepository = LeaderboardRepository(
          firestore: firestore,
        );

        // Signing out first to refresh the auth token when reloading the page.
        final previousUser = await authenticationRepository.user.first;
        if (previousUser != User.unauthenticated) {
          await authenticationRepository.signOut();
        }
        await authenticationRepository.signInAnonymously();
        await authenticationRepository.idToken.first;
        final newUser = await authenticationRepository.user.first;

        final apiClient = ApiClient(
          baseUrl: 'https://io-crossword-api-u3emptgwka-uc.a.run.app',
          idTokenStream: authenticationRepository.idToken,
          refreshIdToken: authenticationRepository.refreshIdToken,
          appCheckTokenStream: appCheck.onTokenChange,
          appCheckToken: await appCheck.getToken(),
        );

        return App(
          apiClient: apiClient,
          leaderboardRepository: leaderboardRepository,
          crosswordRepository: CrosswordRepository(db: firestore),
          boardInfoRepository: BoardInfoRepository(firestore: firestore),
          user: newUser,
        );
      },
    ),
  );
}
