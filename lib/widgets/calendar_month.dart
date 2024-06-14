import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:placker/models/models.dart';
import 'package:placker/widgets/widgets.dart';

//aquest codi ha estat adaptat del vídeo Flutter Tutorial - Calendar Event App | With Day View & Week View - Flutter Syncfusion Calendar de HeyFlutter.com https://www.youtube.com/watch?v=LoDtxRkGDTw 

//calendari mensual
class CalendarMonth extends StatelessWidget {

  final List<Task> tasks;
  final void Function(DateTime) switchToDailyView;

  const CalendarMonth({Key? key, required this.tasks, required this.switchToDailyView}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final dataSource = TaskDataSource(tasks);

    return SfCalendar(
      view: CalendarView.month,
          
      dataSource: dataSource,

      appointmentBuilder: (BuildContext context, CalendarAppointmentDetails details) {
        return AppointmentWidgetMonth.appointmentBuilder(context, details, dataSource);
      },
          
      viewHeaderHeight: 0,
          
      //canvi d'estil de la capçalera
      headerStyle: const CalendarHeaderStyle(
        textStyle: TextStyle(
          color: Color(0xFF506EA4),
          fontSize: 16, 
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
      ),
          
      firstDayOfWeek: DateTime.monday,
          
      //vora del rectangle del dia seleccionat
      selectionDecoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF506EA4), width: 2.5),
        borderRadius: BorderRadius.circular(6),
      ),

      todayHighlightColor: const Color(0xFF506EA4),

      todayTextStyle: const TextStyle(color: Colors.white, fontSize: 8),

      //format de les cel·les
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        appointmentDisplayCount: 2,
        showTrailingAndLeadingDates: false, 
        monthCellStyle: MonthCellStyle(
          textStyle: TextStyle(color: Color(0xFF506EA4), fontSize: 8),
        ),
      ),

      //quan es prem sobre un dia, navega al calendari diari d'aquell dia
      onTap: (CalendarTapDetails details) {
        switchToDailyView(details.date!);
      },
    );
  }
}