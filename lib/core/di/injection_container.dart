import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:usfx_asistencia_docentes_movil/core/network/network_info.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/domain/repositories/auth_repository.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/features/home/presentation/bloc/home_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Registrar NetworkInfo
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(Connectivity()),
  );

  // Dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  // DataSources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt(), getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
      firebaseMessaging: FirebaseMessaging.instance,
    ),
  );

  // UseCase
  getIt.registerLazySingleton<SignInWithEmailAndPasswordUseCase>(
    () => SignInWithEmailAndPasswordUseCase(getIt<AuthRepository>()),
  );

  // BLoC
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(signInUseCase: getIt<SignInWithEmailAndPasswordUseCase>()),
  );
  // Home BloC
  getIt.registerFactory<HomeBloc>(() => HomeBloc());
}
