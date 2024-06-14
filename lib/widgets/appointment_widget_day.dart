import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';

import 'package:placker/models/models.dart'; 
import 'package:placker/widgets/widgets.dart'; 
import 'package:placker/services/services.dart';


//per crear l'appointment al calendari diari
class AppointmentWidgetDay {
  static Widget appointmentBuilder(BuildContext context, CalendarAppointmentDetails details, TaskDataSource dataSource) {
    
    final Appointment appointment = details.appointments.first;
    final tasksService = Provider.of<TasksService>(context, listen: false);

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
    
    // s'obre un pop up per editar o eliminar la tasca
    return GestureDetector(
      onTap: () {
        tasksService.selectedTask = taskToEdit;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return OverlayEditTask(task: taskToEdit);
          },
        );
      },

      //decoració de l'appointment
      child: Container(
        decoration: BoxDecoration(
          color: appointment.color,
          borderRadius: BorderRadius.circular(8),
        ),
          
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Column(
            children: [
              Flexible(
                child: SingleChildScrollView (
                  scrollDirection: Axis.vertical,     
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isDone)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                          
                          const SizedBox(width: 3),

                          Text(
                            printSubjectTask,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis
                          ),
                        ],
                      ),
              
                      Row(
                        children: [
                          Flexible(
                            child: Wrap(
                              children: [
                                buildEtiqueta(etiqueta, appointment),
                                const SizedBox(width: 8),
                                if (taskPrioritat.color != null && taskPrioritat.color != '')
                                  CircleAvatar(radius: 8, backgroundColor: Color(int.tryParse(taskPrioritat.color!) ?? 0xFFFFFFFF))
                                else
                                  Container()
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
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Text(
          etiqueta.toUpperCase(),
          style: TextStyle(
            color: appointment.color,
            fontSize: 9,
          ),
        ),
      ),
    );
  }
}