import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/services/services.dart';
import 'package:placker/models/models.dart';


//pop up que s'obre per editar o eliminar una assignatura
class OverlayEditSubject extends StatelessWidget {
  
  final Subject subject;

  OverlayEditSubject({required this.subject});
  
  @override
  Widget build(BuildContext context) {

    final subjectsService = Provider.of<SubjectsService>(context);

    //utilitzar un stack perquè no s'obri com una nova pantalla
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

                //botó per editar l'assignatura 
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'AddSubject');
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    foregroundColor: const Color(0xFF506EA4),
                    minimumSize: const Size(270, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF506EA4), width: 2),
                    ),
                  ),

                  child: const Text(
                    'EDITAR ASSIGNATURA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                //botó per eliminar l'assignatura
                ElevatedButton(
                  onPressed: () async {
                    final tasksService = Provider.of<TasksService>(context, listen: false);
                    final subjectToDelete = subjectsService.selectedSubject;

                    for (final task in tasksService.tasks) {
                      if (task.subject == subjectToDelete.assignatura) {
                        task.subject = "";
                        await tasksService.updateTask(task);
                      }
                    }
                    subjectsService.deleteSubject(subject.id!);
                    Navigator.of(context).pop();
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    foregroundColor: const Color(0xFF506EA4),
                    minimumSize: const Size(270, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF506EA4), width: 2),
                    ),
                  ),

                  child: const Text(
                    'ELIMINAR ASSIGNATURA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}