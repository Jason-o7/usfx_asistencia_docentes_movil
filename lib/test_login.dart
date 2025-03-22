import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:usfx_asistencia_docentes_movil/core/network/network_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  // Inicializa Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Configura las dependencias
  final dio = Dio();
  final connectivity = Connectivity();
  final firebaseMessaging = FirebaseMessaging.instance;

  // Crea las instancias de los DataSources primero
  final localDataSource = AuthLocalDataSourceImpl();
  final remoteDataSource = AuthRemoteDataSourceImpl(dio);

  final authRepository = AuthRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    networkInfo: NetworkInfoImpl(connectivity),
    firebaseMessaging: firebaseMessaging,
  );

  // Datos de prueba
  // const email = 'gabopro@gmail.com';
  // const password = '111222333';

  const email = 'eddy.navia.405@gmail.com';
  const password = '13721401';

  print('Iniciando sesión...');
  final result = await authRepository.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  result.fold((failure) => print('Error: ${failure.message}'), (authData) {
    print('Login exitoso!');
    print('User ID: ${authData.userId}');
    print('Token: ${authData.token}');
    print('Expiración: ${authData.expirationDate}');
  });
}
