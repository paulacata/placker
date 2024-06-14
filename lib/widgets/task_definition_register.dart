import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/models/models.dart';
import 'package:placker/services/services.dart';


//per mostrar la tasca a la part superior de la pantalla amb un format visual determinat
class TaskDefinitionRegister extends StatelessWidget {

  final Task task;

  const TaskDefinitionRegister({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prioritatService = Provider.of<PrioritatService>(context);
    final prioritat = prioritatService.prioritats.firstWhere((prioritat) => prioritat.nom == task.prioritat, orElse: () => Prioritat(id: '', nom: '', color: ''));

    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width - 50,
      decoration: BoxDecoration(
        color: task.color != null ? Color(int.parse(task.color!)) : null,
        borderRadius: BorderRadius.circular(8),
      ),
                
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Flexible(
              child: SingleChildScrollView (
                scrollDirection: Axis.vertical,     
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
    
                    //mostrar l'assignatura i la tasca
                    if (task.subject != '') 
                    Text(
                      '${task.subject} - ${task.tasca}',
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis
                    )
                    
                    else
                    Text(
                      task.tasca ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis
                    ),
    
                    const SizedBox(height: 5),
    
                    //mostrar l'etiqueta i la prioritat
                    Row(
                      children: [
                        Flexible(
                          child: Wrap(
                            children: [
                              _buildEtiqueta(task.etiqueta!, task.color != null ? Color(int.parse(task.color!)) : const Color(0xff506EA4)),
                              const SizedBox(width: 8),
                              if (prioritat.color != null && prioritat.color != '')
                                CircleAvatar(radius: 8, backgroundColor: Color(int.tryParse(prioritat.color!) ?? 0xFFFFFFFF))
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
    );
  }

  static Widget _buildEtiqueta(String etiqueta, Color color) {
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
            color: color,
            fontSize: 9,
          ),
        ),
      ),
    );
  }
}