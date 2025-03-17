import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  // 1. Configuración inicial de Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 2. Configurar Firebase Messaging
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 3. Configurar listeners de notificaciones
  await _configureFirebaseMessaging(messaging);

  // 4. Mantener la app activa
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Escuchando notificaciones...'),
              FutureBuilder<String?>(
                future: messaging.getToken(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Token FCM: ${snapshot.data}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> _configureFirebaseMessaging(FirebaseMessaging messaging) async {
  // Solicitar permisos (iOS)
  await messaging.requestPermission(alert: true, badge: true, sound: true);

  // Escuchar notificaciones en primer plano
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("\n=== NOTIFICACIÓN RECIBIDA ===");
    print("Título: ${message.notification?.title}");
    print("Cuerpo: ${message.notification?.body}");
    print("Datos: ${message.data}");
  });

  // Opcional: Manejar notificaciones en segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);
}

// Manejador para notificaciones en segundo plano
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {
  print("\n=== NOTIFICACIÓN EN SEGUNDO PLANO ===");
  print("Datos recibidos: ${message.data}");
}
