import 'package:flutter/material.dart';


//gestió de l'estat dels camps dels formularis per log in i sign up
class LoginFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String username = '';
  String mail = '';
  String password = '';
  String phone = '';

  bool _isLoading = false;
  
  bool get isLoading => _isLoading;
  
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  //per validar el formulari 
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}