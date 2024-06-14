import "package:flutter/material.dart";
import "package:placker/models/models.dart";


//gestió de l'estat de l'assignatura
class SubjectFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Subject subject;
  Subject originalSubject;

  //constructor
  SubjectFormProvider(Subject subject): this.subject = subject, this.originalSubject = subject.copy();

  //per validar el formulari 
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}