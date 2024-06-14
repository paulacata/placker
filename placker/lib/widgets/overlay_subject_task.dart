import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:placker/models/models.dart';
import 'package:placker/services/services.dart';


//classe per triar si es vol afegir assignatura o tasca
class OverlaySubjectTask extends StatelessWidget {

  String dateTimeToDayString(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  String dateTimeToHourString(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {

    final subjectsService = Provider.of<SubjectsService>(context);
    final tasksService = Provider.of<TasksService>(context);

    //utiltizar un stack perquè no s'obri com una nova pantalla
    return Stack(
      children: <Widget>[

        //la resta de fons amb opacitat i es tanca el stack si prems fora
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.black.withOpacity(0.3),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),

        Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //botó per afegir tasca
                ElevatedButton(
                  onPressed: () {
                    tasksService.selectedTask = Task(
                      subject: '',
                      tasca: '',
                      dia: dateTimeToDayString(DateTime.now()),
                      horaStart: dateTimeToHourString(DateTime.now()),
                      horaEnd: dateTimeToHourString(DateTime.now().add(const Duration(hours: 1))),
                      recurrent: false,
                      etiqueta: '',
                      color: '0xff506EA4',
                      prioritat: '',
                      isDone: false,
                    );
                    Navigator.pushNamed(context, 'AddTask');
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF96BDEC),
                    elevation: 0,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 40),
                  ),

                  child: const Text('TASCA'),
                ),
                
                const SizedBox(height: 20),
                
                //botó per afegir assignatura
                ElevatedButton(
                  onPressed: () {
                    subjectsService.selectedSubject = Subject(
                      assignatura: '',
                      color:'0xff506EA4',
                      objectius: null,
                    );
                    Navigator.pushNamed(context, 'AddSubject');
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF96BDEC),
                    elevation: 0,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 40),
                  ),

                  child: const Text('ASSIGNATURA'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}