import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/providers/providers.dart';
import 'package:placker/services/services.dart';
import 'package:placker/widgets/widgets.dart'; 

//aquest codi ha estat adaptat del vídeo Flutter Tutorial - Calendar Event App | With Day View & Week View - Flutter Syncfusion Calendar de HeyFlutter.com https://www.youtube.com/watch?v=LoDtxRkGDTw 

//pantalla per modificar les tasques (editar i afegir) 
class AddTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final taskService = Provider.of<TasksService>(context);

    return ChangeNotifierProvider(
      create: (_) => TaskFormProvider(taskService.selectedTask),
      child: _TaskScreenBody(tasksService: taskService),
    );
  }
}
    
class _TaskScreenBody extends StatelessWidget {

  const _TaskScreenBody({
    Key? key,
    required this.tasksService,
  }): super(key: key);

  final TasksService tasksService;

  @override
  Widget build(BuildContext context) {

    final taskForm = Provider.of<TaskFormProvider>(context);
    final task = taskForm.task;

    return Scaffold(
      backgroundColor: const Color(0xFFCDE7FF),
      body: Form(
        key: taskForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [

            //creu a dalt a la dreta per tornar a la pantalla anterior
            Padding(
              padding: const EdgeInsets.only(right: 5, left:5, top: 20, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
            ),

            //títol de la pantalla
            const Text(
              'TASCA',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF506EA4),
              ),
            ),

            const SizedBox(height: 5),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
        
                    //assignatura
                    TaskDropdownSubject(
                      text: 'Assignatura:',
                      options: Provider.of<SubjectsService>(context).subjects.map((subject) => subject.assignatura).toList(),
                      value: task.subject,
                      onChanged: (value) => task.subject = value,
                    ),
                    
                    //nom de la tasca
                    TaskTasca(
                      text: 'Tasca:',
                      value: task.tasca,  
                      onChanged: (value) => task.tasca = value,
                      validator: (value) => value != null && value.isEmpty ? 'Introdueix una tasca' : null,
                    ),

                    //dia
                    TaskDay(
                      text: 'Dia:',
                      value: task.dia,  
                      onChanged: (value) => task.dia = value,
                    ),

                    //hores d'inici i fi
                    TaskHour(
                      text: 'Hora:',
                      startValue: task.horaStart, 
                      endValue: task.horaEnd,
                      onChanged: (newStartValue, newEndValue) {
                        task.horaStart = newStartValue;
                        task.horaEnd = newEndValue;
                      },
                    ),
                    
                    //recurrent
                    TaskRecurrent(
                      text: 'Recurrent:',
                      value: task.recurrent,  
                      onChanged: (value) => task.recurrent = value,
                    ),
                    
                    //etiqueta
                    TaskDropdownEtiqueta(
                      text: 'Etiqueta:',
                      options: Provider.of<EtiquetaService>(context).etiquetes.map((etiqueta) => etiqueta.nom).toList(),
                      value: task.etiqueta,
                      onChanged: (value) => task.etiqueta = value,
                    ),

                    //color
                    TaskColor(
                      text: 'Color:',
                      value: task.color,
                      onChanged: (value) => task.color = value,
                    ),
                    
                    //prioritat
                    TaskDropdownPrioritat(
                      text: 'Prioritat:',
                      options: Provider.of<PrioritatService>(context).prioritats.map((prioritat) => prioritat.nom).toList(),
                      value: task.prioritat,
                      onChanged: (value) => task.prioritat = value,
                    ),

                    //isDone
                    TaskIsDone(
                      text: 'Completada:',
                      value: task.isDone,  
                      onChanged: (value) => task.isDone = value,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),

      //botó per guardar la tasca
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          if (!taskForm.isValidForm()) return;
          await tasksService.updateOrCreateTask(taskForm.task);
          Navigator.pop(context);
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF506EA4),
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        child: const Text('GUARDAR', style: TextStyle(fontSize: 18)), 
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}