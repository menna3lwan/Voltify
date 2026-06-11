import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:voltify/core/errors/failures.dart';
import 'package:voltify/features/auth/domain/entities/user_entity.dart';
import 'package:voltify/features/auth/domain/repositories/auth_repository.dart';
import 'package:voltify/features/auth/domain/usecases/sign_up_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignUpUseCase useCase;
  late MockAuthRepository mockRepository;

  const testUser = UserEntity(
    uid: 'uid-123',
    email: 'test@example.com',
    displayName: 'Test User',
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUpUseCase(repository: mockRepository);
  });

  test('calls repository.signUp with trimmed inputs', () async {
    when(
      () => mockRepository.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer((_) async => const Right(testUser));

    await useCase(
      fullName: '  Test User  ',
      email: '  test@example.com  ',
      password: 'StrongP@ss1',
    );

    verify(
      () => mockRepository.signUp(
        email: 'test@example.com',
        password: 'StrongP@ss1',
        fullName: 'Test User',
      ),
    ).called(1);
  });

  test('returns UserEntity on success', () async {
    when(
      () => mockRepository.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer((_) async => const Right(testUser));

    final result = await useCase(
      fullName: 'Test User',
      email: 'test@example.com',
      password: 'StrongP@ss1',
    );

    expect(result, const Right(testUser));
  });

  test('returns Failure on error', () async {
    const failure = AuthFailure('Email already in use');
    when(
      () => mockRepository.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer((_) async => const Left(failure));

    final result = await useCase(
      fullName: 'Test User',
      email: 'existing@example.com',
      password: 'StrongP@ss1',
    );

    expect(result, const Left(failure));
  });
}
