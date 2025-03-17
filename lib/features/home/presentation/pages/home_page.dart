import 'package:flutter/material.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_palette.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_text_styles.dart';
import 'package:usfx_asistencia_docentes_movil/core/widgets/custom_card.dart';
import 'package:usfx_asistencia_docentes_movil/core/widgets/status_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // B A R R A - S U P E R I O R
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 140,
        backgroundColor: AppPalette.primaryColor,
        title: Column(
          children: [
            // Fila 1
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Columna 1 (Día y fecha)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Miércoles',
                        style: AppTextStyles.title(
                          color: AppPalette.lightTextColor,
                        ),
                      ),
                      Text(
                        'Marzo 5, 2025',
                        style: AppTextStyles.subtitle(
                          color: AppPalette.lightTextColor,
                        ),
                      ),
                    ],
                  ),

                  // Columna 2 y 3 (Iconos)
                  Row(
                    children: [
                      // Botón de notificaciones
                      InkWell(
                        onTap: () {}, // TODO: Implementar acción
                        customBorder: const CircleBorder(),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppPalette.lightBackgroundColor,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.notifications_none_sharp,
                            color: AppPalette.darkTextColor,
                          ),
                        ),
                      ),

                      // Espacio entre botones
                      const SizedBox(width: 10),

                      // Botón de perfil
                      InkWell(
                        onTap: () {}, // TODO: Implementar acción
                        customBorder: const CircleBorder(),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppPalette.lightBackgroundColor,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.person_outline,
                            color: AppPalette.darkTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Fila 2 (Placeholder carrusel)
            const SizedBox(height: 10),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Carrusel de fechas (Próxima implementación)',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),

      // -----------------------------------------------------------------------
      // B O D Y
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomCard(
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _buildStatusCard(index),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildStatusCard(int index) {
    final statusTypes = [
      StatusType.correct,
      StatusType.incorrect,
      StatusType.incomplete,
      StatusType.entryCorrect,
      StatusType.pending,
    ];

    return StatusCard(
      status: statusTypes[index],
      materia: 'SIS ${103 + index} - ${_getMateriaNombre(index)}',
      aula: 'B-20${index + 6}',
      horaInicio: const TimeOfDay(hour: 7, minute: 0),
      horaFin: const TimeOfDay(hour: 9, minute: 0),
    );
  }

  String _getMateriaNombre(int index) {
    const materias = [
      'Sistemas Operativos',
      'Metodología de la Programación',
      'Arquitectura de Computadoras',
      'Base de Datos',
      'Inteligencia Artificial',
    ];
    return materias[index];
  }
}
