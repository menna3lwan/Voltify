import '../../domain/entities/user_entity.dart';

abstract class AuthDataSource {
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class MockAuthDataSource implements AuthDataSource {
  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return UserEntity(
      uid: 'mock-uid-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName,
    );
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final name = email.split('@').first;
    final displayName = name[0].toUpperCase() + name.substring(1);
    return UserEntity(
      uid: 'mock-uid-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName,
    );
  }
}
