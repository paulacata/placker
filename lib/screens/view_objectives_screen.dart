import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/providers/providers.dart';
import 'package:placker/services/services.dart';


//classe per veure els objectius de cada assignatura
class ViewObjectivesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final subjectService = Provider.of<SubjectsService>(context);

    return ChangeNotifierProvider(
      create: (_) => SubjectFormProvider(subjectService.selectedSubject),
      child: _ViewObjectivesBody(subjectsService: subjectService, subjectColor: Color(int.tryParse(subjectService.selectedSubject.color ?? '0xFF506EA4') ?? 0xFF506EA4)),
    );
  }
}

class _ViewObjectivesBody extends StatelessWidget {

  const _ViewObjectivesBody({
    Key? key,
    required this.subjectsService,
    required this.subjectColor,
  }): super(key: key);

  final SubjectsService subjectsService;
  final Color subjectColor;

  @override
  Widget build(BuildContext context) {

    final subjectForm = Provider.of<SubjectFormProvider>(context);
    final subject = subjectForm.subject;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 70),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: subjectColor, width: 3),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5, left:5, top: 20, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  //botó per tornar enrere
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded, color: subjectColor),
                  ),

                  //text amb l'assignatura
                  Flexible(
                    child: Text(
                      subjectsService.selectedSubject.assignatura!,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: subjectColor),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            //per fer la llista d'objectius
            SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    SubjectObjectivesView(
                      value: subject.objectius,  
                      onChanged: (value) => subject.objectius = value, 
                    ),
                  ],
                ),
              ),
            ],
        ),
      ),
    );
  }
}

//visualització dels objectius
class SubjectObjectivesView extends StatefulWidget {
  
  final String? value;
  final Function(String?) onChanged;
  
  const SubjectObjectivesView({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SubjectObjectivesViewState createState() => _SubjectObjectivesViewState();
}

class _SubjectObjectivesViewState extends State<SubjectObjectivesView> {
  
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //dibuixar els objectius
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_selectedObjectives.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ${_selectedObjectives[index]}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
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
}