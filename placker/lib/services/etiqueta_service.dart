import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:placker/models/models.dart';
import 'package:placker/services/services.dart';


//fa les peticions http per l'etiqueta 
class EtiquetaService extends ChangeNotifier {

  final String _baseUrl = 'placker-app-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Etiqueta> etiquetes = [];
  late Etiqueta selectedEtiqueta;
  bool isSaving = false;
  final TasksService tasksService;
  final storage = new FlutterSecureStorage();
  
  EtiquetaService(this.tasksService) {
    selectedEtiqueta = Etiqueta();
    loadEtiquetes();
  }

  Future<String?> _getUid() async {
    return await storage.read(key: 'uid');
  }

  Future<void> loadEtiquetes() async {  
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/etiquetes.json');
    final response = await http.get(url);
    final Map<String, dynamic> etiquetesMap = json.decode(response.body);

    etiquetes.clear();

    etiquetesMap.forEach((key, value) {
      final temporalEtiqueta = Etiqueta.fromMap(value);
      temporalEtiqueta.id = key;
      etiquetes.add(temporalEtiqueta);
    });

    notifyListeners();
  }

  Future<void> updateOrCreateEtiqueta(Etiqueta novaEtiqueta, Etiqueta anteriorEtiqueta) async {
    isSaving = true;
    notifyListeners();

    if (novaEtiqueta.id == null ) {
      await createEtiqueta(novaEtiqueta);
    } else {
      await updateEtiqueta(novaEtiqueta, anteriorEtiqueta);
    }

    isSaving = false;
    notifyListeners();
  }
  
  Future<void> updateEtiqueta(Etiqueta novaEtiqueta, Etiqueta anteriorEtiqueta) async {
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/etiquetes/${novaEtiqueta.id}.json');
    await http.put(url, body: novaEtiqueta.toJson());

    final index = etiquetes.indexWhere((element) => element.id == novaEtiqueta.id);
    etiquetes[index] = novaEtiqueta;

    for (Task task in tasksService.tasks) {
      if (task.etiqueta == anteriorEtiqueta.nom) {
        task.etiqueta = novaEtiqueta.nom;
        tasksService.updateTask(task);
        tasksService.notifyListeners();
      }
    }

    notifyListeners();
  }

  Future<void> createEtiqueta(Etiqueta etiqueta) async {
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/etiquetes.json');
    final response = await http.post(url, body: etiqueta.toJson());
    final decodedData = json.decode(response.body);

    etiqueta.id = decodedData['name'];

    etiquetes.add(etiqueta);
    
    notifyListeners();
  }

  Future<void> deleteEtiqueta(String id) async {
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/etiquetes/$id.json');
    await http.delete(url);

    etiquetes.removeWhere((etiqueta) => etiqueta.id == id);

    notifyListeners();
  }
}