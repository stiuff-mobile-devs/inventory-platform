import 'package:get_it/get_it.dart';
import 'package:inventory_platform/core/services/firebase_service.dart';
import 'package:inventory_platform/features/login/data/repositories/login_repository_impl.dart';
import 'package:inventory_platform/features/login/domain/usecases/sign_in_with_google.dart';
import 'package:inventory_platform/features/login/presentation/bloc/login_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<FirebaseService>(() => FirebaseService());

  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(firebaseService: sl<FirebaseService>()),
  );

  sl.registerLazySingleton(() => SignInWithGoogle(sl<LoginRepository>()));

  sl.registerFactory(() => LoginBloc(sl<SignInWithGoogle>()));
}
