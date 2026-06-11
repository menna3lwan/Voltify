import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

enum SignInStatus { initial, loading, success, failure }

class SignInState extends Equatable {
  final SignInStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final bool isPasswordVisible;

  const SignInState({
    this.status = SignInStatus.initial,
    this.user,
    this.errorMessage,
    this.isPasswordVisible = false,
  });

  bool get isLoading => status == SignInStatus.loading;
  bool get isSuccess => status == SignInStatus.success;
  bool get isFailure => status == SignInStatus.failure;

  SignInState copyWith({
    SignInStatus? status,
    UserEntity? user,
    String? errorMessage,
    bool? isPasswordVisible,
  }) {
    return SignInState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, isPasswordVisible];
}
