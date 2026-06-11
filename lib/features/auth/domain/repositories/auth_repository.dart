import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

/// Abstract contract for authentication operations.
abstract class AuthRepository {
  /// Registers a new user with [email], [password], and [fullName].
  /// Returns [UserEntity] on success or [Failure] on error.
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String fullName,
  });
}
