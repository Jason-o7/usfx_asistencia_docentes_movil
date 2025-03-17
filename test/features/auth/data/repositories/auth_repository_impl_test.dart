import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:usfx_asistencia_docentes_movil/core/network/network_info.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/domain/entities/auth_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockFirebaseMessaging mockFirebaseMessaging;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tAuthData = AuthData(
    userId: '1',
    token: 'token123',
    expirationDate: DateTime.now(),
  );

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockFirebaseMessaging = MockFirebaseMessaging();

    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
      firebaseMessaging: mockFirebaseMessaging,
    );
  });

  group('signInWithEmailAndPassword', () {
    test('debería retornar AuthData cuando el login es exitoso', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => tAuthData);

      when(
        mockLocalDataSource.cacheAuthData(tAuthData),
      ).thenAnswer((_) async => {});

      when(
        mockFirebaseMessaging.getToken(),
      ).thenAnswer((_) async => 'fcm_token');

      // Act
      final result = await repository.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      // Assert
      expect(result, Right(tAuthData));
      verify(
        mockRemoteDataSource.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      );
      verify(mockLocalDataSource.cacheAuthData(tAuthData));
      verify(mockFirebaseMessaging.getToken());
    });
  });
}
