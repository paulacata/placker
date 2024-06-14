import 'package:flutter/material.dart';
import 'package:placker/widgets/widgets.dart';


//per afegir objectius a l'assignatura
class SubjectObjectives extends StatefulWidget {
  
  final String text;
  final String? value;
  final Function(String?) onChanged;
  
  const SubjectObjectives({
    Key? key,
    required this.text,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SubjectObjectivesState createState() => _SubjectObjectivesState();
}

class _SubjectObjectivesState extends State<SubjectObjectives> {
  
  late List<String> _selectedObjectives;

  @override
  void initState() {
    super.initState();
    _selectedObjectives = _stringToList(widget.value);
  }

  //passar del string de Firebase a una llista
  List<String> _stringToList(String? value) {
    if (value == null || value.isEmpty) {
      return [];
    } else {
      return value.replaceAll(RegExp(r'\[|\]'), '').split(', ');
    }
  }

  //passar de la llista al string de Firebase
  String _listToString(List<String> objectives) {
    return objectives.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BuildTaskText(text: widget.text),
              Expanded(
                child: Container(
                  height: 30,
                  alignment: Alignment.centerLeft,

                  //per afegir l'objectiu
                  child: ElevatedButton(
                    onPressed: () => _showOptionDialog(context, initialText: null),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      elevation: 0,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.add, size: 30, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),
          
          //llistat d'objectius
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_selectedObjectives.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '• ${_selectedObjectives[index]}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      //per eliminar l'objectiu
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        iconSize: 17,
                        onPressed: () {
                          setState(() {
                            _selectedObjectives.removeAt(index);
                          });
                          widget.onChanged(_listToString(_selectedObjectives));
                        },
                      ),

                      //per editar l'objectiu
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        iconSize: 17,
                        onPressed: () {
                          _showOptionDialog(context, initialText: _selectedObjectives[index]);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  //diàleg per afegir un nou objectiu o editar un existent
  void _showOptionDialog(BuildContext context, {String? initialText}) {
    
    TextEditingController _controller = TextEditingController(text: initialText);
    bool isEditing = initialText != null;
    int? indexOfEditedObjective;

    //es busca l'índex de l'objectiu si s'està editant
    if (isEditing) {
      indexOfEditedObjective = _selectedObjectives.indexOf(initialText);
    }

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
            
            //botó de cancel·lar
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shadowColor: Colors.transparent,
                surfaceTintColor: const Color(0xFF506EA4),
              ), 
              child: const Text('Cancelar', style: TextStyle(color: Color(0xFF506EA4))),
            ),

            //botó d'acceptar
            TextButton(
              onPressed: () {
                setState(() {
                  String newObjective = _controller.text.trim();
                  if (isEditing) {
                    
                    //actualitzar l'objectiu
                    _selectedObjectives[indexOfEditedObjective!] = newObjective;
                    _selectedObjectives = _reorderObjectives(_selectedObjectives, indexOfEditedObjective);
                  } else {
                    
                    //afegir el nou objectiu
                    _selectedObjectives.add(newObjective);
                  }
                });
                widget.onChanged(_listToString(_selectedObjectives));
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

  //perquè l'objectiu que s'ha afegit nou aparegui l'últim de la llista
  List<String> _reorderObjectives(List<String> objectives, int indexOfEditedObjective) {
    String editedObjective = objectives.removeAt(indexOfEditedObjective);
    objectives.insert(indexOfEditedObjective, editedObjective);
    return objectives;
  }
}