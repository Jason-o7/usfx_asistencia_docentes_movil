import 'package:flutter/material.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_palette.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_text_styles.dart';
import 'package:usfx_asistencia_docentes_movil/core/widgets/custom_card.dart';
import 'package:usfx_asistencia_docentes_movil/core/widgets/status_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/domain/entities/register_notification.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/presentation/bloc/register_notification_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/presentation/bloc/register_notification_event.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/presentation/bloc/register_notification_state.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/presentation/widgets/notification_icon_with_overlay.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Si el dropdown de notificaciones está abierto, cerrar al hacer tap en cualquier parte de la pantalla
      onTap: () {
        if (context.read<RegisterNotificationBloc>().state
            is RegisterNotificationsOpen) {
          context.read<RegisterNotificationBloc>().add(
            const ToggleNotifications(),
          );
        }
      },
      child: Scaffold(
        // B A R R A - S U P E R I O R
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 140,
          backgroundColor: AppPalette.primaryColor,
          title: Column(
            children: [
              // Fila 1
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
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
                        // _buildNotificationIcon(context),
                        NotificationIconWithOverlay(),
                        const SizedBox(width: 10),
                        _buildProfileIcon(),
                      ],
                    ),
                  ],
                ),
              ),

              // Fila 2 (Placeholder carrusel)
              const SizedBox(height: 10),
              _buildDateCarouselPlaceholder(),
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

  // Widget _buildNotificationIcon(BuildContext context) {
  //   return BlocConsumer<RegisterNotificationBloc, RegisterNotificationState>(
  //     listener: (context, state) {
  //       if (state is RegisterNotificationsError) {
  //         ScaffoldMessenger.of(
  //           context,
  //         ).showSnackBar(SnackBar(content: Text(state.message)));
  //       }
  //     },
  //     builder: (context, state) {
  //       return Stack(
  //         clipBehavior: Clip.none,
  //         children: [
  //           // no hay notitificaciones a ser leidas, de todas formas construye el icono de notificaciones
  //           InkWell(
  //             onTap:
  //                 () => context.read<RegisterNotificationBloc>().add(
  //                   ToggleNotifications(),
  //                 ),
  //             customBorder: const CircleBorder(),
  //             child: Container(
  //               decoration: const BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: AppPalette.lightBackgroundColor,
  //               ),
  //               padding: const EdgeInsets.all(8),
  //               child: Icon(
  //                 Icons.notifications_none_sharp,
  //                 color: AppPalette.darkTextColor,
  //               ),
  //             ),
  //           ),
  //           // hay notificaciones a ser leidas, muestra un punto rojo encima de las notificaciones
  //           if (state is RegisterNotificationsClosed && state.hasUnread)
  //             Positioned(
  //               right: 0,
  //               top: 0,
  //               child: Container(
  //                 width: 12,
  //                 height: 12,
  //                 decoration: const BoxDecoration(
  //                   color: Colors.red,
  //                   shape: BoxShape.circle,
  //                 ),
  //               ),
  //             ),
  //           // muestra el dropdown de notificaciones
  //           if (state is RegisterNotificationsOpen)
  //             Positioned(
  //               right: 0,
  //               top: 45,
  //               child: _buildNotificationsDropdown(
  //                 context,
  //                 state.notifications,
  //               ),
  //             ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildProfileIcon() {
    return InkWell(
      onTap: () {},
      customBorder: const CircleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppPalette.lightBackgroundColor,
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(Icons.person_outline, color: AppPalette.darkTextColor),
      ),
    );
  }

  Widget _buildDateCarouselPlaceholder() {
    return Container(
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
    );
  }
}
