import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';

import 'package:placker/models/models.dart';
import 'package:placker/providers/providers.dart';
import 'package:placker/services/services.dart';
import 'package:placker/widgets/widgets.dart'; 


//pantalla per modificar les prioritats (editar, eliminar i afegir)
class AddPrioritatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final prioritatService = Provider.of<PrioritatService>(context);

    return ChangeNotifierProvider(
      create: (_) => PrioritatProvider(prioritatService.selectedPrioritat),
      child: _PrioritatScreenBody(prioritatService:prioritatService),
    );
  }
}

class _PrioritatScreenBody extends StatelessWidget {

  const _PrioritatScreenBody({
    Key? key,
    required this.prioritatService,
  }): super(key: key);

  final PrioritatService prioritatService;

  @override
  Widget build(BuildContext context) {

    final prioritatForm = Provider.of<PrioritatProvider>(context);

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
      
          const SizedBox(height: 30),
      
          Expanded(
            child: ListView.builder(
              itemCount: prioritatService.prioritats.length,
              itemBuilder: (BuildContext context, int index) {
                final prioritat = prioritatService.prioritats[index];
                return ListTile(
                  title: Row(
                    children: [
                      
                      //colors de les prioritats
                      GestureDetector(
                        onTap: () => _showColorPicker(context, prioritat, prioritatService),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: (prioritat.color != null ? Color(int.parse(prioritat.color!)) : const Color(0xFF506EA4)),
                        ),
                      ),

                      const SizedBox(width: 10),
                      
                      //noms de les prioritats
                      Expanded(
                        child: Text(prioritat.nom ?? '', style: const TextStyle(color: Colors.grey)),
                      ),
                      
                      //per eliminar la prioritat
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        iconSize: 20,
                        onPressed: () async {
                          final tasksService = Provider.of<TasksService>(context, listen: false);

                          for (final task in tasksService.tasks) {
                            if (task.prioritat == prioritat.nom) {
                              task.prioritat = "";
                              await tasksService.updateTask(task);
                            }
                          }
                          prioritatService.deletePrioritat(prioritat.id!);
                        },
                      ),
                      
                      //per editar la prioritat
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        iconSize: 20,
                        onPressed: () {
                          prioritatForm.prioritat = prioritat;
                          _showPrioritatDialog(context, prioritatService, prioritatForm, initialText: prioritatForm.prioritat.nom);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 30),
          
          //per afegir la prioritat
          Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: ElevatedButton(
              onPressed: () {
                prioritatForm.prioritat = Prioritat(id: null, nom: '', color: '0xFF506EA4');
                _showPrioritatDialog(context, prioritatService, prioritatForm, initialText: null);
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

//serveix per editar el nom de la prioritat o per afegir-ne una de nova
void _showPrioritatDialog(BuildContext context, PrioritatService prioritatService, PrioritatProvider prioritatForm, {String? initialText}) {
  
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
              String newPrioritat = _controller.text.trim();
              if (newPrioritat.isNotEmpty) {
                Prioritat novaPrioritat = Prioritat(id: prioritatForm.prioritat.id, nom: newPrioritat);
                Prioritat anteriorPrioritat = Prioritat(id: prioritatForm.prioritat.id, nom: prioritatForm.prioritat.nom);

                if (prioritatForm.prioritat.id == null) {
                  novaPrioritat.color = '0xFF506EA4';
                } else {
                  novaPrioritat.color = prioritatForm.prioritat.color ?? '0xFF506EA4'; 
                }

                await prioritatService.updateOrCreatePrioritat(novaPrioritat, anteriorPrioritat);
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

//serveix per editar el color de la prioritat
void _showColorPicker(BuildContext context, Prioritat prioritat, PrioritatService prioritatService) {
  
  Color _selectedColor = prioritat.color != null ? Color(int.parse(prioritat.color!)) : const Color(0xFF506EA4);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: MaterialColorPicker(
            selectedColor: _selectedColor,
            onMainColorChange: (ColorSwatch<dynamic>? colorSwatch) {
              if (colorSwatch != null) {
                //agafa la tonalitat concreta
                Color color = colorSwatch[500]!;
                _selectedColor = color;
              }
            },
            allowShades: false,
            colors: [
            ColorSwatch(const Color(0xFF506EA4).value, const {500:  Color(0xFF506EA4)}),
            ColorSwatch(Colors.red.shade300.value, {500: Colors.red.shade300}),
            ColorSwatch(Colors.cyan.shade200.value, {500: Colors.cyan.shade200}),
            ColorSwatch(Colors.yellow.shade300.value, {500: Colors.yellow.shade300}),
            ColorSwatch(Colors.pink.shade200.value, {500: Colors.pink.shade200}),
            ColorSwatch(Colors.green.shade200.value, {500: Colors.green.shade200}),
            ColorSwatch(const Color(0xFFCE82DB).value, const {500:  Color(0xFFCE82DB)}),
            ColorSwatch(const Color(0xFFECB87A).value, const {500:  Color(0xFFECB87A)}),
            ],
          ),
        ),

        //botó per cancel·lar
        actions: <Widget>[
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
            child: const Text('Cancelar', style: TextStyle (color: Color(0xFF506EA4))),
          ),

          //botó per acceptar
          ElevatedButton(
            onPressed: () {
              prioritat.color = '0x${_selectedColor.value.toRadixString(16)}';
              prioritatService.updatePrioritat(prioritat, prioritat);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shadowColor: Colors.transparent,
              surfaceTintColor: const Color(0xFF506EA4),
            ),           
            child: const Text('ACEPTAR', style: TextStyle (color: Color(0xFF506EA4))),
          ),
        ],
      );
    },
  );
}