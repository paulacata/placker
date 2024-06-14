import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:placker/models/models.dart';
import 'package:placker/services/services.dart';


//fa les peticions http per la prioritat
class PrioritatService extends ChangeNotifier {

  final String _baseUrl = 'placker-app-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Prioritat> prioritats = [];
  late Prioritat selectedPrioritat;
  bool isSaving = false;
  final TasksService tasksService;
  final storage = new FlutterSecureStorage();
  
  PrioritatService(this.tasksService) {
    selectedPrioritat = Prioritat();
    loadPrioritats();
  }

  Future<String?> _getUid() async {
    return await storage.read(key: 'uid');
  }

  Future<void> loadPrioritats() async { 
    final uid = await _getUid(); 
    final url = Uri.https(_baseUrl, 'users/$uid/prioritats.json');
    final response = await http.get(url);
    final Map<String, dynamic> prioritatsMap = json.decode(response.body);

    prioritats.clear();

    prioritatsMap.forEach((key, value) {
      final temporalPrioritat = Prioritat.fromMap(value);
      temporalPrioritat.id = key;
      prioritats.add(temporalPrioritat);
    });

    notifyListeners();
  }

  Future<void> updateOrCreatePrioritat(Prioritat novaPrioritat, Prioritat anteriorPrioritat) async {
    isSaving = true;
    notifyListeners();

    if (novaPrioritat.id == null ) {
      await createPrioritat(novaPrioritat);
    } else {
      await updatePrioritat(novaPrioritat, anteriorPrioritat);
    }

    isSaving = false;
    notifyListeners();
  }
  
  Future<void> updatePrioritat(Prioritat novaPrioritat, Prioritat anteriorPrioritat) async {
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/prioritats/${novaPrioritat.id}.json');
    await http.put(url, body: novaPrioritat.toJson());

    final index = prioritats.indexWhere((element) => element.id == novaPrioritat.id);
    prioritats[index] = novaPrioritat;

    for (Task task in tasksService.tasks) {
      if (task.prioritat == anteriorPrioritat.nom) {
        task.prioritat = novaPrioritat.nom;
        tasksService.updateTask(task);
        tasksService.notifyListeners();
      }
    }

    notifyListeners();
  }

  Future<void> createPrioritat(Prioritat prioritat) async {
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/prioritats.json');
    final response = await http.post(url, body: prioritat.toJson());
    final decodedData = json.decode(response.body);

    prioritat.id = decodedData['name'];

    prioritats.add(prioritat);
    
    notifyListeners();
  }

  Future<void> deletePrioritat(String id) async {
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/prioritats/$id.json');
    await http.delete(url);

    prioritats.removeWhere((propietat) => propietat.id == id);

    notifyListeners();
  }
}