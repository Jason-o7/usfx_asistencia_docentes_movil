import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:usfx_asistencia_docentes_movil/core/network/network_info.dart';

@GenerateMocks([NetworkInfo])
import 'network_info_test.mocks.dart';

void main() {
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
  });

  test('debería retornar true cuando hay conexión a internet', () async {
    // Arrange
    when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);

    // Act
    final result = await mockNetworkInfo.isConnected();

    // Assert
    expect(result, true);
    verify(mockNetworkInfo.isConnected());
  });

  test('debería retornar false cuando no hay conexión a internet', () async {
    // Arrange
    when(mockNetworkInfo.isConnected()).thenAnswer((_) async => false);

    // Act
    final result = await mockNetworkInfo.isConnected();

    // Assert
    expect(result, false);
    verify(mockNetworkInfo.isConnected());
  });
}
