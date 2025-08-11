import 'package:get_it/get_it.dart';
import '../../features/authentication/data/repositories/auth_repository.dart';
import '../../features/authentication/presentation/cubit/auth_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Register AuthRepository as singleton
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // Register AuthCubit as singleton
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>()),
  );
}
