import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:usfx_asistencia_docentes_movil/core/network/network_info.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Registrar NetworkInfo
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(Connectivity()),
  );
}
