import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/services/services.dart';

//overlay on es mostren els filtres al calendari i al llistat
class FiltersOverlay extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final subjectsService = Provider.of<SubjectsService>(context);
    final filtersService = Provider.of<FiltersService>(context);
    final etiquetaService = Provider.of<EtiquetaService>(context);
    final prioritatService = Provider.of<PrioritatService>(context);

    final etiquetes = etiquetaService.etiquetes.map((prioritat) => prioritat.nom).toList();
    final prioritats = prioritatService.prioritats.map((prioritat) => prioritat.nom).toList();

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Center(child: Text('FILTRES', style: TextStyle(fontSize: 22, color: Color(0xFF506EA4), fontWeight: FontWeight.bold))),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //opcions d'assignatures
            const Text('Assignatures', style: TextStyle(fontSize: 18, color: Color(0xFF506EA4))),
            ...subjectsService.subjects.map((subject) {
              return CheckboxListTile(
                title: Text(subject.assignatura!, style: const TextStyle(fontSize: 15, color: Colors.grey)),
                value: filtersService.selectedSubjects.contains(subject.assignatura),
                onChanged: (bool? value) {
                  filtersService.selectSubject(subject.assignatura);
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color(0xFF506EA4),
                side: const BorderSide(color: Colors.grey, width: 2),
                
              );
            }).toList(),

            const SizedBox(height: 15),

            //opcions d'etiquetes
            const Text('Etiquetes', style: TextStyle(fontSize: 19, color: Color(0xFF506EA4))),
            ...etiquetes.map((etiqueta) {
              return CheckboxListTile(
                title: Text(etiqueta!, style: const TextStyle(fontSize: 15, color: Colors.grey)),
                value: filtersService.selectedEtiquetas.contains(etiqueta),
                onChanged: (bool? value) {
                  filtersService.selectEtiqueta(etiqueta);
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color(0xFF506EA4),
                side: const BorderSide(color: Colors.grey, width: 2),
              );
            }).toList(),

            const SizedBox(height: 15),
            
            //opcions de prioritats
            const Text('Prioritats', style: TextStyle(fontSize: 19, color: Color(0xFF506EA4))),
            ...prioritats.map((prioritat) {
              return CheckboxListTile(
                title: Text(prioritat!, style: const TextStyle(fontSize: 15, color: Colors.grey)),
                value: filtersService.selectedPrioritats.contains(prioritat),
                onChanged: (bool? value) {
                  filtersService.selectPrioritat(prioritat);
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color(0xFF506EA4),
                side: const BorderSide(color: Colors.grey, width: 2),
              );
            }).toList(),

            const SizedBox(height: 15),

            //opcions de tasques pendents o realitzades
            const Text('Estat', style: TextStyle(fontSize: 19, color: Color(0xFF506EA4))),
            CheckboxListTile(
              title: const Text('Pendents', style: TextStyle(fontSize: 15, color: Colors.grey)),
              value: filtersService.showCompletedTasks,
              onChanged: (bool? value) {
                filtersService.selectShowCompletedTasks(value ?? false);              
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFF506EA4),
              side: const BorderSide(color: Colors.grey, width: 2),
            ),

            CheckboxListTile(
              title: const Text('Realitzades', style: TextStyle(fontSize: 15, color: Colors.grey)),
              value: filtersService.showPendingTasks,
              onChanged: (bool? value) {
                filtersService.selectShowPendingTasks(value ?? false);
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFF506EA4),
              side: const BorderSide(color: Colors.grey, width: 2),
            ),
          ],
        ),
      ),

      actions: [

        //botó per treure tots els filtres
        ElevatedButton(
          onPressed: () {
            filtersService.clearFilters();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: const Color(0xFF506EA4),
          ), 
          child: const Text('Treure tots els filtres', style: TextStyle(color: Color(0xFF506EA4))),
        ),

        //botó per aplicar tots els filtres
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: const Color(0xFF506EA4),
          ), 
          child: const Text('Aplicar els filtres', style: TextStyle(color: Color(0xFF506EA4))),
        ),
      ],
    );
  }
}