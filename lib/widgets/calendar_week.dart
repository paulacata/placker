import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:placker/models/models.dart';
import 'package:placker/widgets/widgets.dart';
import 'package:placker/services/services.dart';

//aquest codi ha estat adaptat del vídeo Flutter Tutorial - Calendar Event App | With Day View & Week View - Flutter Syncfusion Calendar de HeyFlutter.com https://www.youtube.com/watch?v=LoDtxRkGDTw 

//calendari setmanal
class CalendarWeek extends StatelessWidget {

  String dateTimeToDayString(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  String dateTimeToHourString(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  final List<Task> tasks;
  const CalendarWeek({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final dataSource = TaskDataSource(tasks);
    final tasksService = Provider.of<TasksService>(context);

    return SfCalendar(
      view: CalendarView.week,

      dataSource: dataSource,

      appointmentBuilder: (BuildContext context, CalendarAppointmentDetails details) {
        return AppointmentWidgetWeek.appointmentBuilder(context, details, dataSource);
      },

      //canvi d'estil de la capçalera
      headerStyle: const CalendarHeaderStyle(
        textStyle: TextStyle(
          color: Color(0xFF506EA4),
          fontSize: 16, 
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
      ),
      
      todayHighlightColor: const Color(0xFF506EA4),

      firstDayOfWeek: DateTime.monday,

      //capçalera on es mostren els dies de la setmana
      viewHeaderStyle: const ViewHeaderStyle(
        dayTextStyle: TextStyle(color: Color(0xFF506EA4), fontSize: 10),
        dateTextStyle: TextStyle(color: Color(0xFF506EA4), fontSize: 10),
      ),

      //vora del rectangle de l'hora seleccionada
      selectionDecoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF506EA4), width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),

      //configuració de les hores
      timeSlotViewSettings: const TimeSlotViewSettings(
        timeIntervalHeight: 60,
        timeFormat: 'HH:mm',
      ),

      //quan es prem sobre el calendari, s'obre la pantalla per afegir una nova tasca a aquella hora
      onTap: (CalendarTapDetails details) {
        if (details.appointments == null || details.appointments!.isEmpty) {

          final DateTime selectedDate = details.date ?? DateTime.now();
          
          tasksService.selectedTask = Task(
            subject: '',
            tasca: '',
            dia: dateTimeToDayString(selectedDate),
            horaStart: dateTimeToHourString(selectedDate),
            horaEnd: dateTimeToHourString(selectedDate.add(const Duration(hours: 1))),
            recurrent: false,
            etiqueta: '',
            color: '0xff506EA4',
            prioritat: '',
          );
          Navigator.pushNamed(context, 'AddTask');
        }
      },
    );
  }
}
