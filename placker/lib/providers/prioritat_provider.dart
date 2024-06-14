import "package:flutter/material.dart";
import "package:placker/models/models.dart";


//gestió de l'estat de la prioritat
class PrioritatProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Prioritat prioritat;

  //constructor
  PrioritatProvider(this.prioritat);

  //per validar el formulari 
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}