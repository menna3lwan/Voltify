import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/sign_in_usecase.dart';
import 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInUseCase signInUseCase;

  SignInCubit({required this.signInUseCase}) : super(const SignInState());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: SignInStatus.loading));

    final result = await signInUseCase(email: email, password: password);

    result.fold(
      (failure) => emit(state.copyWith(
        status: SignInStatus.failure,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        status: SignInStatus.success,
        user: user,
      )),
    );
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void clearError() {
    emit(state.copyWith(status: SignInStatus.initial));
  }
}
