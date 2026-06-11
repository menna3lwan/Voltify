import 'package:equatable/equatable.dart';

/// Base failure class for the domain layer.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure originating from Firebase Auth.
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Failure due to network issues.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Catch-all for unexpected failures.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
