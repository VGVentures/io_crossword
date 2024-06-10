import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

/// {@template authentication_repository}
/// Repository to manage authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    fb.FirebaseAuth? firebaseAuth,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        userController = BehaviorSubject<User>();

  final fb.FirebaseAuth _firebaseAuth;

  /// [BehaviorSubject] with the [User].
  @visibleForTesting
  final BehaviorSubject<User> userController;
  StreamSubscription<fb.User?>? _firebaseUserSubscription;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.unauthenticated] if the user is not authenticated.
  Stream<User> get user {
    _firebaseUserSubscription ??=
        _firebaseAuth.authStateChanges().listen((firebaseUser) {
      userController.add(
        firebaseUser?.toUser ?? User.unauthenticated,
      );
    });

    return userController.stream;
  }

  /// Stream of id tokens that can be used to authenticate with Firebase.
  Stream<String?> get idToken {
    return _firebaseAuth
        .idTokenChanges()
        .asyncMap((user) => user?.getIdToken());
  }

  /// Refreshes the id token.
  Future<String?> refreshIdToken() async {
    final user = _firebaseAuth.currentUser;
    return user?.getIdToken(true);
  }

  /// Sign in the user anonymously.
  ///
  /// If the sign in fails, an [AuthenticationException] is thrown.
  Future<void> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      userController.add(userCredential.toUser);
    } on Exception catch (error, stackTrace) {
      throw AuthenticationException(error, stackTrace);
    }
  }

  /// Sign out the user.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();

    userController.add(User.unauthenticated);
  }

  /// Disposes any internal resources.
  void dispose() {
    _firebaseUserSubscription?.cancel();
    userController.close();
  }
}

extension on fb.User {
  User get toUser => User(id: uid);
}

extension on fb.UserCredential {
  User get toUser => user?.toUser ?? User.unauthenticated;
}
