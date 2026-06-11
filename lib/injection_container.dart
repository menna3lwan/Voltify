import 'package:get_it/get_it.dart';

import 'features/auth/data/datasources/auth_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/cubit/sign_in_cubit.dart';
import 'features/auth/presentation/cubit/sign_up_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // ──── Data Sources ────
  sl.registerLazySingleton<AuthDataSource>(() => MockAuthDataSource());

  // ──── Repositories ────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl()),
  );

  // ──── Use Cases ────
  sl.registerLazySingleton(() => SignUpUseCase(repository: sl()));
  sl.registerLazySingleton(() => SignInUseCase(repository: sl()));

  // ──── Cubits ────
  sl.registerFactory(() => SignUpCubit(signUpUseCase: sl()));
  sl.registerFactory(() => SignInCubit(signInUseCase: sl()));
}
