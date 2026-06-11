import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'features/auth/data/datasources/firebase_auth_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/cubit/sign_up_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // ──── External ────
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // ──── Data Sources ────
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(firebaseAuth: sl()),
  );

  // ──── Repositories ────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl()),
  );

  // ──── Use Cases ────
  sl.registerLazySingleton(() => SignUpUseCase(repository: sl()));

  // ──── Cubits ────
  sl.registerFactory(() => SignUpCubit(signUpUseCase: sl()));
}
