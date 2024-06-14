import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:placker/models/models.dart'; 


//per convertir les tasques d'appointment (pel calendari) a les tasques de Firebase
Task AppointmentToTask(Appointment appointment) {

  List<String> subjectParts = appointment.subject.split(' - ');
  String? assignatura = subjectParts.isNotEmpty ? subjectParts[0] : '';
  String? tasca = subjectParts.length > 1 ? subjectParts[1] : '';

  List<String> notesParts = appointment.notes?.split(' - ') ?? [];
  String? etiqueta = notesParts.isNotEmpty ? notesParts[0] : '';
  String? prioritat = notesParts.length > 1 ? notesParts[1] : '';

  String dateTimeToDayString(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  String dateTimeToHourString(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  List<String> times = (appointment.location ?? '').split(',');
  String? tempsTotal = times.isNotEmpty ? times[0] : null;
  String? tempsFocus = times.length > 1 ? times[1] : null;
  String? tempsPausa = times.length > 2 ? times[2] : null;
  bool isDone = times.length > 3 ? times[3].toLowerCase() == 'true' : false;

  return Task(
    id: appointment.id?.toString(),
    subject: assignatura,
    tasca: tasca,
    dia: dateTimeToDayString(appointment.startTime),
    horaStart: dateTimeToHourString(appointment.startTime),
    horaEnd: dateTimeToHourString(appointment.endTime),
    etiqueta: etiqueta,
    prioritat: prioritat,
    color: '0x${appointment.color.value.toRadixString(16)}',
    recurrent: appointment.recurrenceRule != null,
    tempsTotal: tempsTotal,
    tempsFocus: tempsFocus,
    tempsPausa: tempsPausa,
    isDone: isDone,
  );
}