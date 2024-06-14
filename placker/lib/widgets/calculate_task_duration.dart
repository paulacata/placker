import 'package:intl/intl.dart';
import 'package:placker/models/models.dart';

//classe per calcular la duració d'una tasca pels informes
String calculateTaskDuration(Task task) {
  if (task.horaStart != null && task.horaEnd != null) {
    DateTime startTime = DateFormat("HH:mm").parse(task.horaStart!);
    DateTime endTime = DateFormat("HH:mm").parse(task.horaEnd!);
    Duration duration = endTime.difference(startTime);

    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:00';
  }
  return '';
}