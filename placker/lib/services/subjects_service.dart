import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:placker/models/models.dart';
import 'package:placker/services/services.dart';


//fa les peticions http per l'assignatura
class SubjectsService extends ChangeNotifier {

  final String _baseUrl = 'placker-app-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Subject> subjects = [];
  late Subject selectedSubject;
  bool isSaving = false;
  final TasksService tasksService;
  final storage = new FlutterSecureStorage();

  SubjectsService(this.tasksService) {
    selectedSubject = Subject();
    loadSubjects();
  }

  Future<String?> _getUid() async {
    return await storage.read(key: 'uid');
  }

  Future<void> loadSubjects() async {  
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/subjects.json');
    final response = await http.get(url);
    final Map<String, dynamic> subjectsMap = json.decode(response.body);

    subjects.clear();

    subjectsMap.forEach((key, value) { 
      final temporalSubject = Subject.fromMap(value);
      temporalSubject.id = key;
      subjects.add(temporalSubject);
    });

    notifyListeners();
  }

  Future<void> updateOrCreateSubject(Subject nouSubject, Subject anteriorSubject) async {
    isSaving = true;
    notifyListeners();

    if (nouSubject.id == null ) {
      await createSubject(nouSubject);
    } else {
      await updateSubject(nouSubject, anteriorSubject);
    }

    isSaving = false;
    notifyListeners();
  }
  
  Future<void> updateSubject(Subject nouSubject, Subject anteriorSubject) async {
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/subjects/${nouSubject.id}.json');
    await http.put(url, body: nouSubject.toJson());

    final index = subjects.indexWhere((element) => element.id == nouSubject.id);
    subjects[index] = nouSubject;

    for (Task task in tasksService.tasks) {
      if (task.subject == anteriorSubject.assignatura) {
        task.subject = nouSubject.assignatura;
        tasksService.updateTask(task);
        tasksService.notifyListeners();
      }
    }
    
    notifyListeners();
  }

  Future<void> createSubject(Subject subject) async {
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/subjects.json');
    final response = await http.post(url, body: subject.toJson());
    final decodedData = json.decode(response.body);

    subject.id = decodedData['name'];

    subjects.add(subject);
    
    notifyListeners();
  }

  Future<void> deleteSubject(String id) async {
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/subjects/$id.json');
    await http.delete(url);

    subjects.removeWhere((subject) => subject.id == id);

    notifyListeners();
  }
}