import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

enum SignUpStatus { initial, loading, success, failure }

class SignUpState extends Equatable {
  final SignUpStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  const SignUpState({
    this.status = SignUpStatus.initial,
    this.user,
    this.errorMessage,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  bool get isLoading => status == SignUpStatus.loading;
  bool get isSuccess => status == SignUpStatus.success;
  bool get isFailure => status == SignUpStatus.failure;

  SignUpState copyWith({
    SignUpStatus? status,
    UserEntity? user,
    String? errorMessage,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return SignUpState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        errorMessage,
        isPasswordVisible,
        isConfirmPasswordVisible,
      ];
}
