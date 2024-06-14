import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/models/models.dart';
import 'package:placker/providers/providers.dart';
import 'package:placker/services/services.dart';
import 'package:placker/widgets/widgets.dart'; 


//pantalla per modificar les etiquetes (editar, eliminar i afegir)
class AddEtiquetaScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final etiquetaService = Provider.of<EtiquetaService>(context);

    return ChangeNotifierProvider(
      create: (_) => EtiquetaProvider(etiquetaService.selectedEtiqueta),
      child: _EtiquetaScreenBody(etiquetaService: etiquetaService),
    );
  }
}

class _EtiquetaScreenBody extends StatelessWidget {

  const _EtiquetaScreenBody({
    Key? key,
    required this.etiquetaService,
  }): super(key: key);

  final EtiquetaService etiquetaService;

  @override
  Widget build(BuildContext context) {

    final etiquetaForm = Provider.of<EtiquetaProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFCDE7FF),
      body: Column(

        children: [
        
          //creu a dalt a la dreta per tornar a la pantalla anterior
          Padding(
            padding: const EdgeInsets.only(right: 5, left:5, top: 25, bottom: 0),
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
            'ETIQUETA',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF506EA4),
            ),
          ),
      
          const SizedBox(height: 30),
      
          Expanded(
            child: ListView.builder(
              itemCount: etiquetaService.etiquetes.length,
              itemBuilder: (BuildContext context, int index) {
                final etiqueta = etiquetaService.etiquetes[index];
                return ListTile(
                  title: Row(
                    children: [
                      
                      //noms de les etiquetes
                      Expanded(
                        child: Text(etiqueta.nom ?? '', style: const TextStyle(color: Colors.grey)),
                      ),
                      
                      //per eliminar l'etiqueta
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        iconSize: 20,
                        onPressed: () async {
                          final tasksService = Provider.of<TasksService>(context, listen: false);
                          
                          for (final task in tasksService.tasks) {
                            if (task.etiqueta == etiqueta.nom) {
                              task.etiqueta = "";
                              await tasksService.updateTask(task);
                            }
                          }
                          etiquetaService.deleteEtiqueta(etiqueta.id!);
                        },
                      ),
                      
                      //per editar l'etiqueta
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        iconSize: 20,
                        onPressed: () {
                          etiquetaForm.etiqueta = etiqueta;
                          _showEtiquetaDialog(context, etiquetaService, etiquetaForm, initialText: etiquetaForm.etiqueta.nom);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 30),
          
          //per afegir l'etiqueta
          Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: ElevatedButton(
              onPressed: () {
                etiquetaForm.etiqueta = Etiqueta(id: null, nom: '');
                _showEtiquetaDialog(context, etiquetaService, etiquetaForm, initialText: null);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                elevation: 0,
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.add, size: 35, color: Colors.white),
            ),
          ),  
        ],
      ),
    );
  }
}

//serveix per editar el nom de l'etiqueta o per afegir-ne una de nova
void _showEtiquetaDialog(BuildContext context, EtiquetaService etiquetaService, EtiquetaProvider etiquetaForm, {String? initialText}) {
  
  TextEditingController _controller = TextEditingController(text: initialText);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: TextField(
          controller: _controller,
          cursorColor: const Color.fromARGB(255, 170, 170, 170),
          decoration: InputDecorations.LoginInputDecoration(hintText: ''),
          style: const TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.normal),
        ),
        
        actions: [
          
          //botó per cancel·lar
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shadowColor: Colors.transparent,
              surfaceTintColor: const Color(0xFF506EA4),
            ), 
            child: const Text('Cancelar', style: TextStyle(color: Color(0xFF506EA4))),
          ),

          //botó per acceptar
          ElevatedButton(
            onPressed: () async {
              String newEtiqueta = _controller.text.trim();
              if (newEtiqueta.isNotEmpty) {
                Etiqueta novaEtiqueta = Etiqueta(id: etiquetaForm.etiqueta.id, nom: newEtiqueta);
                Etiqueta anteriorEtiqueta = Etiqueta(id: etiquetaForm.etiqueta.id, nom: etiquetaForm.etiqueta.nom);
                await etiquetaService.updateOrCreateEtiqueta(novaEtiqueta, anteriorEtiqueta);
              }
              Navigator.pop(context);
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shadowColor: Colors.transparent,
              surfaceTintColor: const Color(0xFF506EA4),
            ), 
            child: const Text('ACEPTAR', style: TextStyle(color: Color(0xFF506EA4))),
          ),
        ],
      );
    },
  );
}