import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  const AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final user = await dataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: fullName,
      );
      return Right(user);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await dataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(user);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
