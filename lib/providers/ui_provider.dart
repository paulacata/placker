import 'package:flutter/material.dart';

//per actualitzar l'opció seleccionada del menú
class UiProvider extends ChangeNotifier{

  //índex de l'opció seleccionada 
  int _selectedMenuOption = 0;

  int get selectedMenuOption => _selectedMenuOption;

  set selectedMenuOption(int i){
    this._selectedMenuOption = i;
    notifyListeners();
  }
}