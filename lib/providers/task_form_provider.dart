import 'package:flutter/material.dart';
import "package:placker/models/models.dart";


//gestió de l'estat de la tasca
class TaskFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Task task;

  //constructor
  TaskFormProvider(this.task);

  //per validar el formulari 
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}