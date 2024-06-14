import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';

import 'package:placker/models/models.dart';
import 'package:placker/services/services.dart';


//per crear l'appointment al calendari mensual
class AppointmentWidgetMonth {
  static Widget appointmentBuilder(BuildContext context, CalendarAppointmentDetails details, TaskDataSource dataSource) {
    
    final Appointment appointment = details.appointments.first;

    List<String> subjectParts = appointment.subject.split(' - ');
    String assignatura = subjectParts.isNotEmpty ? subjectParts[0] : '';
    String tasca = subjectParts.length > 1 ? subjectParts[1] : '';

    List<String> notesParts = appointment.notes?.split(' - ') ?? [];
    String etiqueta = notesParts.isNotEmpty ? notesParts[0] : '';

    String printSubjectTask = '';

    if (assignatura.isNotEmpty) {
        printSubjectTask = '$assignatura: $tasca';
    } else {
        printSubjectTask = tasca;
    }

    final List<String> locationParts = appointment.location?.split(',') ?? [];
    final bool isDone = locationParts.length > 3 ? locationParts[3].toLowerCase() == 'true' : false;

    final Task taskToEdit = AppointmentToTask(appointment);

    final prioritatService = Provider.of<PrioritatService>(context);
    final taskPrioritat = prioritatService.prioritats.firstWhere((prioritat) => prioritat.nom == taskToEdit.prioritat, orElse: () => Prioritat(id: '', nom: '', color: ''));
    
    //decoració de l'appointment
    return Container(
      decoration: BoxDecoration(
        color: appointment.color,
        borderRadius: BorderRadius.circular(5),
      ),
      width: double.infinity, 
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        child: Column(
          children: [
            Flexible(
              child: SingleChildScrollView (
                scrollDirection: Axis.vertical,     
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDone)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 12,
                      ),
                    
                    Text(
                      printSubjectTask,
                      style: const TextStyle(color: Colors.white, fontSize: 7),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
            
                    Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              buildEtiqueta(etiqueta, appointment),
                              const SizedBox(height: 3),
                              if (taskPrioritat.color != null && taskPrioritat.color != '')
                                CircleAvatar(radius: 4, backgroundColor: Color(int.tryParse(taskPrioritat.color!) ?? 0xFFFFFFFF))
                              else
                                Container(),
                              const SizedBox(height: 1),
                            ]
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]
      ),
    );
  }

  static Container buildEtiqueta(String etiqueta, Appointment appointment) {
    if (etiqueta.isEmpty) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        child: Text(
          etiqueta.toUpperCase(),
          style: TextStyle(
            color: appointment.color,
            fontSize: 4,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis
        ),
      ),
    );
  }
}