import 'package:firebase_auth/firebase_auth.dart';

/// Contract for Firebase Authentication data operations.
abstract class FirebaseAuthDataSource {
  /// Creates a new user with [email] and [password], sets [displayName].
  /// Returns the [UserCredential] on success.
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });
}

/// Concrete implementation backed by [FirebaseAuth].
class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth firebaseAuth;

  const FirebaseAuthDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update the user's display name after creation.
    await credential.user?.updateDisplayName(displayName);
    await credential.user?.reload();

    return credential;
  }
}
