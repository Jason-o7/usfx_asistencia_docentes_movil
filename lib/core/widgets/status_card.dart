import 'package:flutter/material.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_palette.dart';

class StatusCard extends StatelessWidget {
  final StatusType status;
  final String materia;
  final String aula;
  final TimeOfDay horaInicio;
  final TimeOfDay horaFin;

  const StatusCard({
    super.key,
    required this.status,
    required this.materia,
    required this.aula,
    required this.horaInicio,
    required this.horaFin,
  });

  (String, Color) _getTituloYColor() {
    switch (status) {
      case StatusType.correct:
        return ('Registro Correcto', AppPalette.successColor);
      case StatusType.incorrect:
        return ('Registro no Realizado', AppPalette.errorColor);
      case StatusType.incomplete:
        return ('Registro Incompleto', AppPalette.warningColor);
      case StatusType.entryCorrect:
        return ('Registro de Entrada Correcto', Color(0xFF2196F3));
      case StatusType.pending:
        return ('Registro Pendiente', AppPalette.semiDarkTextColor);
    }
  }

  String _formatearHora(TimeOfDay hora) {
    return '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final (titulo, colorTitulo) = _getTituloYColor();

    return Container(
      decoration: BoxDecoration(color: AppPalette.lightBackgroundColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _StatusIndicator(status: status),
          const SizedBox(width: 2),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: AppPalette.darkEdgeColor, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    titulo,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorTitulo,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(materia),
                  Text(
                    'Hora de Clases: ${_formatearHora(horaInicio)} - ${_formatearHora(horaFin)}',
                  ),
                  Text('Aula: $aula'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final StatusType status;

  const _StatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTopIcon(),
          const SizedBox(height: 8),
          _buildLineWithState(1),
          const SizedBox(height: 7),
          _buildLineWithState(2),
        ],
      ),
    );
  }

  Widget _buildTopIcon() {
    return Icon(_getTopIcon(), color: _getTopIconColor(), size: 24);
  }

  Widget _buildLineWithState(int lineNumber) {
    final (color, icon) = _getLineProperties(lineNumber);

    return Container(
      width: 3,
      height: 35,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [if (icon != null) Icon(icon, size: 16, color: Colors.white)],
      ),
    );
  }

  (Color, IconData?) _getLineProperties(int lineNumber) {
    switch (status) {
      case StatusType.correct:
        return (AppPalette.successColor, Icons.check);
      case StatusType.incorrect:
        return (AppPalette.errorColor, Icons.close);
      case StatusType.incomplete:
        return lineNumber == 1
            ? (AppPalette.successColor, Icons.check)
            : (AppPalette.errorColor, Icons.close);
      case StatusType.entryCorrect:
        return lineNumber == 1
            ? (AppPalette.successColor, Icons.check)
            : (AppPalette.semiDarkTextColor, null);
      case StatusType.pending:
        return (AppPalette.semiDarkTextColor, null);
    }
  }

  IconData _getTopIcon() {
    switch (status) {
      case StatusType.correct:
        return Icons.check;
      case StatusType.incorrect:
        return Icons.close;
      case StatusType.incomplete:
        return Icons.incomplete_circle;
      case StatusType.entryCorrect:
        return Icons.access_time;
      case StatusType.pending:
        return Icons.access_time;
    }
  }

  Color _getTopIconColor() {
    switch (status) {
      case StatusType.correct:
        return AppPalette.successColor;
      case StatusType.incorrect:
        return AppPalette.errorColor;
      case StatusType.incomplete:
        return AppPalette.warningColor;
      case StatusType.entryCorrect:
        return Color(0xFF2196F3);
      default:
        return AppPalette.semiDarkTextColor;
    }
  }
}

enum StatusType { correct, incorrect, incomplete, entryCorrect, pending }
