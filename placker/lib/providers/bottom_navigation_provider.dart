import "package:flutter/material.dart";


//per la barra de navegació inferior 
class BottomNavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}