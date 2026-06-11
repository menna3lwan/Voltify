import 'package:firebase_auth/firebase_auth.dart';

import '../constants/app_strings.dart';
import 'failures.dart';

/// Maps [FirebaseAuthException] codes to user-friendly [Failure] instances.
abstract final class FirebaseErrorHandler {
  static Failure handle(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return const AuthFailure(AppStrings.emailAlreadyInUse);
      case 'invalid-email':
        return const AuthFailure(AppStrings.invalidEmailFirebase);
      case 'weak-password':
        return const AuthFailure(AppStrings.weakPasswordFirebase);
      case 'network-request-failed':
        return const NetworkFailure(AppStrings.networkError);
      case 'too-many-requests':
        return const AuthFailure(
          'Too many attempts. Please try again later.',
        );
      case 'operation-not-allowed':
        return const AuthFailure(
          'Email/password sign up is not enabled. Please contact support.',
        );
      default:
        return const UnexpectedFailure(AppStrings.unexpectedError);
    }
  }

  static Failure handleGeneric(Object e) {
    if (e is FirebaseAuthException) return handle(e);
    return const UnexpectedFailure(AppStrings.unexpectedError);
  }
}
