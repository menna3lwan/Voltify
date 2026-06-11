import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/sign_up_usecase.dart';
import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpUseCase signUpUseCase;

  SignUpCubit({required this.signUpUseCase}) : super(const SignUpState());

  /// Executes the sign-up flow.
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: SignUpStatus.loading));

    final result = await signUpUseCase(
      fullName: fullName,
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: SignUpStatus.success,
          user: user,
        ),
      ),
    );
  }

  /// Toggles password field visibility.
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  /// Toggles confirm-password field visibility.
  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(
        isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
      ),
    );
  }

  /// Resets any error so the snackbar doesn't re-appear on rebuild.
  void clearError() {
    emit(state.copyWith(status: SignUpStatus.initial));
  }
}
