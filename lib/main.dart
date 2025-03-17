import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/core/di/injection_container.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/presentation/pages/sign_in_page.dart';
import 'package:usfx_asistencia_docentes_movil/features/home/presentation/bloc/home_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/features/home/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => getIt<AuthBloc>())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Docentes USFX',
        initialRoute: '/home',
        routes: {
          '/': (context) => const SignInPage(),
          '/home':
              (context) => BlocProvider(
                create: (context) => getIt<HomeBloc>(),
                child: const HomePage(),
              ),
        },
      ),
    );
  }
}
