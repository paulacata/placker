import "package:flutter/material.dart";
import "package:placker/models/models.dart";


//gestió de l'estat de l'etiqueta
class EtiquetaProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Etiqueta etiqueta;

  //constructor
  EtiquetaProvider(this.etiqueta);

  //per validar el formulari 
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}