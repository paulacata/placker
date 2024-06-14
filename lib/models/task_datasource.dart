import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:placker/models/models.dart';

//aquest codi ha estat adaptat del vídeo Flutter Tutorial - Calendar Event App | With Day View & Week View - Flutter Syncfusion Calendar de HeyFlutter.com https://www.youtube.com/watch?v=LoDtxRkGDTw 

//classe per gestionar la datasource 
class TaskDataSource extends CalendarDataSource {

  TaskDataSource(List<Task> tasks) {
    TaskToAppointment taskToAppointment = TaskToAppointment();
    appointments = taskToAppointment.convertTasksToAppointments(tasks);
  }

  getAppointmentsForDate(DateTime date) {
    return appointments!.where((appointment) =>
      appointment.startTime.year == date.year &&
      appointment.startTime.month == date.month &&
      appointment.startTime.day == date.day
    ).toList();
  }

  @override
  DateTime getStartTime(int index) => appointments![index].startTime;

  @override
  DateTime getEndTime(int index) => appointments![index].endTime;

  @override
  String getSubject(int index) => appointments![index].subject;

  @override
  Color getColor(int index) => appointments![index].color;

  @override
  String? getNotes(int index) => appointments![index].notes;
}