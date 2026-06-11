import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:voltify/core/errors/failures.dart';
import 'package:voltify/features/auth/domain/entities/user_entity.dart';
import 'package:voltify/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:voltify/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:voltify/features/auth/presentation/cubit/sign_up_state.dart';

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

void main() {
  late SignUpCubit cubit;
  late MockSignUpUseCase mockSignUpUseCase;

  const testUser = UserEntity(
    uid: 'uid-123',
    email: 'test@example.com',
    displayName: 'Test User',
  );

  setUp(() {
    mockSignUpUseCase = MockSignUpUseCase();
    cubit = SignUpCubit(signUpUseCase: mockSignUpUseCase);
  });

  tearDown(() => cubit.close());

  test('initial state is correct', () {
    expect(cubit.state, const SignUpState());
    expect(cubit.state.status, SignUpStatus.initial);
  });

  group('signUp', () {
    blocTest<SignUpCubit, SignUpState>(
      'emits [loading, success] on successful registration',
      build: () {
        when(
          () => mockSignUpUseCase(
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(testUser));
        return cubit;
      },
      act: (cubit) => cubit.signUp(
        fullName: 'Test User',
        email: 'test@example.com',
        password: 'StrongP@ss1',
      ),
      expect: () => [
        const SignUpState(status: SignUpStatus.loading),
        const SignUpState(status: SignUpStatus.success, user: testUser),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits [loading, failure] when email is already in use',
      build: () {
        when(
          () => mockSignUpUseCase(
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => const Left(AuthFailure('Email already in use')),
        );
        return cubit;
      },
      act: (cubit) => cubit.signUp(
        fullName: 'Test User',
        email: 'existing@example.com',
        password: 'StrongP@ss1',
      ),
      expect: () => [
        const SignUpState(status: SignUpStatus.loading),
        const SignUpState(
          status: SignUpStatus.failure,
          errorMessage: 'Email already in use',
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits [loading, failure] on network error',
      build: () {
        when(
          () => mockSignUpUseCase(
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => const Left(NetworkFailure('No connection')),
        );
        return cubit;
      },
      act: (cubit) => cubit.signUp(
        fullName: 'Test User',
        email: 'test@example.com',
        password: 'StrongP@ss1',
      ),
      expect: () => [
        const SignUpState(status: SignUpStatus.loading),
        const SignUpState(
          status: SignUpStatus.failure,
          errorMessage: 'No connection',
        ),
      ],
    );
  });

  group('togglePasswordVisibility', () {
    blocTest<SignUpCubit, SignUpState>(
      'toggles password visibility',
      build: () => cubit,
      act: (cubit) {
        cubit.togglePasswordVisibility();
        cubit.togglePasswordVisibility();
      },
      expect: () => [
        const SignUpState(isPasswordVisible: true),
        const SignUpState(isPasswordVisible: false),
      ],
    );
  });

  group('toggleConfirmPasswordVisibility', () {
    blocTest<SignUpCubit, SignUpState>(
      'toggles confirm password visibility',
      build: () => cubit,
      act: (cubit) {
        cubit.toggleConfirmPasswordVisibility();
        cubit.toggleConfirmPasswordVisibility();
      },
      expect: () => [
        const SignUpState(isConfirmPasswordVisible: true),
        const SignUpState(isConfirmPasswordVisible: false),
      ],
    );
  });

  group('clearError', () {
    blocTest<SignUpCubit, SignUpState>(
      'resets status to initial',
      build: () => cubit,
      seed: () => const SignUpState(
        status: SignUpStatus.failure,
        errorMessage: 'Some error',
      ),
      act: (cubit) => cubit.clearError(),
      expect: () => [const SignUpState(status: SignUpStatus.initial)],
    );
  });
}
