import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:io_crossword/app/app.dart';
import 'package:io_crossword/bootstrap.dart';
import 'package:io_crossword/firebase_options.dart';

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

        return App(
          crosswordRepository: CrosswordRepository(db: firestore),
        );
      },
    ),
  );
}
