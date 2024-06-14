import 'package:flutter/material.dart';


//per gestionar els filtres del calendari i el llistat
class FiltersService extends ChangeNotifier {
  List<String?> selectedSubjects = [];
  List<String?> selectedEtiquetas = [];
  List<String?> selectedPrioritats = [];

  //inicialitzem a true perquè es mostrin tant les tasques realitzades com les pendents
  bool showCompletedTasks = true;
  bool showPendingTasks = true;

  void selectSubject(String? subject) {
    if (selectedSubjects.contains(subject)) {
      selectedSubjects.remove(subject);
    } else {
      selectedSubjects.add(subject);
    }
    notifyListeners();
  }

  void selectEtiqueta(String? etiqueta) {
    if (selectedEtiquetas.contains(etiqueta)) {
      selectedEtiquetas.remove(etiqueta);
    } else {
      selectedEtiquetas.add(etiqueta);
    }
    notifyListeners();
  }

  void selectPrioritat(String? prioritat) {
    if (selectedPrioritats.contains(prioritat)) {
      selectedPrioritats.remove(prioritat);
    } else {
      selectedPrioritats.add(prioritat);
    }
    notifyListeners();
  }

  void selectShowCompletedTasks(bool value) {
    showCompletedTasks = value;
    notifyListeners();
  }

  void selectShowPendingTasks(bool value) {
    showPendingTasks = value;
    notifyListeners();
  }

  void clearFilters() {
    selectedSubjects = [];
    selectedEtiquetas = [];
    selectedPrioritats = [];
    showCompletedTasks = true;
    showPendingTasks = true;
    notifyListeners();
  }
}