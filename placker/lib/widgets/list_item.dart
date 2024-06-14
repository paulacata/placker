import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/models/models.dart';
import 'package:placker/services/services.dart';


//les tasques que apareixen al llistat dins de cada assignatura
class ListItem extends StatelessWidget {

  final Task task;

  const ListItem({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prioritatService = Provider.of<PrioritatService>(context);
    final prioritat = prioritatService.prioritats.firstWhere((prioritat) => prioritat.nom == task.prioritat, orElse: () => Prioritat(id: '', nom: '', color: ''));

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              
              //nom de la tasca
              Flexible(
                child: Text(
                  task.tasca!,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              const SizedBox(width: 8),

              //etiqueta de la tasca
              buildEtiqueta(task.etiqueta!),

              const SizedBox(width: 8),

              //prioritat de la tasca
              if (prioritat.color != null && prioritat.color != '')
                CircleAvatar(radius: 8, backgroundColor: Color(int.tryParse(prioritat.color!) ?? 0xFFFFFFFF))
              else
                Container()
            ],
          ),
        ],
      ),
    );
  }
}

//per dibuixar l'etiqueta amb el format corresponent
Container buildEtiqueta(String etiqueta) {
  if (etiqueta.isEmpty) {
    return Container();
  }
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Text(
        etiqueta.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    ),
  );
}