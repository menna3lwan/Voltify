import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Encapsulates the sign-up business logic.
class SignUpUseCase {
  final AuthRepository repository;

  const SignUpUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String fullName,
  }) {
    return repository.signUp(
      email: email.trim(),
      password: password,
      fullName: fullName.trim(),
    );
  }
}
