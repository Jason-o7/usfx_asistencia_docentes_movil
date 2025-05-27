import 'package:dio/dio.dart';
import 'package:usfx_asistencia_docentes_movil/core/errors/exceptions.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/data/models/register_notification_model.dart';

abstract class RegisterNotificationRemoteDataSource {
  Future<List<RegisterNotificationModel>> getNotifications({
    required String teacherId,
    required String authToken,
    int page,
    int perPage,
  });
}

class RegisterNotificationRemoteDataSourceImpl
    implements RegisterNotificationRemoteDataSource {
  final Dio dio;

  RegisterNotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RegisterNotificationModel>> getNotifications({
    required String teacherId,
    required String authToken,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await dio.get(
        // 'https://hsqlmjx0-5000.brs.devtunnels.ms/frav1/mdl/notifications/id/$teacherId',
        'http://10.0.2.2:5000/frav1/mdl/notifications/id/$teacherId',
        queryParameters: {'page': page, 'per_page': perPage},
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );

      print(
        'Respuesta de la API: ${response.data}',
      ); // TODO Eliminar en producción

      final idPerson = teacherId;

      final notifications = response.data['data']['notifications'] as List;
      return notifications
          .map((json) => RegisterNotificationModel.fromJson(json, idPerson))
          .toList();
    } on DioException catch (e) {
      print('Error del servidor: ${e.response?.data}'); // TODO Borrar esto!
      throw ServerException(
        message:
            e.response?.data['message'] ?? 'Error al obtener notificaciones',
        statusCode: e.response?.statusCode ?? 500,
        errorCode: e.response?.data['error_code'],
      );
    }
  }
}
