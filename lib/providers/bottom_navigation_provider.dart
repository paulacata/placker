import "package:flutter/material.dart";

//aquest codi ha estat adaptat del curs Legacy – Flutter: Tu guia completa para IOS y Android de Fernando Herrera https://www.udemy.com/course/flutter-ios-android-fernando-herrera/ 

//per la barra de navegació inferior 
class BottomNavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}