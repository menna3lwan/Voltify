import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/firebase_error_handler.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

/// Bridges the domain [AuthRepository] contract with Firebase data source.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  const AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final credential = await dataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: fullName,
      );

      final user = credential.user;
      if (user == null) {
        return const Left(
          UnexpectedFailure('Account creation failed. Please try again.'),
        );
      }

      return Right(
        UserEntity(
          uid: user.uid,
          email: user.email ?? email,
          displayName: user.displayName ?? fullName,
        ),
      );
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseErrorHandler.handle(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}
