import 'package:syncfusion_flutter_calendar/calendar.dart'; 
import 'package:flutter/material.dart';
import 'package:placker/models/models.dart'; 


//per convertir les tasques de Firebase a appointment (pel calendari)
class TaskToAppointment {

  List<Appointment> convertTasksToAppointments(List<Task> tasks) {
    return tasks.map((task) {

      //convertir string de dia a DateTime
      DateTime selectedDay = task.dia != null ? DateTime.parse(task.dia! + ' 00:00:00') : DateTime.now();
      
      //convertir string de horaStart a DateTime
      List<String> partsHoraStart = task.horaStart?.split(':') ?? ['00', '00'];
      int hourStart = int.parse(partsHoraStart[0]);
      int minuteStart = int.parse(partsHoraStart[1]);

      //convertir string de horaEnd a DateTime
      List<String> partsHoraEnd = task.horaEnd?.split(':') ?? ['00', '00'];
      int hourEnd = int.parse(partsHoraEnd[0]);
      int minuteEnd = int.parse(partsHoraEnd[1]);

      DateTime startTime = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
        hourStart,
        minuteStart,
      );

      DateTime endTime = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
        hourEnd,
        minuteEnd,
      );

      Map<int, String> weekdayMap = {
        DateTime.monday: 'MO',
        DateTime.tuesday: 'TU',
        DateTime.wednesday: 'WE',
        DateTime.thursday: 'TH',
        DateTime.friday: 'FR',
        DateTime.saturday: 'SA',
        DateTime.sunday: 'SU',
      };

      String? recurrenceRule = task.recurrent == true
          ? 'FREQ=WEEKLY;BYDAY=${weekdayMap[selectedDay.weekday]}'
          : null;

      String concatenatedTimes = '${task.tempsTotal ?? ''},${task.tempsFocus ?? ''},${task.tempsPausa ?? ''},${task.isDone}';

      return Appointment(
        id: task.id,
        subject: '${task.subject} - ${task.tasca}',
        startTime: startTime,
        endTime: endTime,
        recurrenceRule: recurrenceRule,
        color: task.color != null ? Color(int.parse(task.color!)) : const Color(0xff506EA4),
        notes: '${task.etiqueta ?? ''} - ${task.prioritat ?? ''}',
        location: concatenatedTimes,
      );
    }).toList();
  }
}