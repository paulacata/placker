import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/services/services.dart';
import 'package:placker/models/models.dart';
import 'package:placker/screens/screens.dart';


//pop up que s'obre per editar, eliminar o registrar una tasca
class OverlayEditTask extends StatelessWidget {

  final Task? task;

  OverlayEditTask({this.task});
  
  @override
  Widget build(BuildContext context) {

    final tasksService = Provider.of<TasksService>(context);

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

                //botó per editar la tasca 
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'AddTask');
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    foregroundColor: const Color(0xFF506EA4),
                    minimumSize: const Size(250, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF506EA4), width: 2),
                    ),
                  ),

                  child: const Text(
                    'EDITAR TASCA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                //botó per eliminar la tasca 
                ElevatedButton(
                  onPressed: () {
                    tasksService.deleteTask(task!.id!);
                    Navigator.of(context).pop();
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    foregroundColor: const Color(0xFF506EA4),
                    minimumSize: const Size(250, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF506EA4), width: 2),
                    ),
                  ),

                  child: const Text(
                    'ELIMINAR TASCA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                //botó per registrar la tasca
                ElevatedButton(
                  onPressed: () {     
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(task: task),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    foregroundColor: const Color(0xFF506EA4),
                    minimumSize: const Size(250, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF506EA4), width: 2),
                    ),
                  ),

                  child: const Text(
                    'REGISTRAR TASCA',
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