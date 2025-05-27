import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:usfx_asistencia_docentes_movil/core/network/network_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/domain/entities/auth_data.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/data/datasources/register_notification_remote_data_source.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/data/repositories/register_notifications_repository_impl.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/domain/repositories/register_notification_repository.dart';

void main() async {
  // Inicializa Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Configura las dependencias
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://tu-api.com', // Reemplaza con tu URL base
      headers: {'Content-Type': 'application/json'},
    ),
  );

  final connectivity = Connectivity();
  final firebaseMessaging = FirebaseMessaging.instance;

  // Configura Auth
  final localDataSource = AuthLocalDataSourceImpl();
  final authRemoteDataSource = AuthRemoteDataSourceImpl(dio);

  final authRepository = AuthRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: authRemoteDataSource,
    networkInfo: NetworkInfoImpl(connectivity),
    firebaseMessaging: firebaseMessaging,
  );

  // Configura Notificaciones
  final notificationsDataSource = RegisterNotificationRemoteDataSourceImpl(
    dio: dio,
  );
  final notificationsRepository = RegisterNotificationRepositoryImpl(
    remoteDataSource: notificationsDataSource,
    authRepository: authRepository,
  );

  // Datos de prueba
  const email = 'eddy.navia.405@gmail.com';
  const password = '13721401';

  print('⏳ Iniciando sesión...');
  final loginResult = await authRepository.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  loginResult.fold((failure) => print('❌ Error de login: ${failure.message}'), (
    authData,
  ) async {
    print('\n✅ Login exitoso!');
    print('🔑 Token: ${authData.token}');
    print('👤 User ID: ${authData.userId}');

    // Probamos las notificaciones
    print('\n⏳ Obteniendo notificaciones...');

    final notificationsResult =
        await notificationsRepository.getActiveNotifications();

    notificationsResult.fold(
      (failure) => print('❌ Error en notificaciones: ${failure.message}'),
      (notifications) {
        print('\n🎉 Notificaciones obtenidas correctamente!');
        print('📬 Total: ${notifications.length} notificaciones\n');

        for (final notification in notifications) {
          print('┌───────────────────────────────────');
          print('│ 📌 ID: ${notification.idNotification}');
          print('│ 🏷️  Titulo: ${notification.title}');
          print('│ 📚 Materia: ${notification.subject}');
          print('│ 🕒 Hora: ${notification.registerTime}');
          print('│ 📍 Estado: ${notification.status.toUpperCase()}');
          print('└───────────────────────────────────\n');
        }
      },
    );
    //----------------
    // }
  });
}
