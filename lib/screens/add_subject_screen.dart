import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/models/models.dart'; 
import 'package:placker/providers/providers.dart';
import 'package:placker/services/services.dart';
import 'package:placker/widgets/widgets.dart'; 


//pantalla per modificar les assignatures (editar i afegir) 
class AddSubjectScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final subjectService = Provider.of<SubjectsService>(context);

    return ChangeNotifierProvider(
      create: (_) => SubjectFormProvider(subjectService.selectedSubject),
      child: _SubjectScreenBody(subjectsService: subjectService),
    );
  }
}

class _SubjectScreenBody extends StatelessWidget {

  const _SubjectScreenBody({
    Key? key,
    required this.subjectsService,
  }): super(key: key);

  final SubjectsService subjectsService;

  @override
  Widget build(BuildContext context) {

    final subjectForm = Provider.of<SubjectFormProvider>(context);
    final subject = subjectForm.subject;
    
    return Scaffold(
      backgroundColor: const Color(0xFFCDE7FF),
      body: Form(
        key: subjectForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
        
            //creu a dalt a la dreta per tornar a la pantalla anterior
            Padding(
              padding: const EdgeInsets.only(right: 5, left:5, top: 20, bottom: 0),
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
              'ASSIGNATURA',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF506EA4),
              ),
            ),
            
            const SizedBox(height: 5),
        
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    //nom de l'assignatura
                    SubjectAssignatura(
                      text: 'Assignatura: ',
                      value: subject.assignatura,  
                      onChanged: (value)  => subject.assignatura = value,
                      validator: (value) => value != null && value.isEmpty ? 'Introdueix una assignatura' : null,
                    ),

                    //color de l'assignatura
                    SubjectColor(
                      text: 'Color: ',
                      value: subject.color,  
                      onChanged: (value) => subject.color = value,
                    ),

                    //objectius de l'assignatura
                    SubjectObjectives(
                      text: 'Objectius:',
                      value: subject.objectius,  
                      onChanged: (value) => subject.objectius = value, 
                    ),
                  ],
                )
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),

      //botó per guardar l'assignatura
      floatingActionButton: ElevatedButton(        
        onPressed: () async {
          if (!subjectForm.isValidForm()) return;
          Subject nouSubject = subjectForm.subject;
          Subject anteriorSubject = subjectForm.originalSubject;
          await subjectsService.updateOrCreateSubject(nouSubject, anteriorSubject);
          Navigator.of(context).pop();
        },
    
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF506EA4),
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        child: const Text('GUARDAR', style: TextStyle(fontSize: 18)), 
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}